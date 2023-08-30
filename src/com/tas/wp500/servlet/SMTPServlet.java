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

@WebServlet("/SMTPServlet")
public class SMTPServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(SMTPServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		
		if (check_username != null) {
			
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			JSONObject jsonObject = new JSONObject();
			
			try {
				
				json.put("operation", "protocol");
				json.put("protocol_type", "smtp");
				json.put("operation_type", "get_query");
				json.put("user", check_username);
				
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				logger.info("res " + respJson.toString());
				
				for (int i = 0; i < respJson.length(); i++) {
					
					String ssl_socket_factory_port = respJson.getString("ssl_socket_factory_port");
					String tls_port = respJson.getString("tls_port");
					String from_email_id = respJson.getString("from_email_id");
					String password = respJson.getString("password");
					String smtp_type = respJson.getString("smtp_type");
					String tls_auth = respJson.getString("tls_auth");
					String tls_enable = respJson.getString("tls_enable");
					String ssl_smtp_type = respJson.getString("ssl_smtp_type");
					String host = respJson.getString("host");
					String ssl_port = respJson.getString("ssl_port");
					
					try {
						jsonObject.put("ssl_socket_factory_port", ssl_socket_factory_port);
						jsonObject.put("tls_port", tls_port);
						jsonObject.put("from_email_id", from_email_id);
						jsonObject.put("password", password);
						jsonObject.put("smtp_type", smtp_type);
						jsonObject.put("tls_auth", tls_auth);
						jsonObject.put("tls_enable", tls_enable);
						jsonObject.put("ssl_smtp_type", ssl_smtp_type);
						jsonObject.put("host", host);
						jsonObject.put("ssl_port", ssl_port);
						
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in putting SMTP settings in json object: " + e);
					}
				}
				
				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();

				
			}catch(Exception e){
				e.printStackTrace();
				logger.error("Error while getting SMTP Settings : "+e);
				
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		
		String ssl_socket_factory_port = null;
		String tls_port = null;
		String from_email_id = null;
		String password = null;
		String smtp_type = null;
		String tls_auth = null;
		String tls_enable = null;
		String ssl_smtp_type = null;
		String host = null;
		String ssl_port = null;
		
		if (check_username != null) {
			
			String action = request.getParameter("action");
			System.out.println("action : "+action);

			if (action != null) {
				switch (action) {
				
				case "add":
					ssl_socket_factory_port = request.getParameter("ssl_socket_factory_port");
					tls_port = request.getParameter("tls_port");
					from_email_id = request.getParameter("from_email_id");
					password = request.getParameter("password");
					smtp_type = request.getParameter("smtp_type");
					tls_auth = request.getParameter("tls_auth");
					tls_enable = request.getParameter("tls_enable");
					ssl_smtp_type = request.getParameter("ssl_smtp_type");
					host = request.getParameter("host");
					ssl_port = request.getParameter("ssl_port");
					
					try{
						
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();
	
						json.put("operation", "protocol");
						json.put("protocol_type", "smtp");
						json.put("operation_type", "add_query");
						json.put("from_email_id", from_email_id);
						json.put("password", password);
						json.put("host", host);
						json.put("smtp_type", smtp_type);
						json.put("from_email_id", from_email_id);
						json.put("password", password);
						json.put("host", host);
						json.put("smtp_type", smtp_type);
						json.put("ssl_socket_factory_port", ssl_socket_factory_port);
						json.put("ssl_port", ssl_port);
						json.put("ssl_smtp_type", ssl_smtp_type);
						json.put("tls_port", tls_port);
						json.put("tls_enable", tls_enable);
						json.put("tls_auth", tls_auth);
						json.put("user", check_username);

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
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error in adding SMTP settings: "+e);
					}
					
					break;
					
				case "update":
					ssl_socket_factory_port = request.getParameter("ssl_socket_factory_port");
					tls_port = request.getParameter("tls_port");
					from_email_id = request.getParameter("from_email_id");
					password = request.getParameter("password");
					smtp_type = request.getParameter("smtp_type");
					tls_auth = request.getParameter("tls_auth");
					tls_enable = request.getParameter("tls_enable");
					ssl_smtp_type = request.getParameter("ssl_smtp_type");
					host = request.getParameter("host");
					ssl_port = request.getParameter("ssl_port");
					
					try{
						
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();
	
						json.put("operation", "protocol");
						json.put("protocol_type", "smtp");
						json.put("operation_type", "update_query");
						json.put("from_email_id", from_email_id);
						json.put("password", password);
						json.put("host", host);
						json.put("smtp_type", smtp_type);
						json.put("from_email_id", from_email_id);
						json.put("password", password);
						json.put("host", host);
						json.put("smtp_type", smtp_type);
						json.put("ssl_socket_factory_port", ssl_socket_factory_port);
						json.put("ssl_port", ssl_port);
						json.put("ssl_smtp_type", ssl_smtp_type);
						json.put("tls_port", tls_port);
						json.put("tls_enable", tls_enable);
						json.put("tls_auth", tls_auth);
						json.put("user", check_username);

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
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error in updating SMTP settings: "+e);
					}
					
					break;
				}
			}
			
		}else{
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

	protected void doDelete(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// delete operation
		HttpSession session = request.getSession(false);

		if (session != null) {
			String check_username = (String) session.getAttribute("username");

			try {

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();
				
				json.put("operation", "protocol");
				json.put("protocol_type", "smtp");
				json.put("operation_type", "delete_query");
				json.put("user", check_username);

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
				logger.error("Error in deleting SMTP Settings : " + e);
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
