<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>销售记录</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<link href="css/bootstrap.min.css" rel="stylesheet">
<link href="css/bootstrap-responsive.min.css" rel="stylesheet">
<link href="http://fonts.googleapis.com/css?family=Open+Sans:400italic,600italic,400,600"
        rel="stylesheet">
<link href="css/font-awesome.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/pages/dashboard.css" rel="stylesheet">

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
              <h3> 商品销售记录</h3>
            </div>
            <!-- /widget-header -->
            <div class="widget-content">
                <div style="padding: 10px">
                    商品名称：<input name="productName" value="${productName!}"/>
                    <button class="btn btn-primary" onclick="searchP()">查询</button>
                </div>
                <table class="table table-striped table-bordered">
                    <thead>
                    <tr>
                        <th> 序号 </th>
                        <th> 商品名称</th>
                        <th> 商品型号</th>
                        <th> 商品种类</th>
                        <th> 销售数量</th>
                        <th> 销售单价</th>
                        <th> 总价(元)</th>
                        <th> 销售日期</th>
                        <th class="td-actions">操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list ps.content as c>
                    <tr>
                        <td>${c.id!}</td>
                        <td>${c.product.name!}</td>
                        <td>${c.product.modelNum!}</td>
                        <td>${c.product.category.name!}</td>
                        <td>${c.count!}${c.product.unit}</td>
                        <td>${c.salePrice!}</td>
                        <td>${c.totalPrice!}</td>
                        <td>${c.saleDate!}</td>
                        <td><a href="javascript:void(0)" onclick="openDialog('${c.id!}')">删除</a></td>
                    </tr>
                    </#list>
                    </tbody>
                </table>

                <nav aria-label="...">
                    <ul class="pager">
                        <#if previous!>
                            <li><a href="/s?page=${ps.number-1}">上一页</a></li>
                        </#if>
                        <#if next!>
                            <li><a href="/s?page=${ps.number+1}">下一页</a></li>
                        </#if>
                    </ul>
                </nav>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<#include "../common/footer.ftl">
<script src="js/jquery-1.7.2.min.js"></script> 
<script src="js/bootstrap.js"></script>
<script src="layer/layer.js"></script>
<script>

    function openDialog(id) {
        var content = '/p/form';
        if (id != undefined) {
            content += "?id=" + id;
        }
        var index = layer.open({
            type: 2,
            title:'商品信息',
            area: ['700px', '460px'],
            fixed: false, //不固定
            maxmin: true,
            content: content
        });
    }

    function refreshC() {
        window.location.reload();
    }

    function searchP() {
        window.location.href="/s?productName="+$("input[name='productName']").val();
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
        $("#li_salerecord").addClass("active");
    });
</script>
</body>
</html>
