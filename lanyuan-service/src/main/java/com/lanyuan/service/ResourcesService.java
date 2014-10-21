package com.lanyuan.service;


import java.util.List;

import com.lanyuan.base.BaseService;
import com.lanyuan.entity.Resources;

public interface ResourcesService extends BaseService<Resources>{
	//<!-- 根据账号Id获取该用户的权限-->
	public List<Resources> findAccountResourcess(String accountId);
	/**
	 * @author lanyuan
	 * Email：mmm333zzz520@163.com
	 * date：2014-2-25
	 * @return
	 */
	public List<Resources> findRoleRes(String roleId);
	
	public List<Resources> queryByParentId(Resources resources);
	/**
	 * 更新菜单排序号
	 * @author lanyuan
	 * Email：mmm333zzz520@163.com
	 * date：2014-04-12
	 * @param resourceVOs
	 */
	void updateSortOrder(List<Resources> menus);
	public void addRoleRes(String roleId,List<String> list);

	public Resources isExist(String menuName);
	public  int  getMaxLevel();
}
