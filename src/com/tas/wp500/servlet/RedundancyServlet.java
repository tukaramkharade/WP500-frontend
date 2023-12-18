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
				System.out.println("common_setting 0 :"+common_setting.toString());
				
				
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
		
	}

}
