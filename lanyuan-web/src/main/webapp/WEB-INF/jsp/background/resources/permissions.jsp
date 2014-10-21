<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/common/header.jsp"%>
</head>
<style type="text/css">
/* CSS Document */

body {
 font: normal 13px auto "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
 color: #4f6b72;
}

a {
 color: #c75f3e;
}

#mytable {
 width: 660px;
 padding: 0;
 margin: 0;
}

caption {
 padding: 0 0 5px 0;
 width: 660px;  
 font: italic 13px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
 text-align: right;
}

th {
 font: bold 13px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
 color: #4f6b72;
 border-right: 1px solid #C1DAD7;
 border-bottom: 1px solid #C1DAD7;
 border-top: 1px solid #C1DAD7;
 letter-spacing: 2px;
 text-transform: uppercase;
 text-align: left;
 padding: 6px 6px 6px 12px;
}

th.nobg {
 border-top: 0;
 border-left: 0;
 border-right: 1px solid #C1DAD7;
 background: none;
}

#mytable td {
 border-right: 1px solid #C1DAD7;
 border-bottom: 1px solid #C1DAD7;
 background: #fff;
 font-size:11px;
 padding: 6px 6px 6px 12px;
 color: #4f6b72;
}

.lanyuan_bb{
border-bottom: 1px solid #C1DAD7;
}

td.alt {
 background: #F5FAFA;
 color: #797268;
}

th.spec {
 border-left: 1px solid #C1DAD7;
 border-top: 0;
 background: #fff ;
 font: bold 10px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
}

th.specalt {
 border-left: 1px solid #C1DAD7;
 border-top: 1px solid #C1DAD7;
 background: #f5fafa ;
 font: bold 13px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
 color: #797268;
}
/*---------for IE 5.x bug*/
html>body td{ font-size:13px;}
</style>
<script type="text/javascript">
function smenu(obj,id){  
	  $("input[_key='menu_1_"+id+"']").each(function(){
	   $(this).attr("checked",obj.checked);
	  });
	  $("input[_key='menu_1_1_"+id+"']").each(function(){
		   $(this).attr("checked",obj.checked);
		  });
};
function menu_1(obj,id,pid){  
	  $("input[_key_2='menu_1_1_"+id+"']").each(function(){
		   $(this).attr("checked",obj.checked);
	});
	  if(obj.checked==true){
		  $("input[_key='menu_"+pid+"']").each(function(){
			   $(this).attr("checked",obj.checked);
		});
	  }
};
function menu_1_1(obj,id,pid){  
	if(obj.checked==true){
		  $("input[_key_1='menu_1_1_"+id+"']").each(function(){
			   $(this).attr("checked",obj.checked);
		});
		  $("input[_key='menu_"+pid+"']").each(function(){
			   $(this).attr("checked",obj.checked);
		});
	}
}
function closeWin(){
	jQuery.ligerDialog.confirm('确定关闭吗?', function(confirm) {
		if (confirm) {
			parent.tab.removeSelectedTabItem();
		}
	});
}
function sub(){
	if ("${param.roleId}" != "") {
		$.ajax({
			async : false, //请勿改成异步，下面有些程序依赖此请数据
			type : "POST",
			data : $("#from").serialize(),
			url : rootPath + '/background/resources/addRoleRes.html',
			dataType : 'json',
			success : function(json) {
				if (json.flag == "true") {
					parent.$.ligerDialog.confirm('分配成功！是否关闭窗口？', function(yes) {
						if(yes){
							parent.tab.removeSelectedTabItem();
						}
					});
				} else {
					$.ligerDialog.error("分配失败！！");
				}
				;
			}
		});
		// window.location="${pageContext.servletContext.contextPath }/function/addRoleFun?roleId=${roleId}&functionId="+fids;
	} else {
		$.ligerDialog.warn("该账号还没有分配角色或账号的角色被删除了，请重新分配角色！！");
	};
}
</script>
<body>
<div class="divdialog">
<form method="post" id="from" name="form">
<input type="hidden" name="roleId" id="roleId" value="${param.roleId}">
<table id="mytable" cellspacing="0" summary="The technical specifications of the Apple PowerMac G5 series">
 <tr>
    <th scope="row" abbr="L2 Cache" class="specalt">一级菜单</th>
    <th scope="row" abbr="L2 Cache" class="specalt"><span>二级菜单</span><span style="float: right;margin-right: 150px;">按扭</span></th>
  </tr>
  <c:forEach items="${permissions}" var="k">
  <tr>
    <th scope="row" abbr="L2 Cache" class="specalt" width="140px">
    <input type="checkbox" name="id" id="menu" _key="menu_${k.id}" onclick="smenu(this,'${k.id}')" value="${k.id}">
    ${k.name}
    </th>
    <th scope="row" abbr="L2 Cache" class="specalt">
    <table id="mytable" cellspacing="0" summary="The technical specifications of the Apple PowerMac G5 series" style="width: 100%;height: 100%;">
    <c:forEach items="${k.children}" var="kc">
    <tr>
    <th scope="row" abbr="L2 Cache" class="specalt">
    <input type="checkbox"  name="id" id="menu" _key="menu_1_${k.id}" _key_1="menu_1_1_${kc.id}" onclick="menu_1(this,'${kc.id}','${k.id}')"  value="${kc.id}">
    ${kc.name}
    </th>
     <th>
    <c:if test="${not empty kc.children}">
   
    <table id="mytable" cellspacing="0" summary="The technical specifications of the Apple PowerMac G5 series" style="width: 100%;height: 100%;">
    <c:forEach items="${kc.children}" var="kcc">
    <tr>
    <th scope="row" abbr="L2 Cache" class="specalt">
    <input type="checkbox"  name="id" id="menu" _key="menu_1_1_${k.id}" _key_2="menu_1_1_${kc.id}" onclick="menu_1_1(this,'${kc.id}','${k.id}')" value="${kcc.id}">
    ${kcc.name}
    </th>
     </tr>
    </c:forEach>
   
    </table>
    
    </c:if>
    </th>
     </tr>
    </c:forEach>
   
    </table>
    </th>
  </tr>
</c:forEach>
<tr>
<td colspan="10">
<div class="l_btn_centent">
		<!-- saveWin_form   from是表单Ｉd-->
		<a class="btn btn-primary" href="javascript:void(0)"
			id="saveWin_form" onclick="sub();"><span>保存</span> </a>
			 　　
			 <a class="btn btn-primary" href="javascript:void(0)" id="closeWin"
			onclick="closeWin()"><span>关闭</span> </a>
	</div></td>
</tr>
</table>
	</form>
	</div>
	<script type="text/javascript">
	if('${param.roleId}'!=''){
		$.ajax({
			async : false, //请勿改成异步，下面有些程序依赖此请数据
			type : "POST",
			//data : $("#from").serialize(),
			url : rootPath + '/background/resources/findRoleRes.html?roleId=${param.roleId}',
			dataType : 'json',
			success : function(json) {
				for(index in json){
					$("input:checkbox[value='"+json[index].id+"']").attr('checked','true');
				}
			}
		});
	}
	</script>
</body>
</html>