package dtusat;

public interface FSSocketObserver {
	public void onConnected();

	public void onConnectionRefused();

	public void onDisconnected();
	
	public void log(String string);

	public void registerCallback(String id, FSCallback callback);

	public void handleIncomingData(String s);

}
