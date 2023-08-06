package com.tas.wp500;

public class StratonLiveData {
	
	private String extError;
	private String access;
	private String tag_name;
	private String error;
	private String value;
	
	public StratonLiveData(String extError, String access, String tag_name, String error, String value) {
		super();
		this.extError = extError;
		this.access = access;
		this.tag_name = tag_name;
		this.error = error;
		this.value = value;
	}

	public StratonLiveData() {
		super();
	}

	public String getExtError() {
		return extError;
	}

	public void setExtError(String extError) {
		this.extError = extError;
	}

	public String getAccess() {
		return access;
	}

	public void setAccess(String access) {
		this.access = access;
	}

	public String getTag_name() {
		return tag_name;
	}

	public void setTag_name(String tag_name) {
		this.tag_name = tag_name;
	}

	public String getError() {
		return error;
	}

	public void setError(String error) {
		this.error = error;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}
	
}
