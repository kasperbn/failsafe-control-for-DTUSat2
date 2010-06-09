package dtusat.components;

import dtusat.*;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

public class ConnectPanel extends JPanel {
	
	public FSController controller;
	JTextField hostTextField, portTextField;
	public JCheckBox autoLockCheckBox;
	
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
		
		autoLockCheckBox = new JCheckBox("Autolock", controller.isAutoLocked);
		autoLockCheckBox.addChangeListener(new ChangeListener() {
			public void stateChanged(ChangeEvent arg0) {
				controller.setAutoLocked(autoLockCheckBox.isSelected());
			}
		});
		
		JButton connectButton = new JButton("Connect");
		connectButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				controller.getSocket().connect(hostTextField.getText(), portTextField.getText());				
			}
		});
		
		hostPanel.add(hostLabel);
		hostPanel.add(hostTextField);
		portPanel.add(portLabel);
		portPanel.add(portTextField);
		buttonPanel.add(connectButton);
		boxPanel.add(hostPanel);
		boxPanel.add(portPanel);
		boxPanel.add(autoLockCheckBox);
		boxPanel.add(buttonPanel);
		add(boxPanel);
	}

}
