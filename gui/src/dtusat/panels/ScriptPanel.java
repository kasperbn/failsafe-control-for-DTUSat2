package dtusat.panels;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.border.TitledBorder;

import dtusat.FSController;
import dtusat.FSResponse;

public class ScriptPanel extends JPanel {
	
	String name, help;
	JPanel descriptionPanel;
	JLabel nameLabel;
	
	JTextArea helpTextArea;
	JTextField argumentsTextField;
	JButton executeButton;
	JLabel argumentsLabel;
	
	public ScriptPanel(String name, String help) {
		this.name = name;
		this.help = help;		
		setLayout(new BorderLayout());
		setBorder(new TitledBorder(name));
		
		// Description
		descriptionPanel = new JPanel();
		descriptionPanel.setLayout(new BoxLayout(descriptionPanel, BoxLayout.Y_AXIS));
		add(descriptionPanel, BorderLayout.CENTER);
		
		nameLabel = new JLabel(name);
		helpTextArea = new JTextArea(help);
		helpTextArea.setEditable(false);
		helpTextArea.setBackground(this.getBackground());
		helpTextArea.setMargin(new Insets(5,5,5,5));
		descriptionPanel.add(helpTextArea);
		
		// Execution Panel
		JPanel executionPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
		add(executionPanel, BorderLayout.SOUTH);
		
		argumentsLabel = new JLabel("Arguments: ");
		executionPanel.add(argumentsLabel);	
		
		argumentsTextField = new JTextField(20);
		executionPanel.add(argumentsTextField);
		
		executeButton = new JButton("Execute");
		executeButton.addActionListener(new ActionListener() { public void actionPerformed(ActionEvent e) {execute();} });
		executionPanel.add(executeButton);
		
	}
	
	private String getArguments() {
		String r = argumentsTextField.getText();
		return (r == "") ? "" : " "+r;
	}
	
	public void execute() {
		FSController.getInstance().getSocket().execute("run_script "+name+getArguments());
	}
}
