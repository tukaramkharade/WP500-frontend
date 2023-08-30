package com.tas.wp500.entity;

public class ActiveThreats {

	private String src_ip;
	private int src_port;
	private String protocol_type;
	private String ack_at;
	private String ack_by;
	private String alert_message;
	private String dest_ip;
	private String thread_id;
	private String priority;
	private String dest_port;
	private String timestamp;
	
	public ActiveThreats() {
		super();
	}

	public ActiveThreats(String src_ip, int src_port, String protocol_type, String ack_at, String ack_by,
			String alert_message, String dest_ip, String thread_id, String priority, String dest_port,
			String timestamp) {
		super();
		this.src_ip = src_ip;
		this.src_port = src_port;
		this.protocol_type = protocol_type;
		this.ack_at = ack_at;
		this.ack_by = ack_by;
		this.alert_message = alert_message;
		this.dest_ip = dest_ip;
		this.thread_id = thread_id;
		this.priority = priority;
		this.dest_port = dest_port;
		this.timestamp = timestamp;
	}

	public String getSrc_ip() {
		return src_ip;
	}

	public void setSrc_ip(String src_ip) {
		this.src_ip = src_ip;
	}

	public int getSrc_port() {
		return src_port;
	}

	public void setSrc_port(int src_port) {
		this.src_port = src_port;
	}

	public String getProtocol_type() {
		return protocol_type;
	}

	public void setProtocol_type(String protocol_type) {
		this.protocol_type = protocol_type;
	}

	public String getAck_at() {
		return ack_at;
	}

	public void setAck_at(String ack_at) {
		this.ack_at = ack_at;
	}

	public String getAck_by() {
		return ack_by;
	}

	public void setAck_by(String ack_by) {
		this.ack_by = ack_by;
	}

	public String getAlert_message() {
		return alert_message;
	}

	public void setAlert_message(String alert_message) {
		this.alert_message = alert_message;
	}

	public String getDest_ip() {
		return dest_ip;
	}

	public void setDest_ip(String dest_ip) {
		this.dest_ip = dest_ip;
	}

	public String getThread_id() {
		return thread_id;
	}

	public void setThread_id(String thread_id) {
		this.thread_id = thread_id;
	}

	public String getPriority() {
		return priority;
	}

	public void setPriority(String priority) {
		this.priority = priority;
	}

	public String getDest_port() {
		return dest_port;
	}

	public void setDest_port(String dest_port) {
		this.dest_port = dest_port;
	}

	public String getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}
	
}
