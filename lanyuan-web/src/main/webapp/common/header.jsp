<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %> 
<%
 String contextPath = request.getContextPath();
%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<title>蓝缘管理系统</title>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
<META HTTP-EQUIV="Expires" CONTENT="0"> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${ctx}/css/basic.css" />
<link href="${ctx}/ligerUI/skins/koala/css/style-all.css" rel="stylesheet" type="text/css" />  
 <script src="${ctx}/js/jquery-1.8.3.js"></script>
<script type="text/javascript" src="${ctx}/js/jquery.form.js"></script>
<script type="text/javascript" src="${ctx}/js/jquery-validation/jquery.validate.min.js"></script>
<script type="text/javascript" src="${ctx}/js/jquery-validation/messages_cn.js"></script>
<script type="text/javascript" src="${ctx}/ligerUI/js/ligerui.min.js"></script>
<script type="text/javascript" src="${ctx}/ligerUI/js/plugins/ligerDialog.js"></script>
 <script src="${ctx}/js/lyGrid.js" type="text/javascript"></script>
<link href="${ctx}/css/lanyuan.css" rel="stylesheet">
<script type="text/javascript">
var rootPath = "${ctx}";
document.oncontextmenu=new Function('event.returnValue=false;');
//禁止选中
//document.onselectstart=new Function('event.returnValue=false;');
//单独验证某一个input  class="isNum"
function loadingShow(){
	$("body").append('<div class="divshow" style="display: none" id="divshow"></div>');
	document.getElementById("divshow").style.display="block"; 
    var loadingContainer = $("div.loading");
    if (loadingContainer.length <= 0) {

        loadingContainer = $("<div>", { Class: "loadingWhenSave" , id:"loadingWhenSave" });
        var img = $("<img>", { src: "${pageContext.request.contextPath}/images/loading.gif" });
        loadingContainer.html("");
        loadingContainer.append(img).css({
            position: "absolute", //"absolute",
            zIndex: "9999",
            textAlign: "center",
           // backgroundColor: "#000",
            border: "solid 1px back",
            paddingTop: "18px",
            fontSize: "14px",
            top: "30%",
            left: "40%"
           // height: "20px",
           // width: "20px"
        });
        //document.body.appendChild(loadingContainer);
        loadingContainer.appendTo('body');
    }
    //$(loadingContainer).show();
}

function loadingHide(){
	document.getElementById("divshow").style.display="none";  
    $("#loadingWhenSave").remove();
}
//根据字典类型返回  byId显示的位置id
function bydic(type,byId){
	//异步加载所有菜单列表
	$.ajax({
	    type: "post", //使用get方法访问后台
	    dataType: "json", //json格式的数据
	    async: true, //同步   不写的情况下 默认为true
	    url: rootPath + '/background/dic/findDicType.html', //要访问的后台地址
	    data:{"dicTypeKey":type},
	    success : function(data){
	    	for(var i = 0; i < data.length;i++)
	    	$("#"+byId).append("<option value='"+data[i].dicKey+"'>"+data[i].dicName+"</option>");
		}
});
}

function bydicType(type,byId){
	//异步加载所有菜单列表
	$.ajax({
	    type: "post", //使用get方法访问后台
	    dataType: "json", //json格式的数据
	    async: true, //同步   不写的情况下 默认为true
	    url: rootPath + '/background/dicType/findDicType.html', //要访问的后台地址
	    //data:{"dicTypeKey":type},
	    success : function(data){
	    	for(var i = 0; i < data.length;i++)
	    	$("#"+byId).append("<option value='"+data[i].id+"'>"+data[i].dicTypeName+"</option>");
		}
});
}

function getSelectBydicType(byId,value){
	//异步加载所有菜单列表
	$.ajax({
	    type: "post", //使用get方法访问后台
	    dataType: "json", //json格式的数据
	    async: true, //同步   不写的情况下 默认为true
	    url: rootPath + '/background/dicType/findDicType.html', //要访问的后台地址
	    //data:{"dicTypeKey":type},
	    success : function(data){
	    	for(var i = 0; i < data.length;i++)  	
		    	{	
		    	  $("#"+byId).append("<option value='"+data[i].id+"'>"+data[i].dicTypeName+"</option>");
		    	}	
	    
	    	obj=document.getElementById(byId).options;
	    	for(i=0,k=obj.length;i<k;i++){
	    	   if(obj[i].value==value){
	    	    obj[i].selected=true;
	    	    break;
	    	   }
	    	}
	    	
		}
});
	
}

function getSelectByName(byId,value,parentId){
	//异步加载所有菜单列表
	$.ajax({
	    type: "post", //使用get方法访问后台
	    dataType: "json", //json格式的数据
	    async: true, //同步   不写的情况下 默认为true
	    url: rootPath + '/background/resources/queryParentId.html?type='+value, //要访问的后台地址
	    //data:{"dicTypeKey":type},
	    success : function(data){
	    	for(var i = 0; i < data.length;i++)
		     {$("#"+byId).append("<option value='"+data[i].id+"'>"+data[i].name+"</option>");
		    }	  		
	    	
	    	obj=document.getElementById(byId).options;
	    	for(i=0,k=obj.length;i<k;i++){
	    	   if(obj[i].value==parentId){
	    	    obj[i].selected=true;
	    	    break;
	    	   }
	    	}
	    	
		}
});
	
}
//查找回传的选项并选中
function selectCheck(id,value)
{
    //获得下拉列表的id
    var select = document.getElementById(id);
    //获得下拉列表的所有option
    var options = select.options;
    //循环获得对应的节点
    for(var i=0;i<options.length;i++)
    {
     //获得节点的值和后台传来的值进行比较
      if (options[i].value == value)
      {
      //如果当前节点与后台传来的值一致，则将当前节点设置为选中状态，并跳出循环
       options[i].selected = true;
       break;
      }
    }
 }
 
function closeWin() {
	 parent.$.ligerDialog.close(); //关闭弹出窗; //关闭弹出窗
	parent.$(".l-dialog,.l-window-mask").css("display","none"); 
}
</script>
<style type="text/css">
.l_err{
    background: none repeat scroll 0 0 #FFFCC7;
    border: 1px solid #FFC340;
    font-size: 12px;
    padding: 4px 8px;
    width: 200px;
    display: none;
}
.error{
  border: 3px solid #FFCCCC;
}
</style>