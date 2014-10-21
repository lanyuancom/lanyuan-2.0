package com.lanyuan.controller;


import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lanyuan.entity.Resources;
import com.lanyuan.entity.UserLogin;
import com.lanyuan.pulgin.mybatis.plugin.PageView;
import com.lanyuan.service.UserLoginService;
import com.lanyuan.util.Common;


/**
 * 
 * @author lanyuan
 * 2013-11-19
 * @Email: mmm333zzz520@163.com
 * @version 1.0v
 */
@Controller
@RequestMapping("/background/userLoginList/")
public class UserLoginListController extends BaseController{
	@Inject
	private UserLoginService userLoginService;
	
	/**
	 * @param model
	 * 存放返回界面的model
	 * @return
	 */
	@RequestMapping("query")
	public String list(Model model, Resources menu, String pageNow) {
		return Common.BACKGROUND_PATH+"/userLoginList/list";
	}
	
	@ResponseBody
	@RequestMapping("queryList")
	public PageView query(UserLogin userLogin,String pageNow,String pagesize) {
		pageView = userLoginService.query(getPageView(pageNow,pagesize), userLogin);
		return pageView;
	}
	
}