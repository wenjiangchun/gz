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
    <form id="edit-profile" class="form-horizontal" action="/p/saveBr">
        <fieldset>
            <div class="control-group">
                <label class="control-label" for="name">商品名称</label>
                <div class="controls">
                    <input class="span" value="${product.name!}" type="text" readonly>
                </div> <!-- /controls -->
            </div>
            <div class="control-group">
                <label class="control-label" for="modelNum">型号</label>
                <div class="controls">
                    <input class="span" value="${product.modelNum!}" type="text" readonly>
                </div> <!-- /controls -->
            </div>
            <div class="control-group">
            <label class="control-label" for="currentCount">当前库存</label>
            <div class="controls">
                <input class="span" value="${product.currentCount!}" type="text" readonly>
            </div> <!-- /controls -->
            </div>
            <div class="control-group">
                <label class="control-label" for="unit">进货数量</label>
                <div class="controls">
                    <input class="span" id="count" name="count"  type="text" required>
                </div> <!-- /controls -->
            </div>
            <div class="control-group">
                <label class="control-label" for="unit">进货单价</label>
                <div class="controls">
                    <input class="span" name="buyPrice" type="text" required>
                </div> <!-- /controls -->
            </div>
            <div class="control-group">
                <label class="control-label" for="description">描述</label>
                <div class="controls">
                    <textarea id="description" name="description">${product.description!}</textarea>
                </div> <!-- /controls -->
            </div>

            <div class="form-actions">
                <input class="span" name="product.id" value="${product.id!}" type="hidden">
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
