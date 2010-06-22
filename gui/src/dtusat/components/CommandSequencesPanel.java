package dtusat.components;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFileChooser;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSeparator;
import javax.swing.JSplitPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.JTree;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import dtusat.FSController;
import dtusat.FSResponse;
import dtusat.FSCallback;

public class CommandSequencesPanel extends JPanel implements ActionListener {
	private JPanel commandList;
	private JPanel commandListContainer;
	private FSController controller;
	private JSplitPane splitPane;
	private JButton addButton;
	private JButton executeButton;
	private JPanel leftPanel;
	private FileTree tree;
	private JPanel leftNorthPanel;
	private JButton openButton;
	private JButton saveButton;
	private JButton setDirButton;
	private JPanel rightPanel;
	private JButton exportButton;
	private JButton newButton;
	private JPanel rightEastPanel;
	private String currentDir;
	private CommandPanel[] commandsToExecute;
	private int currentCommandIndex;
	private JButton clearButton;
	private JButton stopButton;
	private boolean stop;

	public CommandSequencesPanel() {
		controller = FSController.getInstance();
		currentDir = "/home/kbn/Code/bachelor/command_sequences";
		
		setLayout(new BorderLayout());
		
		// Splitpane
		splitPane = new JSplitPane();
		add(splitPane, BorderLayout.CENTER);
		
			// Left Panel
			leftPanel = new JPanel(new BorderLayout());		
			splitPane.setLeftComponent(leftPanel);
			
				// North
				leftNorthPanel = new JPanel();
				leftPanel.add(leftNorthPanel, BorderLayout.NORTH);
				
					openButton = new JButton("Open", new ImageIcon("src/dtusat/icons/page_edit.png"));
					openButton.addActionListener(this);
					leftNorthPanel.add(openButton);
					
					setDirButton = new JButton("Set Dir", new ImageIcon("src/dtusat/icons/folder_explore.png"));
					setDirButton.addActionListener(this);
					leftNorthPanel.add(setDirButton);
			
				// Center
				updateFileTree();
				//tree = new FileTree("/home/kbn/Code/bachelor/command_sequences/");
				//leftPanel.add(tree, BorderLayout.CENTER);
				
			// Right Panel
			rightPanel = new JPanel(new BorderLayout());
			splitPane.setRightComponent(rightPanel);
			
				// North Panel - Button Panel
				JPanel rightNorthPanel = new JPanel(new BorderLayout());
				rightPanel.add(rightNorthPanel, BorderLayout.NORTH);
				
					JPanel rightNorthWestPanel = new JPanel();
					rightNorthPanel.add(rightNorthWestPanel, BorderLayout.WEST);
					
						addButton = new JButton("Add Command", new ImageIcon("src/dtusat/icons/add.png"));
						addButton.addActionListener(this);
						rightNorthWestPanel.add(addButton);
					
						executeButton = new JButton("Execute", new ImageIcon("src/dtusat/icons/execute.png"));
						executeButton.addActionListener(this);
						rightNorthWestPanel.add(executeButton);
						
						stopButton = new JButton("Stop", new ImageIcon("src/dtusat/icons/stop.png"));
						stopButton.setEnabled(false);
						stopButton.addActionListener(this);
						rightNorthWestPanel.add(stopButton);
						
						
						clearButton = new JButton("Clear Output", new ImageIcon("src/dtusat/icons/table_delete.png"));
						clearButton.addActionListener(this);
						rightNorthWestPanel.add(clearButton);
					
					JPanel rightNorthEastPanel = new JPanel();
					rightNorthPanel.add(rightNorthEastPanel, BorderLayout.EAST);
					
						newButton = new JButton("New", new ImageIcon("src/dtusat/icons/script_add.png"));
						newButton.addActionListener(this);
						rightNorthEastPanel.add(newButton);
						
						saveButton = new JButton("Save", new ImageIcon("src/dtusat/icons/script_save.png"));
						saveButton.addActionListener(this);
						rightNorthEastPanel.add(saveButton);
						
						exportButton = new JButton("Export as Ruby", new ImageIcon("src/dtusat/icons/script_go.png"));
						exportButton.addActionListener(this);
						rightNorthEastPanel.add(exportButton);
				
				// Right split
				JSplitPane rightSplit = new JSplitPane();
				rightSplit.setDividerLocation(800);
				//rightPanel.add(rightSplit, BorderLayout.CENTER);		
				
					// Left - Command list
					commandListContainer = new JPanel(new BorderLayout());
					
						commandList = new JPanel();
						commandList.setLayout(new BoxLayout(commandList, BoxLayout.Y_AXIS));
						commandListContainer.add(commandList, BorderLayout.NORTH);
						//rightSplit.setLeftComponent(new JScrollPane(commandListContainer));
						rightPanel.add(new JScrollPane(commandListContainer), BorderLayout.CENTER);
					
					// Right - Manual
					rightEastPanel = new JPanel(new BorderLayout());
					//rightPanel.add(rightEastPanel, BorderLayout.EAST);
					rightSplit.setRightComponent(rightEastPanel);
					
						String[] commands = {"list_scripts","reset"}; 
						JComboBox commandsComboBox = new JComboBox(commands);
						rightEastPanel.add(commandsComboBox, BorderLayout.NORTH);
						
						JTextArea manualText = new JTextArea("Blah blah blah");
						manualText.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
						rightEastPanel.add(new JScrollPane(manualText), BorderLayout.CENTER);
				
	}


	@Override
	public void actionPerformed(ActionEvent e) {
		if(e.getSource() == openButton)
			open();
		else if(e.getSource() == setDirButton)
			setDir();
		else if(e.getSource() == addButton)
			add();
		else if(e.getSource() == executeButton)
			startExecution();
		else if(e.getSource() == stopButton)
			stopExecution();
		else if(e.getSource() == clearButton)
			clearOutput();
		else if(e.getSource() == newButton)
			newSequence();
		else if(e.getSource() == saveButton)
			save();
		else if(e.getSource() == exportButton)
			export();
	}

	private void open() {
		try {
			String path = currentDir;
			Object[] paths = tree.getSelectionPath().getPath();
			for(int i=1;i<paths.length;i++) { // Skip first
				path += File.separator+paths[i].toString();
			}
			BufferedReader in = new BufferedReader(new FileReader(path));
			String json = "";
			String str;
			while ((str = in.readLine()) != null) {
			    json += str;
			}
			in.close();
			JSONToSequence(json);
		} catch (IOException e1) {
			
			e1.printStackTrace();
		}
	}

	private void setDir() {
		final JFileChooser fc = new JFileChooser(new File(currentDir));
		fc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
		if(fc.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
			currentDir = fc.getSelectedFile().getAbsolutePath();
			updateFileTree();
		}
	}
	
	private void add() {
		commandList.add(new CommandPanel(commandList.getComponentCount()));
		controller.mainPanel.repaint();
	}
	
	protected void startExecution() {
		stop = false;
		commandsToExecute = new CommandPanel[commandList.getComponentCount()];
		for(int i=0;i<commandList.getComponentCount();i++)
			commandsToExecute[i] = (CommandPanel) commandList.getComponent(i);
		
		if(commandsToExecute.length > 0) {
			setGUIEnabled(false);
			clearOutput();
			currentCommandIndex = 0;
			executeNextCommand();
		}
	}

	public void setGUIEnabled(boolean b) {
		openButton.setEnabled(b);
		setDirButton.setEnabled(b);
		addButton.setEnabled(b);
		executeButton.setEnabled(b);
		stopButton.setEnabled(!b);
		clearButton.setEnabled(b);
		newButton.setEnabled(b);
		saveButton.setEnabled(b);
		exportButton.setEnabled(b);
		for(Component c : commandList.getComponents()) {
			CommandPanel cp = (CommandPanel) c;
			cp.setGUIEnabled(b);
		}
	}
	
	private void clearOutput() {
		for(Component c : commandList.getComponents()) {
			CommandPanel cp = (CommandPanel) c;
			cp.setBackground(this.getBackground());
			cp.outputArea.setText("");
			cp.outputArea.setVisible(false);
		}
	}

	public void executeNextCommand() {
		if(!stop) {
			getCurrentCommandPanel().outputArea.setVisible(true);
			getCurrentCommandPanel().outputArea.setBackground(Color.YELLOW);
			controller.getSocket().request(commandsToExecute[currentCommandIndex].getFullCommand(), new FSCallback() {
				public void onResponse(FSResponse response) {
					CommandPanel cp = getCurrentCommandPanel();
					cp.outputArea.append(response.messageAsString()+": "+response.dataAsString());
					
					if(response.status == FSController.STATUS_ERROR) {
						setGUIEnabled(true);
						cp.outputArea.setBackground(Color.RED);
					} else {
						if(!response.isPartial()) {
							cp.outputArea.setBackground(Color.GREEN);
							currentCommandIndex++;
							if(currentCommandIndex < commandsToExecute.length) 
								executeNextCommand();
							else
								setGUIEnabled(true);
						}
					}
				}
			});
		}
	}

	public void stopExecution() {
		stop = true;
		setGUIEnabled(true);
	}
	
	private void newSequence() {
		int n = JOptionPane.showConfirmDialog(
			    FSController.getInstance().frame,
			    "Are you sure? Any unsaved data will be lost.",
			    "Are you sure?",
			    JOptionPane.YES_NO_OPTION);
		
		if(n == JOptionPane.YES_OPTION) {
			commandList.removeAll();
			FSController.getInstance().mainPanel.repaint();
		}
	}
	
	private void save() {
		doSave(sequenceToJSON());
	}
	
	private void export() {
		File f = doSave(sequenceToRuby());
		f.setExecutable(true);
	}
	
	private File doSave(String data) {
		File f = null;
		try {
			final JFileChooser fc = new JFileChooser(new File(currentDir));
			if(fc.showSaveDialog(this) == JFileChooser.APPROVE_OPTION) {
				f = new File(fc.getSelectedFile().getAbsolutePath());
				FileWriter fstream = new FileWriter(f);
		        BufferedWriter out = new BufferedWriter(fstream);
			    out.write(data);
			    out.close();
				updateFileTree();
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		return f;
	}
	
	private CommandPanel getCurrentCommandPanel() {
		return commandsToExecute[currentCommandIndex];
	}
	
	private void updateFileTree() {
		try {
			leftPanel.remove(tree);
		} catch(NullPointerException noe) {
			// First add
		}
		tree = new FileTree(currentDir);
		leftPanel.add(tree, BorderLayout.CENTER);
		FSController.getInstance().mainPanel.repaint();
	}
	
	private String sequenceToJSON() {
		JSONArray data = new JSONArray();
		try {
			for(Component c : commandList.getComponents()) {
				CommandPanel cp = (CommandPanel) c;
				JSONObject entry = new JSONObject();
				// Command
				entry.put("command", cp.commandList.getSelectedItem().toString());
				// Arguments
				JSONArray arguments = new JSONArray();
				for(Component ac : cp.argumentsPanel.getComponents()) {
					arguments.put(((JTextField) ac).getText());
				}
				entry.put("arguments", arguments);
				
				data.put(entry);
			}
		} catch (JSONException e1) {
			e1.printStackTrace();
		}
		return data.toString(); 
	}
	
	private String sequenceToRuby() {
		String ruby = "";
		ruby += "#!/usr/bin/ruby\n";
		ruby += "\n";
		ruby += "require 'pty'\n";
		ruby += "require 'expect'\n";
		ruby += "\n";
		ruby += "$token = ARGV[0]\n";
		ruby += "\n";
		ruby += "def fsclient(*args)\n";
		ruby += "	begin\n";
		ruby += "		PTY.spawn('fsclient', $token, *args) do |r, w, pid|\n";
		ruby += "			loop {\n";
		ruby += "				out = r.expect(%r/^.+\\n$/io)\n";
		ruby += "				puts out unless out.nil?\n";
		ruby += "			}\n";
		ruby += "		end\n";
		ruby += "	rescue PTY::ChildExited => e\n";		
		ruby += "	end\n";
		ruby += "end\n";
		ruby += "\n";
		
		for(Component c : commandList.getComponents()) {
			CommandPanel cp = (CommandPanel) c;
			ruby += "fsclient('"+cp.commandList.getSelectedItem().toString()+"'";
			for(Component ac : cp.argumentsPanel.getComponents())
				ruby += ", '"+((JTextField) ac).getText()+"'";
			ruby += ")\n";
		}

		return ruby;
	}
	
	private void JSONToSequence(String raw) {
		JPanel newSequence = new JPanel();
		newSequence.setLayout(new BoxLayout(newSequence, BoxLayout.Y_AXIS));
		try {
			JSONArray parsed = new JSONArray(raw);
			
			for(int i=0;i<parsed.length();i++) {
				JSONObject entry = (JSONObject) parsed.get(i);
				newSequence.add(new CommandPanel(newSequence.getComponentCount(), entry));
			}
			
			commandListContainer.remove(commandList);
			commandList = newSequence;
			commandListContainer.add(commandList, BorderLayout.NORTH);
			controller.mainPanel.repaint();
		} catch (JSONException e) {
			JOptionPane.showMessageDialog(controller.frame, "Wrong format.");
		}
	}
	
}
