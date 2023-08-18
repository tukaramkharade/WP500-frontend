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
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.tas.utils.TCPClient;

/**
 * Servlet implementation class GeneralSettingsServlet
 */
@WebServlet("/generalSettingsServlet")
public class GeneralSettingsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(GeneralSettingsServlet.class);

       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GeneralSettingsServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		
		
			// TODO Auto-generated method stub
			// response.getWriter().append("Served at:
			// ").append(request.getContextPath());

			HttpSession session = request.getSession(false);

		
				String check_username = (String) session.getAttribute("username");
				
				if (check_username != null) {
					
					TCPClient client = new TCPClient();
					JSONObject json = new JSONObject();
					
					JSONObject jsonObject = new JSONObject();
					

					try {
						json.put("operation", "firewall_settings");
						json.put("user", check_username);

						String respStr = client.sendMessage(json.toString());

						
						JSONObject respJson = new JSONObject(respStr);
						// JSONObject respJson = new JSONObject(var);

						System.out.println("res " + respJson.toString());

						

						
						JSONObject genral_settings = respJson.getJSONObject("genral_settings");
						
						for (int i = 0; i < genral_settings.length(); i++) {
							
							String output = genral_settings.getString("output");
							logger.info("output : " + output);
							
							String forword = genral_settings.getString("forword");
							logger.info("forword : " + forword);
							
							String input = genral_settings.getString("input");
							logger.info("input : " + input);
							
							String rule_drop = genral_settings.getString("rule_drop");
							logger.info("rule_drop : " + rule_drop);
							
							
							try{
								 jsonObject.put("output", output);
								    jsonObject.put("forword", forword);
								    jsonObject.put("input", input);
								    jsonObject.put("rule_drop", rule_drop);
							}catch(Exception e){
								e.printStackTrace();
							}
						   
							
						}
						// Get the response PrintWriter
						PrintWriter out = response.getWriter();

						// Write the JSON object to the response
						out.print(jsonObject.toString());
						out.flush();

						}catch(Exception e){
							e.printStackTrace();
						}
					
				}else{
					
				
			}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//doGet(request, response);
		
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		
		if (check_username != null) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			String input = request.getParameter("input");
			String output = request.getParameter("output");
			String forward = request.getParameter("forward");
			String rule_drop = request.getParameter("rule_drop");
			
			try{
				json.put("operation", "genral_setting");
				json.put("operation_type", "add");
				json.put("input", input);
				json.put("output", output);
				json.put("forword", forward);
				json.put("rule_drop", rule_drop);
				json.put("user", check_username);
				
				String respStr = client.sendMessage(json.toString());

				System.out.println("res " + new JSONObject(respStr).getString("msg"));
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
				
			}catch(Exception e){
				e.printStackTrace();
			}
			
			
		}else{
			
		}
		
	}

}
