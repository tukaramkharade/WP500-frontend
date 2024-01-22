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


@WebServlet("/CPUMetricsServlet")
public class CPUMetrics extends HttpServlet {
	final static Logger logger = Logger.getLogger(CPUMetrics.class);
	
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
				
				json.put("operation", "get_systeam_info");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);

				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);
				
				logger.info("resp: "+respJson.toString());
				
				String status = respJson.getString("status");
				String message = respJson.getString("msg");
				
				
				
				if(status.equals("success")){
					JSONObject ram_info = respJson.getJSONObject("ram_information");
					
					
					String UsedMemory = ram_info.getString("UsedMemory");
					String TotalMemory = ram_info.getString("TotalMemory");
					String SharedMemory = ram_info.getString("SharedMemory");
					String AvailableMemory = ram_info.getString("AvailableMemory");
					String BufferCache = ram_info.getString("BufferCache");
					String FreeMemory = ram_info.getString("FreeMemory");
					
					
					JSONObject cpu_info = respJson.getJSONObject("cpu_information");
					
					
					String Architecture = cpu_info.getString("Architecture");
					String Version = cpu_info.getString("Version");
					int AvailableProcessors = cpu_info.getInt("AvailableProcessors");
					int SystemLoadAverage = cpu_info.getInt("SystemLoadAverage");
					String Name = cpu_info.getString("Name");
					
					JSONObject memory_info = respJson.getJSONObject("memory_information");
									
					String TotalSwapSpaceSize = memory_info.getString("TotalSwapSpaceSize");
					String AvailableSwapSpaceSize = memory_info.getString("AvailableSwapSpaceSize");
					String CommittedVirtualMemorySize = memory_info.getString("CommittedVirtualMemorySize");
					String AvailablePhysicalMemory = memory_info.getString("AvailablePhysicalMemory");
					String TotalPhysicalMemory = memory_info.getString("TotalPhysicalMemory");
					
					JSONObject task_user_info = respJson.getJSONObject("task_user_information");
									
					int numberOfUsers = task_user_info.getInt("numberOfUsers");
					JSONArray taskDetails = task_user_info.getJSONArray("taskDetails");
					
					JSONObject cpu_running_task_info = respJson.getJSONObject("cpu_running_task_information");
					
					JSONArray cpu_running_task_jsArray = new JSONArray(cpu_running_task_info.getJSONArray("cpuRunningOperations").toString());
					System.out.println("cpu running task: "+cpu_running_task_jsArray.toString());
					
					JSONObject disk_info = respJson.getJSONObject("disk_information");
										
					JSONArray disk_info_jsArray = new JSONArray(disk_info.getJSONArray("diskInfo").toString());
					
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
					jsonObject.put("TotalSwapSpaceSize", TotalSwapSpaceSize);
					jsonObject.put("AvailableSwapSpaceSize", AvailableSwapSpaceSize);
					jsonObject.put("CommittedVirtualMemorySize", CommittedVirtualMemorySize);
					jsonObject.put("AvailablePhysicalMemory", AvailablePhysicalMemory);
					jsonObject.put("TotalPhysicalMemory", TotalPhysicalMemory);
					jsonObject.put("numberOfUsers", numberOfUsers);
					jsonObject.put("taskDetails", taskDetails);
					jsonObject.put("cpu_running_task_jsArray", cpu_running_task_jsArray);
					jsonObject.put("disk_info_jsArray", disk_info_jsArray);
				}else if(status.equals("fail")){
					jsonObject.put("status", status);
					jsonObject.put("message", message);
				}
				
				
				
				// Set the content type of the response to application/json
			    response.setContentType("application/json");
			    response.setHeader("X-Content-Type-Options", "nosniff");
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
