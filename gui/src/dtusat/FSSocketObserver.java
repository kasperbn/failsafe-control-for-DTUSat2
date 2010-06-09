package dtusat;

public interface FSSocketObserver {
	public void onConnected();

	public void onConnectionRefused();

	public void onDisconnected();
	
	public void log(String string);

	public void onRegisterCallback(String id, FSCallback callback);

	public void onIncomingData(String s);

}
