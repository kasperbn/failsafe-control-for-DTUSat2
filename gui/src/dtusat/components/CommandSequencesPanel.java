package dtusat.components;

import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.JScrollPane;

import dtusat.FSController;
import dtusat.FSResponse;
import dtusat.FSCallback;

public class CommandSequencesPanel extends JPanel {
	private JPanel commandList;
	private JPanel commandPanel;
	private FSController controller;

	public CommandSequencesPanel() {
		controller = FSController.getInstance();
		
		setLayout(new BorderLayout());
		
		// Command List
		commandList = new JPanel();
		commandList.setLayout(new BoxLayout(commandList, BoxLayout.Y_AXIS));
		
		commandPanel = new JPanel(new BorderLayout());
		commandPanel.add(commandList, BorderLayout.NORTH);
		
		JScrollPane commandListScroll = new JScrollPane(commandPanel);
		add(commandListScroll, BorderLayout.CENTER);
		
		// Button Panel
		JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
		add(buttonPanel, BorderLayout.NORTH);
		
		JButton addButton = new JButton("Add", new ImageIcon("src/dtusat/icons/add.png"));
		addButton.addActionListener(new ActionListener() {public void actionPerformed(ActionEvent e) {addCommandPanel();}});
		buttonPanel.add(addButton);
		
		JButton executeButton = new JButton("Execute", new ImageIcon("src/dtusat/icons/execute.png"));
		executeButton.addActionListener(new ActionListener() {public void actionPerformed(ActionEvent e) {execute();}});
		buttonPanel.add(executeButton);
	}

	protected void execute() {
		controller.log("===== BEGIN command sequence");
		for(Component c : commandList.getComponents()) {
			CommandPanel cp = (CommandPanel) c;
			controller.getSocket().send(cp.getFullCommand());
		}
		controller.log("===== END command sequence");
	}

	protected void addCommandPanel() {
		commandList.add(new CommandPanel());
		FSController.getInstance().mainPanel.repaint();
	}
}
