package dtusat;

import java.io.*;
import java.math.BigInteger;
import java.net.*;
import java.security.SecureRandom;

public class FSSocket {
	
	public String host, port;
	public String token;
	private Socket socket;
	private BufferedReader in;
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
			
			socketReader = new FSSocketReader(in, observer);
			inThread = new Thread(socketReader);
			inThread.start();
			
			observer.onConnected();
		} catch (UnknownHostException e) {
			e.printStackTrace();
			observer.onConnectionRefused();
		} catch (ConnectException e) {
			observer.onConnectionRefused();
		} catch (IOException e) {
			e.printStackTrace();
			observer.onConnectionRefused();
		}
	}
	
	public void disconnect() {
		try {
			socket.close();
			observer.onDisconnected();
			socketReader.stop();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public void send(String command) {
		request(command, null);
	}
	
	public void request(String command, FSCallback callback) {
		String id = generateUniqueId();
		String request = "{\"id\":\""+id+"\", \"data\":\""+command+"\", \"token\":\""+token+"\"}";
		
		if(callback != null)
			observer.onRegisterCallback(id, callback);
		
		try {
			observer.log("> "+request);
			byte[] bytes = request.getBytes();
			socket.getOutputStream().write(bytes);
		} catch (SocketException e) {
			observer.onDisconnected();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (NullPointerException e) {
			// Not connected yet
		}
		
	}
	
	private String generateUniqueId() {
		SecureRandom random = new SecureRandom();
		return new BigInteger(16, random).toString(6);
	}
	
}