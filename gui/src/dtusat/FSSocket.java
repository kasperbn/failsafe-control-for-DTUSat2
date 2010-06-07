package dtusat;

import java.awt.Color;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.*;
import java.math.BigInteger;
import java.net.*;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Observable;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class FSSocket extends Observable {
	
	String host, port;
	public String token;
	private Socket socket;
	private BufferedReader in;
	private PrintWriter out;
	public FSSocketObserver observer;
	public FSSocketReader socketReader;
	private Thread inThread;
	
	public FSSocket() {
		observer = FSController.getInstance();
		token = "";
	}
	
	public void connect(String host, String port) {
		this.host = host;
		this.port = port;
		
		try {
			socket = new Socket(host, Integer.parseInt(port));
			in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
			out = new PrintWriter(socket.getOutputStream(), true);
			
			socketReader = new FSSocketReader(in, observer);
			inThread = new Thread(socketReader);
			inThread.start();
			
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
	
	public void send(String command) {
		request(command, null);
	}
	
	public void request(String command, FSCallback callback) {
		String data = (command == "lock") ? command : token+" "+command;
		String id = generateUniqueId();
		String request = "{\"id\":\""+id+"\", \"data\":\""+data+"\"}";
		
		if(callback != null)
			observer.registerCallback(id, callback);
		
		observer.log("> "+request);
		out.println(request);
	}
	
	private String generateUniqueId() {
		SecureRandom random = new SecureRandom();
		return new BigInteger(16, random).toString(6);
	}

	
}