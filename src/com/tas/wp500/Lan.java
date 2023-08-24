package com.tas.wp500;

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

import com.tas.utils.TCPClient;

@WebServlet("/lan")
public class Lan extends HttpServlet {
       
	final static Logger logger = Logger.getLogger(Lan.class);
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");

		if (check_username != null) {
	
		try{
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			json.put("operation", "get_ethernet_details");
			json.put("user", check_username);
			
			String respStr = client.sendMessage(json.toString());
			
			logger.info("res " + new JSONObject(respStr));
			
			JSONObject result = new JSONObject(respStr);
			JSONObject lan0 = result.getJSONObject("eth1");
			JSONObject lan1 = result.getJSONObject("LAN1_setting");
			JSONObject lan2 = result.getJSONObject("LAN2_setting");

			String eth1_ipaddr = lan0.getString("eth1_ipaddr");
			String eth1_subnet = lan0.getString("eth1_subnet");
			String eth1_dhcp = lan0.getString("eth1_dhcp");
			String lan1_ipaddr = lan1.getString("lan1_ipaddr");
			String lan1_subnet = lan1.getString("lan1_subnet");
			String lan1_dhcp = lan1.getString("lan1_dhcp");
			String lan2_ipaddr = lan2.getString("lan2_ipaddr");
			String lan2_subnet = lan2.getString("lan2_subnet");
			String lan2_dhcp = lan2.getString("lan2_dhcp");
			
			JSONObject jsonObject = new JSONObject();
		    jsonObject.put("eth1_ipaddr", eth1_ipaddr);
		    jsonObject.put("eth1_subnet", eth1_subnet);
		    jsonObject.put("eth1_dhcp", eth1_dhcp);
		    
		    jsonObject.put("lan1_ipaddr", lan1_ipaddr);
		    jsonObject.put("lan1_subnet", lan1_subnet);
		    jsonObject.put("lan1_dhcp", lan1_dhcp);
		    
		    jsonObject.put("lan2_ipaddr", lan2_ipaddr);
		    jsonObject.put("lan2_subnet", lan2_subnet);
		    jsonObject.put("lan2_dhcp", lan2_dhcp);
		    
		    // Set the content type of the response to application/json
		    response.setContentType("application/json");
		    
		    // Get the response PrintWriter
		    PrintWriter out = response.getWriter();
		    
		    // Write the JSON object to the response
		    out.print(jsonObject.toString());
		    out.flush();
		}catch(Exception e){
			e.printStackTrace();
			logger.error("Error in getting lan details : "+e);
		}
		}else{
		
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
				logger.error("Error in session timeout : "+e);
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");

		if (check_username != null) {
		
		int eth_type = Integer.parseInt(request.getParameter("eth_type"));
		
		try {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			json.put("operation", "get_dhcp_setting");
			json.put("user", check_username);
		
			json.put("eth_type", eth_type);
			
			String respStr = client.sendMessage(json.toString());
			
			logger.info("res " + new JSONObject(respStr).getString("msg"));
			
			String message_dhcp = new JSONObject(respStr).getString("msg");
			
			int eth1_dhcp = new JSONObject(respStr).getInt("eth1_dhcp");
		    String eth1_subnet = new JSONObject(respStr).getString("eth1_subnet");
		    String eth1_ipaddr = new JSONObject(respStr).getString("eth1_ipaddr");
		    
			JSONObject jsonObject = new JSONObject();
		    jsonObject.put("message_dhcp", message_dhcp);
		    jsonObject.put("eth1_dhcp", eth1_dhcp);
		    jsonObject.put("eth1_subnet", eth1_subnet);
		    jsonObject.put("eth1_ipaddr", eth1_ipaddr);
		    
		    // Set the content type of the response to application/json
		    response.setContentType("application/json");
		    
		    // Get the response PrintWriter
		    PrintWriter out = response.getWriter();
		    
		    // Write the JSON object to the response
		    out.print(jsonObject.toString());
		    out.flush();
			
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Error in getting dhcp setting : "+e);
		}
		
		}else{
			
		}
	}
}
