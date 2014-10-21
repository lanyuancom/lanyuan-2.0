package com.lanyuan.service;


import java.util.List;

import com.lanyuan.base.BaseService;
import com.lanyuan.entity.RoleAccount;
import com.lanyuan.entity.Roles;

public interface RolesService extends BaseService<Roles>{
	public Roles isExist(String name);
	public Roles findbyAccountRole(String accountId);
	public void addAccRole(RoleAccount roleAccount);

	public void addAccRole(String accountId, List<String> ids);
}
