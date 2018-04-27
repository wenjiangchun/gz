<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<link href="${ctx.contextPath}/css/bootstrap.min.css" rel="stylesheet">
<link href="${ctx.contextPath}/css/bootstrap-responsive.min.css" rel="stylesheet">
<link href="${ctx.contextPath}/css/font-awesome.css" rel="stylesheet">
<link href="${ctx.contextPath}/css/style.css" rel="stylesheet">
<link href="${ctx.contextPath}/css/pages/dashboard.css" rel="stylesheet">
    <script src="${ctx.contextPath}/js/jquery-1.7.2.min.js"></script>
    <script src="${ctx.contextPath}/js/bootstrap.js"></script>
    <script src="${ctx.contextPath}/js/jquery.form.js"></script>
    <script src="${ctx.contextPath}/layer/layer.js"></script>
</head>
<body>
<!-- /subnavbar -->
    <form id="edit-profile" class="form-horizontal" action="/c/save">
        <fieldset>
            <div class="control-group">
                <label class="control-label" for="firstname">种类名称</label>
                <div class="controls">
                    <input class="span" id="name" name="name" value="${category.name!}" type="text" required>
                </div> <!-- /controls -->
            </div> <!-- /control-group -->
            <div class="form-actions">
                <input class="span" id="id" name="id" value="${category.id!}" type="hidden">
                <button type="submit" class="btn btn-primary">保存</button>
            </div> <!-- /form-actions -->
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
