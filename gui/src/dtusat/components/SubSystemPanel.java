package dtusat.components;

import java.awt.BorderLayout;
import java.awt.Insets;

import javax.swing.BoxLayout;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;

public class SubSystemPanel extends JPanel {
	
	public static final int GREEN = 0;
	public static final int YELLOW = 1;
	public static final int RED = 2;
	
	public SubSystemPanel(String name, int status, String description) throws UnknownStatusException {
		setLayout(new BorderLayout());
		//setBorder(BorderFactory.createLineBorder(Color.BLACK, 1));
		
		JPanel containerPanel = new JPanel();

		//containerPanel.setLayout(new BoxLayout(containerPanel, BoxLayout.Y_AXIS));
		//add(containerPanel, BorderLayout.NORTH);
		containerPanel.setLayout(new BorderLayout());
		add(containerPanel, BorderLayout.CENTER);
		
		JLabel headerLabel = new JLabel(name, iconForStatus(status), JLabel.LEFT);
		JTextArea descriptionTextArea = new JTextArea(description);
		descriptionTextArea.setBackground(this.getBackground());
		descriptionTextArea.setMargin(new Insets(2,5,5,5));
		descriptionTextArea.setLineWrap(true);
		
		containerPanel.add(headerLabel, BorderLayout.NORTH);
		containerPanel.add(descriptionTextArea, BorderLayout.CENTER);
	}

	private Icon iconForStatus(int status) throws UnknownStatusException {
		if(!(status == GREEN || status == YELLOW || status == RED)) 
			throw new UnknownStatusException();
		
		ImageIcon icon = null;
		switch(status) {
			case GREEN: icon = 	new ImageIcon("src/dtusat/icons/green.png"); break;
			case YELLOW: icon = new ImageIcon("src/dtusat/icons/yellow.png"); break;
			case RED: icon = 	new ImageIcon("src/dtusat/icons/red.png"); break;
		}
		return icon;
	}
	
}
