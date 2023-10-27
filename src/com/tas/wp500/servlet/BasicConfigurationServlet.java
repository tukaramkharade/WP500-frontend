package com.tas.wp500.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
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
	    HttpSession session = request.getSession(false);
	    String check_username = (String) session.getAttribute("username");

	    if (check_username != null) {
	        try {
	            TCPClient client = new TCPClient();
	            JSONObject json = new JSONObject();

	            JSONArray responseDataArray = new JSONArray();

	            json.put("operation", "update_iptable_basic_settings");
	            json.put("user", check_username);

	            // Read the JSON data from the request
	            StringBuilder jsonPayload = new StringBuilder();
	            try (BufferedReader reader = request.getReader()) {
	                String line;
	                while ((line = reader.readLine()) != null) {
	                    jsonPayload.append(line);
	                }
	            }

	            // Parse the incoming JSON data
	            JSONObject requestData = new JSONObject(jsonPayload.toString());

	            if (requestData.has("data")) {
	                JSONArray dataArray = requestData.getJSONArray("data");

	                for (int i = 0; i < dataArray.length(); i++) {
	                    JSONObject dataObj = dataArray.getJSONObject(i);

	                    // Extract the data you need and add it to responseDataArray
	                    responseDataArray.put(dataObj);
	                }
	            }

	            // Add the "data" array to the JSON object
	            json.put("data", responseDataArray);

	            String respStr = client.sendMessage(json.toString());
	            System.out.println("res " + new JSONObject(respStr));

	            String message = new JSONObject(respStr).getString("msg");
	            JSONObject jsonObject1 = new JSONObject();
	            jsonObject1.put("message", message);

	            // Set the content type of the response to application/json
	            response.setContentType("application/json");

	            // Get the response PrintWriter
	            PrintWriter out = response.getWriter();

	            // Write the JSON object to the response
	            out.print(jsonObject1.toString());
	            out.flush();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    } else {
	        
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
	}
}
