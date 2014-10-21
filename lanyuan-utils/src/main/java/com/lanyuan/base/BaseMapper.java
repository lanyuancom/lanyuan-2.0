package com.lanyuan.base;

import java.util.List;
import java.util.Map;


/**
 * 所有的Mapper继承这个接口
 * 已经实现民基本的 增,删,改,查接口,不需要重复写
 * @author lanyuan
 * @date 2014-2-10
 * @Email: mmm333zzz520@163.com
 * @version 1.0v
 */
public interface BaseMapper<T> extends Base<T> {
	/**
	 * 返回分页后的数据
	 * @param List
	 * @param t
	 * @return
	 */
	public List<T> query(Map<String, Object> map);
}
