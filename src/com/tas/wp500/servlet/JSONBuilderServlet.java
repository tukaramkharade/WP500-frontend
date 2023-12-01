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
		if (check_username != null) {
			
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			try {
				json.put("operation", "protocol");
				json.put("protocol_type", "json_builder");
				json.put("operation_type", "get_query");
				json.put("user", check_username);
				json.put("token", check_token);
				
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				JSONArray resJsonArray = new JSONArray();

				logger.info("JSON Builder response : " + respJson.toString());

				JSONArray resultArr = respJson.getJSONArray("result");

				for (int i = 0; i < resultArr.length(); i++) {
					JSONObject jsObj = resultArr.getJSONObject(i);

					String json_string_name = jsObj.getString("json_string_name");
					String json_interval = jsObj.getString("json_interval");
					String broker_type = jsObj.getString("broker_type");
					String broker_ip_address = jsObj.getString("broker_ip_address");
					String publish_topic_name = jsObj.getString("publish_topic_name");
					String publishing_status = jsObj.getString("publishing_status");
					String store_n_forward = jsObj.getString("store_n_forward");
					String json_string = jsObj.getString("json_string");
					
					int intervalValue = Integer.parseInt(json_interval);
					String intervalString = IntervalMapper.getIntervalByValue(intervalValue);
					

					JSONObject jsonBuilderObj = new JSONObject();

					try {
						jsonBuilderObj.put("json_string_name", json_string_name);				
					    jsonBuilderObj.put("json_interval", intervalString);
						jsonBuilderObj.put("broker_type", broker_type);
						jsonBuilderObj.put("broker_ip_address", broker_ip_address);
						jsonBuilderObj.put("publish_topic_name", publish_topic_name);
						jsonBuilderObj.put("publishing_status", publishing_status);
						jsonBuilderObj.put("store_n_forward", store_n_forward);
						jsonBuilderObj.put("json_string", json_string);

						resJsonArray.put(jsonBuilderObj);
					} catch (JSONException e) {
						e.printStackTrace();
						logger.error("Error in putting json builder data in json array : "+e);
					}
				}

				logger.info("JSON ARRAY :" + resJsonArray.length() + " " + resJsonArray.toString());

				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());
			} catch (Exception e) {
				e.printStackTrace();
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

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		
		String json_string_name = null;
		String jsonInterval = null;
		String broker_type = null;
		String broker_name = null;
		String publishTopic = null;
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
					 publishTopic = request.getParameter("publish_topic");
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

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "protocol");
						json.put("protocol_type", "json_builder");
						json.put("operation_type", "add_query");
						json.put("user", check_username);
						json.put("token", check_token);
						
						JSONObject json_data = new JSONObject();
						json_data.put("json_string_name", json_string_name);
						json_data.put("json_interval", intervalValue);
						json_data.put("broker_type", broker_type);
						json_data.put("broker_ip_address", broker_name);
						json_data.put("publish_topic_name", publishTopic);
						json_data.put("publishing_status", publishStatus);
						json_data.put("store_n_forward", storeAndForward);
						json_data.put("json_string", json_string_con);

						json.put("Data", json_data);

						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr).getString("msg"));

						String message = new JSONObject(respStr).getString("msg");
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);

						// Set the content type of the response to application/json
						response.setContentType("application/json");

						// Get the response PrintWriter
						PrintWriter out = response.getWriter();

						// Write the JSON object to the response
						out.print(jsonObject.toString());
						out.flush();

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
					 publishTopic = request.getParameter("publish_topic");
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

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "protocol");
						json.put("protocol_type", "json_builder");
						json.put("operation_type", "update_query");
						json.put("user", check_username);
						json.put("token", check_token);
						
						JSONObject json_data = new JSONObject();
						json_data.put("json_string_name", json_string_name);							
						json_data.put("json_interval", intervalValue);
						json_data.put("broker_type", broker_type);
						json_data.put("broker_ip_address", broker_name);
						json_data.put("publish_topic_name", publishTopic);
						json_data.put("publishing_status", publishStatus);
						json_data.put("store_n_forward", storeAndForward);

						json_data.put("json_string", json_string_con);

						json.put("Data", json_data);

						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr).getString("msg"));

						String message = new JSONObject(respStr).getString("msg");
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);

						// Set the content type of the response to application/json
						response.setContentType("application/json");

						// Get the response PrintWriter
						PrintWriter out = response.getWriter();

						// Write the JSON object to the response
						out.print(jsonObject.toString());
						out.flush();

					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in updating json builder : "+e);
					}					
					break;
					
				case "delete":
					
					 json_string_name = request.getParameter("json_string_name");
					 
					 try {
							TCPClient client = new TCPClient();
							JSONObject json = new JSONObject();

							json.put("operation", "protocol");
							json.put("protocol_type", "json_builder");
							json.put("operation_type", "delete_query");
							json.put("user", check_username);
							json.put("json_string_name", json_string_name);
							json.put("token", check_token);
							
							String respStr = client.sendMessage(json.toString());

							logger.info("res " + new JSONObject(respStr).getString("msg"));

							String message = new JSONObject(respStr).getString("msg");
							JSONObject jsonObject = new JSONObject();
							jsonObject.put("message", message);

							// Set the content type of the response to application/json
							response.setContentType("application/json");

							// Get the response PrintWriter
							PrintWriter out = response.getWriter();

							// Write the JSON object to the response
							out.print(jsonObject.toString());
							out.flush();

						} catch (Exception e) {
							e.printStackTrace();
							logger.error("Error in deleting json builder : "+e);
						}				
					break;
				}
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
				logger.error("Error in session timeout: " + e);
			}
		}
	}
}
