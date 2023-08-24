package com.tas.wp500;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;

import com.tas.utils.TCPClient;

@WebServlet("/UserDeleteServlet")
public class UserDeleteServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(UserDeleteServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub

		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");

		String username = request.getParameter("username");

		if (check_username != null) {

			try {
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "delete_user");
				json.put("user", check_username);

				json.put("username", username);

				if (!username.equals("tasm2m_admin")) {

					String respStr = client.sendMessage(json.toString());

					System.out.println("res " + new JSONObject(respStr).getString("msg"));

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
				} else {

					try {
						JSONObject userObj = new JSONObject();
						userObj.put("msg", "Cannot delete tasm2m_admin user !!");
						userObj.put("status", "fail");

						System.out.println(">>" + userObj);

						// Set the response content type to JSON
						resp.setContentType("application/json");

						// Write the JSON data to the response
						resp.getWriter().print(userObj.toString());

					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in deleting tasm2m user: " + e);

					}
				}

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in deleting user: " + e);
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
}
