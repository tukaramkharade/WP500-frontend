package com.tas.wp500;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;

import com.tas.utils.TCPClient;

@WebServlet("/mqttEditServlet")
public class MQTTEditServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(MQTTEditServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");

		if (check_username != null) {

			String broker_ip_address = request.getParameter("broker_ip_address");
			String port_number = request.getParameter("port_number");
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			String sub_topic = request.getParameter("sub_topic");
			String pub_topic = request.getParameter("pub_topic");
			String prefix = request.getParameter("prefix");
			String file_type = request.getParameter("file_type");
			String enable = request.getParameter("enable");
			String file_name = request.getParameter("file_name");

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

				// Set the content type of the response to application/json
				response.setContentType("application/json");

				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in updating mqtt : "+e);
				}
		} else {
			
		}
	}
}
