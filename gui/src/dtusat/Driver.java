package dtusat;

public class Driver {
	public static void main(String[] args) {
		FSController controller = FSController.getInstance();
		controller.start();
	}
}
