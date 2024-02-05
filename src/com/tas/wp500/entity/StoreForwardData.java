package com.tas.wp500.entity;

public class StoreForwardData {
	private String dateTime;
	private String dataString;
	private String publishTopic;
	private String brokerIp;

	public StoreForwardData(String dateTime, String dataString, String publishTopic, String brokerIp) {
		super();
		this.dateTime = dateTime;
		this.dataString = dataString;
		this.publishTopic = publishTopic;
		this.brokerIp = brokerIp;
	}

	public StoreForwardData() {
		super();
	}

	public String getBrokerIp() {
		return brokerIp;
	}

	public void setBrokerIp(String brokerIp) {
		this.brokerIp = brokerIp;
	}

	public String getPublishTopic() {
		return publishTopic;
	}

	public void setPublishTopic(String publishTopic) {
		this.publishTopic = publishTopic;
	}

	public String getDateTime() {
		return dateTime;
	}

	public void setDateTime(String dateTime) {
		this.dateTime = dateTime;
	}

	public String getDataString() {
		return dataString;
	}

	public void setDataString(String dataString) {
		this.dataString = dataString;
	}
}