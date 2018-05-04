<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>坐标信息</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<link href="${ctx.contextPath}/css/bootstrap.min.css" rel="stylesheet">
<link href="${ctx.contextPath}/css/bootstrap-responsive.min.css" rel="stylesheet">
<link href="${ctx.contextPath}/css/font-awesome.css" rel="stylesheet">
<link href="${ctx.contextPath}/css/style.css" rel="stylesheet">
<link href="${ctx.contextPath}/css/pages/dashboard.css" rel="stylesheet">
    <link href="${ctx.contextPath}/dataTables/css/jquery.dataTables.css" type="text/css" rel="stylesheet" />

</head>
<body>
<#include "../common/nav.ftl">
<!-- /subnavbar -->
<div class="main">
  <div class="main-inner">
    <div class="container">
      <div class="row">
        <div class="span12">
          <div class="widget widget-nopad">
            <div class="widget-header"> <i class="icon-list-alt"></i>
              <h3> 坐标点信息</h3>
                    <button id="add_btn" class="btn btn-danger"> 增加坐标点</button>
            </div>
            <!-- /widget-header -->
            <div class="widget-content">
                <table id="contentTable"
                       class="table table-striped table-bordered table-condensed table-hover" data-toggle="context">
                    <thead>
                    <tr>
                        <th sName="pointType.name">坐标类型</th>
                        <th sName="name">地址</th>
                        <th sName="region">区域</th>
                        <th sName="regionCode">区域代码</th>
                        <th sName="x">经度</th>
                        <th sName="y">维度</th>
                        <th sName="formatOperator" columnRender="formatConfigType">操作</th>
                    </tr>
                    </thead>
                </table>
                <div class="hr hr-18 hr-dotted"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<#include "../common/footer.ftl">
<script src="${ctx.contextPath}/js/jquery-1.7.2.min.js"></script>
<script src="${ctx.contextPath}/js/bootstrap.js"></script>
<script src="${ctx.contextPath}/layer/layer.js"></script>
<script type="text/javascript" src="${ctx.contextPath}/dataTables/jquery.dataTables.js"></script>
<script type="text/javascript" src="${ctx.contextPath}/dataTables/hazeTable.js"></script>
<script>
    function openDialog(id) {
        var content = 'form';
        if (id != undefined) {
            content += "?id=" + id;
        }
        var index = layer.open({
            type: 2,
            title:'添加坐标信息',
            area: ['1024px', '600px'],
            fixed: false, //不固定
            maxmin: true,
            content: content
        });
    }

    function buyDialog(id) {
        var index = layer.open({
            type: 2,
            title:'入库信息',
            area: ['700px', '460px'],
            fixed: false, //不固定
            maxmin: true,
            content: '/p/buyForm?id=' + id
        });
    }
    function saleDialog(id) {
        var index = layer.open({
            type: 2,
            title:'销售信息',
            area: ['700px', '460px'],
            fixed: false, //不固定
            maxmin: true,
            content: '/p/saleForm?id=' + id
        });
    }

    $(function() {
        $("#li_geo").addClass("active");
        initDataTable();
        $("#add_btn").click(function() {
            var content = 'add';
            var index = layer.open({
                type: 2,
                title:'坐标信息',
                area: ['800px', '600px'],
                fixed: false, //不固定
                maxmin: true,
                content: content
            });
        });
    });


    /**
     * 初始化用户分页列表
     */
    function initDataTable() {
        var options = {
            divId : "contentTable",
            url : "search"
        };
        createTable(options);
    }

    function refreshC() {
        window.location.reload();
    }

    function formatConfigType(data) {
        var html = "";
        html += "<a href='javascript:void(0)' onclick='edit(" + data.id + ")'> 编辑</a> | ";
        html += "<a href='javascript:void(0)' onclick='deletePosition(" + data.id + ")'>删除</a> |";
        html += "<a href='javascript:void(0)' onclick='editP(" + data.id + ")'>编辑照片</a> |";
        html += "<a href='javascript:void(0)' onclick='editL(" + data.id + ")'>编辑文献</a> |";
        html += "<a href='javascript:void(0)' onclick='editV(" + data.id + ")'>编辑视频</a> |";
        html += "<a href='javascript:void(0)' onclick='editT(" + data.id + ")'>编辑属性</a> |";
        return html;
    }

    function edit(id) {
        var content = 'edit/' + id;
        var index = layer.open({
            type: 2,
            title:'编辑坐标信息',
            area: ['900px', '400px'],
            fixed: false, //不固定
            maxmin: true,
            content: content
        });
    }

    function editP(id) {
        var content = 'editP/' + id;
        var index = layer.open({
            type: 2,
            title:'编辑照片信息',
            area: ['900px', '400px'],
            fixed: false, //不固定
            maxmin: true,
            content: content
        });
    }

    function editL(id) {
        var content = 'editL/' + id;
        var index = layer.open({
            type: 2,
            title:'编辑文献信息',
            area: ['900px', '400px'],
            fixed: false, //不固定
            maxmin: true,
            content: content
        });
    }

    function editT(id) {
        var content = 'editT/' + id;
        var index = layer.open({
            type: 2,
            title:'编辑扩展信息',
            area: ['900px', '400px'],
            fixed: false, //不固定
            maxmin: true,
            content: content
        });
    }

    function editV(id) {
        var content = 'editV/' + id;
        var index = layer.open({
            type: 2,
            title: '编辑视频信息',
            area: ['900px', '400px'],
            fixed: false, //不固定
            maxmin: true,
            content: content
        });
    }

    function deletePosition(id) {
        layer.confirm('确认删除该信息？', {
            btn: ['确认','取消'] //按钮
        }, function(){
            $.ajax({
                "url" : "delete/" + id,
                "dataType" : "text",
                success: function(data) {
                    if (data == "SUCCESS") {
                        refreshC();
                    } else {
                        layer.msg('删除失败，请重试', {icon: 2});
                    }
                }
            });
        }, function(){

        });
    }
</script>
</body>
</html>
