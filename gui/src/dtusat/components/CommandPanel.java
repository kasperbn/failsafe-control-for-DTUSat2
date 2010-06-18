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
				{"calculate_check_sum", "address", "length"},
				{"call_function", "address", "parameter"},
				{"copy_to_flash", "from", "to", "length"},
				{"copy_to_ram", "from", "to", "length"},
				{"delete_flash_block", "address"},
				{"download", "address", "length"},
				{"download_sib"},
				{"execute", "address"},
				{"flash_test", "address"},
				{"health_status"},
				{"list_scripts"},
				{"lock"},
				{"ram_test", "address", "length"},
				{"read_register", "address"},
				{"read_sensor", "address"},
				{"reset"},
				{"reset_sib"},
				{"run_script","script_path","script_arguments"},
				{"set_autoreset","value"},
				{"sleep","seconds"},
				{"unlock"},
				{"unlock_flash"},
				{"upload", "address", "data"},
				{"upload_sib", "sib"},
				{"write_register", "address", "data"}
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
			
			for(int i=0; i < commandsAndArguments.length;i++) {
				if(commandsAndArguments[i][0].equals(command)) {
					commandList.setSelectedIndex(i);
					break;
				}
			}
			
			argumentsPanel.removeAll();
			JSONArray arguments = entry.getJSONArray("arguments");
			for(int i=0;i<arguments.length();i++) {
				argumentsPanel.add(newArgumentField(arguments.getString(i)));
			}
			
			FSController.getInstance().mainPanel.repaint();
		} catch (JSONException e) {
			e.printStackTrace();
		}
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

	public void setGUIEnabled(boolean b) {
		commandList.setEnabled(b);
		upButton.setEnabled(b);
		downButton.setEnabled(b);
		removeButton.setEnabled(b);
		for(Component c : argumentsPanel.getComponents())
			c.setEnabled(b);
		
	}
}