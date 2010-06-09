package dtusat;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.SocketException;

public class FSSocketReader implements Runnable {

	private BufferedReader in;
	public FSSocketObserver observer;
	public boolean stop;
	
	public FSSocketReader(BufferedReader in, FSSocketObserver observer) {
		this.in = in;
		this.observer = observer;
		stop = false;
	}
	
	public void run() {
		String s;
		try {
			while(!stop) {
				s = "";
				// Read until zero-char
				int next = in.read();
				while(next != 0) {
					s += (char) next;
					next = in.read();
				}
				observer.onIncomingData(s);
			}
		} catch(SocketException e) {
			observer.onDisconnected();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void stop() {
		stop = true;
	}

}
