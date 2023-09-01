package com.tas.wp500.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

@WebServlet("/dashboard")
public class Dashboard extends HttpServlet {
	final static Logger logger = Logger.getLogger(Dashboard.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);	
		String check_username = (String) session.getAttribute("username");
		
		if(check_username != null){
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			try{
				json.put("operation", "get_latest_five_active_threats");
				json.put("user", check_username);
				
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				JSONArray resJsonArray = new JSONArray();

				logger.info("Active Threats response : " + respJson.toString());
				
				JSONArray resultArr = respJson.getJSONArray("data");
				
				for (int i = 0; i < resultArr.length(); i++) {
					JSONObject jsObj = resultArr.getJSONObject(i);
					
					String timeStamp = jsObj.getString("timeStamp");
					String alertMessage = jsObj.getString("alertMessage");	
					String threat_id = jsObj.getString("threat_id");
					String priority = jsObj.getString("priority");
					
					JSONObject latestThreatsObj = new JSONObject();
					
					try{
						
						latestThreatsObj.put("timeStamp", timeStamp);
						latestThreatsObj.put("alertMessage", alertMessage);
						latestThreatsObj.put("threat_id", threat_id);
						latestThreatsObj.put("priority", priority);
						
						resJsonArray.put(latestThreatsObj);
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error in putting latest active threats data in json array : " + e);
					}
				}
				
				logger.info("JSON ARRAY :" + resJsonArray.toString());

				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());
				
			}catch(Exception e){
				e.printStackTrace();
				logger.error("Error getting latest active threats : "+e);
			}
			
		}else{
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

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

}
