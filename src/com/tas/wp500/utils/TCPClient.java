package com.tas.wp500.utils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.*;
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
  String keystorePath = "/opt/apache-tomcat-9.0.85/conf/keystore.jks";
        	
  // String keystorePath = "D:\\keystore_73.jks";
        	
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
//  sslSocket = (SSLSocket) sslSocketFactory.createSocket("192.168.1.73", 6801);
           
            input = new BufferedReader(new InputStreamReader(sslSocket.getInputStream()));
            output = new BufferedWriter(new OutputStreamWriter(sslSocket.getOutputStream()));
            logger.info("Writing......." + data);
            output.write(data + "\n");
            output.flush();
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