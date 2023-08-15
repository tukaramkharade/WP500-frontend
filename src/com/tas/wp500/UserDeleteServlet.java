package com.tas.wp500;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import com.tas.utils.TCPClient;

/**
 * Servlet implementation class UserDeleteServlet
 */
@WebServlet("/UserDeleteServlet")
public class UserDeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserDeleteServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		HttpSession session = request.getSession(false);

		
			String check_username = (String) session.getAttribute("username");
		
		String username = request.getParameter("username");

		System.out.println(username);

		try {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			
			json.put("operation", "delete_user");
			json.put("user", check_username);
		
			json.put("username", username);
			
			if(!username.equals("tasm2m_admin")){
				
				String respStr = client.sendMessage(json.toString());
				
				System.out.println("res " + new JSONObject(respStr).getString("msg"));
				
				String message = new JSONObject(respStr).getString("msg");
				JSONObject jsonObject = new JSONObject();
			    jsonObject.put("message", message);
			    
			    // Set the content type of the response to application/json
			    resp.setContentType("application/json");
			    
			    // Get the response PrintWriter
			    PrintWriter out = resp.getWriter();
			    
			    // Write the JSON object to the response
			    out.print(jsonObject.toString());
			    out.flush();
			}else{
				
				System.out.println("test user");
				 
				try {
					JSONObject userObj = new JSONObject();
					userObj.put("msg", "Cannot delete tasm2m_admin user !!");
					userObj.put("status", "fail");
					
					
					System.out.println(">>" +userObj);
					
					// Set the response content type to JSON
					resp.setContentType("application/json");

					// Write the JSON data to the response
					resp.getWriter().print(userObj.toString());
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
		    
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
//		doGet(request, response);
	}

}
