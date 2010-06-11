package dtusat.components;

import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.FlowLayout;

import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTextArea;
import javax.swing.JToolBar;

import dtusat.FSController;
import dtusat.Logger;

public class MainPanel extends JPanel implements Logger {

	public JToolBar toolBar;
	public JSplitPane splitPane;
	public JPanel logPanel, buttonPanel; 
	public JTextArea logArea;
	FSController controller;
	private JScrollPane logScrollPane;
	public JLabel lockStatus;
	private JLabel connectedStatus;
	
	public MainPanel() {	
		controller = FSController.getInstance();
		setLayout(new BorderLayout());
	
		// Toolbars
		toolBar = new JToolBar();
		add(toolBar, BorderLayout.PAGE_END);
	
		// Connected status
		connectedStatus = new JLabel();
		showDisconnectedStatus();
		toolBar.add(connectedStatus);
		
		// Lock status
		lockStatus = new JLabel();
		showUnLockedStatus();
		toolBar.add(lockStatus);
	
		// Splitter
		splitPane = new JSplitPane(JSplitPane.VERTICAL_SPLIT);
		add(splitPane, BorderLayout.CENTER);
		
		// Log
		logArea = new JTextArea();
		logArea.setBorder(BorderFactory.createEmptyBorder(5,5,5,5));
		splitPane.setRightComponent(new JScrollPane(logArea));
		
	}	

	public void showConnectedStatus() {
		connectedStatus.setIcon(new ImageIcon("src/dtusat/icons/green.png"));
		connectedStatus.setText("Connected");
	}
	
	public void showDisconnectedStatus() {
		connectedStatus.setIcon(new ImageIcon("src/dtusat/icons/red.png"));
		connectedStatus.setText("Disconnected");
	}
	
	public void showLockedStatus() {
		lockStatus.setIcon(new ImageIcon("src/dtusat/icons/green.png"));
		lockStatus.setText("Locked");
	}
	
	public void showUnLockedStatus() {
		lockStatus.setIcon(new ImageIcon("src/dtusat/icons/red.png"));
		lockStatus.setText("Unlocked");	
	}
	
	public void log(String msg) {
		logArea.setText(msg+"\n"+logArea.getText());
		logArea.setSelectionStart(0);
		logArea.setSelectionEnd(0);
	}
		
	public void setTopPanel(Component component) {
		splitPane.setLeftComponent(component);
		splitPane.setDividerLocation(0.66);
		splitPane.updateUI();
	}

}