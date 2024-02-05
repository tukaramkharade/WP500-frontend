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
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

@WebServlet("/tagMapping")
public class TagMappingServelt extends HttpServlet {
	final static Logger logger = Logger.getLogger(TagMappingServelt.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		String csrfTokenFromRequest = request.getParameter("csrfToken");
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();
		if (check_username != null) {
			try {
				if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
					json.put("operation", "get_all_tags");
					json.put("user", check_username);
					json.put("token", check_token);
					json.put("role", check_role);

					String respStr = client.sendMessage(json.toString());
					JSONObject respJson = new JSONObject(respStr);
					String status = respJson.getString("status");
					String message = respJson.getString("msg");
					logger.info("Tag Mapping response : " + respJson.toString());
					JSONObject finalJsonObj = new JSONObject();
					if (status.equals("Success")) {
						JSONArray resultArr = respJson.getJSONArray("data");
						finalJsonObj.put("status", status);
						finalJsonObj.put("result", resultArr);
						finalJsonObj.put("message", message);
					} else if (status.equals("fail")) {
						finalJsonObj.put("status", status);
						finalJsonObj.put("message", message);
					}
					response.setContentType("application/json");
					response.setHeader("X-Content-Type-Options", "nosniff");
					response.getWriter().print(finalJsonObj.toString());
				} else {
					logger.error("Token validation failed");
				}
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting mqtt data: " + e);
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
		String tag_name = null;
		String pv_address = null;
		if (check_username != null) {
			String action = request.getParameter("action");
			if (action != null) {
				switch (action) {
				case "add":
					tag_name = request.getParameter("tag_name");
					pv_address = request.getParameter("pv_address");
					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
							TCPClient client = new TCPClient();
							JSONObject json = new JSONObject();
							json.put("operation", "insert_tag");
							json.put("user", check_username);
							json.put("tag_name", tag_name);
							json.put("pv_address", pv_address);
							json.put("token", check_token);
							json.put("role", check_role);

							String respStr = client.sendMessage(json.toString());
							logger.info("res " + new JSONObject(respStr));
							String message = new JSONObject(respStr).getString("msg");
							String status = new JSONObject(respStr).getString("status");
							JSONObject jsonObject = new JSONObject();
							jsonObject.put("message", message);
							jsonObject.put("status", status);
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
						logger.error("Error in adding tags : " + e);
					}
					break;

				case "update":
					tag_name = request.getParameter("tag_name");
					pv_address = request.getParameter("pv_address");
					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
							TCPClient client = new TCPClient();
							JSONObject json = new JSONObject();
							json.put("operation", "update_tag");
							json.put("tag_name", tag_name);
							json.put("pv_address", pv_address);
							json.put("token", check_token);
							json.put("user", check_username);
							json.put("role", check_role);

							String respStr = client.sendMessage(json.toString());
							logger.info("res " + new JSONObject(respStr));
							String message = new JSONObject(respStr).getString("msg");
							String status = new JSONObject(respStr).getString("status");
							JSONObject jsonObject = new JSONObject();
							jsonObject.put("message", message);
							jsonObject.put("status", status);						
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
						logger.error("Error in updating tags : " + e);
					}

					break;

				case "delete":
					tag_name = request.getParameter("tag_name");
					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
							TCPClient client = new TCPClient();
							JSONObject json = new JSONObject();
							json.put("operation", "delete_tag");
							json.put("user", check_username);
							json.put("tag_name", tag_name);
							json.put("token", check_token);
							json.put("role", check_role);

							String respStr = client.sendMessage(json.toString());
							logger.info("res " + new JSONObject(respStr));
							String message = new JSONObject(respStr).getString("msg");
							String status = new JSONObject(respStr).getString("status");
							JSONObject jsonObject = new JSONObject();
							jsonObject.put("message", message);
							jsonObject.put("status", status);
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
						logger.error("Error in deleting tags : " + e);
					}
					break;

				case "add_bulk":
					try {
						String bulkData = request.getParameter("bulk_data");
						JSONArray jsonArray = new JSONArray(bulkData);
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
							json.put("operation", "insert_bulk_tag");
							json.put("user", check_username);
							json.put("token", check_token);
							json.put("role", check_role);
							json.put("bulk_data", jsonArray); // Put the JSON array directly
							String respStr = client.sendMessage(json.toString());
							logger.info("res " + new JSONObject(respStr));
							String message = new JSONObject(respStr).getString("msg");
							String status = new JSONObject(respStr).getString("status");
							JSONObject jsonObject = new JSONObject();
							jsonObject.put("message", message);
							jsonObject.put("status", status);
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
						logger.error("Error in adding bulk tags : " + e);
					}
					break;
				}
			}
		}
	}
}