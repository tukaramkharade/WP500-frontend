package com.tas.wp500;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import com.tas.utils.TCPClient;

/**
 * Servlet implementation class DateTimeServlet
 */
@WebServlet("/dateTimeServlet")
public class DateTimeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DateTimeServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	//	doGet(request, response);
		
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		if (check_username != null) {
			

		String date_time = request.getParameter("datetime");
		
		SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        
		
		try{
			
			 Date date = inputFormat.parse(date_time);
	            String formattedDateTime = outputFormat.format(date);
	            
	            System.out.println("formatted date time : "+formattedDateTime);
			
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			json.put("operation", "set_manul_time");
			json.put("time", formattedDateTime);
			json.put("user", check_username);
			
			String respStr = client.sendMessage(json.toString());

			System.out.println("res " + new JSONObject(respStr));
			
			
		}catch(Exception e){
			e.printStackTrace();
		}
		}
	}

}
