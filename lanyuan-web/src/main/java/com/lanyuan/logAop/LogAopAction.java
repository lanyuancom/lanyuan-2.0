package com.lanyuan.logAop;

import javax.servlet.http.HttpServletRequest;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.lanyuan.entity.Log;
import com.lanyuan.mapper.LogMapper;
import com.lanyuan.util.Common;
/**
 * AOP注解方法实现日志管理 利用spring AOP 切面技术记录日志 
 * 
 * 定义切面类（这个是切面类和切入点整天合在一起的),这种情况是共享切入点情况;
 * 
 * @author lanyuan 2014-04-10
 * @Email: mmm333zzz520@163.com
 * @version 1.0v
 */
@Aspect
// 该注解标示该类为切面类
@Component
public class LogAopAction {
	@Autowired
	private LogMapper logMapper;
	
	public Object logAll(ProceedingJoinPoint point) throws Exception {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		Object result = null;
		// 执行方法名
		String methodName = point.getSignature().getName();
		String className = point.getTarget().getClass().getSimpleName();
		String user = null;
		Long start = 0L;
		Long end = 0L;
		String ip = null;
		// 当前用户
		try {
			// 执行方法所消耗的时间
			start = System.currentTimeMillis();
			result = point.proceed();
			end = System.currentTimeMillis();
		} catch (Throwable e) {
			 e.printStackTrace();
		}
		try {
			ip = Common.toIpAddr(request);
		} catch (Exception e) {
			ip ="无法获取登录用户Ip";
		}
		try {
			// 登录名
			user = Common.findAuthenticatedUsername();
			if (Common.isEmpty(user)) {
				user = "无法获取登录用户信息！";
			}
		} catch (Exception e) {
			user = "无法获取登录用户信息！";
		}
		String name = null;
		// 操作范围
/*		if (className.indexOf("Resources") > -1) {
			name = "资源管理";
		} else if (className.indexOf("Roles") > -1) {
			name = "角色管理";
		} else if (className.indexOf("User") > -1) {
			name = "用户管理";
		}else{
			name=className;
		}*/
		name=className;
		// 操作类型
		String opertype = "";
//				if (methodName.indexOf("saveUserRole") > -1) {
//					opertype = "update用户的角色";
//				} else if (methodName.indexOf("saveRoleRescours") > -1) {
//					opertype = "update角色的权限";
//				} else if (methodName.indexOf("add") > -1 || methodName.indexOf("save") > -1) {
//					opertype = "save操作";
//				} else if (methodName.indexOf("update") > -1 || methodName.indexOf("modify") > -1) {
//					opertype = "update操作";
//				} else if (methodName.indexOf("delete") > -1) {
//					opertype = "delete操作";
//				}
	   opertype=methodName;
		boolean b = false;
	   String[] clazzMethod = {"add","save","update","modify","delete"};
		for (String string : clazzMethod) {
			if(methodName.indexOf(string)>-1){
				b = true;
			}
		}
		if(b){
			Long time = end - start;
			Log log = new Log();
			log.setUsername(user);
			log.setModule(name);
			log.setAction(opertype);
			log.setActionTime(time.toString());
			log.setUserIP(ip);
			logMapper.add(log);
		}

		return result;
	}
}
