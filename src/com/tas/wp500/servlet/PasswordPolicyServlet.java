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
import org.json.JSONException;
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

@WebServlet("/PasswordPolicyServlet")
public class PasswordPolicyServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(PasswordPolicyServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(true);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		
		JSONObject jsonObject = new JSONObject();

		if (check_username != null) {

			try {
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "password_policy");
				json.put("operation_type", "get_password");
				json.put("user", check_username);
				json.put("token", check_token);

				String respStr = client.sendMessage(json.toString());
				JSONObject respJson = new JSONObject(respStr);

				logger.info("res " + respJson.toString());

				for (int i = 0; i < respJson.length(); i++) {
					
					String characters_count = respJson.getString("characters_count");
					JSONArray password_blocked_list = respJson.getJSONArray("password_blocked_list");
					String ascii_ch_count = respJson.getString("ascii_ch_count");
					String number_count = respJson.getString("characters_count");
				//	int id = respJson.getInt("id");
					String mixed_ch_count = respJson.getString("mixed_ch_count");
					String allowed_special_ch = respJson.getString("allowed_special_ch");
					String special_ch_count = respJson.getString("special_ch_count");

					try {
						
						jsonObject.put("characters_count", characters_count);
						jsonObject.put("password_blocked_list", password_blocked_list);
						jsonObject.put("ascii_ch_count", ascii_ch_count);
						jsonObject.put("number_count", number_count);
						//jsonObject.put("id", id);
						jsonObject.put("mixed_ch_count", mixed_ch_count);
						jsonObject.put("allowed_special_ch", allowed_special_ch);
						jsonObject.put("special_ch_count", special_ch_count);

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
					// Set the content type of the response to application/json
					response.setContentType("application/json");


					// Get the response PrintWriter
					PrintWriter out = response.getWriter();

					System.out.println("json obj : "+jsonObject.toString());
					// Write the JSON object to the response
					// Trim the JSON data before sending
					out.print(jsonObject.toString().trim());

					out.flush();

				
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
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

		HttpSession session = request.getSession(true);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");

		String min_asccii_char_count = null;
		String min_mix_char_count = null;
		String min_num_count = null;
		String min_spl_char_count = null;
		String allowed_spl_char = null;
		String min_char_count = null;

		if (check_username != null) {

			String password_policy_action = request.getParameter("password_policy_action");

			if (password_policy_action != null) {
				switch (password_policy_action) {

				case "updatePassword":

					min_asccii_char_count = request.getParameter("min_asccii_char_count");
					min_mix_char_count = request.getParameter("min_mix_char_count");
					min_num_count = request.getParameter("min_num_count");
					min_spl_char_count = request.getParameter("min_spl_char_count");
					allowed_spl_char = request.getParameter("allowed_spl_char");
					min_char_count = request.getParameter("min_char_count");

					String blockedPasswordJson = request.getParameter("password_blocked_list");

					JSONArray password_blocked_list = null;
					try {
						password_blocked_list = new JSONArray(blockedPasswordJson);
					} catch (JSONException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}

					try {

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "password_policy");
						json.put("operation_type", "update_password");
						json.put("user", check_username);
						json.put("token", check_token);
						
						json.put("ascii_ch_count", min_asccii_char_count);
						json.put("mixed_ch_count", min_mix_char_count);
						json.put("number_count", min_num_count);
						json.put("special_ch_count", min_spl_char_count);
						json.put("allowed_special_ch", allowed_spl_char);
						json.put("characters_count", min_char_count);
						json.put("password_blocked_list", password_blocked_list);

						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr).getString("message"));

						String message = new JSONObject(respStr).getString("message");
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
