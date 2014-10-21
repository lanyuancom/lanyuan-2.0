/**
 * js表格分页工具组件
 * 
 * @author lanyuan 2014-04-01
 * @Email: mmm333zzz520@163.com
 * @version 1.0v
 */
;
(function() {
	window.lanyuan = {};
	window.lanyuan.ui = {};
	window.lanyuan.ui.lyGrid = (function(params) {
		var confs = {
			l_column : [],
			pagId : 'paging', // 加载表格存放位置的ID
			width : '100%', // 表格高度
			height : '100%', // 表格宽度
			theadHeight : '28px', // 表格的thead高度
			tbodyHeight : '27px',// 表格body的每一行高度
			jsonUrl : '', // 访问后台地址
			usePage : true,// 是否分页
			serNumber : false,// 是否显示序号
			records : 'records',// 分页数据
			pageNow : 'pageNow',// 当前页码 或 当前第几页
			totalPages : 'pageCount',// 总页数
			totalRecords : 'rowCount',// 总记录数
			pagecode : '10',// 分页时，最多显示几个页码
			async : false, // 默认为同步
			data : '', // 发送给后台的数据 是json数据 例如{nama:"a",age:"100"}....
			pageSize : 10, // 每页显示多少条数据
			checkbox : false,// 是否显示复选框
			checkValue : 'id', // 当checkbox为true时，需要设置存放checkbox的值字段 默认存放字段id的值
			treeGrid : {}
		// 树形式 {tree : false,//是否显示树 name : 'name'}//以哪个字段 的树形式
		};
		var l_col = {
			colkey : null,
			name : null,
			width : 'auto',
			height : 'auto',
			align : 'center',
			hide : false
		};
		var l_treeGrid = {
			tree : false,// 是否显示树
			name : 'name'// 以哪个字段 的树形式
		};
		var conf = $.extend(confs, params);
		var l_tree = $.extend(l_treeGrid, conf.treeGrid);
		var col = [];
		for ( var index in conf.l_column) {
			col.push(l_col);
		}
		// var column = jQuery.extend(true, col, confs.l_column);
		for ( var i = 0; i < col.length; i++) {
			for ( var p in col[i])
				if (col[i].hasOwnProperty(p)
						&& (!conf.l_column[i].hasOwnProperty(p)))
					conf.l_column[i][p] = col[i][p];
		}
		;
		var column = conf.l_column;
		var init = function() {
			createHtml();
			fixhead();
		};
		var extend = function(o, n, override) {
			for ( var p in n)
				if (n.hasOwnProperty(p) && (!o.hasOwnProperty(p) || override))
					o[p] = n[p];
		};

		var jsonRequest = function() {
			var json = '';
			$.ajax({
				type : 'POST',
				async : conf.async,
				data : conf.data,
				url : conf.jsonUrl,
				dataType : 'json',
				success : function(data) {
					json = data;
				},
				error : function(msg) {
					alert("数据异常！");
					json = '';
				}
			});
			return json;
		};
		var divid = "";
		var createHtml = function() {

			var jsonData = jsonRequest();
			if (jsonData == '') {
				return;
			}
			var id = conf.pagId;
			divid = typeof (id) == "string" ? document.getElementById(id) : id;
			divid.innerHTML = '';
			cHeadTable(divid);
			cBodyTable(divid, jsonData);
			if (conf.usePage) {// 是否分页
				fenyeDiv(divid, jsonData);
			}
		};
		var cHeadTable = function(divid) {
			var table = document.createElement("table");// 1.创建一个table表
			table.id = "table_head";// 2.设置id属性
			table.className = "pp-list table table-striped table-bordered";
			table.setAttribute("style", "margin-bottom: -3px;");
			divid.appendChild(table);
			var thead = document.createElement('thead');
			table.appendChild(thead);
			var tr = document.createElement('tr');
			tr.setAttribute("style", "line-height:" + conf.tbodyHeight + ";");
			thead.appendChild(tr);
			var cn = "";
			if (!conf.serNumber) {
				cn = "none";
			}
			var th = document.createElement('th');
			th.setAttribute("style",
							"text-align:center;width: 15px;vertical-align: middle;display: "+ cn + ";");
			tr.appendChild(th);
			var cbk = "";
			if (!conf.checkbox) {
				cbk = "none";
			}
			var cth = document.createElement('th');
			cth.setAttribute(
							"style",
							"text-align:center;width: 18px;vertical-align: middle;text-align:center;display: "+ cbk + ";");
			var chkbox = document.createElement("INPUT");
			chkbox.type = "checkbox";
			chkbox.onclick = checkboxbind.bind();
			cth.appendChild(chkbox); // 第一列添加复选框
			tr.appendChild(cth);
			$.each(column, function(o) {
				if (!column[o].hide || column[o].hide == undefined) {
					var th = document.createElement('th');
					th.setAttribute("style", "text-align:" + column[o].align
							+ ";width: " + column[o].width + ";height:"
							+ conf.theadHeight + ";vertical-align: middle;");
					th.innerHTML = column[o].name;
					tr.appendChild(th);
				}
			});
		};
		var cBodyTable = function(divid, jsonData) {
			var tdiv = document.createElement("div");
			var h = '';
			if (conf.height == "100%") {
				h = $(window).height() - $("#table_head").offset().top
						- $('#table_head').find('th:last').eq(0).height() - 10;
				if (conf.usePage) {// 是否分页
					h -= 40;
				}
				h += "px";
			} else {
				h = conf.height;
			}
			tdiv.setAttribute("style",
					'overflow-y: auto; overflow-x: auto; height: ' + h
							+ '; border: 1px solid #DDDDDD;');
			tdiv.className = "t_table";
			divid.appendChild(tdiv);
			var table2 = document.createElement("table");// 1.创建一个table表
			table2.id = "mytable";
			table2.className = "pp-list table table-striped table-bordered";
			table2.setAttribute("style", "margin-bottom: -3px;");

			tdiv.appendChild(table2);
			var tbody = document.createElement("tbody");// 1.创建一个table表
			table2.appendChild(tbody);
			var json = _getValueByName(jsonData, conf.records);
			$.each(json, function(d) {
				var tr = document.createElement('tr');
				tr.setAttribute("style", "line-height:" + conf.tbodyHeight
						+ ";");
				tbody.appendChild(tr);
				var cn = "";
				if (!conf.serNumber) {
					cn = "none";
				}
				var ntd_d = tr.insertCell(-1);
				ntd_d.setAttribute("style","text-align:center;width: 15px;display: "+ cn + ";");
				ntd_d.innerHTML = tr.rowIndex + 1;
				var cbk = "";
				if (!conf.checkbox) {
					cbk = "none";
				}
					var td_d = tr.insertCell(-1);
					td_d.setAttribute("style",
									"text-align:center;width: 18px;display: "+ cbk + ";");
					var chkbox = document.createElement("INPUT");
					chkbox.type = "checkbox";
					// ******** 树的上下移动需要
					chkbox.setAttribute("cid", _getValueByName(json[d], "id"));
					chkbox.setAttribute("pid", _getValueByName(json[d],
							"parentId"));
					// ******** 树的上下移动需要
					chkbox.setAttribute("_l_key", "checkbox");
					chkbox.value = _getValueByName(json[d], conf.checkValue);
					chkbox.onclick = highlight.bind(this);
					td_d.appendChild(chkbox); // 第一列添加复选框
				$.each(column, function(o) {
					if (!column[o].hide || column[o].hide == undefined) {
						var td_o = tr.insertCell(-1);
						td_o.setAttribute("style", "text-align:"
								+ column[o].align + ";width: "
								+ column[o].width + ";");
						if (l_tree.tree) {
							if (l_tree.name == column[o].colkey) {
								var divtree = document.createElement("div");
								divtree.className = "tree";
								divtree.setAttribute("style",
										"padding-left:5px;text-align:"
												+ column[o].align + ";");
								td_o.appendChild(divtree);
								var divspan = document.createElement("span");
								divspan.className = "l_test";
								divspan.setAttribute("style", "line-height:"
										+ conf.tbodyHeight + ";");
								divspan.innerHTML = _getValueByName(json[d],
										column[o].colkey);
								td_o.appendChild(divspan);
							} else {
								td_o.innerHTML = _getValueByName(json[d],
										column[o].colkey);
							}
							;
						} else {
							td_o.innerHTML = _getValueByName(json[d],
									column[o].colkey);
						}
						;
					}
				});
				treeHtml(tbody, json[d]);// 树形式
			});
		};
		var fenyeDiv = function(divid, jsonData) {
			var totalRecords = _getValueByName(jsonData, conf.totalRecords);
			var totalPages = _getValueByName(jsonData, conf.totalPages);
			var pageNow = _getValueByName(jsonData, conf.pageNow);
			var bdiv = document.createElement("div");
			bdiv
					.setAttribute("style",
							"vertical-align: middle;border: 2px solid #DDDDDD;margin-top: -3px;");

			bdiv.className = "span12 center";
			divid.appendChild(bdiv);
			var btable = document.createElement("table");
			btable.width = "100%";
			bdiv.appendChild(btable);
			var btr = document.createElement("tr");
			btable.appendChild(btr);
			var btd_1 = document.createElement("td");
			btd_1.style.textAlign = "left";
			btr.appendChild(btd_1);
			var btddiv = document.createElement("div");
			btddiv.className = "dataTables_paginate paging_bootstrap pagination";
			btd_1.appendChild(btddiv);
			var divul = document.createElement("ul");
			btddiv.appendChild(divul);
			var ulli = document.createElement("li");
			ulli.className = "prev";
			divul.appendChild(ulli);
			var lia = document.createElement("a");
			lia.href = "javascript:void(0);";
			ulli.appendChild(lia);
			lia.innerHTML = '总&nbsp;' + totalRecords
					+ '&nbsp;条&nbsp;&nbsp;每页&nbsp;' + conf.pageSize
					+ '&nbsp;条&nbsp;&nbsp;共&nbsp;' + totalPages + '&nbsp;页';

			var btd_1 = document.createElement("td");
			btd_1.style.textAlign = "right";
			btr.appendChild(btd_1);
			var btddiv_2 = document.createElement("div");
			btddiv_2.className = "dataTables_paginate paging_bootstrap pagination";
			btd_1.appendChild(btddiv_2);
			var divul_2 = document.createElement("ul");
			btddiv_2.appendChild(divul_2);

			if (pageNow > 1) {
				var ulli_2 = document.createElement("li");
				divul_2.appendChild(ulli_2);
				var lia_2 = document.createElement("a");
				lia_2.onclick = pageBind.bind();
				lia_2.id = "pagNum_" + (pageNow - 1);
				lia_2.href = "javascript:void(0);";
				lia_2.innerHTML = '← prev';
				ulli_2.appendChild(lia_2);
			} else {
				var ulli_2 = document.createElement("li");
				ulli_2.className = "prev disabled";
				divul_2.appendChild(ulli_2);
				var lia_2 = document.createElement("a");
				lia_2.href = "javascript:void(0);";
				lia_2.innerHTML = '← prev';
				ulli_2.appendChild(lia_2);
			}
			var pg = pagesIndex(conf.pagecode, pageNow, totalPages);
			var startpage = pg.start;
			var endpage = pg.end;
			if (startpage != 1) {
				var ulli_3 = document.createElement("li");
				divul_2.appendChild(ulli_3);
				var lia_3 = document.createElement("a");
				lia_3.onclick = pageBind.bind();
				lia_3.href = "javascript:void(0);";
				lia_3.id = "pagNum_1";
				lia_3.innerHTML = '1...';
				ulli_3.appendChild(lia_3);
			}
			if (endpage - startpage <= 0) {
				var ulli_4 = document.createElement("li");
				ulli_4.className = "active";
				divul_2.appendChild(ulli_4);
				var lia_4 = document.createElement("a");
				lia_4.href = "javascript:void(0);";
				lia_4.innerHTML = '1';
				ulli_4.appendChild(lia_4);
			}
			for ( var i = startpage; i <= endpage; i++) {
				if (i == pageNow) {
					var ulli_5 = document.createElement("li");
					ulli_5.className = "active";
					divul_2.appendChild(ulli_5);
					var lia_5 = document.createElement("a");
					lia_5.href = "javascript:void(0);";
					lia_5.innerHTML = i;
					ulli_5.appendChild(lia_5);
				} else {
					var ulli_5 = document.createElement("li");
					divul_2.appendChild(ulli_5);
					var lia_5 = document.createElement("a");
					lia_5.onclick = pageBind.bind();
					lia_5.href = "javascript:void(0);";
					lia_5.id = "pagNum_" + i;
					lia_5.innerHTML = i;
					ulli_5.appendChild(lia_5);
				}
				;

			}
			if (endpage != totalPages) {
				var ulli_6 = document.createElement("li");
				divul_2.appendChild(ulli_6);
				var lia_6 = document.createElement("a");
				lia_6.onclick = pageBind.bind();
				lia_6.href = "javascript:void(0);";
				lia_6.id = "pagNum_" + totalPages;
				lia_6.innerHTML = '...' + totalPages;
				ulli_6.appendChild(lia_6);
			}
			if (pageNow >= totalPages) {
				var ulli_7 = document.createElement("li");
				ulli_7.className = "prev disabled";
				divul_2.appendChild(ulli_7);
				var lia_7 = document.createElement("a");
				lia_7.href = "javascript:void(0);";
				lia_7.innerHTML = 'next → ';
				ulli_7.appendChild(lia_7);
			} else {
				var ulli_7 = document.createElement("li");
				ulli_7.className = "next";
				divul_2.appendChild(ulli_7);
				var lia_7 = document.createElement("a");
				lia_7.onclick = pageBind.bind();
				lia_7.href = "javascript:void(0);";
				lia_7.id = "pagNum_" + (pageNow + 1);
				lia_7.innerHTML = 'next → ';
				ulli_7.appendChild(lia_7);
			}
			;
		};
		var nb = '10';
		var treeHtml = function(tbody, data) {
			if (data == undefined)
				return;
			var jsonTree = data.children;
			if (jsonTree == undefined || jsonTree == '' || jsonTree == null) {
			} else {
				$.each(
								jsonTree,
								function(jt) {
									var tr = document.createElement('tr');
									tr.setAttribute("style", "line-height:"
											+ conf.tbodyHeight + ";");
									tbody.appendChild(tr);
									var cn = "";
									if (!conf.serNumber) {
										cn = "none";
									}
									var ntd_d = tr.insertCell(-1);
									ntd_d.setAttribute("style","text-align:center;width: 15px;display: "+ cn + ";");
									ntd_d.innerHTML = tr.rowIndex + 1;
									var cbk = "";
									if (!conf.checkbox) {
										cbk = "none";
									}
										var td_d = tr.insertCell(-1);
										td_d
												.setAttribute("style",
														"text-align:center;width: 18px;display: "+ cbk + ";");
										var chkbox = document
												.createElement("INPUT");
										chkbox.type = "checkbox";
										// ******** 树的上下移动需要
										chkbox.setAttribute("cid",
												_getValueByName(jsonTree[jt],
														"id"));
										chkbox.setAttribute("pid",
												_getValueByName(jsonTree[jt],
														"parentId"));
										// ******** 树的上下移动需要
										chkbox.setAttribute("_l_key",
												"checkbox");
										chkbox.value = _getValueByName(
												jsonTree[jt], conf.checkValue);
										chkbox.onclick = highlight.bind(this);
										td_d.appendChild(chkbox); // 第一列添加复选框
									$.each(
													column,
													function(o) {
														if (!column[o].hide
																|| column[o].hide == undefined) {
															var td_o = tr
																	.insertCell(-1);
															td_o
																	.setAttribute(
																			"style",
																			"text-align:"
																					+ column[o].align
																					+ ";width: "
																					+ column[o].width
																					+ ";");
															if (l_tree.tree) {
																if (l_tree.name == column[o].colkey) {
																	var divtree = document
																			.createElement("div");
																	divtree.className = "tree";
																	divtree
																			.setAttribute(
																					"style",
																					"padding-left:5px;text-align:"
																							+ column[o].align
																							+ ";margin-left: "
																							+ nb
																							+ "px;");
																	td_o
																			.appendChild(divtree);
																	var divspan = document
																			.createElement("span");
																	divspan.className = "l_test";
																	divspan
																			.setAttribute(
																					"style",
																					"line-height:"
																							+ conf.tbodyHeight
																							+ ";");
																	divspan.innerHTML = _getValueByName(
																			jsonTree[jt],
																			column[o].colkey);
																	td_o
																			.appendChild(divspan);
																} else {
																	td_o.innerHTML = _getValueByName(
																			jsonTree[jt],
																			column[o].colkey);
																}
																;
															} else {
																td_o.innerHTML = _getValueByName(
																		jsonTree[jt],
																		column[o].colkey);
															}
															;
														}
													});
									if (jsonTree[jt].children != undefined
											&& jsonTree[jt].children != ''
											&& jsonTree[jt].children != null) {
										nb = parseInt(nb) + 20;
										treeHtml(tbody, jsonTree[jt]);
									}

								});
				nb = 20;
			}
		};
		Array.prototype.each = function(f) { // 数组的遍历
			for ( var i = 0; i < this.length; i++)
				f(this[i], i, this);
		};
		var lyGridUp = function() { // 上移所选行

			var upOne = function(tr) { // 上移1行
				if (tr.rowIndex > 0) {
					var ctr = divid.children[1].children.mytable.rows[tr.rowIndex - 1];
					swapTr(tr, ctr);
					getChkBox(tr).checked = true;
				}
			};
			var arr = $A(divid.children[1].children.mytable.rows).reverse(); // 反选
			if (arr.length > 0 && getChkBox(arr[arr.length - 1]).checked) {
				for ( var i = arr.length - 1; i >= 0; i--) {
					if (getChkBox(arr[i]).checked) {
						arr.pop();
					} else {
						break;
					}
				}
			}
			;
			arr.reverse().each(
					function(tr) {
						var ck = getChkBox(tr);
						if (ck.checked) {
							var cd = ck.getAttribute("cid");
							$("input:checkbox[pid='" + cd + "']").attr(
									'checked', 'true');// 让子类选中
							upOne(tr);
						}
					});
		};
		var lyGridDown = function() { // 下移所选行

			var downOne = function(tr) {
				if (tr.rowIndex < divid.children[1].children.mytable.rows.length - 1) {
					swapTr(
							tr,
							divid.children[1].children.mytable.rows[tr.rowIndex + 1]);
					getChkBox(tr).checked = true;
				}
			};
			var arr = $A(divid.children[1].children.mytable.rows);
			if (arr.length > 0 && getChkBox(arr[arr.length - 1]).checked) {
				for ( var i = arr.length - 1; i >= 0; i--) {
					if (getChkBox(arr[i]).checked) {
						arr.pop();
					} else {
						break;
					}
				}
			}
			arr.each(function(tr) {
				var ck = getChkBox(tr);
				if (ck.checked) {
					var cd = ck.getAttribute("cid");
					$("input:checkbox[pid='" + cd + "']").attr('checked',
							'true');// 让子类选中
				}
			});
			arr.reverse().each(function(tr) {
				if (getChkBox(tr).checked)
					downOne(tr);
			});
		};
		var row={};
		var highlight = function() { // 设置行的背景色
			row =this;
			var evt = arguments[0] || window.event;
			var chkbox = evt.srcElement || evt.target;
			var tr = chkbox.parentNode.parentNode;
			chkbox.checked ? setBgColor(tr) : restoreBgColor(tr);
		}; 
		var selectRow = function(){
			var r = getSelectedCheckbox();
			if(r.length == 0){
				row={};
			}
			return row;
		};
		var trClick = function() { // 设置行的背景色 兼容性问题很大
			/*
			 * var evt = arguments[0] || window.event; var tr = evt.srcElement ||
			 * evt.currentTarget; var chkbox = getChkBox(tr);
			 * if(chkbox.checked){ chkbox.checked = false; restoreBgColor(tr);
			 * }else{ chkbox.checked=true; setBgColor(tr); }
			 */
		};
		var checkboxbind = function() { // 全选/反选
			var evt = arguments[0] || window.event;
			var chkbox = evt.srcElement || evt.target;
			var checkboxes = $("input[_l_key='checkbox']");
			if (chkbox.checked) {
				checkboxes.prop('checked', true);
			} else {
				checkboxes.prop('checked', false);
			}
			checkboxes.each(function() {
				var tr = this.parentNode.parentNode;
				var chkbox = getChkBox(tr);
				if (chkbox.checked) {
					setBgColor(tr);
				} else {
					restoreBgColor(tr);
				}
			});
		};

		var pageBind = function() { // 页数
			var evt = arguments[0] || window.event;
			var a = evt.srcElement || evt.target;
			var page = a.id.split('_')[1];
			conf.data = $.extend(conf.data, {
				pageNow : page
			});
			init();
		};
		var swapTr = function(tr1, tr2) { // 交换tr1和tr2的位置
			var target = (tr1.rowIndex < tr2.rowIndex) ? tr2.nextSibling : tr2;
			var tBody = tr1.parentNode;
			tBody.replaceChild(tr2, tr1);
			tBody.insertBefore(tr1, target);
		};
		var getChkBox = function(tr) { // 从tr得到 checkbox对象
			return tr.cells[1].firstChild;

		};
		var restoreBgColor = function(tr) {// 不勾选设置背景色
			for ( var i = 0; i < tr.childNodes.length; i++) {
				tr.childNodes[i].style.backgroundColor = "";
			}
		};
		var setBgColor = function(tr) { // 设置背景色
			for ( var i = 0; i < tr.childNodes.length; i++) {
				tr.childNodes[i].style.backgroundColor = "#D4D4D4";
			}
		};
		function $A(arrayLike) { // 数值的填充
			for ( var i = 0, ret = []; i < arrayLike.length; i++)
				ret.push(arrayLike[i]);
			return ret;
		}
		;
		Function.prototype.bind = function() { // 数据的绑定
			var __method = this, args = $A(arguments), object = args.shift();
			return function() {
				return __method.apply(object, args.concat($A(arguments)));
			};
		};

		var _getValueByName = function(data, name) {
			if (!data || !name)
				return null;
			if (name.indexOf('.') == -1) {
				return data[name];
			} else {
				try {
					return new Function("data", "return data." + name + ";")
							(data);
				} catch (e) {
					return null;
				}
			}
		};
		var rowline = function() {
			var cb = [];

			var arr = $A(divid.children[1].children.mytable.rows);
			for ( var i = arr.length - 1; i >= 0; i--) {
				var cbox = getChkBox(arr[i]).value;
				var row = arr[i].rowIndex;
				var sort = {
					"rowNum" : row,
					"rowId" : cbox
				};
				cb.push(sort);
			}
			;
			return cb.reverse();
		};
		/**
		 * 这是一个分页工具 主要用于显示页码,得到返回来的 开始页码和结束页码 pagecode 要获得记录的开始索引 即 开始页码 pageNow
		 * 当前页 pageCount 总页数
		 * 
		 */
		var pagesIndex = function(pagecode, pageNow, pageCount) {
			/*
			 * var pagecode = _getValueByName(jsonData,conf.pagecode) ==
			 * undefined ? conf.pagecode
			 * :_getValueByName(jsonData,conf.pagecode); var sten =
			 * pagesIndex(pagecode, pageNow,totalPages); var
			 * startpage=sten.start; var endpage=sten.end;
			 */
			pagecode = parseInt(pagecode);
			pageNow = parseInt(pageNow);
			pageCount = parseInt(pageCount);
			var startpage = pageNow
					- (pagecode % 2 == 0 ? pagecode / 2 - 1 : pagecode / 2);
			var endpage = pageNow + pagecode / 2;
			if (startpage < 1) {
				startpage = 1;
				if (pageCount >= pagecode)
					endpage = pagecode;
				else
					endpage = pageCount;
			}
			if (endpage > pageCount) {
				endpage = pageCount;
				if ((endpage - pagecode) > 0)
					startpage = endpage - pagecode + 1;
				else
					startpage = 1;
			};
			var se ={
					start : startpage,
					end : endpage
				};
			return se;
		};
		/**
		 * 重新加载
		 */
		var loadData = function() {
			init();
		};
		/**
		 * 查询时，设置参数查询
		 */
		var setOptions = function(params) {
			$.extend(conf, params);
			init();
		};
		/**
		 * 获取选中的值
		 */
		var getSelectedCheckbox = function() {
			var arr = [];
			$("input[_l_key='checkbox']:checkbox:checked").each(function() {
				arr.push($(this).val());
			});
			return arr;
		};
		init();

		return {
			setOptions : setOptions,
			loadData : loadData,
			getSelectedCheckbox : getSelectedCheckbox,
			selectRow:selectRow,//选中行事件
			lyGridUp : lyGridUp,
			lyGridDown : lyGridDown,
			rowline : rowline
		};
	});
})();
// 利用js让头部与内容对应列宽度一致。
var fixhead = function() {
	// 获取表格的宽度
	$('#table_head').css('width',
			$('.t_table').find('table:first').eq(0).width() + 2);
	for ( var i = 0; i <= $('.t_table .pp-list tr:last').find('td:last')
			.index(); i++) {
		$('.pp-list th').eq(i).css('width',
				$('.t_table .pp-list tr:last').find('td').eq(i).width());
	}
	/*
	 * //当有横向滚动条时，需要此js，时内容滚动头部也能滚动。 //暂时不处理横向 $('.t_table').scroll(function() {
	 * $('#table_head').css('margin-left', -($('.t_table').scrollLeft())); });
	 */
};
$(window).resize(function() {
	fixhead();
});
(function($){  
    $.fn.serializeJson=function(){  
        var serializeObj={};  
        var array=this.serializeArray();  
        $(array).each(function(){  
            if(serializeObj[this.name]){  
                if($.isArray(serializeObj[this.name])){  
                    serializeObj[this.name].push(this.value);  
                }else{  
                    serializeObj[this.name]=[serializeObj[this.name],this.value];  
                }  
            }else{  
                serializeObj[this.name]=this.value;   
            }  
        });  
        return serializeObj;  
    };  
})(jQuery);  