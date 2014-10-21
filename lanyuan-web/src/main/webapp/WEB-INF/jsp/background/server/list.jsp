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
						hide:true
					}, {
						colkey : "cpuUsage",
						name : "cpu使用率",
						width : "70px"
					}, {
						colkey : "setCpuUsage",
						name : "预设cpu使用率",
						width : "100px"
					}, {
						colkey : "jvmUsage",
						name : "Jvm使用率",
						width : "75px"
					}, {
						colkey : "setJvmUsage",
						name : "预设Jvm使用率",
						width : "100px"
					} ,{
						colkey : "ramUsage",
						name : "Ram使用率",
						width : "75px"
					} ,{
						colkey : "setRamUsage",
						name : "预设Ram使用率",
						width : "100px"
					} ,{
						colkey : "email",
						name : "发送的邮件"
					} ,{
						colkey : "operTime",
						name : "发送的时间"
					} ,{
						colkey : "mark",
						name : "备注"
					} ],
					jsonUrl : '${pageContext.request.contextPath}/background/serverInfo/query.html',
					checkbox : true
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
				名称：<input type="text" name="accountName" value="${param.name}"
					style="height: 20px" /> <a class="btn btn-primary"
					href="javascript:void(0)" id="seach"> <span>查询</span>
				</a>
			</form>
		</div>
		<div id="paging" class="pagclass"></div>
	</div>
</body>
</html>