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

@WebServlet("/upadateLan2")
public class Lan2UpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at:
		// ").append(request.getContextPath());
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request, response);
		
		
		HttpSession session = request.getSession(false);
		
		String check_username = (String) session.getAttribute("username");
		
		if(check_username != null){
			
		

		String lan2_ipaddr = request.getParameter("lan2_ipaddr");
		String lan2_subnet = request.getParameter("lan2_subnet");
		String lan2_type = request.getParameter("lan2_type");
		String lan2_dhcp = request.getParameter("lan1_dhcp2");
		String lan2_gateway = request.getParameter("lan2_gateway");
		String lan2_dns = request.getParameter("lan2_dns");

		try {

			System.out.println("lan2_ipaddr-->: "+lan2_ipaddr);
			System.out.println("lan2_subnet-->: "+lan2_subnet);
			System.out.println("lan2_type-->: "+lan2_type);
			System.out.println("lan2_dhcp-->: "+lan2_dhcp);
			
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			json.put("operation", "update_lan_setting");
			//json.put("user", check_username);
			json.put("lan_type", lan2_type);
			json.put("lan2_dhcp", lan2_dhcp);
			json.put("lan2_ipaddr", lan2_ipaddr);
			json.put("lan2_subnet", lan2_subnet);
			json.put("lan2_gateway", lan2_gateway);
			json.put("lan2_dns", lan2_dns);
			System.out.println("lan2-->"+json);
			
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
