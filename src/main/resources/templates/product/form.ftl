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
    <form id="edit-profile" class="form-horizontal" action="/p/save">
        <fieldset>
            <div class="control-group">
                <label class="control-label" for="name">商品名称</label>
                <div class="controls">
                    <input class="span" id="name" name="name" value="${product.name!}" type="text" required>
                </div> <!-- /controls -->
            </div>
            <div class="control-group">
                <label class="control-label" for="modelNum">型号</label>
                <div class="controls">
                    <input class="span" id="modelNum" name="modelNum" value="${product.modelNum!}" type="text" required>
                </div> <!-- /controls -->
            </div>
            <div class="control-group">
                <label class="control-label" for="category">商品种类</label>
                <div class="controls">
                    <select name="category.id" id="category" required>
                        <#list cs as c>
                            <#if product.category?? && product.category.id==c.id>
                                <option value="${c.id!}" selected>${c.name!}</option>
                            <#else>
                                <option value="${c.id!}">${c.name!}</option>
                            </#if>
                        </#list>
                    </select>
                </div> <!-- /controls -->
            </div><!-- /control-group -->
            <div class="control-group">
            <label class="control-label" for="currentCount">当前库存</label>
            <div class="controls">
                <input class="span" id="currentCount" name="currentCount" value="${product.currentCount!}" type="text" required>
            </div> <!-- /controls -->
            </div>
            <div class="control-group">
                <label class="control-label" for="unit">单位</label>
                <div class="controls">
                    <input class="span" id="unit" name="unit" value="${product.unit!}" type="text" required>
                </div> <!-- /controls -->
            </div>
            <div class="control-group">
                <label class="control-label" for="price">单价</label>
                <div class="controls">
                    <input class="span" id="price" name="price" value="${product.price?c}" type="text" required>
                </div> <!-- /controls -->
            </div>
            <div class="control-group">
                <label class="control-label" for="saleCount">销量</label>
                <div class="controls">
                    <input class="span" id="saleCount" name="saleCount" value="${product.saleCount!0}" type="text" readonly>
                </div> <!-- /controls -->
            </div>
            <div class="control-group">
                <label class="control-label" for="description">描述</label>
                <div class="controls">
                    <textarea id="description" name="description">${product.description!}</textarea>
                </div> <!-- /controls -->
            </div>
            <div class="form-actions">
                <input id="id" name="id" value="${product.id!}" type="hidden">
                <input name="profit" value="${product.profit?c}" type="hidden">
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
