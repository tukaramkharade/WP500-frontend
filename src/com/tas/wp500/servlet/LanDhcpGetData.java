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

@WebServlet("/lanDhcpGetData1")
public class LanDhcpGetData extends HttpServlet {
	final static Logger logger = Logger.getLogger(LanDhcpGetData.class);

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		
		HttpSession session = request.getSession(false);
		
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		String csrfTokenFromRequest = request.getParameter("csrfToken");

		// Retrieve CSRF token from the session
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
		
		
		if(check_username != null){
			
		

		String dhcp_type = request.getParameter("dhcp_type");
		
		try {
			if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
			
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			json.put("operation", "get_dhcp_setting");
			json.put("token", check_token);
			json.put("eth_type", dhcp_type);
			json.put("user", check_username);
			json.put("role", check_role);
			
			String respStr = client.sendMessage(json.toString());

			System.out.println("response : " + respStr);
			String lan0_ipaddr = new JSONObject(respStr).getString("eth0_ipaddr");
			String lan0_subnet = new JSONObject(respStr).getString("eth0_subnet");			
			String status = new JSONObject(respStr).getString("status");
			String eth0_dhcp = new JSONObject(respStr).getString("eth0_dhcp");
			String lan0_ipaddr1 = lan0_ipaddr.toString();
			String lan0_subnet1 = lan0_subnet.toString();
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("eth1_ipaddr", lan0_ipaddr1);
			jsonObject.put("eth1_subnet", lan0_subnet1);
			jsonObject.put("status", status);
			jsonObject.put("eth0_dhcp", eth0_dhcp);
			System.out.println(jsonObject);

			// Set the content type of the response to application/json
			response.setContentType("application/json");
			 response.setHeader("X-Content-Type-Options", "nosniff");

			// Get the response PrintWriter
			PrintWriter out = response.getWriter();

			// Write the JSON object to the response
			out.print(jsonObject.toString());
			out.flush();
			}else {
				logger.error("CSRF token validation failed");	
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		}
	}

}
