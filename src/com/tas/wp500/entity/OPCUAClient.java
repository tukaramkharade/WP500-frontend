package com.tas.wp500.entity;

public class OPCUAClient {
	
	 private String Username;
	 private String Password;
    private String endUrl;
    private String Security;
    private String ActionType;
    private String prefix;
	 
    public OPCUAClient() {
		super();
	}

	public OPCUAClient(String username, String password, String endUrl, String security, String actionType,
			String prefix) {
		super();
		Username = username;
		Password = password;
		this.endUrl = endUrl;
		Security = security;
		ActionType = actionType;
		this.prefix = prefix;
	}

	public String getUsername() {
		return Username;
	}

	public void setUsername(String username) {
		Username = username;
	}

	public String getPassword() {
		return Password;
	}

	public void setPassword(String password) {
		Password = password;
	}

	public String getEndUrl() {
		return endUrl;
	}

	public void setEndUrl(String endUrl) {
		this.endUrl = endUrl;
	}

	public String getSecurity() {
		return Security;
	}

	public void setSecurity(String security) {
		Security = security;
	}

	public String getActionType() {
		return ActionType;
	}

	public void setActionType(String actionType) {
		ActionType = actionType;
	}

	public String getPrefix() {
		return prefix;
	}

	public void setPrefix(String prefix) {
		this.prefix = prefix;
	}
}