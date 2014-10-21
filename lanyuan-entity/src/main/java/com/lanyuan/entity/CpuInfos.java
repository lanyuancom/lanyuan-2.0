package com.lanyuan.entity;

import java.io.Serializable;

/**
 * CPU信息
 */
public class CpuInfos implements Serializable{
	private static final long serialVersionUID = 1L;
	
	private String id;
	private int totalMHz;
	private String vendor;
	private String model;
	private long cacheSize;
	private String idle;//空闲率
	private String used;//使用率（格式化的值）
	private double usedOrigVal;//使用率（原始的值）
	

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public int getTotalMHz() {
		return totalMHz;
	}

	public void setTotalMHz(int totalMHz) {
		this.totalMHz = totalMHz;
	}

	public String getVendor() {
		return vendor;
	}

	public void setVendor(String vendor) {
		this.vendor = vendor;
	}

	public String getModel() {
		return model;
	}

	public void setModel(String model) {
		this.model = model;
	}

	public long getCacheSize() {
		return cacheSize;
	}

	public void setCacheSize(long cacheSize) {
		this.cacheSize = cacheSize;
	}

	public String getUsed() {
		return used;
	}

	public void setUsed(String used) {
		this.used = used;
	}

	public String getIdle() {
		return idle;
	}

	public void setIdle(String idle) {
		this.idle = idle;
	}

	public double getUsedOrigVal() {
		return usedOrigVal;
	}

	public void setUsedOrigVal(double usedOrigVal) {
		this.usedOrigVal = usedOrigVal;
	}
	
}