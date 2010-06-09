package dtusat.components;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
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
	
	String name, path, help;
	JPanel descriptionPanel;
	JLabel nameLabel;
	
	JTextArea helpTextArea;
	JTextField argumentsTextField;
	JButton executeButton;
	JLabel argumentsLabel;
	JTextArea outputArea;
	
	public ScriptPanel(String name, String path, String help) {
		this.name = name;
		this.path = path;
		this.help = help;
		
		setLayout(new BorderLayout());
		setBorder(new TitledBorder(name));
		
		JPanel boxLayout = new JPanel();
		boxLayout.setLayout(new BoxLayout(boxLayout, BoxLayout.Y_AXIS));
		add(boxLayout, BorderLayout.NORTH);
		
		// Description
		descriptionPanel = new JPanel();
		descriptionPanel.setLayout(new BoxLayout(descriptionPanel, BoxLayout.Y_AXIS));
		boxLayout.add(descriptionPanel);
		
		nameLabel = new JLabel(name);
		helpTextArea = new JTextArea(help);
		helpTextArea.setEditable(false);
		helpTextArea.setBackground(this.getBackground());
		helpTextArea.setMargin(new Insets(5,5,5,5));
		helpTextArea.setFont(Font.decode("monospaced"));
		descriptionPanel.add(helpTextArea);
		
		// Execution Panel
		JPanel executionPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
		boxLayout.add(executionPanel, BorderLayout.SOUTH);
		
		argumentsLabel = new JLabel("Arguments: ");
		executionPanel.add(argumentsLabel);	
		
		argumentsTextField = new JTextField(20);
		executionPanel.add(argumentsTextField);
		
		executeButton = new JButton("Execute");
		executeButton.addActionListener(new ActionListener() { public void actionPerformed(ActionEvent e) {execute();} });
		executionPanel.add(executeButton);
		
		// Outpanel
		outputArea = new JTextArea();
		outputArea.setMargin(new Insets(5,5,5,5));
		boxLayout.add(outputArea);
	}
	
	protected String getArguments() {
		return argumentsTextField.getText();
	}
	
	public void execute() {
	}
}
