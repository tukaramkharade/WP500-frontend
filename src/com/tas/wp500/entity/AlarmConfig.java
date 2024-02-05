package com.tas.wp500.entity;

import org.json.simple.JSONObject;

public class AlarmConfig {
	private String unit_id;
	private String asset_id;
	private String broker_type;
	private String broker_ip;
	private int interval;
	private JSONObject alarm_tag;
	
	public AlarmConfig(String unit_id, String asset_id, String broker_type, String broker_ip, int interval, JSONObject alarm_tag) {
		super();
		this.unit_id = unit_id;
		this.asset_id = asset_id;
		this.broker_type = broker_type;
		this.broker_ip = broker_ip;
		this.interval = interval;
		this.alarm_tag = alarm_tag;
	}

	public AlarmConfig() {
		super();
	}

	public JSONObject getAlarm_tag() {
		return alarm_tag;
	}

	public void setAlarm_tag(JSONObject alarm_tag) {
		this.alarm_tag = alarm_tag;
	}

	public String getUnit_id() {
		return unit_id;
	}

	public void setUnit_id(String unit_id) {
		this.unit_id = unit_id;
	}

	public String getAsset_id() {
		return asset_id;
	}

	public void setAsset_id(String asset_id) {
		this.asset_id = asset_id;
	}

	public String getBroker_type() {
		return broker_type;
	}

	public void setBroker_type(String broker_type) {
		this.broker_type = broker_type;
	}

	public String getBroker_ip() {
		return broker_ip;
	}

	public void setBroker_ip(String broker_ip) {
		this.broker_ip = broker_ip;
	}

	public int getInterval() {
		return interval;
	}

	public void setInterval(int interval) {
		this.interval = interval;
	}
}