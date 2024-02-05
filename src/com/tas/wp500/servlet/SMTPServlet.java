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
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		String csrfTokenFromRequest = request.getParameter("csrfToken");
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
		if (check_username != null) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			JSONObject jsonObject = new JSONObject();
			String tls_auth = "";
			String tls_enable = "";
			String tls_port = "";
			String ssl_smtp_type = "";
			String ssl_socket_factory_port = "";
			String ssl_port = "";
			String to_email_id = "";
			String email_cc = "";
			String email_bcc = "";
			try {
				if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
					json.put("operation", "protocol");
					json.put("protocol_type", "smtp");
					json.put("operation_type", "get_query");
					json.put("user", check_username);
					json.put("token", check_token);
					json.put("role", check_role);

					String respStr = client.sendMessage(json.toString());
					JSONObject respJson = new JSONObject(respStr);
					logger.info("res " + respJson.toString());
					String message = respJson.getString("msg");
					String status = respJson.getString("status");
					if (status.equals("success")) {
						for (int i = 0; i < respJson.length(); i++) {
							String from_email_id = respJson.getString("from_email_id");
							String password = respJson.getString("password");
							String smtp_type = respJson.getString("smtp_type");
							String host = respJson.getString("host");
							to_email_id = respJson.getString("to_email_id");
							if (respJson.has("cc")) {
								email_cc = respJson.getString("cc");
							}
							if (respJson.has("bcc")) {
								email_bcc = respJson.getString("bcc");
							}
							if ("ssl".equalsIgnoreCase(smtp_type)) {
								ssl_socket_factory_port = respJson.getString("ssl_socket_factory_port");
								ssl_port = respJson.getString("ssl_port");
								ssl_smtp_type = respJson.getString("ssl_smtp_type");
							} else if ("tls".equalsIgnoreCase(smtp_type)) {
								tls_port = respJson.getString("tls_port");
								tls_auth = respJson.getString("tls_auth");
								tls_enable = respJson.getString("tls_enable");
							}
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
								jsonObject.put("to_email_id", to_email_id);
								jsonObject.put("email_cc", email_cc);
								jsonObject.put("email_bcc", email_bcc);
								jsonObject.put("status", status);
							} catch (Exception e) {
								e.printStackTrace();
								logger.error("Error in putting SMTP settings in json object: " + e);
							}
						}
					} else if (status.equals("fail")) {
						jsonObject.put("message", message);
						jsonObject.put("status", status);
					}
					response.setHeader("X-Content-Type-Options", "nosniff");
					PrintWriter out = response.getWriter();
					out.print(jsonObject.toString());
					out.flush();
				} else {
					logger.error("Token validation failed");
				}
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error while getting SMTP Settings : " + e);
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		String csrfTokenFromRequest = request.getParameter("csrfToken");
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
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
		String to_email_id = null;
		String email_cc = null;
		String email_bcc = null;
		if (check_username != null) {
			String action = request.getParameter("action");
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
					to_email_id = request.getParameter("to_email_id");
					email_cc = request.getParameter("email_cc");
					email_bcc = request.getParameter("email_bcc");
					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
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
							json.put("to_email_id", to_email_id);
							json.put("email_cc", email_cc);
							json.put("email_bcc", email_bcc);
							json.put("user", check_username);
							json.put("token", check_token);
							json.put("role", check_role);

							String respStr = client.sendMessage(json.toString());
							logger.info("res " + new JSONObject(respStr));
							String message = new JSONObject(respStr).getString("msg");
							JSONObject jsonObject = new JSONObject();
							jsonObject.put("message", message);
							response.setContentType("application/json");
							response.setHeader("X-Content-Type-Options", "nosniff");
							PrintWriter out = response.getWriter();
							out.print(jsonObject.toString());
							out.flush();
						} else {
							logger.error("Token validation failed");
						}
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in adding SMTP settings: " + e);
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
					to_email_id = request.getParameter("to_email_id");
					email_cc = request.getParameter("email_cc");
					email_bcc = request.getParameter("email_bcc");
					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
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
							json.put("to_email_id", to_email_id);
							json.put("email_cc", email_cc);
							json.put("email_bcc", email_bcc);
							json.put("user", check_username);
							json.put("token", check_token);
							json.put("role", check_role);

							String respStr = client.sendMessage(json.toString());
							logger.info("res " + new JSONObject(respStr));
							String message = new JSONObject(respStr).getString("msg");
							JSONObject jsonObject = new JSONObject();
							jsonObject.put("message", message);
							response.setContentType("application/json");
							response.setHeader("X-Content-Type-Options", "nosniff");
							PrintWriter out = response.getWriter();
							out.print(jsonObject.toString());
							out.flush();
						} else {
							logger.error("Token validation failed");
						}
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in updating SMTP settings: " + e);
					}
					break;
				}
			}
		}
	}

	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session != null) {
			String check_username = (String) session.getAttribute("username");
			String check_token = (String) session.getAttribute("token");
			String check_role = (String) session.getAttribute("role");	
			try {				
					TCPClient client = new TCPClient();
					JSONObject json = new JSONObject();
					json.put("operation", "protocol");
					json.put("protocol_type", "smtp");
					json.put("operation_type", "delete_query");
					json.put("user", check_username);
					json.put("token", check_token);
					json.put("role", check_role);

					String respStr = client.sendMessage(json.toString());
					logger.info("res " + new JSONObject(respStr));
					String message = new JSONObject(respStr).getString("msg");
					JSONObject jsonObject = new JSONObject();
					jsonObject.put("message", message);
					response.setContentType("application/json");
					response.setHeader("X-Content-Type-Options", "nosniff");
					PrintWriter out = response.getWriter();
					out.print(jsonObject.toString());
					out.flush();				
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in deleting SMTP Settings : " + e);
			}
		}
	}
}