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
    <form id="edit-profile" class="form-horizontal" action="/p/saveSr">
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
                <input class="span" id="currentCount" value="${product.currentCount!}" type="text" readonly>
            </div> <!-- /controls -->
            </div>
            <div class="control-group">
                <label class="control-label" for="unit">销售数量</label>
                <div class="controls">
                    <input class="span" id="count" name="count"  type="text" required>
                </div> <!-- /controls -->
            </div>
            <div class="control-group">
                <label class="control-label" for="unit">销售单价</label>
                <div class="controls">
                    <input class="span" id="salePrice" name="salePrice" type="text" value="${product.price?c}" required>
                </div> <!-- /controls -->
            </div>
            <div class="control-group">
                <label class="control-label" for="description">描述</label>
                <div class="controls">
                    <textarea id="description"></textarea>
                </div> <!-- /controls -->
            </div>
            <div class="control-group">
            <table class="table table-bordered">
                <thead>
                <tr>
                    <th>进货数量</th>
                    <th>进货价格</th>
                    <th>进货时间</th>
                </tr>
                </thead>
            <#list buyRecordList as buyRecord>
                <tr>
                    <td>
                    ${buyRecord.count!}${product.unit!}
                    </td>
                    <td>
                    ${buyRecord.buyPrice!}
                    </td>
                    <td>
                    ${buyRecord.buyDate!}
                    </td>
                </tr>
            </#list>
            </table>
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
                    try {
                        var currentCount = parseInt($("#currentCount").val());
                        var count = parseInt($("#count").val());
                        if (isNaN(count)) {
                            parent.layer.alert("销售数量输入数值");
                            return false;
                        }
                        var salePrice = parseFloat($("#salePrice").val());
                        if (isNaN(salePrice)) {
                            parent.layer.alert("单价请输入数值");
                            return false;
                        }
                        if (parseInt($("#count").val()) <= 0) {
                            parent.layer.alert("销售数量不能小于0");
                            return false;
                        }
                        if (currentCount < count) {
                            parent.layer.alert("销售数量不能大于当前库存");
                            return false;
                        }
                        if (parseFloat($("#salePrice").val()) <= 0) {
                            parent.layer.alert("销售单价不能小于0");
                            return false;
                        }
                    } catch(err) {
                        parent.layer.alert("销售数量和单价请输入数值");
                        return false;
                    }
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
