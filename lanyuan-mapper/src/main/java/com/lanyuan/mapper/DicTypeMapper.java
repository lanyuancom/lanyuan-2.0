package com.lanyuan.mapper;


import com.lanyuan.base.BaseMapper;
import com.lanyuan.entity.DicType;

public interface DicTypeMapper extends BaseMapper<DicType>{
	public DicType isExist(DicType dicType);
	public DicType queryById(DicType dicType);
}
