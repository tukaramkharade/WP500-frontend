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

@WebServlet("/BasicConfigurationServlet")
public class BasicConfigurationServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(BasicConfigurationServlet.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();
		
		try{
			
			HttpSession session = request.getSession(false);

			String check_username = (String) session.getAttribute("username");
			
			if (check_username != null) {
				
				json.put("operation", "get_iptable_basic_settings");
				json.put("user", check_username);
				
				String respStr = client.sendMessage(json.toString());
				JSONObject respJson = new JSONObject(respStr);

				JSONArray jsonArray = new JSONArray(respJson.getJSONArray("data").toString());
				logger.info(respJson.getJSONArray("data").toString());

				JSONArray resJsonArray = new JSONArray();
				
				for (int i = 0; i < jsonArray.length(); i++) {
					JSONObject jsObj = jsonArray.getJSONObject(i);

					String lan_type = jsObj.getString("lan_type");					
					String protocol = jsObj.getString("protocol");				
					String to_port = jsObj.getString("to_port");
					String action = jsObj.getString("action");
					String comment = jsObj.getString("comment");
					String direction = jsObj.getString("direction");
					int id = jsObj.getInt("id");

					JSONObject basicConfigObj = new JSONObject();

					try {
						basicConfigObj.put("lan_type", lan_type);
						basicConfigObj.put("protocol", protocol);
						basicConfigObj.put("to_port", to_port);
						basicConfigObj.put("action", action);
						basicConfigObj.put("comment", comment);
						basicConfigObj.put("direction", direction);
						basicConfigObj.put("id", id);

						resJsonArray.put(basicConfigObj);
						
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in putting basic configuration data in json array : " + e);
					}
				}

				// Set the response content type to JSON
				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());

				
				
				
			}else {

				try {
					JSONObject userObj = new JSONObject();
					userObj.put("msg", "Your session is timeout. Please login again");
					userObj.put("status", "fail");

					System.out.println(">>" + userObj);

					// Set the response content type to JSON
					response.setContentType("application/json");

					// Write the JSON data to the response
					response.getWriter().print(userObj.toString());

				} catch (Exception e) {
					e.printStackTrace();
					logger.error("Error in session timeout : " + e);
				}
			}
			
		}catch(Exception e){
			e.printStackTrace();
			logger.error("Error in getting basic configuration list : " + e);
		}
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

}
