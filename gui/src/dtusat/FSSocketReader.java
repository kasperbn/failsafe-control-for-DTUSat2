package dtusat;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

public class FSSocketReader implements Runnable {

	private BufferedReader in;
	public FSSocketObserver observer;
	
	public FSSocketReader(BufferedReader in, FSSocketObserver observer) {
		this.in = in;
		this.observer = observer;
	}
	
	public void run() {
		String s;
		try {
			while(true) {
				s = "";
				// Read until zero-char
				int next = in.read();
				while(next != 0) {
					s += (char) next;
					next = in.read();
				}
				observer.handleIncomingData(s);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
