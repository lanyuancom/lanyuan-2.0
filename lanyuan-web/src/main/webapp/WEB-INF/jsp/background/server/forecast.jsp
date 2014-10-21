<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>定时任务监控管理</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
<META HTTP-EQUIV="Expires" CONTENT="0"> 
<link href="${pageContext.servletContext.contextPath }/css/lanyuan.css" rel="stylesheet">
 <script src="${pageContext.servletContext.contextPath }/js/jquery-1.8.3.js"></script>
<script language="JavaScript" src="${pageContext.servletContext.contextPath }/FusionCharts/FusionCharts.js"></script>
<style type="text/css">
body{
font-size: 12px;
}
.ttab{
text-align: center;
}
input[type="text"] {
    border: 1px solid #DDDDDD;
    color: #333333;
    font-size: 13px;
    outline: medium none;
    width:80px;
    background: none repeat scroll 0 0 #FFFF9D;
}
.block_panel{ float:left;width:99%;}
.block_table{ float:left; width:250px; text-align:left; border:0;}
.block_icon_disk{text-align:center; background:url(${pageContext.request.contextPath}/images/icons/other/disk.jpg) no-repeat;}
.block_icon_cpuInfos{text-align:center; background:url(${pageContext.request.contextPath}/images/icons/other/disk.jpg) no-repeat;}
.block_stat{ background:#FFFFFF; border:#666666 solid 1px; height:15px; width:150px;}

</style>
<script type="text/javascript">
$(function(){
	loadingShow();
	var url = "${pageContext.request.contextPath}/background/serverInfo/warnInfo.html";
	$.ajax({
		type : 'POST',
		url : url,
		dataType : 'json',
		success : function(data) {
		 var tbodyContent="";
		 	tbodyContent = tbodyContent + "<tr>";
		 	tbodyContent = tbodyContent + "<td>CPU</td><td style='padding-left:10px;text-align: left;'>使用率："+data.cpuUsage+"%</td>";
		 	tbodyContent = tbodyContent + "<td>使用率超出 <input class='inputclass' name='cpu' id='cpu' type='text' value='"+data.cpu+"'/> %,发送邮箱提示 <a class='btn btn-primary' href='javascript:void(0)' onclick='modifySer(\"cpu\");'> 查询 </a></td><td rowspan='3'><input class='inputclass'style='width:180px;height:24px;' name='toEmail' id='toEmail' type='text' value='"+data.toEmail+"'/><a class='btn btn-primary' href='javascript:void(0)' onclick='modifySer(\"toEmail\");'> 查询 </a></td>";
		 	 tbodyContent = tbodyContent + "</tr>";
		 	tbodyContent = tbodyContent + "<tr>";
		 	tbodyContent = tbodyContent + "<td>服务器内存</td><td style='padding-left:10px;text-align: left;'>总内存："+data.TotalMem+"<br/>空闲内存："+data.FreeMem+"<br/>使用率："+data.serverUsage+"%</td>";
		 	tbodyContent = tbodyContent + "<td>使用率超出 <input class='inputclass' name='ram' id='ram' type='text' value='"+data.ram+"'/> %,发送邮箱提示 <a class='btn btn-primary' href='javascript:void(0)' onclick='modifySer(\"ram\");'> 查询 </a></td>";
			 tbodyContent = tbodyContent + "</tr>";
			 tbodyContent = tbodyContent + "<tr>";
			 	tbodyContent = tbodyContent + "<td>JVM内存</td><td style='padding-left:10px;text-align: left;'>JVM总内存："+data.JvmTotalMem+"<br/>JVM空闲内存："+data.JvmFreeMem+"<br/>使用率："+data.JvmUsage+"%</td>";
			 	tbodyContent = tbodyContent + "<td>使用率超出 <input class='inputclass' name='jvm' id='jvm' type='text' value='"+data.jvm+"'/> %,发送邮箱提示 <a class='btn btn-primary' href='javascript:void(0)' onclick='modifySer(\"jvm\");'> 查询 </a></td>";
				 tbodyContent = tbodyContent + "</tr>";
		 $('#tbody').html(tbodyContent);
		fchart("CPU使用情况","%", "剩余", (100-data.cpuUsage), "已经使用", data.cpuUsage, "cpu", "cpuchart");
		fchart("内存使用情况","%", "剩余", (100-data.serverUsage), "已经使用", data.serverUsage, "ram", "ramchart");
		fchart("JVM使用情况","%", "剩余", (100-data.JvmUsage), "已经使用", data.JvmUsage, "jvm", "jvmchart");
		 var disk = data.diskInfos;
		 var html = "";
		 if(disk == null || disk == undefined || disk == ""){
			 $('#diskInfos').html("无法获取系统磁盘信息");
			 return;
		 }
		html = createDiskInfosHtml(disk);
		 $('#diskInfos').html(html);
		 loadingHide();
	},
	 error: function (XMLHttpRequest, textStatus, errorThrown) { 
         alert(errorThrown); 
         loadingHide();
 	} 
	});
});
function createDiskInfosHtml(datas){
	var html = "";
	var name;
	var availSize;
	var totalSize;
	var percentSize;
	for(var index in datas){
		var info = datas[index];
		name = "磁盘 "+info['devName'];
		totalSize = info['totalSize'];
		availSize = info['availSize'];
		percentSize = 150 * (info['usedSize']/info['totalSize']);
		html = html + "<table class=\"block_table\">";
		html = html + "<tr><th width=\"20%\">&nbsp;</th><th width=\"80%\">"+name+"</th></tr>";
		html = html + "<tr>";
		html = html + "<td rowspan=\"2\" class=\"block_icon_disk\"></td>";
		html = html + "<td><div class=\"block_stat\"><div style=\"background:#46AF6D;height:15px; width:"+percentSize+"px;\">&nbsp;</div></div></td>";
		html = html + "</tr>";
		html = html + "<tr><td>"+availSize+"G 可用 共"+totalSize+"G </td></tr>";
		html = html + "</table>";
	}
	return html;
}
function modifySer(key){
	$.ajax({
        async: false,
        url: "${pageContext.request.contextPath}/background/serverInfo/modifySer.html",
        data:{"key":key,"value":$("#"+key).val()},
        dataType: "json",
        success: function (data) {
    	    if(data.flag){
    	    	alert("更新成功！");
    	    }else{
    	    	alert("更新失败！");
    	    }
        }
	});
}
 function fchart(name,pen,label1,value1,label2,value2,charId,divId){
  	var text_chart="('<chart baseFontSize=\"12\" caption=\""+name+"\" numberPrefix=\""+pen+"\"><set value=\""+value1+"\" label=\""+label1+"\" color=\"AFD8F8\" /><set value=\""+value2+"\" label=\""+label2+"\" color=\"F6BD0F\" /></chart>')";
	  var chart = new FusionCharts("${pageContext.request.contextPath}/FusionCharts/Pie3D.swf", charId, "335", "200");
	  chart.setDataXML(text_chart);		   
	  chart.render(divId);  
 }
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
</script>
</head>
<body>
<center>
<table class="ttab" width="99%">
  <thead>
  <tr style="background-color:#e8f3fd;">
   <td width="100">名称</td>
    <td width="100">参数</td>
	<td width="275">预警设置</td>
	<td width="275">邮箱设置</td>
  </tr>
  </thead>
<tbody id="tbody">
</tbody>
</table>
<table>
<tr>
<td><div id="cpuchart"></div></td>
<td><div id="ramchart"></div></td>
<td><div id="jvmchart"></div></td>
</tr>
</table>
<h1 style="background-color:#e8f3fd; width:99%;text-align: left;">磁盘信息</h1><br/>
<div class="block_panel" id="diskInfos"></div>
</center>
</body>
</html>