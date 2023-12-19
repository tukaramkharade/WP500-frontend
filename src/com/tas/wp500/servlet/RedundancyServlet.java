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

@WebServlet("/redundancyServlet")
public class RedundancyServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(RedundancyServlet.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);

		if (session.getAttribute("username") != null) {
			String check_username = (String) session.getAttribute("username");
			String check_token = (String) session.getAttribute("token");
	
		try{
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			json.put("operation", "get_ethernet_details");
			json.put("user", check_username);
			json.put("token", check_token);
			
			String respStr = client.sendMessage(json.toString());
			
			System.out.println("res " + new JSONObject(respStr));
			logger.info("res " + new JSONObject(respStr));
			JSONObject result = new JSONObject(respStr);
		
			String status = result.getString("status");
			JSONObject jsonObject = new JSONObject();
			
			if(status.equals("success")){
				JSONObject common_setting = result.getJSONObject("common_setting");				
				
				String common_ip0 = common_setting.getString("common_ip0");				
				String common_subnet0 = common_setting.getString("common_subnet0");				
				String common_ip1 = common_setting.getString("common_ip1");				
				String common_subnet1 = common_setting.getString("common_subnet1");			
				String common_ip2 = common_setting.getString("common_ip2");				
				String common_subnet2 = common_setting.getString("common_subnet2");				
				String redundancy_role = result.getString("Redundancy_Role");
				String redundancy_enable = result.getString("Redundancy_enable");
				String partner_ip = result.getString("partner_ip");
				
			    jsonObject.put("common_ip0", common_ip0);
			    jsonObject.put("common_subnet0", common_subnet0);
			    jsonObject.put("common_ip1", common_ip1);
			    jsonObject.put("common_subnet1", common_subnet1);
			    jsonObject.put("common_ip2",common_ip2);
			    jsonObject.put("common_subnet2",common_subnet2);
			    jsonObject.put("Redundancy_Role", redundancy_role);
			    jsonObject.put("Redundancy_enable",redundancy_enable);
			    jsonObject.put("partner_ip",partner_ip);
			    jsonObject.put("status", status);
			    
			   
			}else if(status.equals("fail")){
				String message = result.getString("msg");
				jsonObject.put("status", status);
				jsonObject.put("message", message);
			}
			
		  
		    // Set the content type of the response to application/json
		    response.setContentType("application/json");
		    
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
		
		if (check_username != null) {
			
			String toggle_redundancy_enable = request.getParameter("toggle_redundancy_enable");		
			String toggle_redundancy_role = request.getParameter("toggle_redundancy_role");			
			String partner_ip = request.getParameter("partner_ip");			
			String common_ip_0 = request.getParameter("common_ip_0");			
			String common_subnet_0 = request.getParameter("common_subnet_0");			
			String common_ip_1 = request.getParameter("common_ip_1");			
			String common_subnet_1 = request.getParameter("common_subnet_1");			
			String common_ip_2 = request.getParameter("common_ip_2");			
			String common_subnet_2 = request.getParameter("common_subnet_2");

			try {

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "update_lan_setting");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("lan_type", "redundancy_setting");
				
				
				json.put("Redundancy_enable", toggle_redundancy_enable);			
				json.put("Redundancy_Role", toggle_redundancy_role);				
				json.put("partner_ip", partner_ip);				
				json.put("common_ip0", common_ip_0);				
				json.put("common_subnet0", common_subnet_0);				
				json.put("common_ip1", common_ip_1);				
				json.put("common_subnet1", common_subnet_1);				
				json.put("common_ip2", common_ip_2);				
				json.put("common_subnet2", common_subnet_2);
				

				String respStr = client.sendMessage(json.toString());

				System.out.println("response : " + respStr);

				String message = new JSONObject(respStr).getString("msg");
				String status = new JSONObject(respStr).getString("status");
				
				
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("message", message);
				jsonObject.put("status", status);
				

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

		}
	}


}
