package com.tas.wp500.utils;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.apache.log4j.Logger;



public class configClass {

	private InputStream input;
	private Properties prop = null;
	final static Logger logger = Logger.getLogger(configClass.class);
	public configClass() {
		input = null;
		prop = new Properties();
	}
	
	public String readConfig(String para_name) {
		try {
//			System.out.println("Path "+System.getProperty("user.home") + "/Desktop");
//			String path=System.getProperty("user.home") + "/Desktop/" + "IPconfig.properties";
			 String path=System.getProperty("user.dir") + "/" + "IPconfig.properties";
			 input = new FileInputStream(path);
//			input = new FileInputStream(System.getProperty("user.home") + "/Desktop/IPconfig.properties");
			prop.load(input);
			return prop.getProperty(para_name);
		} catch (Exception e) {
			logger.error("Exception in readConfigFile()>>" + e.getMessage());
		} finally {
			try {
				input.close();
				prop.clear();
			} catch (IOException e) {
				logger.error(e.getMessage());
			}
		}
		return null;
	}
}
