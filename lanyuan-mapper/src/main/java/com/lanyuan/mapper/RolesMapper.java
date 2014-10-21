package com.lanyuan.mapper;

import com.lanyuan.base.BaseMapper;
import com.lanyuan.entity.RoleAccount;
import com.lanyuan.entity.Roles;

public interface RolesMapper extends BaseMapper<Roles>{
	public Roles isExist(String name);
	
	public Roles findbyAccountRole(String accountId);
	
	public void addAccRole(RoleAccount roleAccount);
	
	public void deleteAccountRole(String accountId);
}
