package com.lanyuan.base;

import com.lanyuan.pulgin.mybatis.plugin.PageView;



/**
 * 所有服务接口都要继承这个
 * @author lanyuan
 * @date 2014-2-11
 * @Email: mmm333zzz520@163.com
 * @version 1.0v
 * @param <T>
 */
public interface BaseService<T> extends Base<T> {
	/**
	 * 返回分页后的数据
	 * @param pageView
	 * @param t
	 * @return
	 */
	public PageView query(PageView pageView,T t);
}
