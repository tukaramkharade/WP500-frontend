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
	private String input;
	private String output;
	private String forward;
	private String rule_drop;
	
	public TrafficRules() {
		super();
	}
	
	public TrafficRules(java.lang.String name, java.lang.String protocol, java.lang.String destination_port,
			java.lang.String iface, java.lang.String mac_address, java.lang.String ip_address, java.lang.String action,
			java.lang.String type, java.lang.String input, java.lang.String output, java.lang.String forward,
			java.lang.String rule_drop) {
		super();
		this.name = name;
		this.protocol = protocol;
		this.destination_port = destination_port;
		this.iface = iface;
		this.mac_address = mac_address;
		this.ip_address = ip_address;
		this.action = action;
		this.type = type;
		this.input = input;
		this.output = output;
		this.forward = forward;
		this.rule_drop = rule_drop;
	}

	

	public String getInput() {
		return input;
	}


	public void setInput(String input) {
		this.input = input;
	}


	public String getOutput() {
		return output;
	}


	public void setOutput(String output) {
		this.output = output;
	}


	public String getForward() {
		return forward;
	}


	public void setForward(String forward) {
		this.forward = forward;
	}


	public String getRule_drop() {
		return rule_drop;
	}


	public void setRule_drop(String rule_drop) {
		this.rule_drop = rule_drop;
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
