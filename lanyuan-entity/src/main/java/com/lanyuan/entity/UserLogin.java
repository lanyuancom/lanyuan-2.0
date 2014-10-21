package com.lanyuan.entity;

import java.util.Date;

import org.codehaus.jackson.map.annotate.JsonSerialize;

import com.lanyuan.util.JsonDateSerializer;

public class UserLogin implements java.io.Serializable  {
 /**
	 * 
	 */
	private static final long serialVersionUID = 4999821408224216189L;
private Integer userId;
private String userName;
 private Date loginTime;
 private String loginIP;
 
 public void setUserId (Integer userId)
 {
	    this.userId = userId;
 }
 
 public Integer getUserId(){
	 return userId;
 }
 
 public void setUserName (String userName)
 {
	    this.userName = userName;
 }
 
 public String getUserName(){
	 return userName;
 }
 
 public void setLoginTime (Date loginTime)
 {
	    this.loginTime = loginTime;
 }
 @JsonSerialize(using=JsonDateSerializer.class)
 public Date getLoginTime(){
	 return loginTime;
 }
  
 public void setloginIP (String loginIP)
 {
	    this.loginIP = loginIP;
 }
 
 public String getLoginIP(){
	 return loginIP;
 }
 
 @Override
	public String toString() {
		return "Menu [userId=" + userId + ",userName=" + userName + ", loginTime=" + loginTime + ", loginIP=" + loginIP + "]";
	}
 
}
