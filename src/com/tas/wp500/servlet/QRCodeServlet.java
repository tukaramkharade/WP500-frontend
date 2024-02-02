package com.tas.wp500.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Base64;

@WebServlet("/qrcodeServlet")
public class QRCodeServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(QRCodeServlet.class);
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("username") != null) {
            String check_username = (String) session.getAttribute("username");
            String check_token = (String) session.getAttribute("token");
            String check_role = (String) session.getAttribute("role");
            
            String csrfTokenFromRequest = request.getParameter("csrfToken");

    		// Retrieve CSRF token from the session
    		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
            
            String action = request.getParameter("action");
            
            if (action != null) {
            	switch (action) {
            	case "generate":
            		try {
            			if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
                        TCPClient client = new TCPClient();
                        JSONObject json = new JSONObject();

                        json.put("operation", "generate_qr_code");
                        json.put("user", check_username);
                        json.put("username", check_username);
                        json.put("token", check_token);
                        json.put("role", check_role);

                        String respStr = client.sendMessage(json.toString());

                        System.out.println("res " + new JSONObject(respStr));

                        JSONObject result = new JSONObject(respStr);

                        String qr_image = result.getString("qr_image");
                       
                        
                        String user_secret_key = result.getString("user_secret_key");
                        

                        if (!qr_image.isEmpty()) {
                            // Create a JSON object to hold the image and secret_key
                            JSONObject responseJson = new JSONObject();
                            responseJson.put("qr_image", qr_image);
                            responseJson.put("user_secret_key", user_secret_key);

                            // Set the response content type to JSON
                            response.setContentType("application/json");
                            response.setHeader("X-Content-Type-Options", "nosniff");

                            // Write the JSON data to the response
                            PrintWriter out = response.getWriter();
                            out.print(responseJson.toString());
                            out.flush();
                        } else {
                            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        }
            			}else {
        					logger.error("CSRF token validation failed");	
        				}
                    } catch (Exception e) {
                        e.printStackTrace();
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        logger.error("Error getting qr code and secret key: "+e);
                    }
            		break;
            		
            	case "get":
            		try {
            			
            			if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
                        TCPClient client = new TCPClient();
                        JSONObject json = new JSONObject();

                        json.put("operation", "get_user_qr");
                        json.put("user", check_username);
                        json.put("username", check_username);
                        json.put("token", check_token);
                        json.put("role", check_role);

                        String respStr = client.sendMessage(json.toString());

                        System.out.println("res " + new JSONObject(respStr));

                        JSONObject result = new JSONObject(respStr);
                        String qr_image="";
                        String user_secret_key="";
                        String qr_status="";
                        if(result.has("qr_image")){
                        qr_image = result.getString("qr_image");
                        System.out.println("qr_image :"+qr_image.toString());
                        
                        user_secret_key = result.getString("user_secret_key");
                        System.out.println("secret_key :"+user_secret_key.toString());
                        
                        qr_status = result.getString("qr_status");
                        System.out.println("qr_status :"+qr_status.toString());
                        }
                        if (!qr_image.isEmpty()) {
                            // Create a JSON object to hold the image and secret_key
                            JSONObject responseJson = new JSONObject();
                            responseJson.put("qr_image", qr_image);
                            responseJson.put("user_secret_key", user_secret_key);
                            responseJson.put("qr_status", qr_status);

                            // Set the response content type to JSON
                            response.setContentType("application/json");
                            response.setHeader("X-Content-Type-Options", "nosniff");
                            
                            // Write the JSON data to the response
                            PrintWriter out = response.getWriter();
                            out.print(responseJson.toString());
                            out.flush();
                        } else {
                            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        }
            			}else {
        					logger.error("CSRF token validation failed");	
        				}
                    } catch (Exception e) {
                        e.printStackTrace();
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        logger.error("Error getting qr code and secret key: "+e);
                    }
            		break;
            	}
            	
            }else{
            	logger.error("No action specified : ");
            }

            
        } 
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	
		
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		
		String action = request.getParameter("action");
		
		if (check_username != null) {
			
			String otp = request.getParameter("otp");
			
			
			if (action != null) {
				switch (action) {
				
				case "totp-authentication":
					try {
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "totp_authenticator");
						json.put("otp", otp);
						json.put("user", check_username);
						json.put("username", check_username);
						json.put("role", check_role);
						json.put("hardCorePassword", "S3cureP@ss!2024");

						String respStr = client.sendMessage(json.toString());

			            System.out.println("res " + new JSONObject(respStr));

			            JSONObject result = new JSONObject(respStr);

			           // String otp_result = result.getString("otp_result");
			            String token = result.getString("token");
			            String status = result.getString("status");
			            
						
			            session.setAttribute("token", token);
			            
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("status", status);
						
					//	jsonObject.put("otp_result", otp_result);

						// Set the content type of the response to application/json
						response.setContentType("application/json");
						 response.setHeader("X-Content-Type-Options", "nosniff");

						// Get the response PrintWriter
						PrintWriter out1 = response.getWriter();

						// Write the JSON object to the response
						out1.print(jsonObject.toString());
						out1.flush();

					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
						logger.error("Error geting totp authentication : "+e);
					}
					break;
					
					
				case "totp-authentication-email":
					String email_otp = request.getParameter("email_otp");
					
					try {
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "validate_otp_email");
						json.put("username", check_username);
						json.put("email_otp", email_otp);
			//			json.put("token", check_token);
						json.put("user", check_username);
						json.put("role", check_role);
						json.put("hardCorePassword", "S3cureP@ss!2024");

						String respStr = client.sendMessage(json.toString());

			            System.out.println("res " + new JSONObject(respStr));

			            JSONObject result = new JSONObject(respStr);

			            String status = result.getString("status");
			            
			            String token = result.getString("token");
			            
						
			            session.setAttribute("token", token);
						
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("status", status);

						// Set the content type of the response to application/json
						response.setContentType("application/json");
						 response.setHeader("X-Content-Type-Options", "nosniff");

						// Get the response PrintWriter
						PrintWriter out1 = response.getWriter();

						// Write the JSON object to the response
						out1.print(jsonObject.toString());
						out1.flush();

					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
						logger.error("Error geting totp authentication : "+e);
					}
					break;

				case "test-totp":
					try {
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "test_totp_authenticator");
						
						json.put("otp", otp);
						json.put("token", check_token);
						json.put("user", check_username);
						json.put("role", check_role);


						String respStr = client.sendMessage(json.toString());

			            System.out.println("res " + new JSONObject(respStr));

			            JSONObject result = new JSONObject(respStr);

			     //       String otp_result = result.getString("otp_result");
			            String status = result.getString("status");
						
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("status", status);

						// Set the content type of the response to application/json
						response.setContentType("application/json");
						 response.setHeader("X-Content-Type-Options", "nosniff");

						// Get the response PrintWriter
						PrintWriter out1 = response.getWriter();

						// Write the JSON object to the response
						out1.print(jsonObject.toString());
						out1.flush();

					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
						logger.error("Error geting totp authentication : "+e);
					}
					break;
				}
			}

		
		}
	}
    
}
