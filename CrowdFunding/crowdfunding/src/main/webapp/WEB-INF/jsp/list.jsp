<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
<link rel="stylesheet" href="static/bootstrap/css/bootstrap.min.css">
<script type="text/javascript" src="static/jquery/jquery-3.2.1.min.js"></script>
<script type="text/javascript"
	src="static/bootstrap/js/bootstrap.min.js"></script>
<title>众筹系统</title>
</head>

<style>
body {
	text-align: center;
}

.table th, .table td {
	text-align: center;
	vertical-align: middle;
}
</style>

<script>

function select(owner) {
	$('#owner').val(owner);
}

function confirm() {
	var owner = $.trim($('#owner').val());
	var coin = $.trim($('#coin').val());
	var password = $.trim($('#password').val());
	var file = $.trim($('#file').val());
	if(!owner || !coin || !password || !file) {
		alert('信息不完善！');
        return false;
	}
	
    // 异步提交
    $.ajax({
                url: "sendCoin",
                type: "POST",
                data: new FormData($('#myForm')[0]),
                contentType: false,
                processData: false,
                beforeSend:function()
                {
                    $("#tip").html("<span style='color:blue'>正在处理...</span>");
                    return true;
                },
                success:function(res)
                {
                    if(data)
                    {
                        $("#tip").html("<span style='color:green'>成功</span>");
                        alert('操作成功');
                    }
                    else
                    {
                        $("#tip").html("<span style='color:red'>失败</span>");
                        alert('操作失败');
                    }
                    setTimeout(function(){$("#myModal").modal("hide")}, 1000);
                }
            });

    return false;
}

$(function () { $('#myModal').on('hide.bs.modal', function () {
	$("#owner").val('');
	$("#coin").val('');
	$("#password").val('');
	$("#file").val('');
})
});


</script>

<body>
	<div class="container">
		<div class="jumbotron">

			<h2 class="text-muted">众筹列表</h2>

			<!-- 后台返回结果为空 -->
			<c:if test="${ fn:length(fList) eq 0 }">
				<p class="text-danger">暂无众筹</p>
			</c:if>

			<!-- 后台返回结果不为空 -->
			<c:if test="${ fn:length(fList) gt 0 }">
				<table class="table">
					<thead>
						<tr>
							<th>众筹地址</th>
							<th>已筹人数</th>
							<th>已筹金币</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${ fList }" var="fund">
							<tr>
								<td><c:out value="${ fund.owner }"></c:out></td>
								<td><c:out value="${ fund.number }"></c:out></td>
								<td><c:out value="${ fund.coin }"></c:out></td>
								<td><button type="button" class="btn btn-primary btn-sm"
										data-toggle="modal" data-target="#myModal"
										onclick="select('${ fund.owner }')">捐赠</button></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:if>

			<button type="button" class="btn btn-success"
				onclick="select(${ fund.owner })">发起众筹</button>
		</div>
	</div>

	<!-- 模态框（Modal） -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title" id="myModalLabel">发送金币</h4>
				</div>

				<div class="modal-body">
					<form class="form-horizontal" role="form"
						enctype="multipart/form-data" id="myForm">
						<div class="form-group">
							<label class="col-sm-2 control-label">地址</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="owner" name="owner"
									placeholder="0x..." readOnly />
							</div>
						</div>

						<div class="form-group">
							<label class="col-sm-2 control-label">金币</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="coin" name="coin" />
							</div>
						</div>

						<div class="form-group">
							<label class="col-sm-2 control-label">密码</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="password"
									name="password" />
							</div>
						</div>

						<div class="form-group">
							<label class="col-sm-2 control-label">密钥</label>
							<div class="col-sm-8">
								<input type="file" id="file" name="file" />
							</div>
						</div>
					</form>
				</div>

				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" onclick="confirm()">确认</button>
					<span id="tip"> </span>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->
</body>
</html>