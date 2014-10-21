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
						width : "50px"
					}, {
						colkey : "name",
						name : "角色名"
					}, {
						colkey : "enable",
						name : "是否禁用",
						width:"70px"
					},{
						colkey : "description",
						name : "描述"
					} ],
					jsonUrl : '${pageContext.request.contextPath}/background/role/queryAll.html',
					checkbox : true,
					usePage:false,
					records : "roles",
					height:"180px"
				});
	});
	function sub(){
		var cbox=grid.getSelectedCheckbox();
		if (cbox=="") {
			parent.$.ligerDialog.alert("请选择一条数据!");
			return;
		}
		$.ajax({
			async : false, //请勿改成异步，下面有些程序依赖此请数据
			type : "POST",
			data : {accountId:"${param.id}",ids:cbox.join(",")},
			url : rootPath + '/background/role/addAccRole.html',
			dataType : 'json',
			success : function(json) {
				if (json.flag == "true") {
					parent.$.ligerDialog.confirm('分配成功!', function(yes) {
						parent.account.loadGird();
						closeWin();
					});
				} else {
					$.ligerDialog.error("分配失败！！");
				}
				;
			}
		});
	}
</script>
</head>
<body>
	<div class="divBody">
	<div class="topBtn">
			<table class="table table-striped">
				<tr>
					<td width="65px" style="text-align: right;">账号名:</td>
					<td>${accountName}</td>
				</tr>
				<tr>
					<td style="text-align: right;">所属角色:</td>
					<td>${roleName}</td>
				</tr>
			</table>
		</div>
		<div id="paging" class="pagclass"></div>
		<div class="topBtn"  style="text-align: center;">
			<a class="btn btn-info" href="javascript:void(0)" onclick="sub()"> 保存
			</a>　　　　
			<a class="btn btn-info" href="javascript:void(0)"  onclick="closeWin()"> 关闭
			</a>
		</div>
	</div>
</body>
</html>