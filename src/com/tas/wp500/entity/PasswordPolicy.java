package com.tas.wp500.entity;

import org.json.JSONArray;

public class PasswordPolicy {
	
	private int id;
	private String password_policy;
	private String characters_count;
	private String password_policy_role;
	private JSONArray password_blocked_list;
	private String ascii_ch_count;
	private String number_count;
	private String mixed_ch_count;
	private String allowed_special_ch;
	private String special_ch_count;
	
	
	public PasswordPolicy() {
		super();
	}


	public PasswordPolicy(int id, String password_policy, String characters_count, String password_policy_role,
			JSONArray password_blocked_list, String ascii_ch_count, String number_count, String mixed_ch_count,
			String allowed_special_ch, String special_ch_count) {
		super();
		this.id = id;
		this.password_policy = password_policy;
		this.characters_count = characters_count;
		this.password_policy_role = password_policy_role;
		this.password_blocked_list = password_blocked_list;
		this.ascii_ch_count = ascii_ch_count;
		this.number_count = number_count;
		this.mixed_ch_count = mixed_ch_count;
		this.allowed_special_ch = allowed_special_ch;
		this.special_ch_count = special_ch_count;
	}


	public int getId() {
		return id;
	}


	public void setId(int id) {
		this.id = id;
	}


	public String getPassword_policy() {
		return password_policy;
	}


	public void setPassword_policy(String password_policy) {
		this.password_policy = password_policy;
	}


	public String getCharacters_count() {
		return characters_count;
	}


	public void setCharacters_count(String characters_count) {
		this.characters_count = characters_count;
	}


	public String getPassword_policy_role() {
		return password_policy_role;
	}


	public void setPassword_policy_role(String password_policy_role) {
		this.password_policy_role = password_policy_role;
	}


	public JSONArray getPassword_blocked_list() {
		return password_blocked_list;
	}


	public void setPassword_blocked_list(JSONArray password_blocked_list) {
		this.password_blocked_list = password_blocked_list;
	}


	public String getAscii_ch_count() {
		return ascii_ch_count;
	}


	public void setAscii_ch_count(String ascii_ch_count) {
		this.ascii_ch_count = ascii_ch_count;
	}


	public String getNumber_count() {
		return number_count;
	}


	public void setNumber_count(String number_count) {
		this.number_count = number_count;
	}


	public String getMixed_ch_count() {
		return mixed_ch_count;
	}


	public void setMixed_ch_count(String mixed_ch_count) {
		this.mixed_ch_count = mixed_ch_count;
	}


	public String getAllowed_special_ch() {
		return allowed_special_ch;
	}


	public void setAllowed_special_ch(String allowed_special_ch) {
		this.allowed_special_ch = allowed_special_ch;
	}


	public String getSpecial_ch_count() {
		return special_ch_count;
	}


	public void setSpecial_ch_count(String special_ch_count) {
		this.special_ch_count = special_ch_count;
	}
	
	
	
	

}
