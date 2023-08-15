package com.tas.wp500;

public class Firewall {

	private String lineNumber;
	private String target;
	private String protocol;
	private String opt;
	private String source_port;
	private String destination_address;
	private String name;
	private String mac_address;
	private String ip_address;
	
	public Firewall(String lineNumber, String target, String protocol, String opt, String source_port,
			String destination_address, String name, String mac_address, String ip_address) {
		super();
		this.lineNumber = lineNumber;
		this.target = target;
		this.protocol = protocol;
		this.opt = opt;
		this.source_port = source_port;
		this.destination_address = destination_address;
		this.name = name;
		this.mac_address = mac_address;
		this.ip_address = ip_address;
	}

	public Firewall() {
		super();
	}

	public String getLineNumber() {
		return lineNumber;
	}

	public void setLineNumber(String lineNumber) {
		this.lineNumber = lineNumber;
	}

	public String getTarget() {
		return target;
	}

	public void setTarget(String target) {
		this.target = target;
	}

	public String getProtocol() {
		return protocol;
	}

	public void setProtocol(String protocol) {
		this.protocol = protocol;
	}

	public String getOpt() {
		return opt;
	}

	public void setOpt(String opt) {
		this.opt = opt;
	}

	public String getSource_port() {
		return source_port;
	}

	public void setSource_port(String source_port) {
		this.source_port = source_port;
	}

	public String getDestination_address() {
		return destination_address;
	}

	public void setDestination_address(String destination_address) {
		this.destination_address = destination_address;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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
