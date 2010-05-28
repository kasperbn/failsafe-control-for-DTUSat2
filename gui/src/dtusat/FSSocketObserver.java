package dtusat;

public interface FSSocketObserver {
	public void onConnected();

	public void onConnectionRefused();

	public void onDisconnected();
}
