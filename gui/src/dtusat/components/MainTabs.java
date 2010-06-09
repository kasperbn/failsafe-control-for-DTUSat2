package dtusat.components;

import javax.swing.JTabbedPane;

public class MainTabs extends JTabbedPane {

	public MainTabs() {
		
		setTabPlacement(JTabbedPane.LEFT);
		
		addTab("Server Scripts", new ServerScriptsPanel());
		addTab("Local Scripts", new LocalScriptsPanel());
		addTab("Linear Command Sequences", new CommandSequencesPanel());
		addTab("Health Status", new HealthPanel());
	}

}
