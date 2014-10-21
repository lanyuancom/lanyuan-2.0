<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/common/header.jsp"%>
<script type="text/javascript">
	var tab;
	function addTabEvent(tabid, text, url) {
		tab.removeTabItem(tabid);
		tab.addTabItem({
			tabid : tabid,
			text : text,
			url : url
		});
		tab.reload(tabid);
	}
	function divsize() {
		var h = document.getElementById("bom").offsetTop;
		$(".cl_body").css("height", h - 32);
		$(".l_body").css("height", h - 38);
	}

	var grid;
	$(function() {
		var h = document.getElementById("bom").offsetTop;
		$(".cl_body").css("height", h - 38);
		$(".leftTree").css("height", h - 40);

		$(".leaf .leaf_body").css("height", h / 2 - 24 - 38);
		$(".l_flow-btn").toggle(function() {
			$(".l_container .container").slideUp(1000);
			$(".l_container .leafSet").slideDown(1000);
			//$(".l_body").css("background","none repeat scroll 0 0 #FAFAFA");
		}, function() {

			$(".l_container .container").slideDown(1000);
			$(".l_container .leafSet").slideUp(1000);
		});

		tab = $("#framecenter").ligerTab({
			height : h - 40
		});
		$.ajax({
			async : false, //请勿改成异步，下面有些程序依赖此请数据
			type : "POST",
			//data : $("#from").serialize(),
			url : '${ctx}/background/resources/resources.html?id='+<%=request.getSession().getAttribute("userSessionId").toString()%>,
			dataType : 'json',
			success : function(json) {
				var ul = $("#menu");
				ul.html('');
				var li ='';
				var data = json.resourceslists;
				$.each(data, function(i) {

					li+='<li class="level1"><a href="javascript:void(0)">'+data[i].name+'</a>';
					li+='<ul class="level2" id="level2_'+i+'">';
					var jdata = data[i].children;
					$.each(jdata, function(j) {
						li+='<li><a href="${pageContext.request.contextPath}'+jdata[j].resUrl+'" id="level2_'+jdata[j].resKey+'" name="'+jdata[j].name+'">'+jdata[j].name+'</a></li>';
					});
					li+='</ul></li>';
				});
				ul.html(li);
			}
		});
		//  $("#framecenter").ligerGetTabManager();
		$('a[id^="level2_"]').unbind('click').bind('click', function(e) {
			var sid = this.id;
			sid = sid.substring(sid.indexOf("level2_")+7, sid.length);
			var name = this.name;
			var url = this.href;
			addTabEvent(sid, name, url);
			return false;
		});
	});
</script>
<style type="text/css">
.leaf .leaf_body{
	font-size: 12px;
}
.skin ul {
	margin: 0;
	padding-top: 5px;
	width: 380px;
}

.skin ul li {
	list-style-type: none;
	float: left;
	cursor: pointer;
	margin-top: 5px;
}
.skin ul li span{
	list-style-type: none;
	float: left;
	width: 20px;
	height: 20px;
	cursor: pointer;
}
.skin {
	height: 100%;
	background: #FAFAFA;
	border-bottom: solid 1px #cccc;
	top: 0;
	left: 0;
	width: 100%;
	overflow: hidden; 
	text-overflow: ellipsis; 
}

.black {
	background: #000;
} /*黑色*/

/*白色*/
.white {
	background: #FFFFFF;
}

/*浅绿*/
.light_green {
	background: #8cc540;
}

/*深绿*/
.dark_green {
	background: #009f5d;
}

/*暗蓝*/
.dark_blue {
	background: #019fa0;
}

/*蓝色*/
.blue {
	background: #019fde;
}

/*深蓝*/
.shen_blue {
	background: #007cdc;
}

/*深紫*/
.dark_purple {
	background: #887ddd;
}

/*浅紫*/
.light_purple {
	background: #cd7bdd;
}

/*粉色*/
.pink {
	background: #ff5675;
}

/*红色*/
.red {
	background: #ff1244;
}

/*橙色*/
.orange {
	background: #ff8345;
}

/*黄色*/
.yellow {
	background: #f8bd0b;
}

/*灰色*/
.gray {
	background: #d1d2d4;
}

.img01 {
	background: url("${ctx}/images/img01.jpg");
}
.img02 {
	background: url("${ctx}/images/img02.jpg");
}
.img03 {
	background: url("${ctx}/images/img03.jpg");
}
#lta table td {
	border: solid 1px #000000;
	padding: 10px;
}
</style>
<script type="text/javascript">
	$(document).ready(
			function() {
				//为了安全 google chrome 等浏览器是禁止本地文件写Cookie的即file:///F:/Lord%20community/test/Untitled-2.html这样的以file开头的是不能写本地文件的
				var cookieClass = getCookie('class');//读取需要缓存的对象。
				$("body").attr("class", cookieClass);//
				$(".skin_list li span").each(
						function() {
							$(this).click(
									function() {
										var className = $(this).attr("class");//保存当前选择的类名
										$("body").attr("class", className, 30);//把选中的类名给body
										function SetCookie(name, value, day)//两个参数，一个是cookie的名子，一个是值
										{
											var exp = new Date(); //new Date("December 31, 9998");
											exp.setTime(exp.getTime() + day
													* 24 * 60 * 60 * 1000);
											document.cookie = name + "="
													+ escape(value)
													+ ";expires="
													+ exp.toGMTString();
										}
										SetCookie("class", className, 30);
									});
						});
			});
	function getCookie(name)//取cookies函数       
	{
		var nameEQ = name + "=";
		var ca = document.cookie.split(';');
		for ( var i = 0; i < ca.length; i++) {
			var c = ca[i];
			while (c.charAt(0) == ' ')
				c = c.substring(1, c.length);
			if (c.indexOf(nameEQ) == 0)
				return c.substring(nameEQ.length, c.length);
		}
		return null;
	}
</script>
</head>

<body onresize="divsize();">

	<div class="l_header" id="l_header">
		<span class="l_flow-btn" style="z-index: 0">主页</span>
	</div>


	<div class="l_body">
		<div class="l_container">

			<div class="container">

				<div id="part1" class="leaf one">
					<div class="leaf_body">
					<div class="skin">
					<div style="font-size: 20px;text-align: left;font-weight: 800;padding: 10px;color: red;">
					猛击左上角的主页!
					</div>
					
  <div style="PADDING-RIGHT:0px; PADDING-LEFT:0px; PADDING-BOTTOM:0px; PADDING-TOP:0px; WIDTH:100%; HEIGHT:148px; border:1px solid #cacaca;background: #FFFFFF">
            <div style="WIDTH:100%; clear:both; height:31px; background-image:url(http://www.tianqi.com/static/images/code/bg_13.jpg); background-repeat:repeat-x; border-bottom:1px solid #cacaca;">
                <div style="float:left; height:31px; color:#9e0905; font-weight:bold; line-height:31px; margin-left:20px; font-size:14px; ">城市天气预报</div>
               
            </div>
	   <iframe width="400" scrolling="no" height="120" frameborder="0" allowtransparency="true" src="http://i.tianqi.com/index.php?c=code&id=19&bgc=%23FFFFFF&bdc=%23&icon=1&temp=1&num=2"></iframe>
	</div>
	</div>
						</div>
				</div>

				<div id="part1" class="leaf one">
					<div class="leaf_body">

						<div class="skin">
						<table>
						<tr>
						<td width="80px" valign="top" style="padding-top: 10px;">更换背景：</td>
						<td><ul class="skin_list">
								<li> <span class="red"></span>&nbsp;红色&nbsp;</li>
								<li> <span class="black"></span>&nbsp;黑色&nbsp;</li>
								<li> <span class="white"></span>&nbsp;白色&nbsp;</li>
								<li> <span class="gray"></span>&nbsp;灰色&nbsp;</li>
								<li> <span class="yellow"></span>&nbsp;黄色&nbsp;</li>
								<li> <span class="orange"></span>&nbsp;橙色&nbsp;</li>
								<li> <span class="pink"></span>&nbsp;粉色&nbsp;</li>
								<li> <span class="light_purple"></span>&nbsp;浅紫&nbsp;</li>
								<li> <span class="dark_purple"></span>&nbsp;深紫&nbsp;</li>
								<li> <span class="shen_blue"></span>&nbsp;深蓝&nbsp;</li>
								<li> <span class="blue"></span>&nbsp;蓝色&nbsp;</li>
								<li> <span class="dark_blue"></span>&nbsp;暗蓝&nbsp;</li>
								<li> <span class="light_green"></span>&nbsp;浅绿&nbsp;</li>
								<li> <span class="dark_green"></span>&nbsp;深绿&nbsp;</li>
							</ul></td>
						</tr>
						<tr>
						<td width="80px" valign="top" style="padding-top: 10px;">背景图片：</td>
						<td><ul class="skin_list">
								<li> <span class="img02" style="width: 100px;height: 100px;"></span>&nbsp;</li>
								<li> <span class="img03" style="width: 100px;height: 100px;"></span>&nbsp;</li>
								<li> <span class="img01" style="width: 100px;height: 100px;"></span></li>
							</ul></td>
						</tr>
						</table>
							
						</div>

					</div>
				</div>
				<div id="part1" class="leaf one">
					<div class="leaf_body">
					<div class="skin">
						<div style="font-size: 14px;text-align: left;padding: 10px;">
							感谢捐助者:<br>
							沧海一粟 200元　Alias 5元　Could 10元　lee 100元　逗留 5元  小滴棍 50元 张XX名 4元  apache 5元 明月不懂20
							翱翔-北京 50元       老周 50元    天涯无痕 50元    其实我很Z 4元   小胖 50元  南大西洋 10元　回忆　20元　王懿　50元　初来乍到　50
							久成　5元　　修成　30元　何银　5元　小张　6元　　家铭　1元　
							(可能有些忘记了写上,可以联系我,我补上,非常感谢各位)
						</div>
</div>
					</div>
				</div>懿

				<div id="part1" class="leaf one">
					<div class="leaf_body">
					<div class="skin">
					<table style="width:100%;height: 100%;">
					<tr>
					<td style="font-size: 17px;color: blue;padding-top: 20px;" valign="top">感谢捐助:</td>
					<td align="left" style="font-size: 14px;color: blue;">
					以下是蓝缘系统捐助的支付页面，由于空间网站需求收费，故此征集大家为蓝缘系统做一点贡献，有了你的支持，蓝缘系统将做得更好，服务开源，献身开源！再次致谢 ！
					</td>
					</tr>
					<tr>
					<td>支付宝账号是:</td>
					<td style="font-size: 17px;color: blue;">mmm333zzz520@163.com</td>
					</tr>
					<tr>
					<td width="116"><img alt="蓝缘系统的支付连接" src="${ctx}/images/zhifubao.png"></td>
					<td >
					<span title="蓝缘系统的支付连接" style="font-size: 17px;color: blue;" >支付地址已经关闭,亲可以直接转到支付宝账号上，记得备注哦！</span></td>
					<td style="font-size: 17px;color: red;">
					捐助请备注哦！谢谢！</td>
					</tr>
					<tr>
					<td>技术支持:</td>
					<td style="font-size: 17px;color: blue;">QQ:421828229</td>
					</tr>
					<tr>
					<td>QQ交流群:</td>
					<td style="font-size: 17px;color: blue;">90993106 (加群请说明来意!)</td>
					</tr>
					</table>
							
							
							</div>

					</div>
				</div>
			</div>

			<div class="leafSet" style="display: none;">
				<div class="cl_body"
					style="background: none repeat scroll 0 0 #FAFAFA; overflow: auto;">
					<div id="divHeght">
						<div class="leftTree">
							<jsp:include page="/menu.jsp"></jsp:include>
						</div>
						<div style="float: right; width: 83%;" id="framecenter">
							<div class="box-content" tabid="home" title="我的主页">

								<div class="topBtn" style="padding-left: 20px;">
								关于新版本的说明：
								<div style="padding-left: 20px;">
									说明：
									<div style="padding-left: 20px;">
									这个版本主要是对原有的蓝缘系统更换UI界面,功能上基本一致,
									但此还在开发当中..... 关于以前版本,不再维护,致力于新版本的开发和维护.
									</div>
									优化：
									<div style="padding-left: 20px;">此版本不再使用前版本在dao层创建session方法来进行数据CRUD,
									用mapper来代替dao,由mybaits自动管理各事务的操作,大大减少代码开发时间.
									</div><div style="padding-left: 20px;">
									此版本开发采用了maven管理工具,不再使用传统的web方式,所有jar所由maven管理!
									</div>
									技术要点：
									<div style="padding-left: 20px;">
									1：此版本采用ajax+js分页,js完成是群主自己写的,有点模仿ligerui的分页实现
									<br>2：列表的表头固定,兼容IE,firefox,google,360的浏览器,其他暂没有测试.<br>
									3：表格排序功能<br>
									4：解决dialog窗口拖动时,阴影变大问题<br>
									5：加入druid技术,对sql语句的监控.<br>
									6：自定义注解导出excel<br>
									7：<font color="blue">使用了ehcache缓存机制</font><br>
									8：<font color="blue">新增支持oracle分页实现</font><br>
									8：<font color="blue">解决分页参数没法传到后台的问题</font><br>
									10：........<br>
								</div>
								<div style="font-size: 14px;color: red;" id="lta">
								下载地址：
								<table width="600px">
								<tr>
								<td width="100px">版本  1.0</td>
								<td>暂缺…………。</td>
								</tr>
								<tr>
								<td>版本  2.0</td>
								<td>
								<a id="lurl" style="color: blue;">点击此处下载！</a>
								<script type="text/javascript">
								var h = location.href;
								h = h.substring(0,h.lastIndexOf("/"));
								h+="/download.html?fileName=lanyuan-2.0.rar";
								$("#lurl").attr("href",h);
								</script>
								
								</td>
								</tr>
								</table>
								</div>
								</div>
								<div>
								最后寻求大家的一点点帮助：
								<div style="padding-left: 20px;">
							          我希望蓝缘有一个自己的网站空间,所有在学习和使用蓝缘系统的同志们捐助1元或2元就行(要求不过分吧!街边吃顿都10元以上啊.....),
							       以下是蓝缘系统捐助的支付页面，由于空间网站需求收费，故此征集大家为蓝缘系统做一点贡献，有了你的支持，蓝缘系统将做得更好，服务开源，献身开源！再次致谢 ！
							     </div>  <br><img alt="蓝缘系统的支付连接" src="${ctx}/images/zhifubao.png" title="蓝缘系统的支付连接">　　支付宝账号是:mmm333zzz520@163.com<br> <span title="蓝缘系统的支付连接" style="font-size: 17px;color: blue;" >支付地址: 支付地址已经关闭,亲可以直接转到支付宝账号上，记得备注哦！</span>
								</div></div>
							</div>
						</div>
					</div>

				</div>
			</div>
		</div>



	</div>

	<div class="bom" id="bom"></div>


</body>

</html>