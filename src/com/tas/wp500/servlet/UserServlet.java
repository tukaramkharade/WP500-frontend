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

import com.tas.wp500.utils.PasswordHasher;
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
		String check_token = (String) session.getAttribute("token");

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
					
				
                    // Hash the password
                   // String hashedPassword = PasswordHasher.hashPassword(password);


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
						json.put("token", check_token);
						
						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr));

						String message = new JSONObject(respStr).getString("msg");
						String status = new JSONObject(respStr).getString("status");
						
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);
						jsonObject.put("status", status);
						
						
						// Set the content type of the response to application/json
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
						json.put("token", check_token);
						json.put("username", username);
						json.put("first_name", first_name);
						json.put("last_name", last_name);
						json.put("role", role);

						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr));

						String message = new JSONObject(respStr).getString("msg");
						String status = new JSONObject(respStr).getString("status");
						
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);
						jsonObject.put("status", status);

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
						json.put("token", check_token);
						json.put("username", username);

							String respStr = client.sendMessage(json.toString());

							System.out.println("res " + new JSONObject(respStr));

							String message = new JSONObject(respStr).getString("msg");
							String status = new JSONObject(respStr).getString("status");
							
							JSONObject jsonObject = new JSONObject();
							jsonObject.put("message", message);
							jsonObject.put("status", status);

							// Set the content type of the response to application/json
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
						json.put("token", check_token);
						
						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr));

						String message = new JSONObject(respStr).getString("msg");
						String status = new JSONObject(respStr).getString("status");
						
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);
						jsonObject.put("status", status);

						// Set the content type of the response to application/json
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
				}
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
			String check_token = (String) session.getAttribute("token");
			
			if (check_username != null) {
				json.put("operation", "get_all_user");
				json.put("user", check_username);
				json.put("token", check_token);
				String respStr = client.sendMessage(json.toString());
				System.out.println("response string :"+respStr);
				respJson = new JSONObject(respStr);

				logger.info(respJson.toString());
				String status = respJson.getString("status");
				String message = respJson.getString("msg");
				
				
				JSONObject finalJsonObj = new JSONObject();
				
				if(status.equals("success")){
					JSONArray jsonArray = new JSONArray(respJson.getJSONArray("result").toString());
					
					finalJsonObj.put("status", status);
				    finalJsonObj.put("result", jsonArray);
				}else if(status.equals("fail")){
					finalJsonObj.put("status", status);
				    finalJsonObj.put("message", message);
				}
				
				
				    // Set the response content type to JSON
				    response.setContentType("application/json");

				    // Write the JSON data to the response
				    response.getWriter().print(finalJsonObj.toString());
				
			}

		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Error in getting user list : " + e);
		}
	}
}
