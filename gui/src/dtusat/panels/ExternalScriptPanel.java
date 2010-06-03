package dtusat.panels;

import dtusat.FSController;

public class ExternalScriptPanel extends ScriptPanel {

	public ExternalScriptPanel(String name, String help) {
		super(name, help);
	}

	public void execute() {
		FSController.getInstance().getSocket().execute("run_script "+name+" "+getArguments());
	}
}
