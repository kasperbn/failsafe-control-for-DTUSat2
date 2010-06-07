package dtusat.panels;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTextArea;
import javax.swing.JToolBar;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

import dtusat.FSController;
import dtusat.FSSocket;
import dtusat.Logger;

public class MainPanel extends JPanel implements Logger, ActionListener {

	public JToolBar toolBar;
	public JSplitPane splitPane;
	public JPanel logPanel, buttonPanel; 
	public JTextArea logArea;
	FSController controller;
	JButton lockButton, unlockButton;
	private JScrollPane logScrollPane;
	public JLabel lockStatus;
	private JCheckBox autoLockCheckBox;
	
	public MainPanel() {	
		controller = FSController.getInstance();
		
		setLayout(new BorderLayout());
	
		// Toolbars
		toolBar = new JToolBar();
		add(toolBar, BorderLayout.PAGE_START);
		
		// Lock status
		lockStatus = new JLabel();
		showUnLockedStatus();
		toolBar.add(lockStatus);
	
		autoLockCheckBox = new JCheckBox("Autolock", controller.auto_lock);
		autoLockCheckBox.addChangeListener(new ChangeListener() {
			public void stateChanged(ChangeEvent arg0) {
				controller.auto_lock = autoLockCheckBox.isSelected();	
			}
		});
		toolBar.add(autoLockCheckBox);
		
		// Lock
		lockButton = new JButton("Lock", new ImageIcon("src/dtusat/icons/lock.png"));
		lockButton.addActionListener(this);
		toolBar.add(lockButton);
		
		// Unlock
		unlockButton = new JButton("Unlock", new ImageIcon("src/dtusat/icons/unlock.png"));
		unlockButton.addActionListener(this);
		toolBar.add(unlockButton);
		
		// Splitter
		splitPane = new JSplitPane(JSplitPane.VERTICAL_SPLIT);
		add(splitPane, BorderLayout.CENTER);
		
		// Log
		JPanel logPanel = new JPanel(new BorderLayout());
		logPanel.setBorder(BorderFactory.createTitledBorder("Log"));
		logArea = new JTextArea();
		logScrollPane = new JScrollPane(logArea);
		logPanel.add(logScrollPane , BorderLayout.CENTER);
		splitPane.setRightComponent(logPanel);
		
	}	

	public void showLockedStatus() {
		lockStatus.setIcon(new ImageIcon("src/dtusat/icons/green.png"));
		lockStatus.setText("Server is locked");
	}
	
	public void showUnLockedStatus() {
		lockStatus.setIcon(new ImageIcon("src/dtusat/icons/red.png"));
		lockStatus.setText("Server is unlocked");	
	}
	
	public void showLockButtons() {
		lockButton.setVisible(true);
		unlockButton.setVisible(true);
	}
	
	public void hideLockButtons() {
		lockButton.setVisible(false);
		unlockButton.setVisible(false);
	}
	
	public void log(String msg) {
		//logArea.append(msg+"\n");
		logArea.setText(msg+"\n"+logArea.getText());
		logArea.setSelectionStart(0);
		logArea.setSelectionEnd(0);
	}
		
	public void setTopPanel(Component component) {
		splitPane.setLeftComponent(component);
		splitPane.setDividerLocation(0.66);
	}

	public void actionPerformed(ActionEvent event) {
		String e = event.getActionCommand();
		
		if(e == "Lock")
			controller.lock();
		if(e == "Unlock")
			controller.unlock();
	}

}