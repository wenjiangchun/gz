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
<div class="row">
    <form id="edit-profile" class="form-horizontal" action="/ps/updateT" method="post">
        <fieldset>

                <div class="form-group col-sm-10" style="margin: 10px">
                    <table class="table table-bordered extend">
                        <thead><tr><th>地质年代</th><th>地层</th><th>岩性</th><th>古地理环境</th><th>地质事件</th><th>地貌</th><th><button type="button" class="btn btn-success btn-xs" id="addExtend">+</button></th></tr></thead>
                        <tbody>
                        <#list ps as key>
                        <tr>
                            <td><input type="text" class="form-control input-sm" name="extendList[${key_index}].geoPeriod" value="${key.geoPeriod}"/></td>
                            <td><input type="text" class="form-control input-sm" name="extendList[${key_index}].geoFloor" value="${key.geoFloor}"/></td>
                            <td><input type="text" class="form-control input-sm" name="extendList[${key_index}].rockProperty" value="${key.rockProperty}"/></td>
                            <td><input type="text" class="form-control input-sm" name="extendList[${key_index}].geoEnviroment" value="${key.geoEnviroment}"/></td>
                            <td><input type="text" class="form-control input-sm" name="extendList[${key_index}].geoEvent" value="${key.geoEvent}"/></td>
                            <td><input type="text" class="form-control input-sm" name="extendList[${key_index}].geoLook" value="${key.geoLook}"/></td>
                            <td><button type="button" class="btn btn-danger btn-xs" onclick="deleteExtend(this)">x</button></td>
                        </tr>
                        </#list>
                        </tbody>
                    </table>
                </div>

            <div class="form-group">
                <label class="control-label col-sm-2" for="description"></label>
                <div class="col-sm-4">
                    <input name="id" value="${position.id!}" type="hidden" required>
                    <button type="submit" class="btn btn-success">保  存</button>
                </div>
            </div>
        </fieldset>
    </form>
</div>
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
            var html = "<td><input type=\"text\" class=\"form-control input-sm\" name=\"extendList["+ (size)+ "].geoPeriod\" value=\"\"/></td>";
            html += "<td><input type=\"text\" class=\"form-control input-sm\" name=\"extendList["+ (size)+ "].geoFloor\" value=\"\"/></td>";
            html += "<td><input type=\"text\" class=\"form-control input-sm\" name=\"extendList["+ (size)+ "].rockProperty\" value=\"\"/></td>";
            html += "<td><input type=\"text\" class=\"form-control input-sm\" name=\"extendList["+ (size)+ "].geoEnviroment\" value=\"\"/></td>";
            html += "<td><input type=\"text\" class=\"form-control input-sm\" name=\"extendList["+ (size)+ "].geoEvent\" value=\"\"/></td>";
            html += "<td><input type=\"text\" class=\"form-control input-sm\" name=\"extendList["+ (size)+ "].geoLook\" value=\"\"/></td>";
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
