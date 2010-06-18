package dtusat;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class FSResponse {
	
	public String type;
	public String id;
	public int status;
	private JSONObject parsed;
	private boolean partial;
	
	public FSResponse(String raw) {
		try {
			parsed = new JSONObject(raw);
			this.type = parsed.getString("type");
			
			if(type.equals("response")) {
				this.status = parsed.getInt("status");
				this.id = parsed.getString("id");
			}
			
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		try {
			this.partial = parsed.getBoolean("partial");
		} catch (JSONException e1) {
			this.partial = false;
		}
	}
	
	public String dataAsString() {
		String r = null;
		try {
			r = parsed.getString("data");
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return r;
	}
	
	public JSONArray dataAsArray() {
		JSONArray res = null;
		try {
			res = parsed.getJSONArray("data");
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return res;
	}
	
	public boolean isSuccess() {
		return (status == FSController.STATUS_OK);
	}

	public boolean isPartial() {
		return partial;
	}

	public String messageAsString() {
		String r = null;
		try {
			r = parsed.getString("message");
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return r;
	}
	
}
