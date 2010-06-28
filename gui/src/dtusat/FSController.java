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

import dtusat.components.ConnectPanel;
import dtusat.components.FSMenu;
import dtusat.components.MainPanel;
import dtusat.components.MainTabs;

public class FSController implements Logger, FSSocketObserver {

	// --- Singleton Pattern -------------------------------
	
	private FSController() {}
	private static FSController instance = new FSController();
	public static synchronized FSController getInstance() { return instance; }
	public Object clone() throws CloneNotSupportedException { throw new CloneNotSupportedException(); }
	
	// ---- STATUS -----------------------------------------

	public final static int STATUS_OK 						= 100;
	public final static int STATUS_ERROR 					= 101;
	public final static int STATUS_IS_LOCKED 				= 102;
	public final static int STATUS_MUST_LOCK 				= 103;
	public final static int STATUS_WRONG_ARGUMENTS 			= 104;
	public final static int STATUS_UNKNOWN_COMMAND 			= 105;
	public final static int STATUS_TIMEOUT 					= 106;
	public final static int STATUS_VALIDATION_ERROR 		= 107;
	public final static int STATUS_SERVER_UNLOCKED			= 108;
	public final static int STATUS_UNKNOWN_SCRIPT			= 109;
	public final static int STATUS_SERIALPORT_NOT_CONNECTED = 110;
	
	// Command Codes
	public final static int FS_HEALTH_STATUS				= 19;

	
	// ---- Fields -----------------------------------------
	
	private FSSocket socket;
	public JFrame frame;
	public MainPanel mainPanel;
	public ConnectPanel connectPanel;
	public MainTabs mainTabs;
	public FSMenu menu;
	
	Hashtable<String, IncomingDataHandler> incomingDataHandlers;
	Hashtable<String, FSCallback> requestCallbacks;
	
	public boolean isConnected, isLocked, isAutoLocked, isServerLocked;
	
	// ---- Intitialization -----------------------------------------
	
	public void start() {
		isAutoLocked = true;
		isConnected = false;
		isServerLocked = false;
		
		socket = new FSSocket();
		mainPanel = new MainPanel();
		mainTabs = new MainTabs();
		connectPanel = new ConnectPanel();
		menu = new FSMenu();
		
		incomingDataHandlers = new Hashtable<String, IncomingDataHandler>();
		requestCallbacks = new Hashtable<String, FSCallback>();
		
		setupIncomingDataHandlers();
		setupWindow();
		showConnectPanel();
	}

	// --- Incoming Data Handlers -------------------------------
	
	private void setupIncomingDataHandlers() {

		// Response Handler
		incomingDataHandlers.put("response", new IncomingDataHandler() {
			public void onData(FSResponse response) {
				
				try {
					
					// Check for lock errors
					if(response.status == STATUS_MUST_LOCK) {
						setIsLocked(false);
					} else if(response.status == STATUS_IS_LOCKED) {
						isServerLocked = true;
						setIsLocked(false);
					} 
					
					requestCallbacks.get(response.id).onResponse(response);
					
					// Forget callback unless partial
					if(!response.isPartial())
						requestCallbacks.remove(response.id);
					
				} catch(NullPointerException e) {
					// No callback for response
				}
			}
		});
		
		// Server Unlocked Handler
		incomingDataHandlers.put("server_unlocked", new IncomingDataHandler() {
			public void onData(FSResponse response) {
				isServerLocked = false;
				setIsLocked(false);
			}
		});
	}
		
	public void setupWindow() {
		frame = new JFrame("Failsafe Control GUI");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setSize(Toolkit.getDefaultToolkit().getScreenSize());
		frame.setContentPane(mainPanel);
		frame.setJMenuBar(menu);
		frame.setVisible(true);
	}
	
	// --- Views -------------------------------
	
	public void showConnectPanel() {
		mainPanel.setTopPanel(connectPanel);
	}
	
	public void showMainPanel() {
		mainPanel.setTopPanel(mainTabs);
	}
	
	// --- Log -------------------------------
	
	public void log(String msg) {
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
		if(isConnected) {
			setIsConnected(false);
			showConnectPanel();
		}
	}
	
	public void onIncomingData(String s) {
		log("< "+s);
		FSResponse response = new FSResponse(s);
		incomingDataHandlers.get(response.type).onData(response);
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
		menu.autoLockItem.setSelected(selected);
		
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