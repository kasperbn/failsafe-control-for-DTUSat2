package dtusat.components;

import dtusat.FSCallback;
import dtusat.FSController;
import dtusat.FSResponse;

public class ServerScriptPanel extends ScriptPanel {

	public ServerScriptPanel(String name, String path, String help) {
		super(name, path, help);
	}

	public void execute() {
		outputArea.setText("");
		FSController.getInstance().getSocket().request("run_script "+path+" "+getArguments(), new FSCallback() {
			public void onResponse(FSResponse response) {
				if(response.isPartial())
					outputArea.append(response.dataAsString());
			}
		});
	}
}
