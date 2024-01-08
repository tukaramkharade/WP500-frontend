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


@WebServlet("/CPUMetricsServlet")
public class CPUMetrics extends HttpServlet {
	final static Logger logger = Logger.getLogger(CPUMetrics.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		
		if (check_username != null) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			JSONObject jsonObject = new JSONObject();
			
			try{
				
				json.put("operation", "get_systeam_info");
				json.put("user", check_username);
				json.put("token", check_token);

				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);
				
				JSONObject ram_info = respJson.getJSONObject("ram_information");
				
				
				String UsedMemory = ram_info.getString("UsedMemory");
				String TotalMemory = ram_info.getString("TotalMemory");
				String SharedMemory = ram_info.getString("SharedMemory");
				String AvailableMemory = ram_info.getString("AvailableMemory");
				String BufferCache = ram_info.getString("BufferCache");
				String FreeMemory = ram_info.getString("FreeMemory");
				String status = ram_info.getString("status");
				
				JSONObject cpu_info = respJson.getJSONObject("cpu_information");
				
				
				String Architecture = cpu_info.getString("Architecture");
				String Version = cpu_info.getString("Version");
				int AvailableProcessors = cpu_info.getInt("AvailableProcessors");
				int SystemLoadAverage = cpu_info.getInt("SystemLoadAverage");
				String Name = cpu_info.getString("Name");
				
				JSONObject memory_info = respJson.getJSONObject("memory_information");
				System.out.println("memory info :"+memory_info.toString());
				
				
				
				
				jsonObject.put("UsedMemory", UsedMemory);
				jsonObject.put("TotalMemory", TotalMemory);
				jsonObject.put("SharedMemory", SharedMemory);
				jsonObject.put("AvailableMemory", AvailableMemory);
				jsonObject.put("BufferCache", BufferCache);
				jsonObject.put("FreeMemory", FreeMemory);
				jsonObject.put("status", status);
				jsonObject.put("Architecture", Architecture);
				jsonObject.put("Version", Version);
				jsonObject.put("AvailableProcessors", AvailableProcessors);
				jsonObject.put("SystemLoadAverage", SystemLoadAverage);
				jsonObject.put("Name", Name);
				
				
				// Set the content type of the response to application/json
			    response.setContentType("application/json");
			    
			    // Get the response PrintWriter
			    PrintWriter out = response.getWriter();
			    
			    // Write the JSON object to the response
			    out.print(jsonObject.toString());
			    out.flush();
				
				
			
				
			}catch(Exception e){
				
			}
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

}
