package dtusat;

import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.swing.JFrame;

import org.json.JSONArray;

import dtusat.panels.ConnectPanel;
import dtusat.panels.FSGuiPanel;
import dtusat.panels.MainPanel;

public class FSController implements Logger, FSSocketObserver {

	// --- Singleton Pattern -------------------------------
	
	private FSController() {}
	private static FSController instance = new FSController();
	public static synchronized FSController getInstance() { return instance; }
	public Object clone() throws CloneNotSupportedException { throw new CloneNotSupportedException(); }
	
	// -----------------------------------------------------

	FSGuiPanel fsGuiPanel;
	JFrame frame;
	
	// Readable socket
	private FSSocket socket;
	public FSSocket getSocket() {
		return socket;
	}
	
	// Universal logger
	private Logger logger;
	public void log(String msg) {
		Calendar cal = Calendar.getInstance();
	    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yy HH:mm:ss");
	    String time = "["+sdf.format(cal.getTime())+"]";
		logger.log(time+" "+msg);
	}
	
	public void start() {
		socket = new FSSocket();
		fsGuiPanel = new FSGuiPanel();
		logger = fsGuiPanel;
		createWindow();
	}
		
	public void createWindow() {
		frame = new JFrame("Failsafe Control GUI");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setContentPane(fsGuiPanel);
		frame.setSize(600,400);
		frame.setVisible(true);
		showConnectPanel();
	}
	
	// --- Views -------------------------------
	
	public void showConnectPanel() {
		fsGuiPanel.setTopPanel(new ConnectPanel());
		fsGuiPanel.hideDisconnectButton();
		fsGuiPanel.hideLockButtons();
	}
	
	public void showMainPanel() {
		fsGuiPanel.setTopPanel(new MainPanel());
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
			socket.token = response.bodyAsString()+" ";
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