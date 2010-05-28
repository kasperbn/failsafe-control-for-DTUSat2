package dtusat;

public class UnsuccessfulRequestException extends Exception {

	String errorMessage;
	
	public UnsuccessfulRequestException(String e) {
		this.errorMessage = e;
	}

	public String toString() {
		return errorMessage;
	}
	
}
