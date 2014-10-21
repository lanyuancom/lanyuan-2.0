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
				colkey : "name",
				name : "菜单名称",
				align : 'left'
			}, {
				colkey : "type",
				name : "菜单类型",
				width : "70px",
			}, {
				colkey : "resKey",
				name : "唯一KEY"
			}, {
				colkey : "resUrl",
				name : "URL地址"
			}, {
				colkey : "description",
				name : "描述"
			} ],
			jsonUrl : '${ctx}/background/resources/resources.html',
			checkbox : true,
			usePage : false,
			records : "resourceslists",
			treeGrid : {
				tree : true,
				name : 'name'
			}
		});
		$("#rowline").click("click", function() {//update排序
			var row = grid.rowline();//数组对象默认是{"rowNum":row,"rowId":cbox};
			var data = [];
			$.each(row, function(i) {
				data.push("resources[" + i + "].level=" + row[i].rowNum);
				data.push("resources[" + i + "].id=" + row[i].rowId);
			});
			grid.setOptions({
				jsonUrl : rootPath + '/background/resources/sortUpdate.html',
				data : data.join("&")
			});
		});
		$("#lyGridUp").click("click", function() {//上移
			grid.lyGridUp();
		});
		$("#lyGridDown").click("click", function() {//下移
			grid.lyGridDown();
		});
		$("#seach").click("click", function() {//绑定查询按扭
			var searchParams = $("#fenye").serializeJson();
			grid.setOptions({
				data : searchParams
			});
		});
		$("#add").click("click", function() {//绑定查询按扭
			dialog = parent.$.ligerDialog.open({
				width : 315,
				height : 300,
				url : rootPath + '/background/resources/addUI.html',
				title : "增加菜单",
				isHidden : false
			//关闭对话框时是否只是隐藏，还是销毁对话框
			});
		});
		$("#editView").click(
				"click",
				function() {//绑定查询按扭
					var cbox = grid.getSelectedCheckbox();
					if (cbox.length > 1 || cbox == "") {
						parent.$.ligerDialog.alert("只能选中一个");
						return;
					}
					dialog = parent.$.ligerDialog.open({
						width : 350,
						height : 310,
						url : rootPath
								+ '/background/resources/editUI.html?resourcesId='
								+ cbox,
						title : "修改账号",
						isHidden : false
					});
				});
		$("#deleteView")
				.click(
						"click",
						function() {//绑定查询按扭
							var cbox = grid.getSelectedCheckbox();
							if (cbox == "") {
								parent.$.ligerDialog.alert("请选择删除项！！");
								return;
							}
							var u = "";
							$.each(cbox, function(i, item){      
							      if(item<=41){
							    	  u="y";
							      };   
							}); 
							if(u!=""){
								 parent.$.ligerDialog.warn("原数据禁止删除！你的IP已经记录！有问题请联系管理员 －－ 蓝缘");
						    	  parent.$.ligerDialog.alert("请先新增一条数据再进行删除！");
						    	  return;
							}
							parent.$.ligerDialog
									.confirm(
											'删除后不能恢复，确定删除吗？',
											function(confirm) {
												if (confirm) {
													$
															.ajax({
																type : "post", //使用get方法访问后台
																dataType : "json", //json格式的数据
																async : false, //同步   不写的情况下 默认为true
																url : rootPath
																		+ '/background/resources/deleteById.html', //要访问的后台地址
																data : {
																	ids : cbox
																			.join(",")
																}, //要发送的数据
																success : function(
																		data) {
																	if (data.flag == "true") {
																		parent.$.ligerDialog
																				.success(
																						'删除成功!',
																						'提示',
																						function() {
																							loadGird();//重新加载表格数据
																						});
																	} else {
																		parent.$.ligerDialog
																				.warn("删除失败！！");
																	}
																}
															});
												}
											});
						});
	});
	function loadGird() {
		grid.loadData();
	}
</script>
</head>
<body>
	<div class="divBody">
		<div class="search">
			<form name="fenye" id="fenye">
				名称：<input type="text" name="name" value="${param.name}"
					style="height: 20px" /> <a class="btn btn-primary"
					href="javascript:void(0)" id="seach"> <span>查询</span>
				</a>
			</form>
		</div>
		<div class="topBtn">
			<a class="btn btn-primary" href="javascript:void(0)" id="add"> <i
				class="icon-zoom-add icon-white"></i> <span>add</span>
			</a>
			<!-- <a class="btn btn-success" href="javascript:void(0)"> <i
				class="icon-zoom-in icon-white" id="View"></i> View
			</a> -->
			<a class="btn btn-info" href="javascript:void(0)" id="editView">
				<i class="icon-edit icon-white"></i> Edit
			</a> <a class="btn btn-danger" href="javascript:void(0)" id="deleteView">
				<i class="icon-trash icon-white"></i> Delete
			</a>
			<a class="btn btn-large btn-success" href="javascript:void(0)" id="lyGridUp">
				上移
			</a>
			<a class="btn btn-large btn-success" href="javascript:void(0)" id="lyGridDown">
				下移
			</a>
			<a class="btn btn-large btn-success" href="javascript:void(0)" id="rowline">
				更新排序
			</a>
			
		</div>
		<div id="paging" class="pagclass"></div>
	</div>
</body>
</html>