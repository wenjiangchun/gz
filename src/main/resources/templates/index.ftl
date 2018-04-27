<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>贵州三叠纪古地理GIS系统</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<link href="css/bootstrap.min.css" rel="stylesheet">
<link href="css/bootstrap-responsive.min.css" rel="stylesheet">
<link href="css/font-awesome.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/pages/dashboard.css" rel="stylesheet">
</head>
<body>
<#include "common/nav.ftl">
<!-- /subnavbar -->
<div class="main">
  <div class="main-inner">
    <div class="container">
      <div class="row">
        <div class="span6">
          <div class="widget widget-nopad">
            <div class="widget-header"> <i class="icon-list-alt"></i>
              <h3> 今日统计</h3>
            </div>
            <!-- /widget-header -->
            <div class="widget-content">
              <div class="widget big-stats-container">
                <div class="widget-content">
                  <#--<h6 class="bigstats">A fully responsive premium quality admin template built on Twitter Bootstrap by <a href="http://www.by EGrappler" target="_blank">by EGrappler</a>.  These are some dummy lines to fill the area.</h6>-->
                  <div id="big_stats" class="cf" style="width: 400px;height:280px;">
                    <div class="stat" title="入库金额"> <i class="icon-truck"></i> <span class="value">${buy!}</span> (元)</div>
                    <!-- .stat -->
                    
                    <div class="stat" title="销售金额"> <i class="icon-shopping-cart"></i> <span class="value">${sale!}</span>(元) </div>
                    <!-- .stat -->
                  </div>
                </div>
                <!-- /widget-content --> 
                
              </div>
            </div>
          </div>
          <!-- /widget -->
          <!-- /widget -->
          <!-- /widget -->
        </div>
          <div class="span6">
              <div class="widget widget-nopad">
                  <div class="widget-header"> <i class="icon-list-alt"></i>
                      <h3> 销量排行</h3>
                  </div>
                  <!-- /widget-header -->
                  <div class="widget-content">
                      <div class="widget big-stats-container">
                          <div class="widget-content">
                          <#--<h6 class="bigstats">A fully responsive premium quality admin template built on Twitter Bootstrap by <a href="http://www.by EGrappler" target="_blank">by EGrappler</a>.  These are some dummy lines to fill the area.</h6>-->
                              <div id="count_chart" class="cf" style="width: 400px;height:300px;">

                                  <!-- .stat -->
                              </div>
                          </div>
                          <!-- /widget-content -->

                      </div>
                  </div>
              </div>
              <!-- /widget -->
              <!-- /widget -->
              <!-- /widget -->
          </div>
          <#--<div class="span4">
              <div class="widget widget-nopad">
                  <div class="widget-header"> <i class="icon-list-alt"></i>
                      <h3> 利润排行</h3>
                  </div>
                  <!-- /widget-header &ndash;&gt;
                  <div class="widget-content">
                      <div class="widget big-stats-container">
                          <div class="widget-content">
                          &lt;#&ndash;<h6 class="bigstats">A fully responsive premium quality admin template built on Twitter Bootstrap by <a href="http://www.by EGrappler" target="_blank">by EGrappler</a>.  These are some dummy lines to fill the area.</h6>&ndash;&gt;
                              <div id="count_chart" class="cf">

                                  <!-- .stat &ndash;&gt;
                              </div>
                          </div>
                          <!-- /widget-content &ndash;&gt;

                      </div>
                  </div>
              </div>
              <!-- /widget &ndash;&gt;
              <!-- /widget &ndash;&gt;
              <!-- /widget &ndash;&gt;
          </div>-->
        <!-- /span6 -->
        <!-- /span6 -->
      </div>
      <!-- /row --> 
    </div>
    <!-- /container --> 
  </div>
  <!-- /main-inner --> 
</div>
<!-- /main -->
<!-- /extra -->
<#include "common/footer.ftl">
<!-- /footer --> 
<!-- Le javascript
================================================== --> 
<!-- Placed at the end of the document so the pages load faster --> 
<script src="js/jquery-1.7.2.min.js"></script> 
<script src="js/excanvas.min.js"></script> 
<script src="js/echarts.min.js" type="text/javascript"></script>
<script src="js/bootstrap.js"></script>
<script language="javascript" type="text/javascript" src="js/full-calendar/fullcalendar.min.js"></script>
 
<script src="js/base.js"></script> 
<script>     
       $(function() {
           $("#li_dashboard").addClass("active");
           initSaleCountChart();
       });

       function initSaleCountChart() {
           $.post("/findCountTop/2",function(data){
               var rs = [];
               var title = [];
               for (var i = 0; i < data.length; i++) {
                   rs.push({"value":data[i][1], "name":data[i][0]});
                   title.push(data[i][0]);
               }
               var option = {
                   title : {
                       text: '销售排行Top5',
                       subtext: '',
                       x:'center'
                   },
                   tooltip : {
                       trigger: 'item',
                       formatter: "{a} <br/>{b} : {c} ({d}%)"
                   },
                   legend: {
                       orient: 'vertical',
                       left: 'left',
                       data: title
                   },
                   series : [
                       {
                           name: '销售排行',
                           type: 'pie',
                           radius : '55%',
                           center: ['50%', '60%'],
                           data:rs,
                           itemStyle: {
                               emphasis: {
                                   shadowBlur: 10,
                                   shadowOffsetX: 0,
                                   shadowColor: 'rgba(0, 0, 0, 0.5)'
                               }
                           }
                       }
                   ]
               };
               var myChart = echarts.init(document.getElementById('count_chart'));
               myChart.setOption(option);
           },"json");
       }
       function initSaleProfitChart() {

       }
    </script><!-- /Calendar -->
</body>
</html>
