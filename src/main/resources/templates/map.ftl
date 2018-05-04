<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no">
    <title></title>
    <link rel="stylesheet" type="text/css" href="res/css/main.css" />
    <style type="text/css">
        #dates li {list-style: none;float: left;width: 160px;height: 60px;font-size: 18px;text-align: center;background: url('res/img/biggerdot.png') center bottom no-repeat;}
        #dates a {line-height: 38px;padding-bottom: 10px;}
        #dates .selected {font-size: 28px; color: #d58512}
    </style>
    <link rel="stylesheet" href="res/bootstrap/css/bootstrap.css">
    <script type="text/javascript" src="res/js/jquery.min.js"></script>
    <script type="text/javascript" src="res/bootstrap/js/bootstrap.js"></script>
    <script type="text/javascript" src="layer/layer.js"></script>
    <script type="text/javascript">
    </script>
    <style type="text/css">
        html, body
        {
            margin: 0;
            padding: 0;
        }

        html, body, #viewDiv {
            padding: 0;
            margin: 0;
            height: 100%;
            width: 100%;
        }

        #infoDiv {
            position: absolute;
            bottom: 15px;
            left: 0;
            max-height: 80%;
            max-width: 300px;
            background-color: black;
            padding: 8px;
            border-top-left-radius: 5px;
            color: white;
            opacity: 0.8;
        }
    </style>
    <link rel="stylesheet" href="http://121.42.151.97:8080/arcgis_js_api/library/4.6/esri/themes/dark/main.css">
    <script src="http://121.42.151.97:8080/arcgis_js_api/library/4.6/init.js"></script>
    <script>
        var myMap = {};
        require([
                    "esri/Map",
                    "esri/views/SceneView",
                    "esri/layers/MapImageLayer",
                    "esri/layers/ImageryLayer",
                    "esri/layers/TileLayer",
                    "esri/layers/Layer",
                    "esri/geometry/Extent",
                    "esri/layers/FeatureLayer",
                    "esri/widgets/LayerList",
                    "esri/geometry/Point",
                    "esri/widgets/Legend",
                    "esri/layers/support/LabelClass",
                    "esri/layers/ImageryLayer",
                    "esri/request",
                    "dojo/domReady!templates/index"
                ],
                function(
                        Map, SceneView, MapImageLayer,ImageryLayer,TileLayer,Layer,Extent,FeatureLayer,LayerList, Point, Legend,LabelClass, VectorTileLayer,esriRequest
                ) {
                    jQuery("#wrj").click(function() {
                        if (wrj.visible) {
                            wrj.visible = false;
                        } else {
                            wrj.visible = true;
                            myMap.goTo(wrj.fullExtent,wrj.spatialReference.wkid,permitsLyr.spatialReference.wkid);
                        }
                    });

                    jQuery("#weixing").click(function() {
                            myMap.goTo(permitsLyr.fullExtent,permitsLyr.spatialReference.wkid,permitsLyr.spatialReference.wkid);
                    });


                    var  layarr = [];
                    jQuery(".pointType").click(function() {
                        //myMap.goTo(permitsLyr.fullExtent,permitsLyr.spatialReference.wkid,permitsLyr.spatialReference.wkid);


                        var id = $(this).attr("id");

                        var x = $(this).attr("lat");
                        var y = $(this).attr("lng");
                        for (var i = 0; i < layarr.length; i++) {
                            map.remove(layarr[i]);
                            //
                            var lid = layarr[i].id;
                            if (id !== lid) {
                                $("#" + lid).removeClass("fselected");
                            }
                        }

                        if ($(this).hasClass("fselected")) {
                            //var layer = map.findLayerById(id);
                            //map.remove(layer);
                            $(this).removeClass("fselected");
                        } else {
                            $(this).addClass("fselected");
                            //请求数据
                           /* view.when(function() {
                                // Request the earthquake data from USGS when the view resolves
                                getData(id)
                                        .then(createGraphics) // then send it to the createGraphics() method
                                        .then(createLayer) // when graphics are created, create the layer
                                        .then(createLegend) // when layer is created, create the legend
                                        .otherwise(errback);
                            });*/
                            //
                            $.getJSON("ps/getAll?typeId=" + id,function(data){
                                var graphics =  data.map(function(feature, i) {
                                    return {
                                        geometry: new Point({
                                            x: feature.x,
                                            y: feature.y
                                        }),
                                        attributes: {
                                            ObjectID: feature.id,
                                            address: feature.name,
                                            x: feature.x,
                                            y: feature.y,
                                            region: feature.region,
                                            regionCode: feature.regionCode,
                                            picture:feature.pictures,
                                            literature: feature.literatures,
                                            video: feature.videos,
                                            positionExtend: feature.positionExtends
                                        }
                                    };
                                });
                                const statesLabelClass = new LabelClass({
                                    labelExpressionInfo: { expression: "$feature.ADDRESS" },
                                    symbol: {
                                        type: "text",  // autocasts as new TextSymbol()
                                        color: "red",
                                        haloSize: 2,
                                        haloColor: "white"
                                    }
                                });
                                var lyr = new FeatureLayer({
                                    id:id,
                                    source: graphics, // autocast as an array of esri/Graphic
                                    // create an instance of esri/layers/support/Field for each field object
                                    fields: fields, // This is required when creating a layer from Graphics
                                    objectIdField: "ObjectID", // This must be defined when creating a layer from Graphics
                                    renderer: quakesRenderer, // set the visualization on the layer
                                    spatialReference: {
                                        wkid: 4326
                                    },
                                    geometryType: "point", // Must be set when creating a layer from Graphics
                                    popupTemplate: pTemplate,
                                    //displayField: "address",
                                    labelsVisible: true,
                                    labelingInfo : [statesLabelClass],
                                    elevationInfo: {
                                        // this elevation mode will place points on top of
                                        // buildings or other SceneLayer 3D objects
                                        mode: "relative-to-scene"
                                    }
                                });

                                map.add(lyr);
                                layarr.push(lyr);
                                lyr.when(function() {
                                    //view.goTo(lyr.fullExtent);
                                    //view.extent = layer.fullExtent;
                                    //var center = permitsLyr.fullExtent.center;
                                    var center = {x:x,y:y};
                                    view.goTo({center:center,zoom:10});
                                });
                            });
                        }
                    });

                    myMap.setMap = function(map, view) {
                        this.map = map;
                        this.view = view;
                    };
                    myMap.goTo = function(extent,sourceWkid, targetWkid) {
                        var $this = this;
                        jQuery.post("http://121.42.151.97:6080/arcgis/rest/services/Utilities/Geometry/GeometryServer/project", {
                            inSR:sourceWkid,
                            outSR:targetWkid,
                            geometries:'{\'geometryType\':\'esriGeometryPoint\',\'geometries\':[{\'x\':537612.83487,\'y\':2860609.99709},{\'x\':545870.22445,\'y\':2868741.86003}]}',
                            f:"pjson"
                        },function(result) {
                            var geos = result.geometries;
                            if (geos.length > 0) {
                                var extent = new Extent({
                                    xmin: geos[0].x,
                                    ymin: geos[0].y,
                                    xmax: geos[1].x,
                                    ymax: geos[1].y,
                                    spatialReference: {
                                        wkid: targetWkid
                                    }
                                });
                                $this.view.goTo(extent,{
                                    duration: 6000,
                                    easing: "in-expo"
                                });
                            }
                        },"json");
                    };


                    var permitsLyr = new MapImageLayer({
                        url:"https://localhost:6443/arcgis/rest/services/gz/MapServer"
                    });

                    var wrj = new MapImageLayer({
                        url:"https://localhost:6443/arcgis/rest/services/wrj/MapServer",
                        visible:false
                    });
                    /*****************************************************************
                     * Add the layer to a map
                     *****************************************************************/
                    var map = new Map({
                        basemap: "topo-vector",
                        layers: [permitsLyr]
                    });
                    var view = new SceneView({
                        container: "viewDiv",
                        map: map,
                        zoom: 6,
                        ui: {
                            padding: {
                                bottom: 15,
                                left: 0
                            }
                        }
                    });
                    //add wrj
                    map.add(wrj);
                    myMap.setMap(map, view);
                    view.then(function() {
                        permitsLyr.then(function() {
                            //view.goTo(permitsLyr.fullExtent);
                            var center = permitsLyr.fullExtent.center;
                            view.goTo({center:center,zoom:10});
                        });
                    });
                    var fields = [
                        {
                            name: "ObjectID",
                            alias: "ObjectID",
                            type: "oid"
                        }, {
                            name: "x",
                            alias: "x",
                            type: "string"
                        }, {
                            name: "y",
                            alias: "y",
                            type: "string"
                        }, {
                            name: "address",
                            alias: "address",
                            type: "string"
                        }, {
                            name: "region",
                            alias: "region",
                            type: "string"
                        }, {
                            name: "regionCode",
                            alias: "regionCode",
                            type: "string"
                        }];

                    var pTemplate = {
                        title: "{address}",
                        content: "<ul><li>经度: {x}</li><li>维度: {y}</li><li>地址: {address}</li><li>所在区域: {region}</li><li>区域代码: {regionCode}</li><li>照片: {picture:getPictures}</li><li>文献资料: {literature:downloadLiterature}</li><li>视频资料: {video:getVideos}</li><li>扩展信息: {positionExtend:getExtends}</li></ul>"
                    };

                    getPictures = function (value, key, data) {
                        var pictures = data.picture;
                        var html = "";
                        for (var i = 0; i < pictures.length; i++) {
                            html += "<a href='javascript:void(0)' onclick='preview(\""+pictures[i].url+"\")'>"+pictures[i].title+"</a>";
                        }
                        return html;
                    };
                    downloadLiterature = function (value, key, data) {
                        var literatures = data.literature;
                        var html = "";
                        for (var i = 0; i < literatures.length; i++) {
                            html += "<a href='javascript:void(0)' onclick='downloadL(\""+literatures[i].url+"\",\""+literatures[i].title+"\")'>"+literatures[i].title+"</a>";
                        }
                        return html;
                    };

                    getVideos = function (value, key, data) {
                        var pictures = data.video;
                        var html = "";
                        for (var i = 0; i < pictures.length; i++) {
                            html += "<a href='javascript:void(0)' onclick='play(\"" + pictures[i].name + "\")'>" + pictures[i].name + "</a>";
                            html += "&nbsp;&nbsp;"
                        }
                        return html;
                    };

                    getExtends = function (value, key, data) {

                        var html = "<a href='javascript:void(0)' onclick='showExtends(\"" + data.ObjectID + "\")'>查看</a>";
                        return html;
                    };

                    var quakesRenderer = {
                        type: "simple", // autocasts as new SimpleRenderer()
                        label: "",
                        symbol: {
                            type: "simple-marker", // autocasts as new SimpleMarkerSymbol()
                            style: "circle",
                            size: 5,
                            color: [211, 255, 0, 0],
                            outline: {
                                width: 5,
                                color: "#FF0055",
                                style: "solid"
                            }
                        }
                    };




                    function getData(id) {
                        var url = "ps/getAll?typeId=" + id;
                        var response = esriRequest(url, {
                            responseType: "json"
                        });

                        return {type:id, data:response.data};
                        /*return esriRequest(url, {
                            responseType: "json"
                        });*/
                    }

                    function createGraphics(rt) {

                        var geoJson = rt.data;
                        var typeId = rt.type;
                        var data =  geoJson.map(function(feature, i) {
                            return {
                                geometry: new Point({
                                    x: feature.x,
                                    y: feature.y
                                }),
                                attributes: {
                                    ObjectID: feature.id,
                                    address: feature.name,
                                    x: feature.x,
                                    y: feature.y,
                                    region: feature.region,
                                    regionCode: feature.regionCode,
                                    picture:feature.pictures,
                                    literature:feature.literatures
                                }
                            };
                        });
                        return {type:typeId,graphics:data};
                    }

                    function createLayer(graphics) {
                        const statesLabelClass = new LabelClass({
                            labelExpressionInfo: { expression: "$feature.ADDRESS" },
                            symbol: {
                                type: "text",  // autocasts as new TextSymbol()
                                color: "red",
                                haloSize: 2,
                                haloColor: "white"
                            }
                        });
                        var lyr = new FeatureLayer({
                            id:graphics.type,
                            source: graphics.graphics, // autocast as an array of esri/Graphic
                            // create an instance of esri/layers/support/Field for each field object
                            fields: fields, // This is required when creating a layer from Graphics
                            objectIdField: "ObjectID", // This must be defined when creating a layer from Graphics
                            renderer: quakesRenderer, // set the visualization on the layer
                            spatialReference: {
                                wkid: 4326
                            },
                            geometryType: "point", // Must be set when creating a layer from Graphics
                            popupTemplate: pTemplate,
                            //displayField: "address",
                            labelsVisible: true,
                            labelingInfo : [statesLabelClass]
                        });

                        map.add(lyr);
                        lyr.then(function() {
                            view.goTo(lyr.fullExtent);

                        });
                        return lyr;
                    }

                    // Executes if data retrieval was unsuccessful.
                    function errback(error) {
                        console.error("Creating legend failed. ", error);
                    }


                });

        function openPoint() {
            window.open("/ps/index");
        }

        var downloadL = function(url, name) {
            window.open("${ctx.contextPath}/ps/download?parentPath=" + url + "&fileName=" + name);
        };
        var preview = function(url) {
            window.open("${ctx.contextPath}/ps/previewPath?path=" + url);
        };

        var play = function (name) {
            var content = "${ctx.contextPath}/ps/play?name=" + name
            var index = parent.layer.open({
                type: 2,
                title: '视频播放',
                area: ['1024px', '650px'],
                fixed: false, //不固定
                maxmin: true,
                content: content
            });
        };
        var showExtends = function (id) {
            alert(id)
            var content = "${ctx.contextPath}/ps/getExtends?id=" + id;
            var index = parent.layer.open({
                type: 2,
                title: '扩展信息',
                area: ['700px', '400px'],
                fixed: false, //不固定
                maxmin: true,
                content: content
            });
        }
    </script>
</head>
<body>
<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">上传坐标信息</h4>
            </div>
            <div class="modal-body">
                ...
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary">确认上传</button>
            </div>
        </div>
    </div>
</div>
<img class="title" src="res/images/title.png"  style="position:absolute;top:20px;left:50%;margin-left:-394px;z-index: 999"/>
<div style="width:90px;height:30px;position:absolute;right:2px;top:30px;margin:auto auto;border-radius:5px; z-index: 999" ><button id="testId" onclick="openPoint()">上传坐标</button></div>
<div id="viewDiv"></div>
<#--<div class="wurenji" type="ls" style="width:80px;height:70px;position:absolute;right:10px;top:100px;margin:auto auto;border-radius:5px;">
    <img class="weixing" src="res/images/weixing.png" style="margin-left:18px;margin-top:8px;"/>
</div>
<div class="wurenji"  type="gf" style="width:80px;height:70px;position:absolute;right:10px;top:200px;margin:auto auto;border-radius:5px;">
    <img class="wurenji1" src="res/images/gf_pms.png" style="margin-left:18px;margin-top:4px;" />
</div>-->
<div class="wurenji fselected"  id="weixing" type="uav" style="width:80px;height:70px;position:absolute;right:10px;margin:auto auto;border-radius:5px;">
    <img class="wurenji1" src="res/images/weixing.png" style="margin-left:18px;margin-top:4px;" />
</div>
<div class="wurenji"  id="wrj" type="uav" style="width:80px;height:70px;position:absolute;top:200px;right:10px;margin:auto auto;border-radius:5px;">
    <img class="wurenji1" src="res/images/wurenji.png" style="margin-left:18px;margin-top:4px;" />
</div>
<#assign top=300>
<#list types as type>
    <div class="wurenji pointType"  type="uav" style="width:80px;height:70px;position:absolute;top:${top+type_index*100};right:10px;margin:auto auto;border-radius:5px;" id="${type.id}" title="${type.name}" lat="${type.x}" lng="${type.y}">
        <img class="wurenji1" src="${ctx.contextPath}/ps/previewPath?path=${type.url!}" style="margin-left:18px;margin-top:4px;" width="42px" height="58px"/>
    </div>
</#list>

<#--<div class="wurenji"  type="br" style="width:80px;height:70px;position:absolute;right:10px;top:500px;margin:auto auto;border-radius:5px;">
    <img class="wurenji1" src="res/images/langangpeng.png" style="margin-left:18px;margin-top:4px;" />

</div>-->
<#--
<div id="infoDiv">
    <h2>Worldwide Earthquakes</h2>
    Reported from 03/28/16 to 04/04/16
</div>
-->


</body>
</html>