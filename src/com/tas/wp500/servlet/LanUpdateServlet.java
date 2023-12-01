package com.tas.wp500.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

@WebServlet("/lanUpdateServlet")
public class LanUpdateServlet extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);
		
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		
		if(check_username != null){
		
		String eth1_ipaddr = request.getParameter("eth1_ipaddr");
		String eth1_subnet = request.getParameter("eth1_subnet");
		String eth1_type = request.getParameter("lan_type");
		String eth1_dhcp = request.getParameter("eth1_dhcp1");
		String eth1_gateway = request.getParameter("eth1_gateway");
		String eth1_dns = request.getParameter("eth1_dns");
		String toggle_enable_lan1 = request.getParameter("toggle_enable_lan1");
		

		try {

			System.out.println("eth1_ipaddr-->: "+eth1_ipaddr);
			System.out.println("eth1_subnet-->: "+eth1_subnet);
			System.out.println("eth1_type-->: "+eth1_type);
			System.out.println("eth1_dhcp-->: "+eth1_dhcp);
			System.out.println("toggle_enable_lan1-->: "+toggle_enable_lan1);
			
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
//{"operation":"update_lan_setting","lan_type":"eth1","eth1_dhcp":"0","eth1_ipaddr":"192.168.1.50","eth1_subnet":"255.255.255.0"}
			json.put("operation", "update_lan_setting");
			json.put("user", check_username);
			json.put("token", check_token);
			json.put("lan_type", eth1_type);
			json.put("eth1_dhcp", eth1_dhcp);
			json.put("eth1_ipaddr", eth1_ipaddr);
			json.put("eth1_subnet", eth1_subnet);
			json.put("eth1_gateway", eth1_gateway);
			json.put("eth1_dns", eth1_dns);
			json.put("toggle_enable_lan1", toggle_enable_lan1);
			
			
			System.out.println("eth1-->"+json);
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
			
		}
	}

}
