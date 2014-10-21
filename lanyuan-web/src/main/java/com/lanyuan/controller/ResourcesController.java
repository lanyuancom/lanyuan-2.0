package com.lanyuan.controller;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.PropertyUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lanyuan.entity.Params;
import com.lanyuan.entity.Resources;
import com.lanyuan.pulgin.mybatis.plugin.PageView;
import com.lanyuan.service.ResourcesService;
import com.lanyuan.util.Common;
import com.lanyuan.util.PropertiesUtils;
import com.lanyuan.util.TreeObject;
import com.lanyuan.util.TreeUtil;

/**
 * 
 * @author lanyuan 2013-11-19
 * @Email: mmm333zzz520@163.com
 * @version 1.0v
 */
@Controller
@RequestMapping("/background/resources/")
public class ResourcesController extends BaseController {
	@Inject
	private ResourcesService resourcesService;

	@ResponseBody
	@RequestMapping("perm")
	public Map<String, Object> perm(Model model) {
		Map<String, Object> map = new HashMap<String, Object>();
		/*List<Department> dp = DepartmentUtil.getChildDeparts(departmentService.queryAll(new Department()), 0);
		map.put("records", dp);*/
		return map;
	}

	@RequestMapping("aution")
	public String aution(Model model) throws Exception {
		List<Resources> rs =resourcesService.queryAll(new Resources());
		List<TreeObject> treeObjects = new ArrayList<TreeObject>();
		for (Resources res : rs) {//转换为树对象
			TreeObject t = new TreeObject();
			PropertyUtils.copyProperties(t,res );
			treeObjects.add(t);
		}
		List<TreeObject> ns = TreeUtil.getChildResourcess(treeObjects, 0);
		model.addAttribute("permissions", ns);
		return Common.BACKGROUND_PATH+"/resources/permissions";
	}

	@ResponseBody
	@RequestMapping("findRoleRes")
	public List<Resources> findRoleRes(String roleId){
		return resourcesService.findRoleRes(roleId);
	}

	/**
	 * @param model
	 *            存放返回界面的model
	 * @return
	 */
	@RequestMapping("query")
	public String query(Model model, Resources resources, String pageNow) {
		PageView pageView = null;
		if (Common.isEmpty(pageNow)) {
			pageView = new PageView(1);
		} else {
			pageView = new PageView(Integer.parseInt(pageNow));
		}
		pageView = resourcesService.query(pageView, resources);
		model.addAttribute("pageView", pageView);
		return Common.BACKGROUND_PATH+"/resources/list";
	}

	/**
	 * @param model
	 *            存放返回界面的model
	 * @return
	 */
	@RequestMapping("list")
	public String list(Model model, Resources resources, String pageNow) {
		return Common.BACKGROUND_PATH+"/resources/list";
	}

	@ResponseBody
	@RequestMapping("resources")
	public Map<String, Object> resourcess(Resources resources,HttpServletRequest request) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Resources> rs;
		if (PropertiesUtils.findPropertiesKey("rootName").equals(Common.findAuthenticatedUsername()))
		{
		    rs =resourcesService.queryAll(resources);
		}
		else
		{
			rs =resourcesService.findAccountResourcess(Common.findUserSessionId(request));
		}
		List<TreeObject> treeObjects = new ArrayList<TreeObject>();
		for (Resources res : rs) {//转换为树对象
			TreeObject t = new TreeObject();
			PropertyUtils.copyProperties(t,res );
			treeObjects.add(t);
		}
		List<TreeObject> ns = TreeUtil.getChildResourcess(treeObjects, 0);
		map.put("resourceslists", ns);
		return map;
	}

	@ResponseBody
	@RequestMapping("queryAll")
	public List<Resources> queryAll(HttpServletRequest request) {
		if (PropertiesUtils.findPropertiesKey("rootName").equals(Common.findAuthenticatedUsername())) {// 根据账号拥有所有权限
			return resourcesService.queryAll(new Resources());
		} else {
			return resourcesService.queryAll(new Resources());
		}
	}

	@ResponseBody
	@RequestMapping("queryParentId")
		public List<Resources> queryParentId(Resources resources) {			
				return resourcesService.queryByParentId(resources);
	}
	
	@ResponseBody
	@RequestMapping("/updateResourcesOrder")
	public void updateResourcesOrder(Params params) {
		//resourcesService.updateMeunOrder(params.getResourcess());
	}

	/**
	 * 跳转到修改界面
	 * 
	 * @param model
	 * @param resourcesId
	 *            修改菜单信息ID
	 * @return
	 */
	@RequestMapping("editUI")
	public String editUI(Model model, String resourcesId) {
		Resources resources = resourcesService.getById(resourcesId);
		model.addAttribute("resources", resources);
		return Common.BACKGROUND_PATH+"/resources/edit";
	}

	/**
	 * 跳转到新增界面
	 * 
	 * @return
	 */
	@RequestMapping("addUI")
	public String addUI(Model model) {
		List<Resources> resources = resourcesService.queryAll(new Resources());
		model.addAttribute("resources", resources);
		return Common.BACKGROUND_PATH+"/resources/add";
	}
	/**
	 * 权限分配页面
	 * @author lanyuan
	 * Email：mmm333zzz520@163.com
	 * date：2014-4-14
	 * @param model
	 * @return
	 */
	@RequestMapping("permissions")
	public String permissions(Model model) {
		return Common.BACKGROUND_PATH+"/resources/permissions";
	}
	/**
	 * 添加菜单
	 * 
	 * @param resources
	 * @return Map
	 */
	@RequestMapping("add")
	@ResponseBody
	public Map<String, Object> add(Resources resources) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			//判断是否为目录(目录的parentId为0)
			if(-1==resources.getParentId()){
				resources.setParentId(0);
			}
			resourcesService.add(resources);
			map.put("flag", "true");
		} catch (Exception e) {
			e.printStackTrace();
			map.put("flag", "false");
		}
		return map;
	}

	/**
	 * 更新菜单
	 * 
	 * @param model
	 * @param Map
	 * @return
	 */
	@ResponseBody
	@RequestMapping("update")
	public Map<String, Object> update(Model model, Resources resources) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			resourcesService.update(resources);
			map.put("flag", "true");
		} catch (Exception e) {
			map.put("flag", "false");
		}
		return map;
	}

	/**
	 * 根据ID删除菜单
	 * 
	 * @param model
	 * @param ids
	 * @return
	 */
	@ResponseBody
	@RequestMapping("deleteById")
	public Map<String, Object> deleteById(Model model, String ids) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			String id[] = ids.split(",");
			for (int i = 0, inv = id.length; i < inv; i++) {
				if (!Common.isEmpty(id[i])) {
					resourcesService.delete(id[i]);
				}
			}
			map.put("flag", "true");
		} catch (Exception e) {
			map.put("flag", "false");
		}
		return map;
	}
	
	/**
	 * 验证菜单是否存在
	 * @param name
	 * @return
	 */
	@RequestMapping("isExist")
	@ResponseBody
	public boolean isExist(String name){
		//Account account = accountService.isExist(name);
		Resources resources=resourcesService.isExist(name);
		if(resources == null){
			return true;
		}else{
			return false;
		}
	}
	
	@ResponseBody
	@RequestMapping("addRoleRes")
	public Map<String, Object> addRoleRes(String roleId, Params params) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<String> list = params.getId();
		try {
			if (null != list && list.size() > 0) {
				resourcesService.addRoleRes(roleId, list);
				map.put("flag", "true");
			} else {
				map.put("flag", "false");
			}
		} catch (Exception e) {
			map.put("flag", "false");
		}

		return map;
	}
	@RequestMapping("sortUpdate")
	@ResponseBody
	public Map<String, Object> sortUpdate(Params params,HttpServletRequest request) throws Exception{
		resourcesService.updateSortOrder(params.getResources());
		return resourcess(new Resources(),request);
	}
}