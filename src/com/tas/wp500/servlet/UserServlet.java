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

@WebServlet("/userServlet")
public class UserServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(UserServlet.class);

	TCPClient client = new TCPClient();
	JSONObject json = new JSONObject();
	JSONObject respJson = null;

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {

		HttpSession session = request.getSession(true);

		String check_username = (String) session.getAttribute("username");

		String first_name = null;
		String last_name = null;
		String username = null;
		String password = null;
		String role = null;

		if (check_username != null) {

			String action = request.getParameter("action");

			if (action != null) {
				switch (action) {

				case "add":

					first_name = request.getParameter("first_name");
					last_name = request.getParameter("last_name");
					username = request.getParameter("username");
					password = request.getParameter("password");
					role = request.getParameter("role");

					try {
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "add_user");
						json.put("user", check_username);
						json.put("username", username);
						json.put("password", password);
						json.put("first_name", first_name);
						json.put("last_name", last_name);
						json.put("role", role);

						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr).getString("msg"));

						String message = new JSONObject(respStr).getString("msg");
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);

						// Set the content type of the response to
						// application/json
						resp.setContentType("application/json");

						// Get the response PrintWriter
						PrintWriter out = resp.getWriter();

						// Write the JSON object to the response
						out.print(jsonObject.toString());
						out.flush();

					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in adding user: " + e);
					}

					break;

				case "update":
					first_name = request.getParameter("first_name");
					last_name = request.getParameter("last_name");
					username = request.getParameter("username");
					role = request.getParameter("role");

					try {
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "update_user");
						json.put("user", check_username);

						json.put("username", username);
						json.put("first_name", first_name);
						json.put("last_name", last_name);
						json.put("role", role);

						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr).getString("msg"));

						String message = new JSONObject(respStr).getString("msg");
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);

						// Set the content type of the response to
						// application/json
						resp.setContentType("application/json");

						// Get the response PrintWriter
						PrintWriter out = resp.getWriter();

						// Write the JSON object to the response
						out.print(jsonObject.toString());
						out.flush();

					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in updating user: " + e);
					}

					break;

				case "delete":

					username = request.getParameter("username");

					try {
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "delete_user");
						json.put("user", check_username);

						json.put("username", username);

							String respStr = client.sendMessage(json.toString());

							System.out.println("res " + new JSONObject(respStr).getString("msg"));

							String message = new JSONObject(respStr).getString("msg");
							JSONObject jsonObject = new JSONObject();
							jsonObject.put("message", message);

							// Set the content type of the response to
							// application/json
							resp.setContentType("application/json");

							// Get the response PrintWriter
							PrintWriter out = resp.getWriter();

							// Write the JSON object to the response
							out.print(jsonObject.toString());
							out.flush();
						 

					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in deleting user: " + e);
					}

					break;
					
					
				case "update_user_password":
					username = request.getParameter("username");
					password = request.getParameter("password");
					
					try{
						
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "update_user_password");
						json.put("user", check_username);
						json.put("username", username);
						json.put("password", password);
						
						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr).getString("msg"));

						String message = new JSONObject(respStr).getString("msg");
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);

						// Set the content type of the response to
						// application/json
						resp.setContentType("application/json");

						// Get the response PrintWriter
						PrintWriter out = resp.getWriter();

						// Write the JSON object to the response
						out.print(jsonObject.toString());
						out.flush();
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error in changing password: " + e);
					}
					break;
				
				case "update_old_password": 
					
					username = request.getParameter("username");
					String old_password = request.getParameter("old_password");
					String new_password = request.getParameter("new_parameter");
					
					try{
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();
						
						json.put("operation", "update_old_password");
						json.put("user", check_username);
						json.put("username", username);
						json.put("old_password", old_password);
						json.put("new_password", new_password);
						
						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr).getString("msg"));

						String message = new JSONObject(respStr).getString("msg");
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);

						// Set the content type of the response to
						// application/json
						resp.setContentType("application/json");

						// Get the response PrintWriter
						PrintWriter out = resp.getWriter();

						// Write the JSON object to the response
						out.print(jsonObject.toString());
						out.flush();
						
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error in updating old password to new password: "+e);
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
				resp.setContentType("application/json");

				// Write the JSON data to the response
				resp.getWriter().print(userObj.toString());

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in session timeout: " + e);
			}
		}

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		TCPClient client = new TCPClient();
		json = new JSONObject();

		try {

			HttpSession session = request.getSession(false);

			String check_username = (String) session.getAttribute("username");

			if (check_username != null) {
				json.put("operation", "get_all_user");
				json.put("user", check_username);

				String respStr = client.sendMessage(json.toString());
				respJson = new JSONObject(respStr);

				JSONArray jsonArray = new JSONArray(respJson.getJSONArray("result").toString());
				logger.info(respJson.getJSONArray("result").toString());

				JSONArray resJsonArray = new JSONArray();

				// Convert each user to a JSONObject and add it to the JSONArray
				for (int i = 0; i < jsonArray.length(); i++) {
					JSONObject jsObj = jsonArray.getJSONObject(i);

					String first_name = jsObj.getString("first_name");
					String last_name = jsObj.getString("last_name");
					String username = jsObj.getString("username");
					String role = jsObj.getString("role");

					JSONObject userObj = new JSONObject();

					try {
						userObj.put("first_name", first_name);
						userObj.put("last_name", last_name);
						userObj.put("username", username);
						userObj.put("role", role);

						resJsonArray.put(userObj);
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in putting user data in json array : " + e);
					}
				}

				// Set the response content type to JSON
				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());
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

		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Error in getting user list : " + e);
		}
	}
}
