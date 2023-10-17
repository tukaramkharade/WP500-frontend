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

import com.tas.wp500.utils.IntervalMapper;
import com.tas.wp500.utils.TCPClient;

	
	@WebServlet("/ntpDataUpadate")
	public class NtpDataUpadate extends HttpServlet {
		
	       
		final static Logger logger = Logger.getLogger(Lan.class);
	    
		protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			// TODO Auto-generated method stub
		//	response.getWriter().append("Served at: ").append(request.getContextPath());
			HttpSession session = request.getSession(false);

			if (session.getAttribute("username") != null) {
				String check_username = (String) session.getAttribute("username");
		
			try{
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();
				
				json.put("operation", "get_ethernet_details");
				json.put("user", check_username);
				
				String respStr = client.sendMessage(json.toString());
				
				System.out.println("res " + new JSONObject(respStr));
				logger.info("res " + new JSONObject(respStr));
				JSONObject result = new JSONObject(respStr);
			
				
				JSONObject ntp = result.getJSONObject("ntp_setting");
				System.out.println("ntp :"+ntp.toString());
				
				
				
				String ntp_server1 = ntp.getString("ntp_server1");
				System.out.println("ntp_server1 : "+ntp_server1);
				logger.info("ntp_server1 : "+ntp_server1);
				 
				String ntp_server2 = ntp.getString("ntp_server2");
				System.out.println("ntp_server2 : "+ntp_server2);
				logger.info("ntp_server2 : "+ntp_server2);
				
				String ntp_server3 = ntp.getString("ntp_server3");
				System.out.println("ntp_server3 : "+ntp_server3);
				logger.info("ntp_server3 : "+ntp_server3);
				
				
				String ntp_interval = ntp.getString("ntp_interval");
				int intervalValue = Integer.parseInt(ntp_interval);
				String ntpIntervalString = IntervalMapper.getIntervalByValue(intervalValue);
				System.out.println("ntp_interval : "+ntpIntervalString);
				logger.info("ntp_interval : "+ntpIntervalString);
				
				
				JSONObject jsonObject = new JSONObject();
			    
			    jsonObject.put("ntp_server1", ntp_server1);
			    jsonObject.put("ntp_server2", ntp_server2);
			    jsonObject.put("ntp_server3", ntp_server3);
			    jsonObject.put("ntp_interval",ntp_interval);
			    
			    
			    response.setContentType("application/json");
			    
			    // Get the response PrintWriter
			    PrintWriter out = response.getWriter();
			    
			    // Write the JSON object to the response
			    out.print(jsonObject.toString());
			    out.flush();
			}catch(Exception e){
				e.printStackTrace();
			}
			}else{
//				System.out.println("Login first");
//				response.sendRedirect("login.jsp");
				
				
				try {
					JSONObject userObj = new JSONObject();
					userObj.put("msg", "Your session is timeout. Please login again");
					userObj.put("status", "fail");
					
					
					
					System.out.println(">>" +userObj);
					
					// Set the response content type to JSON
					response.setContentType("application/json");

					// Write the JSON data to the response
					response.getWriter().print(userObj.toString());
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
		}

		
		protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			// TODO Auto-generated method stub
		//	doGet(request, response);
			
			HttpSession session = request.getSession(false);
			
			String check_username = (String) session.getAttribute("username");
			
			if(check_username != null){
			String ntpIntervalValue = null;
			

			String ntp_server1 = request.getParameter("ntp_server1");
			String ntp_server2 = request.getParameter("ntp_server2");
			String ntp_server3 = request.getParameter("ntp_server2");
			String ntp_interval = request.getParameter("ntp_interval");
			 ntpIntervalValue = IntervalMapper.getIntervalByString(ntp_interval);

			try {

				System.out.println("ntp_server1-->: "+ntp_server1);
				System.out.println("ntp_server2-->: "+ntp_server2);
				System.out.println("ntp_server3-->: "+ntp_server3);
				System.out.println("ntp_interval-->:"+ntpIntervalValue);
				
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();
	//{"operation":"update_lan_setting","lan_type":"eth1","eth1_dhcp":"0","eth1_ipaddr":"192.168.1.50","eth1_subnet":"255.255.255.0"}
				json.put("operation", "update_lan_setting");
				json.put("lan_type", "ntp");
				//json.put("user", check_username);
				json.put("ntp_server1", ntp_server1);
				json.put("ntp_server2", ntp_server2);
				json.put("ntp_server3", ntp_server3);
				json.put("ntp_interval", ntpIntervalValue);
			
				System.out.println("ntp-->"+json);
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
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			}else{
				try {
					JSONObject userObj = new JSONObject();
					userObj.put("msg", "Your session is timeout. Please login again");
					userObj.put("status", "fail");
					
					
					
					System.out.println(">>" +userObj);
					
					// Set the response content type to JSON
					response.setContentType("application/json");

					// Write the JSON data to the response
					response.getWriter().print(userObj.toString());
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

	}


