package com.tas.wp500;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

		String firstName = request.getParameter("firstName");
		String password = request.getParameter("password");

		System.out.println(firstName + " " + password);

		try {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			
			json.put("operation", "add_user");
			json.put("password", password);
			json.put("username", firstName);
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
//		super.doPost(request, resp);
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Retrieve the user data from wherever it's stored (e.g., a database)

		TCPClient client = new TCPClient();
		json = new JSONObject();

		// String errorString = null;

		try {
			
			json.put("operation", "get_all_user");
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
				JSONObject userObj = new JSONObject();
				try {
					System.out.println("jsonArray " + jsonArray.get(i));
					userObj.put("firstName", jsonArray.get(i).toString());
					userObj.put("lastName", "");
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				logger.info(jsonArray.get(i).toString());
				resJsonArray.put(userObj);
			}

			// Set the response content type to JSON
			response.setContentType("application/json");

			// Write the JSON data to the response
			response.getWriter().print(resJsonArray.toString());
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
