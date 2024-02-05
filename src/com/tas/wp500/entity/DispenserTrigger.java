package com.tas.wp500.entity;

public class DispenserTrigger {

	private String station_name;
	private String serial_number;
	private String side;
	private String trigger_tag;
	private String trigger_value;
	private String status;
	private String start_pressure;
	private String end_pressure;
	private String temperature;
	private String total;
	private String broker_ip_address;
	private String quantity;
	private String unit_price;
	private String unit_id;
	
	
	public DispenserTrigger(String station_name, String serial_number, String side, String trigger_tag,
			String trigger_value, String status, String start_pressure, String end_pressure, String temperature,
			String total, String broker_ip_address, String quantity, String unit_price, String unit_id) {
		super();
		this.station_name = station_name;
		this.serial_number = serial_number;
		this.side = side;
		this.trigger_tag = trigger_tag;
		this.trigger_value = trigger_value;
		this.status = status;
		this.start_pressure = start_pressure;
		this.end_pressure = end_pressure;
		this.temperature = temperature;
		this.total = total;
		this.broker_ip_address = broker_ip_address;
		this.quantity = quantity;
		this.unit_price = unit_price;
		this.unit_id = unit_id;
	}

	public String getUnit_id() {
		return unit_id;
	}

	public void setUnit_id(String unit_id) {
		this.unit_id = unit_id;
	}

	public DispenserTrigger() {
		super();
	}

	public String getStation_name() {
		return station_name;
	}

	public void setStation_name(String station_name) {
		this.station_name = station_name;
	}

	public String getSerial_number() {
		return serial_number;
	}

	public void setSerial_number(String serial_number) {
		this.serial_number = serial_number;
	}

	public String getSide() {
		return side;
	}

	public void setSide(String side) {
		this.side = side;
	}

	public String getTrigger_tag() {
		return trigger_tag;
	}

	public void setTrigger_tag(String trigger_tag) {
		this.trigger_tag = trigger_tag;
	}

	public String getTrigger_value() {
		return trigger_value;
	}

	public void setTrigger_value(String trigger_value) {
		this.trigger_value = trigger_value;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getStart_pressure() {
		return start_pressure;
	}

	public void setStart_pressure(String start_pressure) {
		this.start_pressure = start_pressure;
	}

	public String getEnd_pressure() {
		return end_pressure;
	}

	public void setEnd_pressure(String end_pressure) {
		this.end_pressure = end_pressure;
	}

	public String getTemperature() {
		return temperature;
	}

	public void setTemperature(String temperature) {
		this.temperature = temperature;
	}

	public String getTotal() {
		return total;
	}

	public void setTotal(String total) {
		this.total = total;
	}


	public String getBroker_ip_address() {
		return broker_ip_address;
	}

	public void setBroker_ip_address(String broker_ip_address) {
		this.broker_ip_address = broker_ip_address;
	}

	public String getQuantity() {
		return quantity;
	}

	public void setQuantity(String quantity) {
		this.quantity = quantity;
	}

	public String getUnit_price() {
		return unit_price;
	}

	public void setUnit_price(String unit_price) {
		this.unit_price = unit_price;
	}
}