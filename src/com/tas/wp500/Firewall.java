package com.tas.wp500;

public class Firewall {

	private String lineNumber;
	private String target;
	private String protocol;
	private String opt;
	private String source;
	private String destination;
	
	
	public Firewall() {
		super();
	}


	public Firewall(String lineNumber, String target, String protocol, String opt, String source, String destination) {
		super();
		this.lineNumber = lineNumber;
		this.target = target;
		this.protocol = protocol;
		this.opt = opt;
		this.source = source;
		this.destination = destination;
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


	public String getSource() {
		return source;
	}


	public void setSource(String source) {
		this.source = source;
	}


	public String getDestination() {
		return destination;
	}


	public void setDestination(String destination) {
		this.destination = destination;
	}
	
	
}
