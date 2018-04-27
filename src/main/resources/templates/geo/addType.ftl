<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="Content-Type" content="multipart/form-data; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<link href="${ctx.contextPath}/bootstrap/css/bootstrap.css" rel="stylesheet">
<link href="${ctx.contextPath}/css/font-awesome.css" rel="stylesheet">
<link href="${ctx.contextPath}/css/style.css" rel="stylesheet">
<link href="${ctx.contextPath}/css/pages/dashboard.css" rel="stylesheet">
    <script src="${ctx.contextPath}/js/jquery-1.7.2.min.js"></script>
    <script src="${ctx.contextPath}/bootstrap/js/bootstrap.js"></script>
    <script src="${ctx.contextPath}/js/jquery.form.js"></script>
    <script src="${ctx.contextPath}/layer/layer.js"></script>
</head>
<body>
    <form id="edit-profile" modelAttribute="pointType" class="form-horizontal" action="/pt/save" enctype="multipart/form-data" method="post">
        <fieldset>
            <div class="form-group">
                <label class="control-label col-sm-2" for="name">类型名称</label>
                <div class="col-sm-8">
                    <input class="form-control" id="name" name="name"  type="text" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2" for="x">是否显示</label>
                <div class="col-sm-8">
                    <select class="form-control" id="show" name="show">
                        <option value="true">是</option>
                        <option value="false">否</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2" for="picture">图标信息</label>
                <div class="col-sm-8">
                    <input id="file" name="file" value="" type="file" accept=".jpg,.jpeg,.png">
                </div> <!-- /controls -->
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2" for="description"></label>
                <div class="col-sm-10">
                    <button type="submit" class="btn btn-success">保存</button>
                </div> <!-- /controls -->
                </div> <!-- /controls -->
            </div>
        </fieldset>
    </form>

</body>
<script>
    $(document).ready(function() {
        $('#edit-profile').submit(function() {
            $(this).ajaxSubmit({
                beforeSubmit:function() {
                    return true;
                },
                success:function(data) {
                    if (data === "SUCCESS") {
                        parent.layer.close(window.name);
                        parent.refreshC();
                    }
                }
            });
            return false;
        });
    });
</script>
</html>
