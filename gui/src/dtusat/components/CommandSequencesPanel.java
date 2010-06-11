package dtusat.components;

import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSeparator;
import javax.swing.JSplitPane;
import javax.swing.JTextArea;
import javax.swing.JTree;

import dtusat.FSController;
import dtusat.FSResponse;
import dtusat.FSCallback;

public class CommandSequencesPanel extends JPanel implements ActionListener {
	private JPanel commandList;
	private JPanel commandListContainer;
	private FSController controller;
	private JSplitPane splitPane;
	private FileTree fileTree;
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

	public CommandSequencesPanel() {
		controller = FSController.getInstance();
		setLayout(new BorderLayout());
		
		// Splitpane
		splitPane = new JSplitPane();
		add(splitPane, BorderLayout.CENTER);
		
			// Left Panel
			leftPanel = new JPanel(new BorderLayout());		
			splitPane.setLeftComponent(leftPanel);
			
				// Center
				tree = new FileTree("/home/kbn/Code/bachelor/command_sequences/");
				leftPanel.add(tree, BorderLayout.CENTER);
				
				// South
				leftNorthPanel = new JPanel();
				leftPanel.add(leftNorthPanel, BorderLayout.NORTH);
				
					openButton = new JButton("Open", new ImageIcon("src/dtusat/icons/page_edit.png"));
					openButton.addActionListener(this);
					leftNorthPanel.add(openButton);
					
					setDirButton = new JButton("Set Dir", new ImageIcon("src/dtusat/icons/folder_explore.png"));
					setDirButton.addActionListener(this);
					leftNorthPanel.add(setDirButton);	
				
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
					
					JPanel rightNorthEastPanel = new JPanel();
					rightNorthPanel.add(rightNorthEastPanel, BorderLayout.EAST);
					
						newButton = new JButton("New", new ImageIcon("src/dtusat/icons/script_add.png"));
						newButton.addActionListener(this);
						rightNorthEastPanel.add(newButton);
						
						saveButton = new JButton("Save", new ImageIcon("src/dtusat/icons/script_save.png"));
						saveButton.addActionListener(this);
						rightNorthEastPanel.add(saveButton);
						
						exportButton = new JButton("Export", new ImageIcon("src/dtusat/icons/script_go.png"));
						exportButton.addActionListener(this);
						rightNorthEastPanel.add(exportButton);
				
				// Right split
				JSplitPane rightSplit = new JSplitPane();
				rightSplit.setDividerLocation(800);
				rightPanel.add(rightSplit, BorderLayout.CENTER);		
				
					// Left - Command list
					commandListContainer = new JPanel(new BorderLayout());
					
						commandList = new JPanel();
						commandList.setLayout(new BoxLayout(commandList, BoxLayout.Y_AXIS));
						commandListContainer.add(commandList, BorderLayout.NORTH);
						rightSplit.setLeftComponent(new JScrollPane(commandListContainer));
						//rightPanel.add(new JScrollPane(commandListContainer), BorderLayout.CENTER);
					
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

	protected void execute() {
		controller.log("===== BEGIN command sequence");
		for(Component c : commandList.getComponents()) {
			CommandPanel cp = (CommandPanel) c;
			controller.getSocket().send(cp.getFullCommand());
		}
		controller.log("===== END command sequence");
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		if(e.getSource() == addButton) {
			commandList.add(new CommandPanel());
			controller.mainPanel.repaint();
		}
		if(e.getSource() == executeButton)
			execute();
		if(e.getSource() == saveButton) {
			
		}
		if(e.getSource() == openButton) {
					
		}
		if(e.getSource() == setDirButton) {
			
		}
	}
}
