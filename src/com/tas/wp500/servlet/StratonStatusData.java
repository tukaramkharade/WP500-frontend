package com.tas.wp500.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
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

@WebServlet("/stratonStatusData")
public class StratonStatusData extends HttpServlet {
	final static Logger logger = Logger.getLogger(StratonStatusData.class);

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

				json.put("operation", "get_straton_status");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);
				
				String respStr = client.sendMessage(json.toString());
				
				logger.info("status : " + new JSONObject(respStr));

				String sys_cyclecount = new JSONObject(respStr).getString("sys.cyclecount");
				String sys_flags = new JSONObject(respStr).getString("sys.flags");
				String sys_cycletime = new JSONObject(respStr).getString("sys.cycletime");
				String sys_appname = new JSONObject(respStr).getString("sys.appname");
				String sys_cyclemax = new JSONObject(respStr).getString("sys.cyclemax");
				String sys_appversion = new JSONObject(respStr).getString("sys.appversion");
				String sys_cycleoverflows = new JSONObject(respStr).getString("sys.cycleoverflows");
				String message = new JSONObject(respStr).getString("message");

				System.out.println("sys_cyclecount : " + sys_cyclecount);
				System.out.println("sys_flags : " + sys_flags);
				
				System.out.println("sys_cycletime : " + sys_cycletime);
				System.out.println("sys_appname : " + sys_appname);
				
				System.out.println("sys_cyclemax : " + sys_cyclemax);
				System.out.println("sys_appversion : " + sys_appversion);
				
				System.out.println("sys_cycletime : " + sys_cycletime);
				System.out.println("message : " + message);
				System.out.println("sys_cycleoverflows : " + sys_cycleoverflows);
				
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("sys_cyclecount", sys_cyclecount);
				jsonObject.put("sys_flags", sys_flags);
				
				jsonObject.put("sys_cycletime", sys_cycletime);
				jsonObject.put("sys_appname", sys_appname);
				
				jsonObject.put("sys_cyclemax", sys_cyclemax);
				jsonObject.put("sys_appversion", sys_appversion);
				
				jsonObject.put("sys_cycletime", sys_cycletime);
				jsonObject.put("message", message);
				jsonObject.put("sys_cycleoverflows", sys_cycleoverflows);

				System.out.println(jsonObject);

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
