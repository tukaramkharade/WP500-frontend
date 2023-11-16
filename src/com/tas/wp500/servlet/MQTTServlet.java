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

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

@WebServlet("/mqttServlet")
public class MQTTServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(MQTTServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");

		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();

		if (check_username != null) {

			try {

				json.put("operation", "protocol");
				json.put("protocol_type", "mqtt");
				json.put("operation_type", "get_query");
				json.put("user", check_username);

				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);
				JSONArray resJsonArray = new JSONArray();
				logger.info("MQTT response : " + respJson.toString());
				JSONArray resultArr = respJson.getJSONArray("result");

				for (int i = 0; i < resultArr.length(); i++) {
					JSONObject jsObj = resultArr.getJSONObject(i);

					String broker_ip_address = jsObj.getString("broker_ip_address");
					String port_number = jsObj.getString("port_number");
					String username = jsObj.getString("username");
					String password = jsObj.getString("password");
					String publish_topic = jsObj.getString("publish_topic");
					String subscribe_topic = jsObj.getString("subscribe_topic");
					String prefix = jsObj.getString("prefix");
					String file_type = jsObj.getString("file_type");
					String file_name = jsObj.getString("file_name");
					String enable = jsObj.getString("enable");

					JSONObject mqttObj = new JSONObject();

					try {
						mqttObj.put("broker_ip_address", broker_ip_address);
						mqttObj.put("port_number", port_number);
						mqttObj.put("username", username);
						mqttObj.put("password", password);
						mqttObj.put("publish_topic", publish_topic);
						mqttObj.put("subscribe_topic", subscribe_topic);
						mqttObj.put("prefix", prefix);
						mqttObj.put("file_type", file_type);
						mqttObj.put("file_name", file_name);
						mqttObj.put("enable", enable);

						resJsonArray.put(mqttObj);
					} catch (JSONException e) {
						e.printStackTrace();
						logger.error("Error in putting mqtt data in json array : " + e);
					}
				}

				logger.info("JSON ARRAY :" + resJsonArray.length() + " " + resJsonArray.toString());

				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting mqtt data: " + e);
			}
		} else {

			try {
				JSONObject userObj = new JSONObject();
				userObj.put("msg", "Your session is timeout. Please login again");
				userObj.put("status", "fail");

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

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");

		String broker_ip_address = null;
		String port_number = null;
		String username = null;
		String password = null;
		String sub_topic = null;
		String pub_topic = null;
		String prefix = null;
		String file_type = null;
		String enable = null;
		String file_name = null;

		if (check_username != null) {

			String action = request.getParameter("action");

			if (action != null) {
				switch (action) {

				case "add":

					broker_ip_address = request.getParameter("broker_ip_address");
					port_number = request.getParameter("port_number");
					username = request.getParameter("username");
					password = request.getParameter("password");
					sub_topic = request.getParameter("sub_topic");
					pub_topic = request.getParameter("pub_topic");
					prefix = request.getParameter("prefix");
					file_type = request.getParameter("file_type");
					enable = request.getParameter("enable");
					file_name = request.getParameter("file_name");

					try {

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "protocol");
						json.put("protocol_type", "mqtt");
						json.put("operation_type", "add_query");
						json.put("user", check_username);
						json.put("broker_ip_address", broker_ip_address);
						json.put("port_number", port_number);
						json.put("username", username);
						json.put("password", password);
						json.put("subscribe_topic", sub_topic);
						json.put("publish_topic", pub_topic);
						json.put("prefix", prefix);
						json.put("file_type", file_type);
						json.put("enable", enable);
						json.put("file_name", file_name);

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
						logger.error("Error in adding mqtt : " + e);
					}
					break;

				case "update":
					broker_ip_address = request.getParameter("broker_ip_address");
					port_number = request.getParameter("port_number");
					username = request.getParameter("username");
					password = request.getParameter("password");
					sub_topic = request.getParameter("sub_topic");
					pub_topic = request.getParameter("pub_topic");
					prefix = request.getParameter("prefix");
					file_type = request.getParameter("file_type");
					enable = request.getParameter("enable");
					file_name = request.getParameter("file_name");

					try {

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "protocol");
						json.put("protocol_type", "mqtt");
						json.put("operation_type", "update_query");
						json.put("user", check_username);
						json.put("broker_ip_address", broker_ip_address);
						json.put("port_number", port_number);
						json.put("username", username);
						json.put("password", password);
						json.put("subscribe_topic", sub_topic);
						json.put("publish_topic", pub_topic);
						json.put("prefix", prefix);
						json.put("file_type", file_type);
						json.put("file_name", file_name);
						json.put("enable", enable);

						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr).getString("msg"));

						String message = new JSONObject(respStr).getString("msg");
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);

						// Set the content type of the response to
						// application/json
						response.setContentType("application/json");

						// Get the response PrintWriter
						PrintWriter out = response.getWriter();

						// Write the JSON object to the response
						out.print(jsonObject.toString());
						out.flush();

					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in updating mqtt : " + e);
					}

					break;

				case "delete":
					prefix = request.getParameter("prefix");
					
					try {

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "protocol");
						json.put("protocol_type", "mqtt");
						json.put("operation_type", "delete_query");
						json.put("user", check_username);
						json.put("prefix", prefix);

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
						logger.error("Error in deleting mqtt : " + e);
					}

					break;
					
				case "crt_file_delete" :
					
					String crt_file_name = request.getParameter("crt_file_name");
					System.out.println("crt file name: "+crt_file_name);
					
					try{
						
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();
						
						json.put("operation", "file_manager");
						json.put("operation_type", "crt_file_delete");
						json.put("user", check_username);
						json.put("crt_file_name", crt_file_name);
						
						String respStr = client.sendMessage(json.toString());

						//logger.info("res " + new JSONObject(respStr).getString("msg"));

					//	String message = new JSONObject(respStr).getString("msg");
						JSONObject jsonObject = new JSONObject();
				//		jsonObject.put("message", message);

						// Set the content type of the response to application/json
						response.setContentType("application/json");

						// Get the response PrintWriter
						PrintWriter out = response.getWriter();

						// Write the JSON object to the response
						out.print(jsonObject.toString());
						out.flush();
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error in deleting crt file : " + e);
					}
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
