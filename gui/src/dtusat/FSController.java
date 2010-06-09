package dtusat;

import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Hashtable;

import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JSeparator;

import dtusat.panels.ConnectPanel;
import dtusat.panels.MainPanel;
import dtusat.panels.MainTabs;

public class FSController implements Logger, FSSocketObserver {

	// --- Singleton Pattern -------------------------------
	
	private FSController() {}
	private static FSController instance = new FSController();
	public static synchronized FSController getInstance() { return instance; }
	public Object clone() throws CloneNotSupportedException { throw new CloneNotSupportedException(); }
	
	// ---- Fields -----------------------------------------

	public final static int STATUS_OK = 0;
	public final static int STATUS_ERROR = 1; 
	public final static int STATUS_SERVER_IS_LOCKED = 2;
	public final static int STATUS_MUST_LOCK = 3;
	public final static int STATUS_ALREADY_LOCKED = 4;
	public final static int STATUS_WRONG_ARGUMENTS = 5;
	public final static int STATUS_UNKNOWN_COMMAND = 6;
	public final static int STATUS_INVALID_FORMAT = 7;
	
	private FSSocket socket;
	public JFrame frame;
	public MainPanel mainPanel;
	public ConnectPanel connectPanel;
	public MainTabs mainTabs;
	
	Hashtable<String, IncomingDataHandler> incomingDataHandlers;
	Hashtable<String, FSCallback> requestCallbacks;
	
	public boolean isConnected, isLocked, isAutoLocked, isServerLocked;
	
	// ---- Intitialization -----------------------------------------
	
	public void start() {
		isAutoLocked = false;
		isConnected = false;
		isServerLocked = false;
		
		socket = new FSSocket();
		mainPanel = new MainPanel();
		mainTabs = new MainTabs();
		connectPanel = new ConnectPanel();
		
		incomingDataHandlers = new Hashtable<String, IncomingDataHandler>();
		requestCallbacks = new Hashtable<String, FSCallback>();
		
		setupIncomingDataHandlers();
		setupWindow();
	}

	// --- Incoming Data Handlers -------------------------------
	
	private void setupIncomingDataHandlers() {

		// Response Handler
		incomingDataHandlers.put("response", new IncomingDataHandler() {
			public void handle(FSResponse response) {
				
				try {
					
					// Check for lock errors
					if(response.status == STATUS_MUST_LOCK) {
						setIsLocked(false);
					} else if(response.status == STATUS_SERVER_IS_LOCKED) {
						isServerLocked = true;
						setIsLocked(false);
					} else if(response.status == STATUS_ALREADY_LOCKED) {
						isServerLocked = true;
						setIsLocked(true);
					
					// No lock errors, execute callback
					} else { 
						requestCallbacks.get(response.id).onResponse(response);
					}
					
					// Forget callback unless partial
					if(!response.partial)
						requestCallbacks.remove(response.id);
					
				} catch(NullPointerException e) {
					// No callback for response
				}
			}
		});
		
		// Server Unlocked Handler
		incomingDataHandlers.put("server_unlocked", new IncomingDataHandler() {
			public void handle(FSResponse response) {
				isServerLocked = false;
				setIsLocked(false);
			}
		});
	}
		
	public void setupWindow() {
		// Frame
		frame = new JFrame("Failsafe Control GUI");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setContentPane(mainPanel);
		frame.setSize(Toolkit.getDefaultToolkit().getScreenSize());
		frame.setVisible(true);
		
		// Menu
		JMenuBar menuBar = new JMenuBar();
		JMenu fileMenu = new JMenu("File");
		JMenuItem disconnectMenuItem = new JMenuItem("Disconnect", new ImageIcon("src/dtusat/icons/disconnect.png"));
		disconnectMenuItem.addActionListener(new ActionListener() {public void actionPerformed(ActionEvent arg0) {getSocket().disconnect();}});		
		JMenuItem quitMenuItem = new JMenuItem("Quit");
		
		quitMenuItem.addActionListener(new ActionListener() {public void actionPerformed(ActionEvent ae) {System.exit(0);}});
		fileMenu.add(disconnectMenuItem);
		fileMenu.add(new JSeparator());
		fileMenu.add(quitMenuItem);
		menuBar.add(fileMenu);
		frame.setJMenuBar(menuBar);
		
		showConnectPanel();
	}
	
	// --- Views -------------------------------
	
	public void showConnectPanel() {
		mainPanel.hideLockButtons();
		mainPanel.setTopPanel(connectPanel);
	}
	
	public void showMainPanel() {
		mainPanel.showLockButtons();
		mainPanel.setTopPanel(mainTabs);
	}
	
	// --- Log -------------------------------
	
	public void log(String msg) {
		// Datetime
		Calendar cal = Calendar.getInstance();
	    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yy HH:mm:ss");
	    String time = "["+sdf.format(cal.getTime())+"]";

		mainPanel.log(time+" "+msg);
	}

	
	// --- FSSocket Callbacks -------------------------------
	
	public void onConnected() {
		setIsConnected(true);
		showMainPanel();
		if(!isLocked && isAutoLocked)
			lock();
	}
	
	public void onConnectionRefused() {
		setIsConnected(false);
		log("Connection refused to "+socket.host+":"+socket.port);
	}
	
	public void onDisconnected() {
		setIsConnected(false);
		showConnectPanel();
	}
	
	public void onIncomingData(String s) {
		log("< "+s);
		FSResponse response = new FSResponse(s);
		incomingDataHandlers.get(response.type).handle(response);
	}
	
	public void onRegisterCallback(String id, FSCallback callback) {
		requestCallbacks.put(id, callback);	
	}
	
	// --- FS Commands -------------------------------
	
	public void lock() {
		socket.request("lock", new FSCallback() {
			public void onResponse(FSResponse response) {
				if(response.isSuccess()) {
					socket.token = response.dataAsString();
					setIsLocked(true);
				}
			}
		});
	}
	
	public void unlock() {
		socket.request("unlock", new FSCallback() {
			public void onResponse(FSResponse response) {
				if(response.isSuccess()) {
					socket.token = "";
					setIsLocked(false);
				}
			}
		});
	}
	
	// --- Setters & Getters -------------------------------
	
	public FSSocket getSocket() {
		return socket;
	}
	
	public void setAutoLocked(boolean selected) {
		isAutoLocked = selected;

		connectPanel.autoLockCheckBox.setSelected(selected);
		mainPanel.autoLockCheckBox.setSelected(selected);
		
		if(!isLocked && isAutoLocked && isConnected)
			lock();
	}

	private void setIsConnected(boolean b) {
		isConnected = b;
		if(b)
			mainPanel.showConnectedStatus();
		else
			mainPanel.showDisconnectedStatus();
	}
	
	private void setIsLocked(boolean b) {
		isLocked = b;
		if(b) {
			mainPanel.showLockedStatus();
		} else {
			mainPanel.showUnLockedStatus();
			if(isAutoLocked && isConnected && !isServerLocked)
				lock();
		}
	}
}