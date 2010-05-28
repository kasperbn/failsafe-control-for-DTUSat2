package dtusat.panels;

import dtusat.*;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

public class ConnectPanel extends JPanel implements ActionListener {
	
	public FSController controller;
	JTextField hostTextField, portTextField;
	
	public ConnectPanel() {
		
		controller = FSController.getInstance();
		
		setLayout(new FlowLayout());
		
		JPanel boxPanel = new JPanel();
		boxPanel.setLayout(new BoxLayout(boxPanel, BoxLayout.Y_AXIS));
		JPanel hostPanel = new JPanel();
		JPanel portPanel = new JPanel();
		JPanel buttonPanel = new JPanel();
		
		JLabel hostLabel = new JLabel("Host:");
		JLabel portLabel = new JLabel("Port:");
		
		hostTextField = new JTextField("localhost", 15);
		portTextField = new JTextField("3000", 15);
		
		JButton connectButton = new JButton("Connect");
		connectButton.addActionListener(this);
		
		JButton connectAndLockButton = new JButton("Connect and lock");
		connectAndLockButton.addActionListener(this);
		
		hostPanel.add(hostLabel);
		hostPanel.add(hostTextField);
		portPanel.add(portLabel);
		portPanel.add(portTextField);
		buttonPanel.add(connectButton);
		buttonPanel.add(connectAndLockButton);
		boxPanel.add(hostPanel);
		boxPanel.add(portPanel);
		boxPanel.add(buttonPanel);
		add(boxPanel);
	}

	public void actionPerformed(ActionEvent ae) {
		String e = ae.getActionCommand();
		
		if(e == "Connect") {
			controller.getSocket().connect(hostTextField.getText(), portTextField.getText());
		} 
		if(e == "Connect and lock") {
			controller.getSocket().connect(hostTextField.getText(), portTextField.getText());
			controller.lock();
		}
		
	}

}
