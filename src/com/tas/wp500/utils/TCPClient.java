//package com.tas.wp500.utils;
//
//import java.io.BufferedReader;
//import java.io.BufferedWriter;
//import java.io.EOFException;
//import java.io.IOException;
//import java.io.InputStreamReader;
//import java.io.OutputStreamWriter;
//import java.net.Socket;
//import java.net.UnknownHostException;
//
//import org.apache.log4j.Logger;
//public class TCPClient {
//	
//	final static Logger logger = Logger.getLogger(TCPClient.class);
//	
//	public String sendMessage(String data) {
//		Socket s = null;
//		BufferedReader input = null;
//		BufferedWriter output = null;
//		try {
//	
//			logger.info("Connecting.......");
//			System.out.println("Connecting..");
//			s = new Socket("192.168.1.72", 6801);
//
//			if (s.isConnected()) {
//
//				input = new BufferedReader(new InputStreamReader(s.getInputStream()));
//				output = new BufferedWriter(new OutputStreamWriter(s.getOutputStream()));
//				logger.info("Writing......." + data);
//				System.out.println("Writing......." + data);
//				output.write(data.toString() + "\n");
//				output.flush();
//
//				while (true) {
//					String response = input.readLine();
//					
//					if (response != null) {
//						return new String(response);
//					} 
//		
//				}
//			}
//
//		} catch (UnknownHostException e) {
//			System.out.println("Sock:" + e.getMessage());
//			logger.error("Sock:" + e.getMessage());
//		} catch (EOFException e) {
//			System.out.println("EOF:" + e.getMessage());
//			logger.error("EOF:" + e.getMessage());
//		} catch (IOException e) {
//			System.out.println("IO:" + e.getMessage());
//			logger.error("IO:" + e.getMessage());
//			
//		} finally {
//			try {
//				if (input != null) {
//					input.close();
//				}
//				if (s != null) {
//					s.close();
//				}
//				if (output != null) {
//					output.close();
//				}
//			} catch (IOException e) {
//				System.out.println(e);
//				logger.error("IO:" + e.getMessage());
//			}
//		}
//		return "";
//	}
//
//}


//-----------------------------------------------------------------------------------------------------------------------

package com.tas.wp500.utils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.EOFException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.Socket;
import java.net.UnknownHostException;
import java.io.*;
import java.net.Socket;
import java.security.KeyStore;
import javax.net.ssl.*;
import org.apache.log4j.Logger;
public class TCPClient {
    final static Logger logger = Logger.getLogger(TCPClient.class);

    public String sendMessage(String data) {
        SSLSocket sslSocket = null;
        BufferedReader input = null;
        BufferedWriter output = null;

        try {
            // Load the keystore
     String keystorePath = "/opt/apache-tomcat-8.5.5/conf/keystore.jks";
        	
  //  	String keystorePath = "D:\\keystore.jks";
        	
            char[] keystorePassword = "Wp500@https2023".toCharArray();
            KeyStore keystore = KeyStore.getInstance("JKS");
            keystore.load(new FileInputStream(keystorePath), keystorePassword);

            // Create SSL context with the keystore
            TrustManagerFactory trustManagerFactory = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
            trustManagerFactory.init(keystore);
            SSLContext sslContext = SSLContext.getInstance("TLS");
            sslContext.init(null, trustManagerFactory.getTrustManagers(), null);

            // Create SSL socket
            SSLSocketFactory sslSocketFactory = sslContext.getSocketFactory();
      sslSocket = (SSLSocket) sslSocketFactory.createSocket("127.0.0.1", 6801);
  //  sslSocket = (SSLSocket) sslSocketFactory.createSocket("192.168.1.72", 6801);
           
            input = new BufferedReader(new InputStreamReader(sslSocket.getInputStream()));
            output = new BufferedWriter(new OutputStreamWriter(sslSocket.getOutputStream()));

            logger.info("Writing......." + data);
            System.out.println("Writing......." + data);
            output.write(data + "\n");
            output.flush();

            // Read response
            String response = input.readLine();
            if (response != null) {
                return response;
            }
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
            logger.error("Error: " + e.getMessage());
        } finally {
            try {
                if (input != null) {
                    input.close();
                }
                if (sslSocket != null) {
                    sslSocket.close();
                }
                if (output != null) {
                    output.close();
                }
            } catch (IOException e) {
                System.out.println("IO Error: " + e.getMessage());
                logger.error("IO Error: " + e.getMessage());
            }
        }
        return "";
    }}
