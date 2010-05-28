package dtusat.panels;

import java.awt.BorderLayout;
import javax.swing.JPanel;
import javax.swing.JTabbedPane;

import dtusat.FSController;
import dtusat.FSSocket;

public class MainPanel extends JPanel {

	FSSocket socket;
	JPanel internalPanel, customPanel;
	ExternalPanel externalPanel;
	
	
	public MainPanel() {
		socket = FSController.getInstance().getSocket();
		
		// CONTENT
		JTabbedPane tabbedPane = new JTabbedPane();
		externalPanel = new ExternalPanel();
		internalPanel = new JPanel();
		customPanel = new JPanel();
		tabbedPane.addTab("External Scripts", externalPanel);
		tabbedPane.addTab("Internal Scripts", internalPanel);
		tabbedPane.addTab("Custom Scripts", customPanel);
		
		setLayout(new BorderLayout());
		add(tabbedPane, BorderLayout.CENTER);
	}

}
