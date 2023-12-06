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

@WebServlet("/overviewGetData")
public class OverviewGetData extends HttpServlet {
	final static Logger logger = Logger.getLogger(OverviewGetData.class);

	TCPClient client = new TCPClient();
	JSONObject json = new JSONObject();
	JSONObject respJson = null;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");

		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();

		if (check_username != null) {

			try {

				json.put("operation", "get_overview_info");
				json.put("user", check_username);
				json.put("token", check_token);

				String respStr = client.sendMessage(json.toString());
				JSONObject respJson = new JSONObject(respStr);
				
				logger.info("res: "+respJson.toString());
				
				
				
				String HW_REV = respJson.getString("HW_REV");
				String TAS_SERIAL_NO = respJson.getString("TAS_SERIAL_NO");
				String FW_REV = respJson.getString("FW_REV");

				JSONObject jsonObject = new JSONObject();
				jsonObject.put("HW_REV", HW_REV);
				jsonObject.put("TAS_SERIAL_NO", TAS_SERIAL_NO);
				jsonObject.put("FW_REV", FW_REV);

				System.out.println(jsonObject);

				// Set the content type of the response to application/json
				response.setContentType("application/json");

				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting overview data: " + e);
			}

		} 
	}

}
