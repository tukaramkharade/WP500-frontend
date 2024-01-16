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
		String check_role = (String) session.getAttribute("role");

		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();

		if (check_username != null) {

			try {

				json.put("operation", "get_overview_info");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);

				String respStr = client.sendMessage(json.toString());
				System.out.println("respStr"+respStr);
				
				String status = new JSONObject(respStr).getString("status");
				String message = new JSONObject(respStr).getString("msg");
				
				JSONObject jsonObject = new JSONObject();
				if(status.equals("success")){
					String HW_REV = new JSONObject(respStr).getString("HW_REV");
					String TAS_SERIAL_NO = new JSONObject(respStr).getString("TAS_SERIAL_NO");
					String FW_REV = new JSONObject(respStr).getString("FW_REV");
					String SEC_PATCH_LVL = new JSONObject(respStr).getString("SEC_PATCH_LVL");
					String NTP_SYNC_STATUS = new JSONObject(respStr).getString("NTP_SYNC_STATUS");
					
					jsonObject.put("HW_REV", HW_REV);
					jsonObject.put("TAS_SERIAL_NO", TAS_SERIAL_NO);
					jsonObject.put("FW_REV", FW_REV);
					jsonObject.put("SEC_PATCH_LVL", SEC_PATCH_LVL);
					jsonObject.put("NTP_SYNC_STATUS", NTP_SYNC_STATUS);
					jsonObject.put("status", status);
				}else if(status.equals("fail")){
					jsonObject.put("status", status);
					jsonObject.put("message", message);
				}
				
				// Set the content type of the response to application/json
				response.setContentType("application/json");
				 response.setHeader("X-Content-Type-Options", "nosniff");

				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting opcua client list: " + e);
			}

		} 
	}

}
