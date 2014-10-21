<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/common/header.jsp"%>
<script type="text/javascript">
	var dialog;
	var grid;
	$(function() {
		grid = window.lanyuan.ui.lyGrid({
					id : 'paging',
					l_column : [ {
						colkey : "id",
						name : "id",
						width : "50px",
						hide : true
					}, {
						colkey : "username",
						name : "账号"
					}, {
						colkey : "module",
						name : "模块"
					}, {
						colkey : "action",
						name : "方法"
					}, {
						colkey : "actionTime",
						name : "响应时间",
							width : "150px"
					} , {
						colkey : "userIP",
						name : "IP地址"
					}, {
						colkey : "operTime",
						name : "执行时间"
					}],
					jsonUrl : '${pageContext.request.contextPath}/background/log/query.html',
					checkbox : false
				});
		$("#seach").click("click", function() {//绑定查询按扭
			var searchParams = $("#fenye").serializeJson();
			grid.setOptions({
				data : searchParams
			});
		});
	});
	function loadGird(){
		grid.loadData();
	}
</script>
</head>
<body>
	<div class="divBody">
		<div class="search">
			<form name="fenye" id="fenye">
				账号：<input type="text" name="username" value="${param.name}"
					style="height: 20px" /> <a class="btn btn-primary"
					href="javascript:void(0)" id="seach"> <span>查询</span>
				</a>
			</form>
		</div>
		<div id="paging" class="pagclass"></div>
	</div>
</body>
</html>