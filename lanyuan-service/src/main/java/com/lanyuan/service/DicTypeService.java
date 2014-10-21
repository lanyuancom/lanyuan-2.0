package com.lanyuan.service;

import com.lanyuan.base.BaseService;
import com.lanyuan.entity.DicType;



public interface DicTypeService extends BaseService<DicType>{
	public DicType isExist(DicType dicType);
	public DicType queryById(DicType dicType);
}
