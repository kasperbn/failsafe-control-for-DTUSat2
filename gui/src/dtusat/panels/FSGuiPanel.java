package dtusat.panels;

import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTextArea;

import dtusat.FSController;
import dtusat.FSSocket;
import dtusat.Logger;

public class FSGuiPanel extends JPanel implements Logger, ActionListener {

	public JSplitPane splitPane;
	public JPanel logPanel, buttonPanel; 
	public JTextArea logArea;
	FSController controller;
	JButton disconnectButton, lockButton, unlockButton;
	
	public FSGuiPanel() {	
		controller = FSController.getInstance();
		
		setLayout(new BorderLayout());
	
		// Splitter
		splitPane = new JSplitPane(JSplitPane.VERTICAL_SPLIT);
		add(splitPane);
		
		// Log
		JPanel logPanel = new JPanel(new BorderLayout());
		logPanel.setBorder(BorderFactory.createTitledBorder("Log"));
		logArea = new JTextArea();
		JScrollPane scrollPane = new JScrollPane(logArea);
		logPanel.add(scrollPane, BorderLayout.CENTER);
		splitPane.setRightComponent(logPanel);
		
		// Button panel		
		buttonPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT));
		logPanel.add(buttonPanel, BorderLayout.SOUTH);

		// Disconnect
		disconnectButton = new JButton("Disconnect");
		disconnectButton.addActionListener(this);
		buttonPanel.add(disconnectButton);
		
		// Lock
		lockButton = new JButton("Lock");
		lockButton.addActionListener(this);
		buttonPanel.add(lockButton);
		
		// Unlock
		unlockButton = new JButton("Unlock");
		unlockButton.addActionListener(this);
		buttonPanel.add(unlockButton);
	}	

	public void showDisconnectButton() { disconnectButton.setVisible(true); }
	public void hideDisconnectButton() { disconnectButton.setVisible(false); }

	public void showLockButtons() {
		lockButton.setVisible(true);
		unlockButton.setVisible(true);
	}
	
	public void hideLockButtons() {
		lockButton.setVisible(false);
		unlockButton.setVisible(false);
	}
	
	public void log(String msg) {
		logArea.append(msg+"\n");//(logArea.getText()msg+"\n");
	}
		
	public void setTopPanel(Component component) {
		splitPane.setLeftComponent(component);
	}

	public void actionPerformed(ActionEvent event) {
		String e = event.getActionCommand();
		
		if(e == "Disconnect")
			controller.getSocket().disconnect();
		if(e == "Lock")
			controller.lock();
		if(e == "Unlock")
			controller.unlock();
	}

}