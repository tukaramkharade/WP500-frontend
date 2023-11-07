package com.tas.wp500.entity;

public class NodeData {

	private String type;
	private String nodeid;
	private String browsename;
	private String opcname;
	private String displayName;

	public String getDisplayName() {

		return displayName;

	}

	public void setDisplayName(String displayName) {

		this.displayName = displayName;

	}

	public String getOpcname() {

		return opcname;

	}

	public void setOpcname(String opcname) {

		this.opcname = opcname;

	}

	public String getType() {

		return type;

	}

	public void setType(String type) {

		this.type = type;

	}

	public String getNodeid() {

		return nodeid;

	}

	public void setNodeid(String nodeid) {

		this.nodeid = nodeid;

	}

	public String getBrowsename() {

		return browsename;

	}

	public void setBrowsename(String browsename) {

		this.browsename = browsename;

	}

	@Override

	public String toString() {

		return "NodeData [type=" + type + ", nodeid=" + nodeid + ", browsename=" + browsename + ", opcname=" + opcname

				+ ", displayName=" + displayName + "]";

	}

}
