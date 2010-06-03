package dtusat.panels;

import javax.swing.JTabbedPane;

public class MainTabs extends JTabbedPane {

	public MainTabs() {
		addTab("Server Scripts", new ExternalPanel());
		addTab("Local Scripts", new InternalPanel());
		addTab("Linear Command Sequences", new CustomPanel());
		addTab("Health Status", new HealthPanel());
	}

}
