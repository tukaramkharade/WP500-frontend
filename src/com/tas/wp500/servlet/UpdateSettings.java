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

@WebServlet("/updateSettings")
public class UpdateSettings extends HttpServlet {
	final static Logger logger = Logger.getLogger(UpdateSettings.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		
		if (check_username != null) {
			
			String toggle_enable_ftp = request.getParameter("toggle_enable_ftp");
			String toggle_enable_ssh = request.getParameter("toggle_enable_ssh");
			String toggle_enable_usbtty = request.getParameter("toggle_enable_usbtty");
			String lan_type = request.getParameter("lan_type");
			
			try {

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "update_lan_setting");
				json.put("user", check_username);
				
				json.put("lan_type", lan_type);
				json.put("enable_ftp", toggle_enable_ftp);
				json.put("enable_ssh", toggle_enable_ssh);
				json.put("enable_usbtty", toggle_enable_usbtty);
				

				System.out.println("lan1-->" + json);
				String respStr = client.sendMessage(json.toString());

				System.out.println("response : " + respStr);

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
			}

			
		}else{
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
