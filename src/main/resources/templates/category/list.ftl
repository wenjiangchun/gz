<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>产品种类</title>
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
            <div style="left: 220px">
                <a href="javascript:void(0)" onclick="openDialog()">增加种类</a>
            </div>
          <div class="widget widget-nopad">
            <div class="widget-header"> <i class="icon-list-alt"></i>
              <h3> 产品种类</h3>
            </div>
            <!-- /widget-header -->
            <div class="widget-content">
                <table class="table table-striped table-bordered">
                    <thead>
                    <tr>
                        <th> 序号 </th>
                        <th> 种类名称</th>
                        <th class="td-actions">操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list cs as c>
                    <tr>
                        <td>${c.id!}</td>
                        <td>${c.name!}</td>
                        <td><a href="javascript:void(0)" onclick="openDialog('${c.id!}')">编辑</a></td>
                    </tr>
                    </#list>
                    </tbody>
                </table>
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
        var content = '/c/form';
        if (id != undefined) {
            content += "?id=" + id;
        }
        var index = layer.open({
            type: 2,
            title:'种类信息',
            area: ['400px', '250px'],
            fixed: false, //不固定
            maxmin: true,
            content: content
        });
    }

    function refreshC() {
        window.location.reload();
    }

    $(function() {
        $("#li_category").addClass("active");
    });

</script>
</body>
</html>
