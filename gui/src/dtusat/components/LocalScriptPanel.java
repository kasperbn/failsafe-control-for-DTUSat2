package dtusat.components;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;

import dtusat.FSController;
import dtusat.Logger;

public class LocalScriptPanel extends ScriptPanel {

	Logger logger;
	
	public LocalScriptPanel(String name, String path, String help) {
		super(name, path, help);
		logger = FSController.getInstance();
	}

	public void execute() {
		outputArea.setText("");
		try {
			String token = FSController.getInstance().getSocket().token;
			
			String[] args = getArguments().split(" ");
			String[] argList = new String[2+args.length];
			argList[0] = path;
			argList[1] = token;
			for(int i=0;i<args.length;i++)
				argList[2+i] = args[i];
		
			Process child = new ProcessBuilder(argList).start();
			BufferedReader out = new BufferedReader(new InputStreamReader(child.getInputStream()));
			child.waitFor();
			
			String line;
			while ((line = out.readLine()) != null) {
				outputArea.append(line+"\n");
			}
			
		} catch (IOException e) {
			e.printStackTrace();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
}
