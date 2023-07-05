package com.tas.wp500;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.json.JSONObject;

import com.tas.utils.TCPClient;

/**
 * Servlet implementation class Lan1
 */
@WebServlet("/lan")
public class Lan extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	final static Logger logger = Logger.getLogger(Lan.class);
    public Lan() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	//	response.getWriter().append("Served at: ").append(request.getContextPath());
	
		try{
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			json.put("operation", "get_ethernet_details");
			
			String respStr = client.sendMessage(json.toString());
			
			System.out.println("res " + new JSONObject(respStr));
			JSONObject result = new JSONObject(respStr);
		
			
			JSONObject lan0 = result.getJSONObject("LAN0_setting");
			System.out.println("lan 0 :"+lan0.toString());
			
			JSONObject lan1 = result.getJSONObject("LAN1_setting");
			System.out.println("lan 1 :"+lan1.toString());
			
			JSONObject lan2 = result.getJSONObject("LAN2_setting");
			System.out.println("lan 2 :"+lan2.toString());
			
			
			String eth0_ipaddr = lan0.getString("eth0_ipaddr");
			System.out.println("eth0_ipaddr : "+eth0_ipaddr);
			logger.info("eth0_ipaddr : "+eth0_ipaddr);
			
			String eth0_subnet = lan0.getString("eth0_subnet");
			System.out.println("eth0_subnet : "+eth0_subnet);
			logger.info("eth0_subnet : "+eth0_subnet);
			
			String eth1_ipaddr = lan1.getString("eth1_ipaddr");
			System.out.println("eth1_ipaddr : "+eth1_ipaddr);
			logger.info("eth1_ipaddr : "+eth1_ipaddr);
			
			String eth1_subnet = lan1.getString("eth1_subnet");
			System.out.println("eth1_subnet : "+eth1_subnet);
			logger.info("eth1_subnet : "+eth1_subnet);
			
			String eth2_ipaddr = lan2.getString("eth2_ipaddr");
			System.out.println("eth2_ipaddr : "+eth2_ipaddr);
			logger.info("eth2_ipaddr : "+eth2_ipaddr);
			
			String eth2_subnet = lan2.getString("eth2_subnet");
			System.out.println("eth2_subnet : "+eth2_subnet);
			logger.info("eth2_subnet : "+eth2_subnet);
					
			JSONObject jsonObject = new JSONObject();
		    jsonObject.put("eth0_ipaddr", eth0_ipaddr);
		    jsonObject.put("eth0_subnet", eth0_subnet);
		    
		    jsonObject.put("eth1_ipaddr", eth1_ipaddr);
		    jsonObject.put("eth1_subnet", eth1_subnet);
		    
		    jsonObject.put("eth2_ipaddr", eth2_ipaddr);
		    jsonObject.put("eth2_subnet", eth2_subnet);
		    
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

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}