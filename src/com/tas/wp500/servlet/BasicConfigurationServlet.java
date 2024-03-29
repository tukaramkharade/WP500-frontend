package com.tas.wp500.servlet;

import java.io.BufferedReader;
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

@WebServlet("/BasicConfigurationServlet")
public class BasicConfigurationServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(BasicConfigurationServlet.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {		
		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();		
		try{		
			HttpSession session = request.getSession(false);
			String check_username = (String) session.getAttribute("username");
			String check_token = (String) session.getAttribute("token");
			String check_role = (String) session.getAttribute("role");			
			if (check_username != null) {				
				json.put("operation", "get_iptable_basic_settings");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);
				
				String respStr = client.sendMessage(json.toString());
				JSONObject respJson = new JSONObject(respStr);
				String status = respJson.getString("status");
				String message = respJson.getString("msg");
				logger.info(respJson.toString());
				JSONObject finalJsonObj = new JSONObject();
				if(status.equals("success")){
					JSONArray jsonArray = respJson.getJSONArray("data");
					finalJsonObj.put("status", status);
				    finalJsonObj.put("result_basic", jsonArray);
				    finalJsonObj.put("message", message);
				}else if(status.equals("fail")){
					finalJsonObj.put("status", status);
				    finalJsonObj.put("message", message);
				}
			    response.setContentType("application/json");
			    response.setHeader("X-Content-Type-Options", "nosniff");
			    response.getWriter().print(finalJsonObj.toString());			
			}			
		}catch(Exception e){
			e.printStackTrace();
			logger.error("Error in getting basic configuration list : " + e);
		}		
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    HttpSession session = request.getSession(false);
	    String check_username = (String) session.getAttribute("username");
	    String check_token = (String) session.getAttribute("token");
	    String check_role = (String) session.getAttribute("role");
	    if (check_username != null) {
	        try {
	            TCPClient client = new TCPClient();
	            JSONObject json = new JSONObject();
	            JSONArray responseDataArray = new JSONArray();
	            json.put("operation", "update_iptable_basic_settings");
	            json.put("user", check_username);
	            json.put("token", check_token);
	            json.put("role", check_role);
	            StringBuilder jsonPayload = new StringBuilder();
	            try (BufferedReader reader = request.getReader()) {
	                String line;
	                while ((line = reader.readLine()) != null) {
	                    jsonPayload.append(line);
	                }
	            }
	            JSONObject requestData = new JSONObject(jsonPayload.toString());
	            if (requestData.has("data")) {
	                JSONArray dataArray = requestData.getJSONArray("data");
	                for (int i = 0; i < dataArray.length(); i++) {
	                    JSONObject dataObj = dataArray.getJSONObject(i);
	                    responseDataArray.put(dataObj);
	                }
	            }
	            json.put("data", responseDataArray);
	            String respStr = client.sendMessage(json.toString());
	            String message = new JSONObject(respStr).getString("msg");
	            String status = new JSONObject(respStr).getString("status");            
	            JSONObject jsonObject1 = new JSONObject();
	            jsonObject1.put("message", message);
	            jsonObject1.put("status", status);
	            response.setContentType("application/json");
	            response.setHeader("X-Content-Type-Options", "nosniff");
	            PrintWriter out = response.getWriter();
	            out.print(jsonObject1.toString());
	            out.flush();
	        } catch (Exception e) {
	            e.printStackTrace();
	            logger.error("Error updating basic rules: "+e);
	        }
	    } 
	}
}