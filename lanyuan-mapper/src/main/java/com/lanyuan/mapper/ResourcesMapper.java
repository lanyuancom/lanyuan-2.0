package com.lanyuan.mapper;

import java.util.List;

import com.lanyuan.base.BaseMapper;
import com.lanyuan.entity.Resources;
import com.lanyuan.entity.ResourcesRole;

public interface ResourcesMapper extends BaseMapper<Resources> {

	void updateSortOrder(Resources resources);

	public Resources isExist(String name);

	public int getMaxLevel();

	// <!-- 根据账号Id获取该用户的权限-->
	public List<Resources> findAccountResourcess(String accountId);

	/**
	 * @author lanyuan 
	 * @Email：mmm333zzz520@163.com 
	 * @date：2014-2-25
	 * @param DeptId
	 * @return
	 */
	public List<Resources> findRoleRes(String roleId);
	
	public List<Resources> queryByParentId(Resources resources);
	/**
	 * 更新菜单排序号
	 * 
	 * @author lanyuan 
	 * @Email：mmm333zzz520@163.com 
	 * @date：2014-04-12
	 * @param resourceVOs
	 */
	public void addRoleRes(ResourcesRole rr);

	public void deleteResourcesRole(String roleId);
}
