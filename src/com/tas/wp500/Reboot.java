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
 * Servlet implementation class Reboot
 */
@WebServlet("/reboot")
public class Reboot extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(Reboot.class);

       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Reboot() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	//	response.getWriter().append("Served at: ").append(request.getContextPath());
		
try{
			
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			json.put("operation", "reboot");
			
			String respStr = client.sendMessage(json.toString());
			System.out.println("response : "+respStr);
			
			System.out.println("res " + new JSONObject(respStr).getString("Status"));
			logger.info("res " + new JSONObject(respStr).getString("Status"));
			
			String status = new JSONObject(respStr).getString("Status");
			JSONObject jsonObject = new JSONObject();
		    jsonObject.put("status", status);
		    
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
	//	doGet(request, response);
	}

}
