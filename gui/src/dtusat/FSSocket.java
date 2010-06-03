package dtusat;

import java.awt.Color;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.*;
import java.net.*;
import java.util.ArrayList;
import java.util.Observable;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class FSSocket extends Observable {
	
	String host, port;
	public String token;
	FSController controller;
	private Socket socket;
	private BufferedReader in;
	private PrintWriter out;
	public FSSocketObserver observer;
	
	public FSSocket() {
		observer = FSController.getInstance();
		token = "";
	}
	
	public void connect(String host, String port) {
		controller = FSController.getInstance();
		this.host = host;
		this.port = port;
		
		try {
			socket = new Socket(host, Integer.parseInt(port));
			in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
			out = new PrintWriter(socket.getOutputStream(), true);
			observer.onConnected();
		} catch (UnknownHostException e) {
			e.printStackTrace();
		} catch (ConnectException e) {
			observer.onConnectionRefused();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public void disconnect() {
		try {
			socket.close();
			observer.onDisconnected();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public FSResponse execute(String command) {
		String s = "";
		String request = (command == "lock") ? command : token+" "+command;
		controller.log("> "+request);
		out.println(request);
		try {
			// Read until zero-char
			int next = in.read();
			while(next != 0 ) {
				s += (char) next;
				next = in.read();
			}
		} catch (IOException e) {
			s = e.getMessage();
		}
		
		controller.log("< "+s);
		return new FSResponse(s);
	}
}