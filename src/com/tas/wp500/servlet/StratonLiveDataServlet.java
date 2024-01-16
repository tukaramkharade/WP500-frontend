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
		String check_role = (String) session.getAttribute("role");

		if (check_username != null) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			try {

				json.put("operation", "get_live_data");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);
				
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);
				String status = respJson.getString("status");
				System.out.println("status: "+status);
				

				logger.info("Straton live value response : " + respJson.toString());

				
			        JSONObject finalJsonObj = new JSONObject();
					if(status.equals("success")){
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
						
						JSONArray sortedJsonArray = new JSONArray(jsonValues);
						finalJsonObj.put("status", status);
					    finalJsonObj.put("result", sortedJsonArray);
					}else if(status.equals("fail")){
						String message = respJson.getString("msg");
						finalJsonObj.put("status", status);
					    finalJsonObj.put("message", message);
					}

				    // Set the response content type to JSON
				    response.setContentType("application/json");
				    response.setHeader("X-Content-Type-Options", "nosniff");

				    // Write the JSON data to the response
				    response.getWriter().print(finalJsonObj.toString());
	      
			    
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting straton data : "+e);
			}
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	
	}
}
