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
		HttpSession session = request.getSession(false);

		if (session.getAttribute("username") != null) {
			String check_username = (String) session.getAttribute("username");
			String check_token = (String) session.getAttribute("token");
			String check_role = (String) session.getAttribute("role");
	
		try{
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			json.put("operation", "get_ethernet_details");
			json.put("user", check_username);
			json.put("token", check_token);
			json.put("role", check_role);
			
			String respStr = client.sendMessage(json.toString());
			
			System.out.println("res " + new JSONObject(respStr));
			logger.info("res " + new JSONObject(respStr));
			JSONObject result = new JSONObject(respStr);
		
			String status = result.getString("status");
			JSONObject jsonObject = new JSONObject();
			
			if(status.equals("success")){
				JSONObject general_setting = result.getJSONObject("general_setting");				
				
				String enable_ftp = general_setting.getString("enable_ftp");				
				String enable_ssh = general_setting.getString("enable_ssh");				
				String enable_usbtty = general_setting.getString("enable_usbtty");				
				
			    jsonObject.put("enable_ftp", enable_ftp);
			    jsonObject.put("enable_ssh", enable_ssh);
			    jsonObject.put("enable_usbtty", enable_usbtty);
			   
			}else if(status.equals("fail")){
				String message = result.getString("msg");
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
		}catch(Exception e){
			e.printStackTrace();
		}
		}

		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		
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
				json.put("token", check_token);
				json.put("lan_type", lan_type);
				json.put("enable_ftp", toggle_enable_ftp);
				json.put("enable_ssh", toggle_enable_ssh);
				json.put("enable_usbtty", toggle_enable_usbtty);
				json.put("role", check_role);

				String respStr = client.sendMessage(json.toString());

				System.out.println("response : " + respStr);

				String message = new JSONObject(respStr).getString("msg");
				String status = new JSONObject(respStr).getString("status");
				
				
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("message", message);
				jsonObject.put("status", status);
				

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
			}

		}
	}

}
