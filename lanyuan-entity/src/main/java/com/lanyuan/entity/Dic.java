package com.lanyuan.entity;

/**
 * 字典
 * @author lanyuan
 * Email：mmm333zzz520@163.com
 * date：2014-4-8
 */
@SuppressWarnings("serial")
public class Dic implements java.io.Serializable{
	
	private Integer id;
	private Integer dicTypeId;//类型ID
	private String dicKey;//key
	private String dicName;//名
	private String dicTypeName;//类型名
	private String dicTypeKey;//类型key
	private String description;//说明
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getDicTypeId() {
		return dicTypeId;
	}
	public void setDicTypeId(Integer dicTypeId) {
		this.dicTypeId = dicTypeId;
	}
	public String getDicKey() {
		return dicKey;
	}
	public void setDicKey(String dicKey) {
		this.dicKey = dicKey;
	}
	public String getDicName() {
		return dicName;
	}
	public void setDicName(String dicName) {
		this.dicName = dicName;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getDicTypeName() {
		return dicTypeName;
	}
	public void setDicTypeName(String dicTypeName) {
		this.dicTypeName = dicTypeName;
	}
	public String getDicTypeKey() {
		return dicTypeKey;
	}
	public void setDicTypeKey(String dicTypeKey) {
		this.dicTypeKey = dicTypeKey;
	}
}
