package com.tas.wp500;

import org.json.simple.JSONObject;

public class CommandConfig {

	private String unit_id;
	private String asset_id;
	private String broker_type;
	private String broker_ip;
	private int interval;
	private JSONObject command_tag;

	public CommandConfig(String unit_id, String asset_id, String broker_type, String broker_ip, int interval,
			JSONObject command_tag) {
		super();
		this.unit_id = unit_id;
		this.asset_id = asset_id;
		this.broker_type = broker_type;
		this.broker_ip = broker_ip;
		this.interval = interval;
		this.command_tag = command_tag;
	}

	public CommandConfig() {
		super();
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

	public JSONObject getCommand_tag() {
		return command_tag;
	}

	public void setCommand_tag(JSONObject command_tag) {
		this.command_tag = command_tag;
	}
	
	
	
	
}
