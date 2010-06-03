package dtusat;

import java.awt.Color;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.swing.JFrame;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;

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

	public MainPanel fsGuiPanel;
	JFrame frame;
	
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
		fsGuiPanel = new MainPanel();
		logger = fsGuiPanel;
		createWindow();
	}
		
	public void createWindow() {
		// Frame
		frame = new JFrame("Failsafe Control GUI");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setContentPane(fsGuiPanel);
		frame.setSize(Toolkit.getDefaultToolkit().getScreenSize());
		frame.setVisible(true);
		
		// Menu
		JMenuBar menuBar = new JMenuBar();
		JMenu fileMenu = new JMenu("File");
		JMenuItem quitMenuItem = new JMenuItem("Quit");
		quitMenuItem.addActionListener(new ActionListener() {public void actionPerformed(ActionEvent ae) {System.exit(0);}});
		fileMenu.add(quitMenuItem);
		menuBar.add(fileMenu);
		frame.setJMenuBar(menuBar);
		
		showConnectPanel();
	}
	
	// --- Views -------------------------------
	
	public void showConnectPanel() {
		fsGuiPanel.setTopPanel(new ConnectPanel());
		fsGuiPanel.hideDisconnectButton();
		fsGuiPanel.hideLockButtons();
	}
	
	public void showMainPanel() {
		fsGuiPanel.setTopPanel(new MainTabs());
		fsGuiPanel.showDisconnectButton();
		fsGuiPanel.showLockButtons();
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
	
	// --- FS Commands -------------------------------
	
	public void lock() {
		FSResponse response = socket.execute("lock");
		if(response.isSuccess()) {
			socket.token = response.bodyAsString();
			log("Token saved and will be prepended all requests");
		}
	}
	
	public void unlock() {
		FSResponse response = socket.execute("unlock");
		if(response.isSuccess()) {
			socket.token = "";
			log("Token forgotten");
		}
	}
	
}