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

import sun.util.logging.resources.logging;

@WebServlet("/lanUpdateServlet")
public class LanUpdateServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(LanUpdateServlet.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);
		
		String check_username = (String) session.getAttribute("username");
		
		if(check_username != null){
			
		String eth1_ipaddr = request.getParameter("eth1_ipaddr");
		String eth1_subnet = request.getParameter("eth1_subnet");
		String eth1_type = request.getParameter("lan_type");
		String eth1_dhcp = request.getParameter("eth1_dhcp");

		try {

			System.out.println("eth1_ipaddr : "+eth1_ipaddr);
			System.out.println("eth1_subnet : "+eth1_subnet);
			System.out.println("eth1_type : "+eth1_type);
			System.out.println("eth1_dhcp : "+eth1_dhcp);
			
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			json.put("operation", "update_lan_setting");
			json.put("user", check_username);
			json.put("lan_type", eth1_type);
			json.put("eth1_dhcp", eth1_dhcp);
			json.put("eth1_ipaddr", eth1_ipaddr);
			json.put("eth1_subnet", eth1_subnet);

			String respStr = client.sendMessage(json.toString());
			logger.info("res " + new JSONObject(respStr).getString("msg"));
			
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
			logger.error("Error in updating lan settings: "+e);
		}
		}else{
			
		}
	}

}
