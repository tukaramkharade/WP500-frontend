package com.tas.wp500;


public class JSONBuilder {

	private String json_string_name;
	private String json_interval;
	private String broker_type;
	private String broker_ip_address;
	private String publish_topic_name;
	private String publishing_status;
	private String store_n_forward;
	private String json_string;

	public JSONBuilder(String json_string_name, String json_interval, String broker_type, String broker_ip_address,
			String publish_topic_name, String publishing_status, String store_n_forward, String json_string) {
		super();
		this.json_string_name = json_string_name;
		this.json_interval = json_interval;
		this.broker_type = broker_type;
		this.broker_ip_address = broker_ip_address;
		this.publish_topic_name = publish_topic_name;
		this.publishing_status = publishing_status;
		this.store_n_forward = store_n_forward;
		this.json_string = json_string;
	}

	public JSONBuilder() {
		super();
	}

	public String getJson_string_name() {
		return json_string_name;
	}

	public void setJson_string_name(String json_string_name) {
		this.json_string_name = json_string_name;
	}

	public String getJson_interval() {
		return json_interval;
	}

	public void setJson_interval(String json_interval) {
		this.json_interval = json_interval;
	}

	public String getBroker_type() {
		return broker_type;
	}

	public void setBroker_type(String broker_type) {
		this.broker_type = broker_type;
	}

	public String getBroker_ip_address() {
		return broker_ip_address;
	}

	public void setBroker_ip_address(String broker_ip_address) {
		this.broker_ip_address = broker_ip_address;
	}

	public String getPublish_topic_name() {
		return publish_topic_name;
	}

	public void setPublish_topic_name(String publish_topic_name) {
		this.publish_topic_name = publish_topic_name;
	}

	public String getPublishing_status() {
		return publishing_status;
	}

	public void setPublishing_status(String publishing_status) {
		this.publishing_status = publishing_status;
	}

	public String getStore_and_forward() {
		return store_n_forward;
	}

	public void setStore_and_forward(String store_n_forward) {
		this.store_n_forward = store_n_forward;
	}

	public String getJson_string() {
		return json_string;
	}

	public void setJson_string(String json_string) {
		this.json_string = json_string;
	}

}
