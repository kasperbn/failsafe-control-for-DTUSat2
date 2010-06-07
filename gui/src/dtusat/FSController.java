package dtusat;

import java.awt.Color;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Hashtable;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JSeparator;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import dtusat.panels.ConnectPanel;
import dtusat.panels.MainPanel;
import dtusat.panels.MainTabs;

public class FSController implements Logger, FSSocketObserver {

	// --- Singleton Pattern -------------------------------
	
	private FSController() {}
	private static FSController instance = new FSController();
	public static synchronized FSController getInstance() { return instance; }
	public Object clone() throws CloneNotSupportedException { throw new CloneNotSupportedException(); }
	
	// -----------------------------------------------------

	public MainPanel mainPanel;
	JFrame frame;
	Hashtable<String, IncomingDataHandler> incomingDataHandlers;
	Hashtable<String, FSCallback> requestCallbacks;
	public boolean auto_lock;
	
	// Readable socket
	private FSSocket socket;
	public FSSocket getSocket() {
		return socket;
	}
	
	// Universal logger
	private Logger logger;
	
	public void log(String msg) {
		// Datetime
		Calendar cal = Calendar.getInstance();
	    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yy HH:mm:ss");
	    String time = "["+sdf.format(cal.getTime())+"]";

		logger.log(time+" "+msg);
	}

	
	public void start() {
		socket = new FSSocket();
		mainPanel = new MainPanel();
		logger = mainPanel;
		auto_lock = false;
		
		incomingDataHandlers = new Hashtable<String, IncomingDataHandler>();
		requestCallbacks = new Hashtable<String, FSCallback>();
		
		setupIncomingDataHandlers();
		createWindow();
	}
		
	public void createWindow() {
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
		mainPanel.setTopPanel(new ConnectPanel());
		mainPanel.hideLockButtons();
	}
	
	public void showMainPanel() {
		mainPanel.setTopPanel(new MainTabs());
		mainPanel.showLockButtons();
	}
	
	// --- FSSocket Callbacks -------------------------------
	
	public void onConnected() {
		log("Connected to "+socket.host+":"+socket.port);
		showMainPanel();
	}
	
	public void onConnectionRefused() {
		log("Connection refused to "+socket.host+":"+socket.port);
	}
	
	public void onDisconnected() {
		log("Disconnected from "+socket.host+":"+socket.port);
		showConnectPanel();
	}
	
	public void handleIncomingData(String s) {
		log("< "+s);
		FSResponse response = new FSResponse(s);
		incomingDataHandlers.get(response.type).handle(response);
	}
	
	public void registerCallback(String id, FSCallback callback) {
		requestCallbacks.put(id, callback);	
	}
	
	// --- Response Handlers -------------------------------
	private void setupIncomingDataHandlers() {

		// Response Handler
		incomingDataHandlers.put("response", new IncomingDataHandler() {
			public void handle(FSResponse response) {
				try {
					requestCallbacks.get(response.id).onResponse(response);
					
					if(!response.partial)
						requestCallbacks.remove(response.id);
					
				} catch(NullPointerException e) {
					// No registered callback 
				}
			}
		});
		
		// Server Unlocked Handler
		incomingDataHandlers.put("server_unlocked", new IncomingDataHandler() {
			public void handle(FSResponse response) {
				mainPanel.showUnLockedStatus();
				if(auto_lock) 
					lock();
			}
		});
	}
	
	// --- FS Commands -------------------------------
	public void lock() {
		socket.request("lock", new FSCallback() {
			public void onResponse(FSResponse response) {
				if(response.isSuccess()) {
					socket.token = response.dataAsString();
					mainPanel.showLockedStatus();
				}
			}
		});
	}
	
	public void unlock() {
		socket.request("unlock", new FSCallback() {
			public void onResponse(FSResponse response) {
				if(response.isSuccess()) {
					socket.token = "";
					mainPanel.showUnLockedStatus();
				}
			}
		});
	}

}