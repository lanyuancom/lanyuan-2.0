package com.lanyuan.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.context.SecurityContextImpl;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lanyuan.entity.Account;
import com.lanyuan.entity.UserLogin;
import com.lanyuan.service.AccountService;
import com.lanyuan.service.UserLoginService;
import com.lanyuan.util.Common;
import com.lanyuan.util.Md5Tool;

/**
 * 进行管理后台框架界面的类
 * @author lanyuan
 * 2013-11-19
 * @Email: mmm333zzz520@163.com
 * @version 1.0v
 */
@Controller
@RequestMapping ("/")
public class BackgroundController
{
	@Autowired
	private AccountService accountService;
	@Autowired
	private AuthenticationManager myAuthenticationManager;
	
	@Inject
	private UserLoginService userLoginService;
	/**
	 * @return
	 */
	@RequestMapping ("login")
	public String login(Model model,HttpServletRequest request)
	{
		//重新登录时销毁该用户的Session
		Object o = request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");
		if(null != o){
			request.getSession().removeAttribute("SPRING_SECURITY_CONTEXT");
		}
		return Common.BACKGROUND_PATH+"/framework/login";
	}
	
	@RequestMapping ("loginCheck")
	@ResponseBody
	public Map<String, Object> loginCheck(String username,String password){
		Map<String, Object> map = new HashMap<String, Object>();
			Account account = new Account();
			account.setAccountName(username);
			account.setPassword(Md5Tool.getMd5(password));
			// 验证用户账号与密码是否正确
			Account users = this.accountService.countAccount(account);
			map.put("error", "0");
			if (users == null) {
				map.put("error", "用户或密码不正确！");
			}else if (users != null && Common.isEmpty(users.getAccountName())) {
				map.put("error", "用户或密码不正确！");
			}
			return map;
	}
	
	@RequestMapping ("submitlogin")
	public String submitlogin(String username,String password,HttpServletRequest request) throws Exception{
		try {
			if (!request.getMethod().equals("POST")) {
				request.setAttribute("error","支持POST方法提交！");
			}
			if (Common.isEmpty(username) || Common.isEmpty(password)) {
				request.setAttribute("error","用户名或密码不能为空！");
				return Common.BACKGROUND_PATH+"/framework/login";
			}
			// 验证用户账号与密码是否正确
			Account users = this.accountService.querySingleAccount(username);
			if (users == null) {
				request.setAttribute("error", "用户或密码不正确！");
			    return Common.BACKGROUND_PATH+"/framework/login";
			}
			else if (users != null && Common.isEmpty(users.getAccountName()) && !Md5Tool.getMd5(password).equals(users.getPassword())){
				request.setAttribute("error", "用户或密码不正确！");
			    return Common.BACKGROUND_PATH+"/framework/login";
			}
			Authentication authentication = myAuthenticationManager
					.authenticate(new UsernamePasswordAuthenticationToken(username,users.getPassword()));
			SecurityContext securityContext = SecurityContextHolder.getContext();
			securityContext.setAuthentication(authentication);
			HttpSession session = request.getSession(true);  
		    session.setAttribute("SPRING_SECURITY_CONTEXT", securityContext);  
		    // 当验证都通过后，把用户信息放在session里
			request.getSession().setAttribute("userSession", users);
			request.getSession().setAttribute("userSessionId", users.getId());
			System.out.println(authentication.getPrincipal().toString());
			String userId = request.getSession().getAttribute("userSessionId").toString();
			String userName = users.getAccountName();
			String ip = Common.toIpAddr(request);
			UserLogin userLogin = new UserLogin();
			userLogin.setUserId(Integer.parseInt(userId));
			userLogin.setUserName(userName);
			userLogin.setloginIP(ip);
			userLoginService.add(userLogin);
			//request.getSession().setAttribute("userRole",authentication.getPrincipal());
			request.removeAttribute("error");
		} catch (AuthenticationException ae) {  
			request.setAttribute("error", "登录异常，请联系管理员！");
		    return Common.BACKGROUND_PATH+"/framework/login";
		}
		return "redirect:index.html";
	}
	
	/**
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping ("index")
	public String index(Model model)
	{   
    	return Common.BACKGROUND_PATH+"/framework/index";
	}
	@RequestMapping ("menu")
	public String menu(Model model)
	{
		return Common.BACKGROUND_PATH+"/framework/menu";
	}
	
	/**
	 * 获取某个用户的权限资源
	 * @author lanyuan
	 * Email：mmm333zzz520@163.com
	 * date：2014-3-4
	 * @param request
	 * @return
	 */
	@RequestMapping ("findAuthority")
	@ResponseBody
	public List<String> findAuthority(HttpServletRequest request){
		SecurityContextImpl securityContextImpl = (SecurityContextImpl) request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");   
		List<GrantedAuthority> authorities = (List<GrantedAuthority>)securityContextImpl.getAuthentication().getAuthorities();   
		List<String> strings = new ArrayList<String>();
		for (GrantedAuthority grantedAuthority : authorities) {   

			strings.add(grantedAuthority.getAuthority());   

		}  
		return strings;
	}
	
	@ResponseBody
	@RequestMapping ("install")
	public Map<String, Object> install(Model model)
	{
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("success", "初始化成功!");
		} catch (Exception e) {
			map.put("error", "初始化失败  ---------- >   "+e);
		}
		return map;
	}
	@RequestMapping("/download")
	public void download(
	String fileName, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		response.setContentType("text/html;charset=utf-8");
		request.setCharacterEncoding("UTF-8");
		java.io.BufferedInputStream bis = null;
		java.io.BufferedOutputStream bos = null;

		String ctxPath = request.getSession().getServletContext().getRealPath(
				"/")
				+ "\\" + "filezip\\";
		String downLoadPath = ctxPath + fileName;
		System.out.println(downLoadPath);
		try {
			long fileLength = new File(downLoadPath).length();
			response.setContentType("application/x-msdownload;");
			response.setHeader("Content-disposition", "attachment; filename="
					+ new String(fileName.getBytes("utf-8"), "ISO8859-1"));
			response.setHeader("Content-Length", String.valueOf(fileLength));
			bis = new BufferedInputStream(new FileInputStream(downLoadPath));
			bos = new BufferedOutputStream(response.getOutputStream());
			byte[] buff = new byte[2048];
			int bytesRead;
			while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
				bos.write(buff, 0, bytesRead);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (bis != null)
				bis.close();
			if (bos != null)
				bos.close();
		}
	}
	 private static final String MODULE_CODE_SPLIT=",";
	@ResponseBody
	@RequestMapping ("getModules")
	public void getModules(HttpServletResponse response)
	{
		Module module = new Module();
		List l = new ArrayList();
		l.add("a");
		l.add("b");
		l.add("c");
		l.add("d");
		l.add("e");
		List m = new ArrayList();
		l.add("1");
		l.add("2");
		l.add("3");
		l.add("4");
		l.add("5");
		JSONObject jsonObject = new JSONObject();
		module.setModules(m);
		module.setPmodules(l);
		jsonObject.put("module", module);
		doJsonResponse(response, jsonObject);
	}
	/**
	 * 返回json格式的数据
	 * 
	 * @param response
	 * @param jsonObject
	 */
	protected void doJsonResponse(HttpServletResponse response,
			final JSONObject jsonObject) {
		response.setCharacterEncoding("UTF-8");
		try {
			response.getWriter().print(jsonObject);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
