<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no">
    <title></title>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.css">
    <script src="js/jquery-1.7.2.min.js"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>
    <style type="text/css">
        html,
        body,
        #viewDiv {
            padding: 0;
            margin: 0;
            height: 100%;
            width: 100%;
        }

        #elevationDiv {
            font-family: monospace;
            padding: 12px;
            background-color: rgba(0, 0, 0, 0.5);
            color: white;
            width: 300px;
        }

        .right {
            text-align: right;
        }

        select {
            width: 180px;
        }

        select option {
            wi
    </style>
</head>
<body>
<div id="viewDiv">
</div>
<div id="elevationDiv">
    <form class="form">
        <div class="form-group">
            <label for="exampleInputName2">开始日期</label>
            <input type="date" class="form-control" id="exampleInputName2" placeholder="Jane Doe">
        </div>
        <div class="form-group">
            <label for="exampleInputEmail2">结束日期</label>
            <input type="date" class="form-control" id="exampleInputEmail2" placeholder="jane.doe@example.com">
        </div>
        <div class="form-group">
            <label for="exampleInputEmail2">销售类型</label>
            <select class="form-control">
                <option>一手房销售</option>
                <option>二手房销售</option>
            </select>
        </div>
    </form>
    <button type="submit" class="btn btn-success btn-block">统计</button>
</div>

<link rel="stylesheet" href="http://188.9.25.151:8080/arcgis_js_api/library/4.6/esri/themes/dark/main.css">
<script src="http://188.9.25.151:8080/arcgis_js_api/library/4.6/init.js"></script>
<script>
    var urlPath = "http://";
    var myMap = {};
    var areaLayer,buildingLayer;
    require([
                "esri/Map",
                "esri/views/SceneView",
                "esri/views/MapView",
                "esri/layers/MapImageLayer",
                "esri/layers/ImageryLayer",
                "esri/layers/TileLayer",
                "esri/layers/Layer",
                "esri/geometry/Extent",
                "esri/layers/FeatureLayer",
                "esri/widgets/LayerList",
                "esri/layers/VectorTileLayer",
                "esri/core/urlUtils",
                "esri/config",
                "esri/widgets/Legend",
                "esri/layers/GraphicsLayer",
                "esri/Graphic",
                "esri/geometry/Circle",
                "esri/geometry/Point",
                "esri/layers/support/LabelClass",
                "esri/core/watchUtils",
                "esri/request",
                "dojo/_base/array",
                "dojo/on",
                "dojo/dom",
                "dojo/domReady!map"
            ],
            function(
                    Map, SceneView, MapView, MapImageLayer,ImageryLayer,TileLayer,Layer,Extent,FeatureLayer,LayerList
                    ,VectorTileLayer,urlUtils,esriConfig,Legend,GraphicsLayer,Graphic,Circle,Point,LabelClass,watchUtils,esriRequest,arrayUtils, on, dom) {

                myMap.setMap = function(map, view) {
                    this.map = map;
                    this.view = view;
                };


                myMap.goTo = function(layer, targetWkid, view) {
                    jQuery.post("http://121.42.151.97:6080/arcgis/rest/services/Utilities/Geometry/GeometryServer/project", {
                        inSR:layer.spatialReference.wkid,
                        outSR:targetWkid,
                        geometries:"["+layer.fullExtent.xmin+","+layer.fullExtent.ymin+","+layer.fullExtent.xmax+","+layer.fullExtent.ymax+"]",
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
                            view.goTo(extent,{
                                duration: 8000,
                                easing: "in-expo"
                            });
                        }
                    },"json");
                };


                var baseLayer = new TileLayer({
                    url:"http://gisserver.gov.xm:8080/RemoteRest/services/DEM_VEC/MapServer"
                });

               /* var lp = new FeatureLayer({
                    url:"https://188.9.25.152:6443/arcgis/rest/services/lp/MapServer/0",
                    outFields: ["*"]
                });*/
                /*****************************************************************
                 * Add the layer to a map
                 *****************************************************************/
                var map = new Map({
                    //basemap: "streets",
                    layers: [baseLayer],
                    ground: "world-elevation"
                });
                //map.add(permitsLyr1);
                var view = new MapView({
                    container: "viewDiv",
                    map: map
                });
                /*view.constraints = {
                    minZoom: 1,  // User cannot zoom out beyond a scale of 1:500,000
                    maxZoom: 10,  // User can overzoom tiles
                    rotationEnabled: false  // Disables map rotation
                };*/
                view.ui.add("elevationDiv", "top-left");
                myMap.setMap(map, view);

                watchUtils.whenTrue(view, "stationary", function() {
                    /*if (view.extent) {
                        if (view.zoom >= 4) {
                            if (areaLayer.visible) {
                                areaLayer.visible = false;
                            }
                            if (!buildingLayer.visible) {
                                buildingLayer.visible = true;
                            }
                        } else {
                            if (buildingLayer.visible) {
                                buildingLayer.visible = false;
                            }
                            if (!areaLayer.visible) {
                                areaLayer.visible = true;
                            }
                        }
                    }*/
                });

                var fields = [
                    {
                        name: "ObjectID",
                        alias: "ObjectID",
                        type: "oid"
                    }, {
                        name: "title",
                        alias: "title",
                        type: "string"
                    }, {
                        name: "area",
                        alias: "area",
                        type: "string"
                    }, {
                        name: "x",
                        alias: "x",
                        type: "double"
                    }, {
                        name: "y",
                        alias: "y",
                        type: "double"
                    }, {
                        name: "mount",
                        alias: "mount",
                        type: "string"
                    }, {
                        name: "avg",
                        alias: "avg",
                        type: "string"
                    }, {
                        name: "maxPrice",
                        alias: "maxPrice",
                        type: "string"
                    }, {
                        name: "minPrice",
                        alias: "minPrice",
                        type: "string"
                    }
                    ];

                // Set up popup template for the layer
                var pTemplate = {
                    title: "销量",
                    content: [{
                        type: "fields",
                        fieldInfos: [{
                            fieldName: "area",
                            label: "销售面积",
                            visible: true
                        }, {
                            fieldName: "mount",
                            label: "销售套数",
                            visible: true
                        }, {
                            fieldName: "avg",
                            label: "均价",
                            visible: true
                        }, {
                            fieldName: "maxPrice",
                            label: "最高单价",
                            visible: true
                        }, {
                            fieldName: "minPrice",
                            label: "最低单价",
                            visible: true
                        }]
                    }]
                };

                var quakesRenderer = {
                    type: "simple", // autocasts as new SimpleRenderer()
                    label: "测试信息",
                    symbol: {
                        type: "simple-marker", // autocasts as new SimpleMarkerSymbol()
                        style: "circle",
                        size: 50,
                        color: [211, 255, 0, 0],
                        outline: {
                            width: 50,
                            color: "#FF0055",
                            style: "solid"
                        }
                    }
                };

                view.when(function() {
                    // Request the earthquake data from USGS when the view resolves
                    getData()
                            .then(createGraphics) // then send it to the createGraphics() method
                            .then(createLayer) // when graphics are created, create the layer
                            //.then(createLegend) // when layer is created, create the legend
                            .otherwise(errback);
                });

                function getData() {

                    // data downloaded from the USGS at http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/ on 4/4/16
                    // month.geojson represents recorded earthquakes between 03/04/2016 and 04/04/2016
                    // week.geojson represents recorded earthquakes betwen 03/28/2016 and 04/04/2016

                    var url = "data/xm.json";

                    return esriRequest(url, {
                        responseType: "json"
                    });
                }

                /**************************************************
                 * Create graphics with returned geojson data
                 **************************************************/

                function createGraphics(response) {
                    var geoJson = response.data;
                    return geoJson.map(function(feature, i) {
                        return {
                            geometry: new Point({
                                x: feature.x,
                                y: feature.y,
                                spatialReference:baseLayer.spatialReference
                            }),
                            // select only the attributes you care about
                            attributes: {
                                ObjectID: i,
                                title: feature.title,
                                area: feature.area,
                                mount: feature.mount,
                                avg: feature.avg,
                                x: feature.x,
                                y: feature.y,
                                maxPrice: feature.maxPrice,
                                minPrice: feature.minPrice
                            }
                        };
                    });
                }


                function createLayer(graphics) {
                    const statesLabelClass = new LabelClass({
                        labelExpressionInfo: { expression: "$feature.TITLE" },
                        labelPlacement:"center-center",
                        symbol: {
                            type: "text",  // autocasts as new TextSymbol()
                            color: "black",
                            haloSize: 2,
                            haloColor: "white"
                        }
                    });

                    var lyr = new FeatureLayer({
                        source: graphics, // autocast as an array of esri/Graphic
                        // create an instance of esri/layers/support/Field for each field object
                        fields: fields, // This is required when creating a layer from Graphics
                        objectIdField: "ObjectID", // This must be defined when creating a layer from Graphics
                        renderer: quakesRenderer, // set the visualization on the layer
                        spatialReference:baseLayer.spatialReference,
                        geometryType: "point", // Must be set when creating a layer from Graphics
                        popupTemplate: pTemplate,
                        labelsVisible: true,
                        labelingInfo : [statesLabelClass]
                    });
                    myMap.map.add(lyr);
                  //创建标注
                    for (var i = 0; i < graphics.length; i++) {
                        graphics[i].symbol = {
                            type: "text",  // autocasts as new TextSymbol()
                            color: "green",
                            haloColor: "dodgerblue",
                            haloSize: 2,
                            horizontalAlignmentString: "center",
                            text: graphics[i].attributes.title + "\t\n成交套数:" + graphics[i].attributes.mount + "成交面积：" + graphics[i].attributes.area,
                            xoffset: 3,
                            yoffset: 10,
                            font: {  // autocast as new Font()
                                size: 14,
                                weight: "bolder"
                            }
                        };
                        view.graphics.add(graphics[i]);
                    }
                    return lyr;
                }
/*
                /!******************************************************************
                 * Add layer to layerInfos in the legend
                 ******************************************************************!/

                function createLegend(layer) {
                    // if the legend already exists, then update it with the new layer
                    if (legend) {
                        legend.layerInfos = [{
                            layer: layer,
                            title: "Magnitude"
                        }];
                    } else {
                        legend = new Legend({
                            view: view,
                            layerInfos: [
                                {
                                    layer: layer,
                                    title: "Earthquake"
                                }]
                        }, "infoDiv");
                    }
                }*/

                // Executes if data retrieval was unsuccessful.
                function errback(error) {
                    console.error("Creating legend failed. ", error);
                }

            });

</script>
</body>
</html>