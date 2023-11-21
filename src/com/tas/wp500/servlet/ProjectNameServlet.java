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

@WebServlet("/projectNameServlet")
public class ProjectNameServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(ProjectNameServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		JSONObject jsonObject = new JSONObject();

		String check_username = (String) session.getAttribute("username");
		if (check_username != null) {

			try {

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "get_straton_status");
				json.put("user", check_username);

				String respStr = client.sendMessage(json.toString());
				JSONObject respJson = new JSONObject(respStr);

				logger.info("res " + respJson.toString());

				for (int i = 0; i < respJson.length(); i++) {
					String sys_appname = respJson.getString("sys.appname");

					try {
						jsonObject.put("sys_appname", sys_appname);

					} catch (Exception e) {
						e.printStackTrace();
					}

					session.setAttribute("sys_appname", sys_appname);
				}

				response.setContentType("application/json");

				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				// Trim the JSON data before sending
				out.print(jsonObject.toString().trim());

				out.flush();

			} catch (Exception e) {

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
				logger.error("Error in session timeout : " + e);
			}
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}

}
