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
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

@WebServlet("/jsonBuilderData")
public class JSONBuilderBrokerIPListServlet extends HttpServlet {

	final static Logger logger = Logger.getLogger(JSONBuilderBrokerIPListServlet.class);
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {	
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		if (check_username != null) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			try {
				json.put("operation", "protocol");
				json.put("protocol_type", "json_builder");
				json.put("operation_type", "get_broker_ip");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);

				String respStr = client.sendMessage(json.toString());
				logger.info("res " + new JSONObject(respStr));
				JSONObject result = new JSONObject(respStr);
				JSONArray broker_ip_result = result.getJSONArray("result");
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("broker_ip_result", broker_ip_result);
				response.setContentType("application/json");
				response.setHeader("X-Content-Type-Options", "nosniff");
				PrintWriter out = response.getWriter();
				out.print(jsonObject.toString());
				out.flush();
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting broker ip :"+e);
			}
		} 
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {	
	}
}