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

@WebServlet("/upadateLan2")
public class Lan2UpdateServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(Lan2UpdateServlet.class);

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
			
		String lan2_ipaddr = request.getParameter("lan2_ipaddr");
		String lan2_subnet = request.getParameter("lan2_subnet");
		String lan2_type = request.getParameter("lan2_type");
		String lan2_dhcp = request.getParameter("lan1_dhcp2");
		String lan2_gateway = request.getParameter("lan2_gateway");
		String lan2_dns = request.getParameter("lan2_dns");
		String toggle_enable_lan2 = request.getParameter("toggle_enable_lan2");

		try {
			if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			json.put("operation", "update_lan_setting");
			json.put("user", check_username);
			json.put("role", check_role);
//			json.put("lan_type", lan2_type);
//			json.put("lan2_dhcp", lan2_dhcp);
//			json.put("lan2_ipaddr", lan2_ipaddr);
//			json.put("lan2_subnet", lan2_subnet);
//			json.put("lan2_gateway", lan2_gateway);
//			json.put("lan2_dns", lan2_dns);
//			json.put("lan2_enable", toggle_enable_lan2);
			json.put("token", check_token);
			if (!lan2_type.isEmpty()) {
			    json.put("lan_type", lan2_type);
			}

			if (!lan2_dhcp.isEmpty()) {
			    json.put("lan2_dhcp", lan2_dhcp);
			}
			
			System.out.println("lan dhcp: "+lan2_dhcp);

			if (!lan2_ipaddr.isEmpty()) {
			    json.put("lan2_ipaddr", lan2_ipaddr);
			}

			if (!lan2_subnet.isEmpty()) {
			    json.put("lan2_subnet", lan2_subnet);
			}

			if (!lan2_gateway.isEmpty()) {
			    json.put("lan2_gateway", lan2_gateway);
			}

			if (!lan2_dns.isEmpty()) {
			    json.put("lan2_dns", lan2_dns);
			}

			if (!toggle_enable_lan2.isEmpty()) {
			    json.put("lan2_enable", toggle_enable_lan2);
			}
			System.out.println("eth1-->"+json);
			String respStr = client.sendMessage(json.toString());

			System.out.println("response : " + respStr);

			String message = new JSONObject(respStr).getString("msg");
			JSONObject jsonObject = new JSONObject();
		    jsonObject.put("message", message);
		    
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
