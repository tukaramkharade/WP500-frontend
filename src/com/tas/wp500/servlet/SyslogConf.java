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
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

@WebServlet("/syslogConf")
public class SyslogConf extends HttpServlet {
	final static Logger logger = Logger.getLogger(SyslogConf.class);
  
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");

		if (check_username != null) {

			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			JSONObject jsonObject = new JSONObject();

			try {
				json.put("operation", "rsyslog_manager");
				json.put("operation_type", "get_rsyslog");
				json.put("user", check_username);
				json.put("token", check_token);
				
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				logger.info("res " + respJson.toString());

				for (int i = 0; i < respJson.length(); i++) {
					
					String rsyslog_ip = respJson.getString("rsyslog_ip");
					String rsyslog_port = respJson.getString("rsyslog_port");
					
					
					try {
						jsonObject.put("rsyslog_ip", rsyslog_ip);
						jsonObject.put("rsyslog_port", rsyslog_port);
						
						
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in putting syslog in json object: " + e);
					}
					
				}
				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting syslog config data : " + e);
			}

		} 
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");

		String hostname = null;
		String port_number = null;
		

		if (check_username != null) {

			hostname = request.getParameter("hostname");
			port_number = request.getParameter("port_number");
					
					try {
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "rsyslog_manager");
						json.put("operation_type", "update_rsyslog");
						json.put("rsyslog_ip", hostname);
						json.put("rsyslog_port", port_number);
						json.put("user", check_username);
						json.put("token", check_token);
						

						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr));

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
						logger.error("Error in updating general settings : " + e);
					}

	}

	}


	}

