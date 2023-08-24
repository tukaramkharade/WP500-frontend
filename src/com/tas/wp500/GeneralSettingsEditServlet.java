package com.tas.wp500;

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

import com.tas.utils.TCPClient;

@WebServlet("/generalSettingsEditServlet")
public class GeneralSettingsEditServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(GeneralSettingsEditServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");

		if (check_username != null) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			String input = request.getParameter("input");
			String output = request.getParameter("output");
			String forward = request.getParameter("forward");
			String rule_drop = request.getParameter("rule_drop");

			try {
				json.put("operation", "genral_setting");
				json.put("operation_type", "update");
				json.put("input", input);
				json.put("output", output);
				json.put("forword", forward);
				json.put("rule_drop", rule_drop);
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
				logger.error("Error in updating general settings : "+e);
			}

		} else {

		}
	}
}
