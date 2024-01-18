package com.tas.wp500.servlet;

import java.io.IOException;
import java.io.PrintWriter;

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
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.tas.wp500.utils.IntervalMapper;
import com.tas.wp500.utils.TCPClient;

@WebServlet("/jsonBuilderServlet")
public class JSONBuilderServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(JSONBuilderServlet.class);
 
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		String csrfTokenFromRequest = request.getParameter("csrfToken");

		// Retrieve CSRF token from the session
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");

		
		if (check_username != null) {
			
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			try {
				
				if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
				json.put("operation", "protocol");
				json.put("protocol_type", "json_builder");
				json.put("operation_type", "get_query");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);
				
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				logger.info("JSON Builder response : " + respJson.toString());
				
				String status = respJson.getString("status");
				String message = respJson.getString("msg");
				
				JSONObject finalJsonObj = new JSONObject();
				if(status.equals("success")){
					JSONArray resultArr = respJson.getJSONArray("result");
					finalJsonObj.put("status", status);
					
					if (resultArr.length() > 0 && resultArr.getJSONObject(0).has("json_interval")) {
			            String jsonInterval = resultArr.getJSONObject(0).getString("json_interval");
			            int intervalValue = Integer.parseInt(jsonInterval);
			            String intervalString = IntervalMapper.getIntervalByValue(intervalValue);
			            
			            // Add the intervalString to the finalJsonObj
			            finalJsonObj.put("intervalString", intervalString);
			        }
					
				    finalJsonObj.put("result", resultArr);
				}else if(status.equals("fail")){
					finalJsonObj.put("status", status);
				    finalJsonObj.put("message", message);
				}

			    // Set the response content type to JSON
			    response.setContentType("application/json");
			    response.setHeader("X-Content-Type-Options", "nosniff");

			    // Write the JSON data to the response
			    response.getWriter().print(finalJsonObj.toString());
				}else {
					logger.error("CSRF token validation failed");	
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		String csrfTokenFromRequest = request.getParameter("csrfToken");

		// Retrieve CSRF token from the session
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");

		
		String json_string_name = null;
		String jsonInterval = null;
		String broker_type = null;
		String broker_name = null;
	//	String publishTopic = null;
		String publishStatus = null;
		String storeAndForward = null;
		String json_string_text = null;
		
		String intervalValue = null;
		
		JSONParser parser = new JSONParser();
		org.json.simple.JSONObject json_string_con = null;
		
		if (check_username != null) {
			
			String action = request.getParameter("action");

			if (action != null) {
				switch (action) {
				
				case "add":
					json_string_name = request.getParameter("json_string_name");
					 jsonInterval = request.getParameter("json_interval");
					 broker_type = request.getParameter("broker_type");
					 broker_name = request.getParameter("broker_name");
					// publishTopic = request.getParameter("publish_topic");
					 publishStatus = request.getParameter("publishing_status");
					 storeAndForward = request.getParameter("storeAndForward");
					 json_string_text = request.getParameter("json_string_text");
					
					 intervalValue = IntervalMapper.getIntervalByString(jsonInterval);
					
					try {
						json_string_con = (org.json.simple.JSONObject) parser.parse(json_string_text);
					} catch (ParseException e1) {
						e1.printStackTrace();
						logger.error("Error in converting into json object : "+e1);
					}

					try {
						
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "protocol");
						json.put("protocol_type", "json_builder");
						json.put("operation_type", "add_query");
						json.put("user", check_username);
						json.put("token", check_token);
						json.put("role", check_role);
						
						JSONObject json_data = new JSONObject();
						json_data.put("json_string_name", json_string_name);
						json_data.put("json_interval", intervalValue);
						json_data.put("broker_type", broker_type);
						json_data.put("broker_ip_address", broker_name);
						json_data.put("publish_topic_name", "");
						json_data.put("publishing_status", publishStatus);
						json_data.put("store_n_forward", storeAndForward);
						json_data.put("json_string", json_string_con);

						json.put("Data", json_data);

						String respStr = client.sendMessage(json.toString());

						//logger.info("res " + new JSONObject(respStr));

						String message = new JSONObject(respStr).getString("msg");
						String status = new JSONObject(respStr).getString("status");
						
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);
						jsonObject.put("status", status);

						// Set the content type of the response to application/json
						response.setContentType("application/json");
						 response.setHeader("X-Content-Type-Options", "nosniff");
						 
						 
						// Get the response PrintWriter
						PrintWriter out = response.getWriter();

						// Write the JSON object to the response
						out.print(jsonObject.toString());
						out.flush();
						}else {
							logger.error("CSRF token validation failed");	
						}
					} catch (Exception e) {
						e.printStackTrace();
						logger.info("Error in adding json builder : "+e);
					}				
					break;
					
				case "update":
					
					 json_string_name = request.getParameter("json_string_name");
					 jsonInterval = request.getParameter("json_interval");
					 broker_type = request.getParameter("broker_type");
					 broker_name = request.getParameter("broker_name");
				//	 publishTopic = request.getParameter("publish_topic");
					 publishStatus = request.getParameter("publishing_status");
					 storeAndForward = request.getParameter("storeAndForward");
					 json_string_text = request.getParameter("json_string_text");
					
					intervalValue = IntervalMapper.getIntervalByString(jsonInterval);

					try {
						json_string_con = (org.json.simple.JSONObject) parser.parse(json_string_text);
					} catch (ParseException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
						logger.error("Error in converting into json object : "+e1);
					}

					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
							
						
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "protocol");
						json.put("protocol_type", "json_builder");
						json.put("operation_type", "update_query");
						json.put("user", check_username);
						json.put("token", check_token);
						json.put("role", check_role);
						
						JSONObject json_data = new JSONObject();
						json_data.put("json_string_name", json_string_name);							
						json_data.put("json_interval", intervalValue);
						json_data.put("broker_type", broker_type);
						json_data.put("broker_ip_address", broker_name);
						json_data.put("publish_topic_name", "");
						json_data.put("publishing_status", publishStatus);
						json_data.put("store_n_forward", storeAndForward);

						json_data.put("json_string", json_string_con);

						json.put("Data", json_data);

						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr));

						String message = new JSONObject(respStr).getString("msg");
						String status = new JSONObject(respStr).getString("status");
						
						JSONObject jsonObject = new JSONObject();
						
						jsonObject.put("message", message);
						jsonObject.put("status", status);
						// Set the content type of the response to application/json
						response.setContentType("application/json");
						 response.setHeader("X-Content-Type-Options", "nosniff");

						// Get the response PrintWriter
						PrintWriter out = response.getWriter();

						// Write the JSON object to the response
						out.print(jsonObject.toString());
						out.flush();
						}else {
							logger.error("CSRF token validation failed");	
						}
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in updating json builder : "+e);
					}					
					break;
					
				case "delete":
					
					 json_string_name = request.getParameter("json_string_name");
					 
					 try {
						 
							if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
							TCPClient client = new TCPClient();
							JSONObject json = new JSONObject();

							json.put("operation", "protocol");
							json.put("protocol_type", "json_builder");
							json.put("operation_type", "delete_query");
							json.put("user", check_username);
							json.put("json_string_name", json_string_name);
							json.put("token", check_token);
							json.put("role", check_role);
							
							String respStr = client.sendMessage(json.toString());

							logger.info("res " + new JSONObject(respStr));

							String message = new JSONObject(respStr).getString("msg");
							String status = new JSONObject(respStr).getString("status");
							
							JSONObject jsonObject = new JSONObject();
							jsonObject.put("message", message);
							jsonObject.put("status", status);
							
							// Set the content type of the response to application/json
							response.setContentType("application/json");
							 response.setHeader("X-Content-Type-Options", "nosniff");

							// Get the response PrintWriter
							PrintWriter out = response.getWriter();

							// Write the JSON object to the response
							out.print(jsonObject.toString());
							out.flush();
							}else {
								logger.error("CSRF token validation failed");	
							}
						} catch (Exception e) {
							e.printStackTrace();
							logger.error("Error in deleting json builder : "+e);
						}				
					break;
				}
			}			 
		} 
	}
}
