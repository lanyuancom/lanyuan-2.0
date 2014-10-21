package com.lanyuan.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lanyuan.entity.Resources;
import com.lanyuan.entity.ResourcesRole;
import com.lanyuan.mapper.ResourcesMapper;
import com.lanyuan.pulgin.mybatis.plugin.PageView;
import com.lanyuan.service.ResourcesService;

@Transactional
@Service("resourcesService")
public class ResourcesServiceImpl implements ResourcesService {
	@Autowired
	private ResourcesMapper resourcesMapper;

	public PageView query(PageView pageView, Resources resources) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("paging", pageView);
		map.put("t", resources);
		List<Resources> list = resourcesMapper.query(map);
		pageView.setRecords(list);
		return pageView;
	}

	
	public List<Resources> queryAll(Resources t) {
		return resourcesMapper.queryAll(t);
	}

	
	public void delete(String id) throws Exception {
		this.resourcesMapper.delete(id);
	}

	
	public void update(Resources t) throws Exception {
			this.resourcesMapper.update(t);
	}

	
	public Resources getById(String id) {
		return this.resourcesMapper.getById(id);
	}

	public List<Resources> queryByParentId(Resources resources)
	{
		return resourcesMapper.queryByParentId(resources);
	}
	
	public void add(Resources t) throws Exception {
		this.resourcesMapper.add(t);
	}

	
	public void updateSortOrder(List<Resources> resourcess) {
		for (Resources m : resourcess) {
			resourcesMapper.updateSortOrder(m);
		}
	}

	
	public List<Resources> findAccountResourcess(String accountId) {
		return resourcesMapper.findAccountResourcess(accountId);
	}

	
	public List<Resources> findRoleRes(String roleId) {
		return resourcesMapper.findRoleRes(roleId);
	}

	
	public void addRoleRes(String roleId,List<String> list) {
		resourcesMapper.deleteResourcesRole(roleId);
		for (String string : list) {
			ResourcesRole rr = new ResourcesRole();
			rr.setRoleId(roleId);
			rr.setResId(string);
			resourcesMapper.addRoleRes(rr);
		}
	}

	
	public int getMaxLevel() {
		return resourcesMapper.getMaxLevel();
	}

	
	public Resources isExist(String resourcesName) {
		return resourcesMapper.isExist(resourcesName);
	}

}
