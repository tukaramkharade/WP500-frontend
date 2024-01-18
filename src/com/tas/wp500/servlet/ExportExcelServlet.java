package com.tas.wp500.servlet;

import java.io.IOException;
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

@WebServlet("/ExportExcelServlet")
public class ExportExcelServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(ExportExcelServlet.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		
		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();

		if (check_username != null) {

			try {

				json.put("operation", "get_all_tags");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);

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
		} 
	}


	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

}
