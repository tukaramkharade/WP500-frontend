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
	import org.json.JSONObject;

	import com.tas.utils.TCPClient;

	/**
	 * Servlet implementation class Logs
	 */
	@WebServlet("/search_logs")
	public class LogDataSearch extends HttpServlet {
		private static final long serialVersionUID = 1L;
		final static Logger logger = Logger.getLogger(LogDataSearch.class);

	       
	    /**
	     * @see HttpServlet#HttpServlet()
	     */
	    public LogDataSearch() {
	        super();
	        // TODO Auto-generated constructor stub
	    }

		/**
		 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
		 */
		protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			// TODO Auto-generated method stub
			//response.getWriter().append("Served at: ").append(request.getContextPath());
			
			HttpSession session = request.getSession(false);

			if (session != null) {
				String check_username = (String) session.getAttribute("username");
			
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			try{
				json.put("operation", "get_log_file_list");
				json.put("user", check_username);
				
				String respStr = client.sendMessage(json.toString());
				
				System.out.println("res " + new JSONObject(respStr));
				logger.info("res " + new JSONObject(respStr));
				
				JSONObject result = new JSONObject(respStr);
				
				JSONArray log_file_result= result.getJSONArray("result");
				
				JSONObject jsonObject = new JSONObject();
			    jsonObject.put("log_file_result", log_file_result);
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
				System.out.println("Login first");
				response.sendRedirect("login.jsp");
			}
		}

		/**
		 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
		 */
		protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			// TODO Auto-generated method stub
		//	doGet(request, response);
			
			HttpSession session = request.getSession(false);

			if (session != null) {
				String check_username = (String) session.getAttribute("username");
				
			String fileName = request.getParameter("log_file");
			
			String search_query = request.getParameter("search_query");
			String log_type = "application";
			
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			try{
				json.put("operation", "get_log_file_data");
				//json.put("user", "admin");
				
				json.put("log_type", log_type);
				json.put("file_name", fileName);
				json.put("search", search_query);
				
				String respStr = client.sendMessage(json.toString());
				
				System.out.println("res " + new JSONObject(respStr));
				logger.info("res " + new JSONObject(respStr));
				
				JSONObject result = new JSONObject(respStr);
				
				JSONArray log_search_result= result.getJSONArray("result");
				
				JSONObject jsonObject = new JSONObject();
			    jsonObject.put("log_search_result", log_search_result);
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
				System.out.println("Login first");
				response.sendRedirect("login.jsp");
			}
		}

	}

