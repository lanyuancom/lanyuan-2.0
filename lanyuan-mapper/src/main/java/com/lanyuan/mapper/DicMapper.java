package com.lanyuan.mapper;


import com.lanyuan.base.BaseMapper;
import com.lanyuan.entity.Dic;

public interface DicMapper extends BaseMapper<Dic>{
	public Dic isExist(Dic dic);
}
