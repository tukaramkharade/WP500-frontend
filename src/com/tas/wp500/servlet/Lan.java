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

@WebServlet("/lan")
public class Lan extends HttpServlet {
	   
	final static Logger logger = Logger.getLogger(Lan.class);   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {		
		HttpSession session = request.getSession(false);
		if (session.getAttribute("username") != null) {
			String check_username = (String) session.getAttribute("username");
			String check_token = (String) session.getAttribute("token");
			String check_role = (String) session.getAttribute("role");
			String csrfTokenFromRequest = request.getParameter("csrfToken");
			String csrfTokenFromSession = (String) session.getAttribute("csrfToken");			
		try{
			if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();			
			json.put("operation", "get_ethernet_details");
			json.put("user", check_username);
			json.put("token", check_token);
			json.put("role", check_role);
			
			String respStr = client.sendMessage(json.toString());		
			logger.info("res " + new JSONObject(respStr));
			JSONObject result = new JSONObject(respStr);		
			String status = result.getString("status");
			JSONObject jsonObject = new JSONObject();			
			if(status.equals("success")){
				JSONObject lan0 = result.getJSONObject("lan0");			
				JSONObject lan1 = result.getJSONObject("LAN1_setting");				
				JSONObject lan2 = result.getJSONObject("LAN2_setting");				
				String lan0_ipaddr = lan0.getString("lan0_ipaddr");				
				String lan0_subnet = lan0.getString("lan0_subnet");				
				String lan0_dhcp = lan0.getString("lan0_dhcp");				
				String lan0_gateway = lan0.getString("lan0_gateway");
				String lan0_dns = lan0.getString("lan0_dns");				
				String lan1_ipaddr = lan1.getString("lan1_ipaddr");				
				String lan1_subnet = lan1.getString("lan1_subnet");				
				String lan1_dhcp = lan1.getString("lan1_dhcp");				
				String lan1_gateway = lan1.getString("lan1_gateway");
				String lan1_dns = lan1.getString("lan1_dns");
				String lan1_enable = lan1.getString("lan1_enable");				
				String lan2_ipaddr = lan2.getString("lan2_ipaddr");				
				String lan2_subnet = lan2.getString("lan2_subnet");				
				String lan2_dhcp = lan2.getString("lan2_dhcp");				
				String lan2_gateway = lan2.getString("lan2_gateway");
				String lan2_dns = lan2.getString("lan2_dns");
				String lan2_enable = lan2.getString("lan2_enable");				
			    jsonObject.put("eth1_ipaddr", lan0_ipaddr);
			    jsonObject.put("eth1_subnet", lan0_subnet);
			    jsonObject.put("eth1_dhcp", lan0_dhcp);
			    jsonObject.put("eth1_gateway", lan0_gateway);
			    jsonObject.put("eth1_dns",lan0_dns );			    			    
			    jsonObject.put("lan1_ipaddr", lan1_ipaddr); 
			    jsonObject.put("lan1_subnet", lan1_subnet);
			    jsonObject.put("lan1_dhcp", lan1_dhcp);
			    jsonObject.put("lan1_gateway", lan1_gateway);
			    jsonObject.put("lan1_dns", lan1_dns);
			    jsonObject.put("lan1_enable", lan1_enable);			    
			    jsonObject.put("lan2_ipaddr", lan2_ipaddr);
			    jsonObject.put("lan2_subnet", lan2_subnet);
			    jsonObject.put("lan2_dhcp", lan2_dhcp);
			    jsonObject.put("lan2_gateway", lan2_gateway);
			    jsonObject.put("lan2_dns", lan2_dns);
			    jsonObject.put("lan2_enable", lan2_enable);
			}else if(status.equals("fail")){
				String message = result.getString("msg");
				jsonObject.put("status", status);
				jsonObject.put("message", message);
			}
		    response.setContentType("application/json");
		    response.setHeader("X-Content-Type-Options", "nosniff");
		    PrintWriter out = response.getWriter();
		    out.print(jsonObject.toString());
		    out.flush();
			}else {
				logger.error("Token validation failed");	
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		}	
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session != null) {
			String check_username = (String) session.getAttribute("username");
			String check_token = (String) session.getAttribute("token");
			String check_role = (String) session.getAttribute("role");
			String csrfTokenFromRequest = request.getParameter("csrfToken");
			String csrfTokenFromSession = (String) session.getAttribute("csrfToken");			
		int eth_type = Integer.parseInt(request.getParameter("eth_type"));		
		try {		
			if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();		
			json.put("operation", "get_dhcp_setting");
			json.put("user", check_username);
			json.put("token", check_token);
			json.put("eth_type", eth_type);
			json.put("role", check_role);
			
			String respStr = client.sendMessage(json.toString());		
			logger.info("res " + new JSONObject(respStr));		
			String message_dhcp = new JSONObject(respStr).getString("msg");			
			int eth1_dhcp = new JSONObject(respStr).getInt("eth1_dhcp");		    
		    String eth1_subnet = new JSONObject(respStr).getString("eth1_subnet");		    
		    String eth1_ipaddr = new JSONObject(respStr).getString("eth1_ipaddr");		    
			JSONObject jsonObject = new JSONObject();
		    jsonObject.put("message_dhcp", message_dhcp);
		    jsonObject.put("eth1_dhcp", eth1_dhcp);
		    jsonObject.put("eth1_subnet", eth1_subnet);
		    jsonObject.put("eth1_ipaddr", eth1_ipaddr);
		    response.setContentType("application/json");
		    response.setHeader("X-Content-Type-Options", "nosniff");
		    PrintWriter out = response.getWriter();
		    out.print(jsonObject.toString());
		    out.flush();
			}else {
				logger.error("Token validation failed");	
			}	
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		}
	}
}