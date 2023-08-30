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

@WebServlet("/activeThreatServlet")
public class ActiveThreatServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(ActiveThreatServlet.class);

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);
		
		String check_username = (String) session.getAttribute("username");
		
		if(check_username != null){
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			try{
				
				json.put("operation", "get_active_threats");
				json.put("user", check_username);
				
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				JSONArray resJsonArray = new JSONArray();

				logger.info("Active Threats response : " + respJson.toString());
				
				JSONArray resultArr = respJson.getJSONArray("data");
				
				for (int i = 0; i < resultArr.length(); i++) {
					JSONObject jsObj = resultArr.getJSONObject(i);
					
					String src_ip = jsObj.getString("src_ip");
					int src_port = jsObj.getInt("src_port");
					String protocol_type = jsObj.getString("protocol_type");
					String ack_at = jsObj.getString("ack_at");
					String ack_by = jsObj.getString("ack_by");
					String alert_message = jsObj.getString("alert_message");
					String dest_ip = jsObj.getString("dest_ip");
					String threat_id = jsObj.getString("threat_id");
					String priority = jsObj.getString("priority");
					int dest_port = jsObj.getInt("dest_port");
					String timestamp = jsObj.getString("timestamp");
					
					JSONObject activeThreatsObj = new JSONObject();
					try{
						activeThreatsObj.put("src_ip", src_ip);
						activeThreatsObj.put("src_port", src_port);
						activeThreatsObj.put("protocol_type", protocol_type);
						activeThreatsObj.put("ack_at", ack_at);
						activeThreatsObj.put("ack_by", ack_by);
						activeThreatsObj.put("alert_message", alert_message);
						activeThreatsObj.put("dest_ip", dest_ip);
						activeThreatsObj.put("threat_id", threat_id);
						activeThreatsObj.put("priority", priority);
						activeThreatsObj.put("dest_port", dest_port);
						activeThreatsObj.put("timestamp", timestamp);

						resJsonArray.put(activeThreatsObj);
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error in putting active threats data in json array : " + e);
					}					
				}
				
				logger.info("JSON ARRAY :" + resJsonArray.length() + " " + resJsonArray.toString());

				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());
				
			}catch(Exception e){
				e.printStackTrace();
				logger.error("Error getting active threats :"+e);
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
