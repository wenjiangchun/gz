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
</head>
<body>
    <form id="edit-profile" modelAttribute="position" class="form-horizontal" action="/ps/update" method="post">
        <fieldset>
            <div class="form-group">
                <label class="control-label col-sm-2" for="name">选择类型</label>
                <div class="col-sm-8">
                    <select class="form-control" name="pointType.id">
                        <#list types as type>
                            <#if type.id=position.pointType.id>
                            <option value="${type.id}" selected>${type.name!}</option>
                                <#else >
                            <option value="${type.id}">${type.name!}</option>
                            </#if>

                        </#list>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2" for="name">地址</label>
                <div class="col-sm-8">
                    <input class="form-control" id="name" name="name" value="${position.name!}" type="text" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2" for="x">经度</label>
                <div class="col-sm-3">
                    <input class="form-control" id="x" name="x" value="${position.x!}" type="text" required>
                </div>
                <label class="control-label col-sm-2" for="y">维度</label>
                <div class="col-sm-3">
                    <input class="form-control" id="y" name="y" value="${position.y!}" type="text" required>
                </div>
            </div>
            <div class="form-group">
            <label class="control-label col-sm-2" for="region">所在区域</label>
            <div class="col-sm-8">
                <input class="form-control" id="region" name="region" value="${position.region!}" type="text" required>
            </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2" for="regionCode">区域编码</label>
                <div class="col-sm-8">
                    <input class="form-control" id="regionCode" name="regionCode" value="${position.regionCode!}" type="text" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2" for="description"></label>
                <div class="col-sm-4">
                    <input  name="id" value="${position.id!}" type="hidden" required>
                    <button type="submit" class="btn btn-success">保  存</button>
                </div>

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
