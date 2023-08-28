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

@WebServlet("/lanDhcpGetData1")
public class LanDhcpGetData extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		
		HttpSession session = request.getSession(false);
		
		String check_username = (String) session.getAttribute("username");
		
		if(check_username != null){
			
		

		String dhcp_type = request.getParameter("dhcp_type");
		
		try {

			
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			json.put("operation", "get_dhcp_setting");
			
			json.put("eth_type", dhcp_type);
			
			
			String respStr = client.sendMessage(json.toString());

			System.out.println("response : " + respStr);
			String eth1_ipaddr = new JSONObject(respStr).getString("eth1_ipaddr");
			String eth1_subnet = new JSONObject(respStr).getString("eth1_subnet");
			
			String eth1_ipaddr1 = eth1_ipaddr.toString();
			String eth1_subnet1 = eth1_subnet.toString();
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("eth1_ipaddr", eth1_ipaddr1);
			jsonObject.put("eth1_subnet", eth1_subnet1);
			
			System.out.println(jsonObject);

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
