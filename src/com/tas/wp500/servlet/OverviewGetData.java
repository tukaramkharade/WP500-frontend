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

		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();

		if (check_username != null) {

			try {

				json.put("operation", "get_overview_info");
				json.put("user", check_username);

				String respStr = client.sendMessage(json.toString());

				String HW_REV = new JSONObject(respStr).getString("HW_REV");
				String TAS_SERIAL_NO = new JSONObject(respStr).getString("TAS_SERIAL_NO");
				String FW_REV = new JSONObject(respStr).getString("FW_REV");

				System.out.println("HW_REV : " + HW_REV);
				System.out.println("TAS_SERIAL_NO : " + TAS_SERIAL_NO);
				System.out.println("FW_REV : " + FW_REV);

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
				logger.error("Error in getting opcua client list: " + e);
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

}