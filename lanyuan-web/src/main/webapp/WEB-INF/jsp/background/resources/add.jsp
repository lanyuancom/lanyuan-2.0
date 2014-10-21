<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/common/header.jsp"%>
<script type="text/javascript">
	$(function() {
		
		bydic("res_type","type");//调用字典ajax
		
		$("form").validate({
			submitHandler : function(form) {//必须写在验证前面，否则无法ajax提交
				$(form).ajaxSubmit({//验证新增是否成功
					type : "post",
					dataType:"json",
					success : function(data) {
						if (data.flag == "true") {
							$.ligerDialog.success('提交成功!', '提示', function() {
								parent.resources.loadGird();
								closeWin();
							});
							//parent.window.document.getElementById("username").focus();
						} else {
							$.ligerDialog.warn("提交失败！！");
						}
					}
				});
			},
			rules : {
				name : {
				required : true,
				remote:{ //异步验证是否存在
					type:"POST",
					url: rootPath + '/background/resources/isExist.html',
					data:{
						name:function(){return $("#name").val();}
					 }
					}
				},
				resKey : {
					required : true
				},
				resUrl : {
					required : true
				}
			},
			messages : {
				name : {
					required : "菜单名称不能为空",
				    remote:"该菜单名称已经存在"
				},
				resKey : {
					required : "菜单标识不能为空"
				},
				resUrl : {
					required : "url连接不能为空"
				}
			},
			errorPlacement : function(error, element) {//自定义提示错误位置
				$(".l_err").css('display','block');
				//element.css('border','3px solid #FFCCCC');
				$(".l_err").html(error.html());
			},
			success: function(label) {//验证通过后
				$(".l_err").css('display','none');
			}
		});
	});
	function saveWin() {
		$("#form").submit();
	}
	function closeWin() {
		 parent.$.ligerDialog.close(); //关闭弹出窗; //关闭弹出窗
		parent.$(".l-dialog,.l-window-mask").css("display","none"); 
	}
	
</script>
</head>
<body>
<div class="divdialog">
	<div class="l_err" style="width: 270px;"></div>
	<form name="form" id="form" action="${ctx}/background/resources/add.html" method="post">
		<table style="width: 285px; height: 230px;">
			<tbody>
				<tr>
					<td class="l_right">菜单名称：</td>
					<td class="l_left">
						<div class="lanyuan_input">
								<input id="name" name="name" class="checkdesc" type="text">
						</div>
					</td>
				</tr>
				<tr>
					<td class="l_right">菜单标识：</td>
					<td class="l_left">
					<div class="lanyuan_input">
					 <input type="text" name="resKey" id="resKey" >
					 </div>
					</td>
				</tr>
				<tr>
					<td class="l_right">url连接：</td>
					<td class="l_left">
					<div class="lanyuan_input">
					<input id='resUrl'
						name="resUrl" type="text" class="checkdesc" >
						</div>
						</td>
				</tr>
				<tr>
					<td class="l_right">上级菜单：</td>
					<td class="l_left">
					<select name="parentId" id="parentId" style="width: 140px;">
					<option value="0">--请选择--</option>
					<c:forEach items="${resources}" var="key">
					<option value="${key.id}">${key.name}</option>
					</c:forEach>
					</select>
					</td>
				</tr>
				<tr>
					<td class="l_right">菜单类型：</td>
					<td class="l_left">
					<select name="type" id="type" style="width: 140px;">
							 <option value="">--请选择--</option>
<!-- 						 <option value="0" >目录</option> -->
<!-- 						 <option value="1" >菜单</option> -->
<!-- 						 <option value="2" >按钮</option> -->
					</select>
						</td>
				</tr>
				<tr>
					<td class="l_right">菜单描述：</td>
					<td class="l_left">
					<div class="lanyuan_input">
						<input id='description' name="description"   type="text" > 
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div class="l_btn_centent">
								<!-- saveWin_form   from是表单Ｉd-->
								<a class="btn btn-primary" href="javascript:void(0)"
									id="saveWin_form" onclick="saveWin();"><span>保存</span> </a> <a
									class="btn btn-primary" href="javascript:void(0)" id="closeWin"
									onclick="closeWin()"><span>关闭</span> </a>
							</div>
						</td>
				</tr>
			</tbody>
		</table>
	</form>
	</div>
</body>
</html>