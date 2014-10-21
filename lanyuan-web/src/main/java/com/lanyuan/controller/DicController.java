package com.lanyuan.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lanyuan.entity.Resources;
import com.lanyuan.entity.Dic;
import com.lanyuan.pulgin.mybatis.plugin.PageView;
import com.lanyuan.service.DicService;
import com.lanyuan.util.Common;

/**
 * 
 * @author lanyuan
 * 2013-11-19
 * @Email: mmm333zzz520@163.com
 * @version 1.0v
 */
@Controller
@RequestMapping("/background/dic/")
public class DicController extends BaseController{
	@Inject
	private DicService dicService;
	
	@RequestMapping("list")
	public String list(Model model, Resources menu, String pageNow) {
		return Common.BACKGROUND_PATH+"/dic/list";
	}
	/**
	 * @param model
	 * 存放返回界面的model
	 * @return
	 */
	@ResponseBody
	@RequestMapping("query")
	public PageView query(Dic dic,String pageNow,String pagesize) {
		pageView = dicService.query(getPageView(pageNow,pagesize), dic);
		return pageView;
	}
	
	/**
	 * 获取未科组匹配账号
	 * @param account
	 * @param pageNow
	 * @param pagesize
	 * @return
	 */
//	@ResponseBody
//	@RequestMapping("queryNoMatch")
//	public PageView queryNoMatch(Dic dic,String pageNow,String pagesize) {
//		pageView = dicService.queryNoMatch(dic, getPageView(pageNow,pagesize));
//		return pageView;
//	}
	
	/**
	 * 保存数据
	 * 
	 * @param model
	 * @param videoType
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping("add")
	@ResponseBody
	public Map<String, Object> add(Dic dic) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			dicService.add(dic);
			map.put("flag", "true");
		} catch (Exception e) {
			map.put("flag", "false");
		}
		return map;
	}

	
	/**
	 * 跑到新增界面
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping("addUI")
	public String addUI() {
		return Common.BACKGROUND_PATH+"/dic/add";
	}
	/**
	 * 跑到新增界面
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping("editUI")
	public String editUI(Model model,String dicId) {
		Dic dic = dicService.getById(dicId);
		model.addAttribute("dic", dic);
		return Common.BACKGROUND_PATH+"/dic/edit";
	}
	
	/**
	 * @author lanyuan
	 * Email：mmm333zzz520@163.com
	 * date：2014-2-19
	 * @param Dic dic
	 * @return
	 */
	@RequestMapping("isExist")
	@ResponseBody
	public boolean isExist(Dic dic){
		Dic d = dicService.isExist(dic);
		if(d == null){
			return true;
		}else{
			return false;
		}
	}
	/**
	 * 删除
	 * 
	 * @param model
	 * @param videoTypeId
	 * @return
	 * @throws Exception 
	 */
	@ResponseBody
	@RequestMapping("deleteById")
	public Map<String, Object> deleteById(Model model, String ids) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			String id[] = ids.split(",");
			for (String string : id) {
				if(!Common.isEmpty(string)){
					dicService.delete(string);
				}
			}
			map.put("flag", "true");
		} catch (Exception e) {
			map.put("flag", "false");
		}
		return map;
	}
	/**
	 * 删除
	 * 
	 * @param model
	 * @param videoTypeId
	 * @return
	 * @throws Exception 
	 */
//	@ResponseBody
//	@RequestMapping("updateState")
//	public Map<String, Object> updateState(Model model, String ids,String state) {
//		Map<String, Object> map = new HashMap<String, Object>();
//		try {
//			String id[] = ids.split(",");
//			for (String string : id) {
//				if(!Common.isEmpty(string)){
//					Account account = new Account();
//					account.setId(Integer.parseInt(string));
//					account.setState(state);
//					accountService.update(account);
//				}
//			}
//			map.put("flag", "true");
//		} catch (Exception e) {
//			map.put("flag", "false");
//		}
//		return map;
//	}
	/**
	 * 更新类型
	 * 
	 * @param model
	 * @return
	 * @throws Exception 
	 */
	@ResponseBody
	@RequestMapping("update")
	public Map<String, Object> update(Model model, Dic dic) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			dicService.update(dic);
			map.put("flag", "true");
		} catch (Exception e) {
			map.put("flag", "false");
		}
		return map;
	}
	
	@ResponseBody
	@RequestMapping("findDicType")
	public List<Dic> findDicType(Model model, Dic dic) {
		return dicService.queryAll(dic);
	}
}