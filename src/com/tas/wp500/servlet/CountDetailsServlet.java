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

@WebServlet("/countDetailsServlet")
public class CountDetailsServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(CountDetailsServlet.class);
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {	
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");		
		if (check_username != null) {			
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			JSONObject jsonObject = new JSONObject();			
			try{
				json.put("operation", "get_count_details");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);				
				String respStr = client.sendMessage(json.toString());
				JSONObject respJson = new JSONObject(respStr);
				logger.info("res " + respJson.toString());				
				for (int i = 0; i < respJson.length(); i++) {					
					int total_count = respJson.getInt("total_count");
					int threats_log_count = respJson.getInt("threats_log_count");
					int active_threats_count = respJson.getInt("active_threats_count");
					String last_update = respJson.getString("last_update");
					String status_service = respJson.getString("status_service");
					String status = respJson.getString("status");				
					try{
						jsonObject.put("total_count", total_count);
						jsonObject.put("threats_log_count", threats_log_count);
						jsonObject.put("active_threats_count", active_threats_count);
						jsonObject.put("last_update", last_update);
						jsonObject.put("status_service", status_service);
						jsonObject.put("status", status);											
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error in putting count details in json object: "+e );
					}								
				}			
				response.setHeader("X-Content-Type-Options", "nosniff");
				PrintWriter out = response.getWriter();
				out.print(jsonObject.toString());
				out.flush();				
			}catch(Exception e){
				e.printStackTrace();
				logger.error("Error while getting count : "+e);
			}			
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}
}