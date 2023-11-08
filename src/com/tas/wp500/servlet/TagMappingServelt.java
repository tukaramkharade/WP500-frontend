package com.tas.wp500.servlet;

import java.io.BufferedReader;
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

@WebServlet("/tagMapping")
public class TagMappingServelt extends HttpServlet {
	final static Logger logger = Logger.getLogger(TagMappingServelt.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");

		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();

		if (check_username != null) {

			try {

				json.put("operation", "get_all_tags");
				json.put("user", check_username);

				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);
				JSONArray resJsonArray = new JSONArray();
				logger.info("Tag Mapping response : " + respJson.toString());
				JSONArray resultArr = respJson.getJSONArray("data");

				for (int i = 0; i < resultArr.length(); i++) {
					JSONObject jsObj = resultArr.getJSONObject(i);

					String tag_name = jsObj.getString("tag_name");
					String pv_address = jsObj.getString("pv_address");
					
					JSONObject tagObj = new JSONObject();

					try {
						tagObj.put("tag_name", tag_name);
						tagObj.put("pv_address", pv_address);
						
						resJsonArray.put(tagObj);
					} catch (JSONException e) {
						e.printStackTrace();
						logger.error("Error in putting mqtt data in json array : " + e);
					}
				}

				logger.info("JSON ARRAY :" + resJsonArray.length() + " " + resJsonArray.toString());

				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting mqtt data: " + e);
			}
		} else {

			try {
				JSONObject userObj = new JSONObject();
				userObj.put("msg", "Your session is timeout. Please login again");
				userObj.put("status", "fail");

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

		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");

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

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "insert_tag");
						json.put("user", check_username);
						json.put("tag_name", tag_name);
						json.put("pv_address", pv_address);
						

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
						logger.error("Error in adding mqtt : " + e);
					}
					break;

				case "update":
					tag_name = request.getParameter("tag_name");
					pv_address = request.getParameter("pv_address");
					
					try {

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "update_tag");
						json.put("tag_name", tag_name);
						json.put("pv_address", pv_address);
						
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
						logger.error("Error in updating mqtt : " + e);
					}

					break;

				case "delete":
					tag_name = request.getParameter("tag_name");
					
					try {

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "delete_tag");
						json.put("user", check_username);
						json.put("tag_name", tag_name);

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
						logger.error("Error in deleting mqtt : " + e);
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
