<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="multipart/form-data; charset=utf-8"/>
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
<form id="edit-profile" class="form-horizontal" action="/ps/updateV" method="post" enctype="multipart/form-data">
    <fieldset>
        <div class="form-group">
            <div class="col-sm-10">
                <table class="table table-bordered">
                    <thead>
                    <tr>
                        <th>文件名</th>
                        <th>存储路径</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                        <#list vs as key>
                        <tr>
                            <td>${key.name}</td>
                            <td>${key.url}</td>
                            <td>
                                <input type="hidden" name="pid" value="${key.id}"/>
                                <a href="javascript:void(0)" onclick="preview('${key.url}','${key.name}')">下载</a>
                                <a href="javascript:void(0)" onclick="play('${key.name}')">播放</a>
                                <a href="javascript:void(0)" onclick="deleteV(this)">删除</a>
                            </td>
                        </tr>
                        </#list>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="video">选择视频</label>
            <div class="col-sm-8">
                <input id="picture" name="video" type="file" multiple accept=".flv">
            </div> <!-- /controls -->
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="description"></label>
            <div class="col-sm-4">
                <input name="id" value="${position.id!}" type="hidden" required>
                <button type="submit" class="btn btn-success">保 存</button>
            </div>
        </div>
    </fieldset>
</form>
</body>
<script>
    $(document).ready(function () {
        $('#edit-profile').submit(function () {
            $(this).ajaxSubmit({
                beforeSubmit: function () {
                    return true;
                },
                success: function (data) {
                    if (data === "SUCCESS") {
                        parent.layer.close(window.name);
                        parent.refreshC();
                    }
                }
            });
            return false;
        });
    });

    function preview(url, name) {
        window.open("${ctx.contextPath}/ps/download?parentPath=" + url + "&fileName=" + name);
    }

    /*function play(name) {
        window.open("${ctx.contextPath}/ps/play/" + name);
    }*/

    function deleteV(obj) {
        var $tr = $(obj).parent().parent();
        $tr.remove();
    }


    function play(name) {
        var content = "${ctx.contextPath}/ps/play?name=" + name
        var index = parent.layer.open({
            type: 2,
            title: '视频播放',
            area: ['1024px', '650px'],
            fixed: false, //不固定
            maxmin: true,
            content: content
        });
    }
</script>
</html>
