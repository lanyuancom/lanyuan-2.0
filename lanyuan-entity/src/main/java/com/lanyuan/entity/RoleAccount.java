package com.lanyuan.entity;

import java.io.Serializable;

@SuppressWarnings("serial")
public class RoleAccount implements Serializable{

	private Integer roleId;
	private Integer accountId;
	public Integer getRoleId() {
		return roleId;
	}
	public void setRoleId(Integer roleId) {
		this.roleId = roleId;
	}
	public Integer getAccountId() {
		return accountId;
	}
	public void setAccountId(Integer accountId) {
		this.accountId = accountId;
	}
	
}
