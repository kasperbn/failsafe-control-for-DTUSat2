package dtusat;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class FSResponse {
	
	public int status;
	private String raw;
	private JSONObject parsed;
	
	public FSResponse(String raw) {
		this.raw = raw;
		
		try {
			parsed = new JSONObject(raw);
			this.status = parsed.getInt("status");
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}
	
	public String bodyAsString() {
		String r = null;
		try {
			r = parsed.getString("body");
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return r;
	}
	
	public JSONArray bodyAsArray() {
		JSONArray res = null;
		try {
			res = parsed.getJSONArray("body");
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return res;
	}
	
	public boolean isSuccess() {
		return (status == 0);
	}
	
}
