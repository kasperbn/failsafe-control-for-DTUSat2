package dtusat.panels;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;

import dtusat.FSController;
import dtusat.Logger;

public class InternalScriptPanel extends ScriptPanel {

	String path;
	Logger logger;
	
	public InternalScriptPanel(String name, String help, String path) {
		super(name, help);
		this.path = path;
		logger = FSController.getInstance();
	}

	public void execute() {
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
			int status = child.exitValue();
			 
			String line;
			String body = "";
			while ((line = out.readLine()) != null)
				body += line;
			
			logger.log("{\"body\":\""+body+"\", \"status\":"+status+"}");
		} catch (IOException e) {
			e.printStackTrace();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
}
