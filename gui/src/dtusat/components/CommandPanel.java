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
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollBar;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import dtusat.FSController;

public class CommandPanel extends JPanel implements ActionListener {
	
	String[][] commandsAndArguments = {
				{"calculate_check_sum", "address", "length", "options"},
				{"call_function", "address", "parameter", "options"},
				{"copy_to_flash", "from", "to", "length", "options"},
				{"copy_to_ram", "from", "to", "length", "options"},
				{"delete_flash_block", "address", "options"},
				{"download", "address", "length", "options"},
				{"download_sib", "options"},
				{"execute", "address", "options"},
				{"flash_test", "address", "options"},
				{"health_status", "options"},
				{"list_scripts", "options"},
				{"lock", "options"},
				{"ram_test", "address", "length", "options"},
				{"read_register", "address", "options"},
				{"read_sensor", "address", "options"},
				{"reset", "options"},
				{"reset_sib", "options"},
				{"run_script","path","arguments", "options"},
				{"set_autoreset","value", "options"},
				{"sleep","seconds", "options"},
				{"unlock", "options"},
				{"unlock_flash", "options"},
				{"upload", "address", "data", "options"},
				{"upload_sib", "sib", "options"},
				{"write_register", "address", "data", "options"}
			};
	public JComboBox commandList;
	private JButton removeButton;
	private AbstractButton upButton;
	private JButton downButton;
	public JPanel argumentsPanel;
	private int index;
	public JTextArea outputArea;
	
	public CommandPanel(int index) {
		this.index = index;
		
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
		
		// South
		JPanel south = new JPanel(new BorderLayout());
		add(south, BorderLayout.SOUTH);
		
			outputArea = new JTextArea();
			outputArea.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
			outputArea.setWrapStyleWord(true);
			outputArea.setVisible(false);
			south.add(outputArea, BorderLayout.CENTER);
	}

	public CommandPanel(int index, JSONObject entry) {
		this(index);
		try {
			String command = entry.getString("command");
			
			String[] caa = null;
			
			for(int i=0; i < commandsAndArguments.length;i++) {
				if(commandsAndArguments[i][0].equals(command)) {
					caa = commandsAndArguments[i]; 
					commandList.setSelectedIndex(i);
					break;
				}
			}
			
			argumentsPanel.removeAll();
			JSONArray arguments = entry.getJSONArray("arguments");
			for(int i=0;i<arguments.length();i++) {
				argumentsPanel.add(newArgumentField(caa[i+1],arguments.getString(i)));
			}
			
			FSController.getInstance().mainPanel.repaint();
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	private JPanel newArgumentField(String name) {
		return newArgumentField(name, "");
	}
	
	private JPanel newArgumentField(String name, String value) {
		JPanel p = new JPanel();
		
		JLabel l = new JLabel(name);
		
		JTextField a = new JTextField(value);
		a.setColumns(8);
		//a.setText(name);
		a.setBorder(BorderFactory.createCompoundBorder(BorderFactory.createLineBorder(Color.BLACK, 1), BorderFactory.createEmptyBorder(5,5,5,5)));
		a.setToolTipText(name);
		
		p.add(l);
		p.add(a);
		
		return p;
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
		
		for(Component p : argumentsPanel.getComponents()) {
			JTextField a = (JTextField) ((JPanel) p).getComponent(1);
			cmd += " "+ a.getText();
		}
		
		return cmd;
	}

	public void setGUIEnabled(boolean b) {
		commandList.setEnabled(b);
		upButton.setEnabled(b);
		downButton.setEnabled(b);
		removeButton.setEnabled(b);
		for(Component c : argumentsPanel.getComponents())
			c.setEnabled(b);
		
	}
	
	public void actionPerformed(ActionEvent e) {
		if(e.getSource() == commandList) {
			updateArguments();
		}
		
		if(e.getSource() == removeButton) {
			getParent().remove(this);	
			FSController.getInstance().mainPanel.repaint();
		}
		
		if(e.getSource() == downButton) {
			if(index < getParent().getComponentCount()-1) {
				index++;
				((CommandPanel) getParent().getComponent(index)).index--;
				getParent().add(this, index);	
				FSController.getInstance().mainPanel.repaint();
			}
		}
		
		if(e.getSource() == upButton) {
			if(index > 0) {
				index--;
				((CommandPanel) getParent().getComponent(index)).index++;
				getParent().add(this, index);	
				FSController.getInstance().mainPanel.repaint();
			}
		}
	}
}