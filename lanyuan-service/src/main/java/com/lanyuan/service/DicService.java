package com.lanyuan.service;

import com.lanyuan.base.BaseService;
import com.lanyuan.entity.Dic;



public interface DicService extends BaseService<Dic>{
	public Dic isExist(Dic dic);
}
