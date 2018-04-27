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
    <form id="edit-profile" modelAttribute="position" class="form-horizontal" action="/ps/save" enctype="multipart/form-data" method="post">
        <fieldset>
            <div class="form-group">
                <label class="control-label col-sm-2" for="name">选择类型</label>
                <div class="col-sm-8">
                    <select class="form-control" name="pointType.id">
                        <#list types as type>
                            <option value="${type.id}">${type.name!}</option>
                        </#list>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2" for="name">地址</label>
                <div class="col-sm-8">
                    <input class="form-control" id="name" name="name"  type="text" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2" for="x">经度</label>
                <div class="col-sm-3">
                    <input class="form-control" id="x" name="x"  type="text" required>
                </div>
                <label class="control-label col-sm-2" for="y">维度</label>
                <div class="col-sm-3">
                    <input class="form-control" id="y" name="y"  type="text" required>
                </div>
            </div>
            <div class="form-group">
            <label class="control-label col-sm-2" for="region">所在区域</label>
            <div class="col-sm-8">
                <input class="form-control" id="region" name="region"  type="text" required>
            </div> <!-- /controls -->
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2" for="regionCode">区域编码</label>
                <div class="col-sm-8">
                    <input class="form-control" id="regionCode" name="regionCode"  type="text" required>
                </div> <!-- /controls -->
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2" for="picture">图片信息</label>
                <div class="col-sm-8">
                    <input id="picture" name="picture" value="" type="file" multiple accept=".jpg,.jpeg,.png">
                </div> <!-- /controls -->
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2" for="literature">文献资料</label>
                <div class="col-sm-8">
                    <input  id="literature" name="literature" value="" type="file" multiple="multiple">
                </div> <!-- /controls -->
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2" for="description">描述信息</label>
                <div class="col-sm-10">
                    <table class="table table-bordered extend">
                        <thead><tr><th>地质年代</th><th>地层</th><th>岩性</th><th>古地理环境</th><th>地质事件</th><th>地貌</th><th><button type="button" class="btn btn-success btn-xs" id="addExtend">+</button></th></tr></thead>
                        <tbody>
                          <tr>
                              <td><input type="text" class="form-control input-sm" name="extendList[0].geoPeriod" /></td>
                              <td><input type="text" class="form-control input-sm" name="extendList[0].geoFloor" /></td>
                              <td><input type="text" class="form-control input-sm" name="extendList[0].rockProperty" /></td>
                              <td><input type="text" class="form-control input-sm" name="extendList[0].geoEnviroment" /></td>
                              <td><input type="text" class="form-control input-sm" name="extendList[0].geoEvent" /></td>
                              <td><input type="text" class="form-control input-sm" name="extendList[0].geoLook" /></td>
                              <td><button type="button" class="btn btn-danger btn-xs" onclick="deleteExtend(this)">x</button></td>
                          </tr>
                        </tbody>
                    </table>
                    <button type="submit" class="btn btn-success">保存</button>
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

        $("#addExtend").click(function() {
            var size = $(".extend").find("tbody").find("tr").length;
            var html = "<td><input type=\"text\" class=\"form-control input-sm\" name=\"extendList["+ (size)+ "].geoPeriod\" /></td>";
            html += "<td><input type=\"text\" class=\"form-control input-sm\" name=\"extendList["+ (size)+ "].geoFloor\" /></td>";
            html += "<td><input type=\"text\" class=\"form-control input-sm\" name=\"extendList["+ (size)+ "].rockProperty\" /></td>";
            html += "<td><input type=\"text\" class=\"form-control input-sm\" name=\"extendList["+ (size)+ "].geoEnviroment\" /></td>";
            html += "<td><input type=\"text\" class=\"form-control input-sm\" name=\"extendList["+ (size)+ "].geoEvent\" /></td>";
            html += "<td><input type=\"text\" class=\"form-control input-sm\" name=\"extendList["+ (size)+ "].geoLook\" /></td>";
            html += "<td><button type=\"button\" class=\"btn btn-danger btn-xs\" onclick=\"deleteExtend(this)\">x</button></td>";
            var $tr = $("<tr>");
            $tr.html(html);
            $(".extend").find("tbody").append($tr);
        });
    });

    function deleteExtend(obj) {
        var $obj = $(obj);
        var index = $obj.parent().parent().index();
        var $tr = $obj.parent().parent();
        if (index != 0) {
            $tr.remove();
            $(".extend").find("tbody").find("tr").each(function(idx,el){
                var $this = $(el);
                $this.find("input").each(function(idxx,ip){
                    var name = $(ip).attr("name");
                    var names = name.split(".");
                    $(ip).attr("name", "extendList["+idx+"]." + names[1]);
                });
            });

        }

    }
</script>
</html>
