package com.tas.wp500;

public class TrafficRules {

	private String name;
	private String protocol;	
	private String destination_port;
	private String iface;
	private String mac_address;
	private String ip_address;
	private String action;
	private String type;
	
	

	public TrafficRules() {
		super();
	}

	public TrafficRules(String name, String protocol, String destination_port, String iface, String mac_address,
			String ip_address, String action, String type) {
		super();
		this.name = name;
		this.protocol = protocol;
		this.destination_port = destination_port;
		this.iface = iface;
		this.mac_address = mac_address;
		this.ip_address = ip_address;
		this.action = action;
		this.type = type;
	}

	public String getAction() {
		return action;
	}

	public void setAction(String action) {
		this.action = action;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getProtocol() {
		return protocol;
	}

	public void setProtocol(String protocol) {
		this.protocol = protocol;
	}

	public String getDestination_port() {
		return destination_port;
	}

	public void setDestination_port(String destination_port) {
		this.destination_port = destination_port;
	}

	public String getIface() {
		return iface;
	}

	public void setIface(String iface) {
		this.iface = iface;
	}

	public String getMac_address() {
		return mac_address;
	}

	public void setMac_address(String mac_address) {
		this.mac_address = mac_address;
	}

	public String getIp_address() {
		return ip_address;
	}

	public void setIp_address(String ip_address) {
		this.ip_address = ip_address;
	}
	
	
	}
