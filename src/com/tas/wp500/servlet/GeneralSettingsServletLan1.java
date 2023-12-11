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


@WebServlet("/generalSettingsServletLan1")
public class GeneralSettingsServletLan1 extends HttpServlet {
	
	final static Logger logger = Logger.getLogger(GeneralSettingsServletLan1.class);
	
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
				json.put("operation", "genral_settings");
				json.put("operation_type", "get");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("interface", "lan1");

				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				logger.info("res " + respJson.toString());

				for (int i = 0; i < respJson.length(); i++) {
					
					String output = respJson.getString("output");
					String forword = respJson.getString("forword");
					String input = respJson.getString("input");
					String rule_drop = respJson.getString("rule_drop");
					
					try {
						jsonObject.put("output", output);
						jsonObject.put("forword", forword);
						jsonObject.put("input", input);
						jsonObject.put("rule_drop", rule_drop);
						
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

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting general settings data : " + e);
			}

		} 
	}



	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

}
