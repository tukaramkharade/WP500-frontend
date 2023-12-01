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

@WebServlet("/generalSettingsServlet")
public class GeneralSettingsServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(GeneralSettingsServlet.class);

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
				json.put("operation", "firewall_settings");
				json.put("user", check_username);
				json.put("token", check_token);

				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				logger.info("res " + respJson.toString());

				JSONObject genral_settings = respJson.getJSONObject("genral_settings");

				for (int i = 0; i < genral_settings.length(); i++) {

					String output = genral_settings.getString("output");
					String forword = genral_settings.getString("forword");
					String input = genral_settings.getString("input");
					String rule_drop = genral_settings.getString("rule_drop");

					try {
						jsonObject.put("output", output);
						jsonObject.put("forword", forword);
						jsonObject.put("input", input);
						jsonObject.put("rule_drop", rule_drop);
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in putting general settings in json object: " + e);
					}
				}
				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting general settings data : " + e);
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

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");

		String input = null;
		String output = null;
		String forward = null;
		String rule_drop = null;

		if (check_username != null) {

			String operation_action = request.getParameter("operation_action");

			if (operation_action != null) {
				switch (operation_action) {

				case "add":
					input = request.getParameter("input");
					output = request.getParameter("output");
					forward = request.getParameter("forward");
					rule_drop = request.getParameter("rule_drop");

					try {

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "genral_setting");
						json.put("operation_type", "add");
						json.put("input", input);
						json.put("output", output);
						json.put("forword", forward);
						json.put("rule_drop", rule_drop);
						json.put("user", check_username);
						json.put("token", check_token);

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
						logger.error("Error in adding general settings : " + e);
					}

					break;

				case "update":

					 input = request.getParameter("input");
					 output = request.getParameter("output");
					 forward = request.getParameter("forward");
					 rule_drop = request.getParameter("rule_drop");

					try {
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "genral_setting");
						json.put("operation_type", "update");
						json.put("input", input);
						json.put("output", output);
						json.put("forword", forward);
						json.put("rule_drop", rule_drop);
						json.put("user", check_username);
						json.put("token", check_token);

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
						logger.error("Error in updating general settings : " + e);
					}

					break;

				case "delete":
					 input = request.getParameter("input");
					 output = request.getParameter("output");
					 forward = request.getParameter("forward");
					 rule_drop = request.getParameter("rule_drop");

					try {

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "genral_setting");
						json.put("operation_type", "delete");
						json.put("input", input);
						json.put("output", output);
						json.put("forword", forward);
						json.put("rule_drop", rule_drop);
						json.put("user", check_username);
						json.put("token", check_token);

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
						logger.error("Error in deleting general settings: " + e);
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
