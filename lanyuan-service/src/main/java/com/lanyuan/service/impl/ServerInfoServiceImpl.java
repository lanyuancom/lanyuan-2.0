package com.lanyuan.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lanyuan.entity.ServerInfo;
import com.lanyuan.mapper.ServerInfoMapper;
import com.lanyuan.pulgin.mybatis.plugin.PageView;
import com.lanyuan.service.ServerInfoService;

@Transactional
@Service("serverInfoService")
public class ServerInfoServiceImpl implements ServerInfoService{
	@Autowired
	private ServerInfoMapper serverInfoMapper;

	public void add(ServerInfo serverInfo) throws Exception {
		serverInfoMapper.add(serverInfo);
	}

	public void delete(String id) throws Exception {
		serverInfoMapper.delete(id);
	}

	public ServerInfo getById(String id) {
		return serverInfoMapper.getById(id);
	}
	
	public PageView query(PageView pageView, ServerInfo serverInfo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("paging", pageView);
		map.put("t", serverInfo);
		List<ServerInfo> list = serverInfoMapper.query(map);
		pageView.setRecords(list);
		return pageView;
	}
	
	public List<ServerInfo> queryAll(ServerInfo serverInfo) {
		return serverInfoMapper.queryAll(serverInfo);
	}

	public void update(ServerInfo serverInfo) throws Exception {
		serverInfoMapper.update(serverInfo);
	}
	
}
