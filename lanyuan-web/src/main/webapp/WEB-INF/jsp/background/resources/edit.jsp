<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/common/header.jsp"%>
<script type="text/javascript">
jQuery.validator.addMethod("checkpass", function(value, element) {
	 return this.optional(element) || ((value.length <= 16) && (value.length>=6));
}, "密码由6至16位字符组合构成");
	$(function() {
		getSelectByName("parentId","${resources.type}","${resources.parentId}");
		selectCheck("type","${resources.type}")
		$("form").validate({
			submitHandler : function(form) {//必须写在验证前面，否则无法ajax提交
				$(form).ajaxSubmit({//验证新增是否成功
					type : "post",
					dataType:"json",
					success : function(data) {
						if (data.flag == "true") {
							$.ligerDialog.success('提交成功!', '提示', function() {
								//这个是调用同一个页面趾两个iframe里的js方法
								//account是iframe的id
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
				state : {
					required : true
				}
			},
			messages : {
				state : {
					required : "选择状态"
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
	$(function() {
		$("input:radio[value='${account.state}']").attr('checked','true');
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
	<form name="form" id="form" action="${ctx}/background/resources/update.html" method="post">
		<table style="width: 285px; height: 200px;">
			<tbody>
				<tr>
					<td class="l_right">菜单名称：</td>
					<td class="l_left">
						<div class="lanyuan_input">
						<input id='id' name="id"  type="hidden" class="" value="${resources.id}">
								<input id="name" name="name" class="checkdesc" type="text" value ="${resources.name}">
						</div>
					</td>
				</tr>
				<tr>
					<td class="l_right">菜单标识：</td>
					<td class="l_left">
					<div class="lanyuan_input">
					 <input type="text" name="resKey" id="resKey" value ="${resources.resKey}">
					 </div>
					</td>
				</tr>
				<tr>
					<td class="l_right">url连接：</td>
					<td class="l_left">
						<div class="lanyuan_input">
						<input id='resUrl' name="resUrl" type="text"  value ="${resources.resUrl}">
						</div>
					</td>
				</tr>
				<tr>
					<td class="l_right">上级菜单：</td>
					<td class="l_left">
					<select name="parentId" id="parentId" style="width: 140px;">
					<option value="0">--请选择--</option>
					
					</select>
					</td>
				</tr>
				<tr>
					<td class="l_right">菜单类型：</td>
					<td class="l_left">
					<select name="type" id="type" style="width: 140px;">
							 <option value="">--请选择--</option>
         					 <option value="0" >目录</option> 
    						 <option value="1" >菜单</option> 
    						 <option value="2" >按钮</option> 
					</select>
						</td>
				</tr>
				<tr>
					<td class="l_right">菜单描述：</td>
					<td class="l_left">
					<div class="lanyuan_input">
						<input id='description' name="description"   type="text" value ="${resources.description}"> 
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