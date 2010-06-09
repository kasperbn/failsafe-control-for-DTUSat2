package dtusat.components;

import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JPanel;
import javax.swing.JTextField;

public class CommandPanel extends JPanel implements ActionListener {
	
	String[] commands = {"reset","execute","run_script","list_scripts","pause"};
	private JComboBox commandList;
	private JTextField argumentsTextField;
	
	public CommandPanel() {
		setLayout(new FlowLayout(FlowLayout.LEFT));
		
		JButton removeButton = new JButton(new ImageIcon("src/dtusat/icons/remove.png"));
		removeButton.addActionListener(this); 
		
		commandList = new JComboBox(commands);

		argumentsTextField = new JTextField();
		argumentsTextField.setColumns(30);
		
		add(removeButton);
		add(commandList);
		add(argumentsTextField);
	}

	public void actionPerformed(ActionEvent e) {
		getParent().remove(this);	
	}

	public String getFullCommand() {
		return commandList.getSelectedItem().toString() + " " + argumentsTextField.getText();
	}
}