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
import org.json.JSONArray;
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

@WebServlet("/firmwareStatusServlet")
public class FirmwareStatusServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(FirmwareStatusServlet.class);
	
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		
		if (check_username != null) {			
			try{
				
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "get_firmware_status");
				json.put("token", check_token);
				json.put("user", check_username);
				json.put("role", check_role);
				
				String respStr = client.sendMessage(json.toString());

				logger.info("res " + new JSONObject(respStr));
				
				JSONObject respJson = new JSONObject(respStr);
				String status = respJson.getString("status");
				String message = respJson.getString("msg");

				JSONObject finalJsonObj = new JSONObject();
				if(status.equals("success")){
					JSONArray firmware_status_data = respJson.getJSONArray("firmware_status");
					finalJsonObj.put("status", status);
				    finalJsonObj.put("firmware_status_data", firmware_status_data);
				}else if(status.equals("fail")){
					finalJsonObj.put("status", status);
				    finalJsonObj.put("message", message);
				}

			    // Set the response content type to JSON
			    response.setContentType("application/json");
			    response.setHeader("X-Content-Type-Options", "nosniff");

			    // Write the JSON data to the response
			    response.getWriter().print(finalJsonObj.toString());
//				
			}catch(Exception e){
				e.printStackTrace();
				logger.error("Error in applying traffic rules : "+e);
			}	
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

}
