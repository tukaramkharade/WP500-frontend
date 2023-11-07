package com.tas.wp500.entity;

public class NodeValue {

	private String nodeid;

	private String status;

	private Object value;

	private String timestamp;

	private String dataType;

	public String getDataType() {

		return dataType;

	}

	public void setDataType(String dataType) {

		this.dataType = dataType;

	}

	public String getNodeid() {

		return nodeid;

	}

	public void setNodeid(String nodeid) {

		this.nodeid = nodeid;

	}

	public String getStatus() {

		return status;

	}

	public void setStatus(String status) {

		this.status = status;

	}

	public Object getValue() {

		return value;

	}

	public void setValue(Object value) {

		this.value = value;

	}

	public String getTimestamp() {

		return timestamp;

	}

	public void setTimestamp(String timestamp) {

		this.timestamp = timestamp;

	}

	@Override

	public String toString() {

		return "NodeValue [nodeid=" + nodeid + ", status=" + status + ", value=" + value + ", timestamp=" + timestamp

				+ ", dataType=" + dataType + "]";

	}
}
