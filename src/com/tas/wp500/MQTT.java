package com.tas.wp500;

public class MQTT {

	private String publish_topic;
	private String password;
	private String broker_ip_address;
	private String prefix;
	private String file_type;
	private String enable;
	private String port_number;
	private String subscribe_topic;
	private String username;
	
	public MQTT() {
		super();
	}

	public MQTT(String publish_topic, String password, String broker_ip_address, String prefix, String file_type,
			String enable, String port_number, String subscribe_topic, String username) {
		super();
		this.publish_topic = publish_topic;
		this.password = password;
		this.broker_ip_address = broker_ip_address;
		this.prefix = prefix;
		this.file_type = file_type;
		this.enable = enable;
		this.port_number = port_number;
		this.subscribe_topic = subscribe_topic;
		this.username = username;
	}

	public String getPublish_topic() {
		return publish_topic;
	}

	public void setPublish_topic(String publish_topic) {
		this.publish_topic = publish_topic;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getBroker_ip_address() {
		return broker_ip_address;
	}

	public void setBroker_ip_address(String broker_ip_address) {
		this.broker_ip_address = broker_ip_address;
	}

	public String getPrefix() {
		return prefix;
	}

	public void setPrefix(String prefix) {
		this.prefix = prefix;
	}

	public String getFile_type() {
		return file_type;
	}

	public void setFile_type(String file_type) {
		this.file_type = file_type;
	}

	public String getEnable() {
		return enable;
	}

	public void setEnable(String enable) {
		this.enable = enable;
	}

	public String getPort_number() {
		return port_number;
	}

	public void setPort_number(String port_number) {
		this.port_number = port_number;
	}

	public String getSubscribe_topic() {
		return subscribe_topic;
	}

	public void setSubscribe_topic(String subscribe_topic) {
		this.subscribe_topic = subscribe_topic;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}
	
	
}
