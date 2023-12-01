package com.tas.wp500.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

@WebServlet("/stratonLiveDataServlet")
public class StratonLiveDataServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(StratonLiveDataServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);
		
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");

		if (check_username != null) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			try {

				json.put("operation", "get_live_data");
				json.put("user", check_username);
				json.put("token", check_token);
				
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				JSONArray resJsonArray = new JSONArray();

				logger.info("Straton live value response : " + respJson.toString());

				JSONArray resultArr = respJson.getJSONArray("result");
				
				String result_arr = resultArr.toString();
								
				 	JSONArray jsonArr = new JSONArray(result_arr);
				    
				    List<JSONObject> jsonValues = new ArrayList<JSONObject>();
				    for (int i = 0; i < jsonArr.length(); i++) {
				        jsonValues.add(jsonArr.getJSONObject(i));
				    }
				    Collections.sort( jsonValues, new Comparator<JSONObject>() {
				        //You can change "Name" with "ID" if you want to sort by ID
				        private static final String KEY_NAME = "tag_name";

				        @Override
				        public int compare(JSONObject a, JSONObject b) {
				            String valA = new String();
				            String valB = new String();

				            try {
				                valA = (String) a.get(KEY_NAME);
				                valB = (String) b.get(KEY_NAME);
				            } 
				            catch (JSONException e) {
				               e.printStackTrace();
				               logger.error("Error in sorting tags :" +e);
				            }

				            return valA.compareTo(valB);
				            //if you want to change the sort order, simply use the following:
				            //return -valA.compareTo(valB);
				        }
				    });
				    
				 // Convert the sorted list back to JSONArray
			        JSONArray sortedJsonArray = new JSONArray(jsonValues);

			        // Print the sorted JSONArray
			        System.out.println("sorted json array:" + sortedJsonArray);
				    

				for (int i = 0; i < sortedJsonArray.length(); i++) {
					JSONObject jsObj = sortedJsonArray.getJSONObject(i);

					String extError = jsObj.getString("extError");
					String access = jsObj.getString("access");
					String tag_name = jsObj.getString("tag_name");
					String error = jsObj.getString("error");
					String value = jsObj.getString("value");
			
					JSONObject stratonObj = new JSONObject();

					try {

						stratonObj.put("extError", extError);
						stratonObj.put("access", access);
						stratonObj.put("tag_name", tag_name);
						stratonObj.put("error", error);
						stratonObj.put("value", value);

						resJsonArray.put(stratonObj);
					} catch (JSONException e) {
						e.printStackTrace();
						logger.error("Error in putting straton data in json array : "+e);
					}
				}

				logger.info("JSON ARRAY :" + resJsonArray.length() + " " + resJsonArray.toString());

				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting straton data : "+e);
			}
		} else {
			
			try {
				JSONObject userObj = new JSONObject();
				userObj.put("msg", "Your session is timeout. Please login again");
				userObj.put("status", "fail");
				
				System.out.println(">>" +userObj);
				
				// Set the response content type to JSON
				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(userObj.toString());
				
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in session timeout : "+e);
			}

		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	
	}
}
