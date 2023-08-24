package com.tas.utils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.EOFException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.Socket;
import java.net.UnknownHostException;

import org.apache.log4j.Logger;
public class TCPClient {
	
	final static Logger logger = Logger.getLogger(TCPClient.class);
	
	public String sendMessage(String data) {
		Socket s = null;
		BufferedReader input = null;
		BufferedWriter output = null;
		try {

			//127.0.0.1
			logger.info("Connecting.......");
			System.out.println("Connecting..");
		//	s = new Socket("192.168.1.125", 6801);
			s = new Socket("127.0.0.1", 6801);
			
			// new
																			// Socket("192.168.1.149",
																			// 6881);
			// Step 1 read length
			// s.setSoTimeout(1000);
			if (s.isConnected()) {

				// JSONObject obj = new JSONObject();
				input = new BufferedReader(new InputStreamReader(s.getInputStream()));
				output = new BufferedWriter(new OutputStreamWriter(s.getOutputStream()));
				logger.info("Writing......." + data);
				System.out.println("Writing......." + data);
				output.write(data.toString() + "\n");
				output.flush();

				while (true) {
					String response = input.readLine();
					// System.out.println("Read data " + response);
					if (response != null) {
						return new String(response);
					} 
			//		logger.error("response is null:");
//					else {
//						return new String("Ok");
//					}

				}
			}

		} catch (UnknownHostException e) {
			System.out.println("Sock:" + e.getMessage());
			logger.error("Sock:" + e.getMessage());
		} catch (EOFException e) {
			System.out.println("EOF:" + e.getMessage());
			logger.error("EOF:" + e.getMessage());
		} catch (IOException e) {
			System.out.println("IO:" + e.getMessage());
			logger.error("IO:" + e.getMessage());
			// e.printStackTrace();
		} finally {
			try {
				if (input != null) {
					input.close();
				}
				if (s != null) {
					s.close();
				}
				if (output != null) {
					output.close();
				}
			} catch (IOException e) {
				System.out.println(e);
				logger.error("IO:" + e.getMessage());
			}
		}
		return "";
	}

}
