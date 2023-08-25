package com.tas.wp500.entity;

public class LanDhcp {

	private int eth_type;

	public LanDhcp() {
		super();
	}

	public LanDhcp(int eth_type) {
		super();
		this.eth_type = eth_type;
	}

	public int getEth_type() {
		return eth_type;
	}

	public void setEth_type(int eth_type) {
		this.eth_type = eth_type;
	}
}
