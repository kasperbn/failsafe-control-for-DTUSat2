package dtusat.components;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.AbstractButton;
import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JPanel;
import javax.swing.JTextField;

import dtusat.FSController;

public class CommandPanel extends JPanel implements ActionListener {
	
	String[][] commandsAndArguments = {
				{"execute", "address"},
				{"list_scripts"},
				{"lock"},
				{"reset"},
				{"run_script","script_path","script_arguments"},
				{"sleep","seconds"},
				{"unlock"}
			};
	private JComboBox commandList;
	private JButton removeButton;
	private AbstractButton upButton;
	private JButton downButton;
	private JPanel argumentsPanel;
	
	public CommandPanel() {
		setLayout(new BorderLayout());
		setBorder(BorderFactory.createCompoundBorder(BorderFactory.createMatteBorder(0, 0, 1, 0, Color.GRAY),BorderFactory.createEmptyBorder(5,5,5,5)));
		
		// West
		JPanel west = new JPanel(new FlowLayout(FlowLayout.LEFT)); 
		add(west, BorderLayout.WEST);
		
			String[] commands = new String[commandsAndArguments.length]; 
			for(int i=0;i<commandsAndArguments.length ; i++) {
				commands[i] = commandsAndArguments[i][0];
			}
		
			commandList = new JComboBox(commands);
			commandList.setBorder(BorderFactory.createEmptyBorder(5,5,5,5));
			commandList.addActionListener(this);
			west.add(commandList);
			
			argumentsPanel = new JPanel();
			updateArguments();
			west.add(argumentsPanel);
			
		// East
		JPanel east = new JPanel(new FlowLayout(FlowLayout.LEFT));
		add(east, BorderLayout.EAST);
		
			upButton = new JButton(new ImageIcon("src/dtusat/icons/arrow_up.png"));
			upButton.addActionListener(this); 
			east.add(upButton);
			
			downButton = new JButton(new ImageIcon("src/dtusat/icons/arrow_down.png"));
			downButton.addActionListener(this); 
			east.add(downButton);
			
			removeButton = new JButton(new ImageIcon("src/dtusat/icons/remove.png"));
			removeButton.addActionListener(this); 
			east.add(removeButton);
		
	}

	private JTextField newArgumentField(String name) {
		JTextField a = new JTextField();
		a.setColumns(10);
		a.setText(name);
		a.setBorder(BorderFactory.createCompoundBorder(BorderFactory.createLineBorder(Color.BLACK, 1), BorderFactory.createEmptyBorder(5,5,5,5)));
		a.setToolTipText(name);
		return a;
	}
	
	public void actionPerformed(ActionEvent e) {
		if(e.getSource() == commandList) {
			updateArguments();
		}
		
		if(e.getSource() == removeButton) {
			getParent().remove(this);	
			FSController.getInstance().mainPanel.repaint();
		}
	}

	private void updateArguments() {
		argumentsPanel.removeAll();
		String[] caa = commandsAndArguments[commandList.getSelectedIndex()];
		for(int i=1;i<caa.length;i++) {
			argumentsPanel.add(newArgumentField(caa[i]));
		}
		FSController.getInstance().mainPanel.repaint();	
	}

	public String getFullCommand() {
		String cmd = commandList.getSelectedItem().toString(); 
		
		for(Component a : argumentsPanel.getComponents())
			cmd += " "+((JTextField) a).getText();
		
		return cmd;
	}
}