package com.lanyuan.entity;

import java.util.ArrayList;
import java.util.List;


/**
 * 前台发送的是一个对象数组
 * 后台需要以下对象接受
 * 例如:
 * menus[0].id	    1
 * menus[0].level	1
 * menus[1].id	    3
 * menus[1].level	2
 * menus[2].id	    2
 * menus[2].level	3
 * 这个菜单数组对象要接收这个对象,必须在这里加一个list<Resourcess>
 * @author lanyuan
 * Email：mmm333zzz520@163.com
 * date：2014-2-12
 */
public class Params {

	
	private List<Resources> resources = new ArrayList<Resources>();
	private List<String> id = new ArrayList<String>();

	public List<String> getId() {
		return id;
	}

	public void setId(List<String> id) {
		this.id = id;
	}

	public List<Resources> getResources() {
		return resources;
	}

	public void setResources(List<Resources> resources) {
		this.resources = resources;
	}

}
