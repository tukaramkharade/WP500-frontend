package com.tas.wp500;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
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

import com.tas.utils.TCPClient;

@WebServlet("/data")
public class UserDataServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(UserDataServlet.class);

	TCPClient client = new TCPClient();
	JSONObject json = new JSONObject();
	JSONObject respJson = null;

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub

		HttpSession session = request.getSession(true);

		if (session != null) {
			//System.out.println("session : " + session);
			String check_username = (String) session.getAttribute("username");

			String first_name = request.getParameter("first_name");
			String last_name = request.getParameter("last_name");
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			String role = request.getParameter("role");

			System.out.println(username + " " + password + " " + first_name + " " + last_name);

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

				System.out.println("res " + new JSONObject(respStr).getString("msg"));
				logger.info("res " + new JSONObject(respStr).getString("msg"));

				String message = new JSONObject(respStr).getString("msg");
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("message", message);

				// Set the content type of the response to application/json
				resp.setContentType("application/json");

				// Get the response PrintWriter
				PrintWriter out = resp.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();
				
				

			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else {

			//System.out.println("session : " + session);
			System.out.println("Login first");
			// resp.sendRedirect("login.jsp");

			RequestDispatcher dispatcher = this.getServletContext().getRequestDispatcher("login.jsp");

			try {
				dispatcher.forward(request, resp);
			} catch (ServletException | IOException e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				logger.error(e.getMessage());
			}
		}

	}

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Retrieve the user data from wherever it's stored (e.g., a database)

		TCPClient client = new TCPClient();
		json = new JSONObject();

		// String errorString = null;

		try {

			HttpSession session = request.getSession(false);

			System.out.println(">> " + session.getAttribute("username"));
			
			String check_username = (String) session.getAttribute("username");

			if (check_username != null) {
				json.put("operation", "get_all_user");
				json.put("user", check_username);
				
				
				
				String respStr = client.sendMessage(json.toString());
				respJson = new JSONObject(respStr);

				System.out.println("res " + respJson.getJSONArray("result"));

				// Create a JSONArray to hold the user data

				JSONArray jsonArray = new JSONArray(respJson.getJSONArray("result").toString());
				logger.info(respJson.getJSONArray("result").toString());

				JSONArray resJsonArray = new JSONArray();

				System.out.println("jsonArray " + jsonArray.toString());
				// Convert each user to a JSONObject and add it to the JSONArray
				for (int i = 0; i < jsonArray.length(); i++) {
					JSONObject jsObj = jsonArray.getJSONObject(i);

					String first_name = jsObj.getString("first_name");
					logger.info("first_name : " + first_name);

					String last_name = jsObj.getString("last_name");
					logger.info("last_name : " + last_name);

					String username = jsObj.getString("username");
					logger.info("username : " + username);

					String role = jsObj.getString("role");
					logger.info("role : " + role);

					// logger.info(jsonArray.get(i).toString());
					// resJsonArray.put(userObj);

					JSONObject userObj = new JSONObject();

					try {
						userObj.put("first_name", first_name);
						userObj.put("last_name", last_name);
						userObj.put("username", username);
						userObj.put("role", role);

						resJsonArray.put(userObj);
					} catch (Exception e) {
						e.printStackTrace();
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
					
					
					System.out.println(">>" +userObj);
					
					// Set the response content type to JSON
					response.setContentType("application/json");

					// Write the JSON data to the response
					response.getWriter().print(userObj.toString());
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
