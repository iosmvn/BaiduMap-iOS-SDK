//
//  OpenBaiduMapDemo.m
//  IphoneMapSdkDemo
//
//  Created by wzy on 15/5/6.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "OpenBaiduMapDemo.h"
#import "PromptInfo.h"

@interface OpenBaiduMapDemo()<BMKOpenPanoramaDelegate> {
    BMKOpenPanorama *_openPanorama;//调起全景类
}

@end

@implementation OpenBaiduMapDemo


- (void)viewDidLoad
{
    [super viewDidLoad];
    _titleArray = [[NSArray alloc]initWithObjects:
                   @"启动百度地图驾车导航",
                   @"启动百度地图POI周边检索",
                   @"启动百度地图POI详情页面",
                   @"启动百度地图步行路线规划",
                   @"启动百度地图驾车路线规划",
                   @"启动百度地图公交路线规划",
                   @"启动百度地图步行导航",
                   @"启动百度地图骑行导航",
                   @"调起百度地图全景",
                      nil];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    _openPanorama = [[BMKOpenPanorama alloc] init];
}

-(void)viewWillAppear:(BOOL)animated {
    _openPanorama.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    _openPanorama.delegate = nil;
}

#pragma mark -
#pragma mark Table view data source


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"BaiduMapApiDemoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self openNativeNavi];
            break;
            
        case 1:
            [self openMapPoiNearby];
            break;
            
        case 2:
            [self openMapPoiDetail];
            break;
            
        case 3:
            [self openMapWalkingRoute];
            break;
            
        case 4:
            [self openMapDrivingRoute];
            break;
            
        case 5:
            [self openMapTransitRoute];
            break;
            
        case 6:
            [self openMapWalkOrRideNavi:YES];
            break;
            
        case 7:
            [self openMapWalkOrRideNavi:NO];
            break;
            
        case 8:
            [self openMapPanorama];
            break;
            
        default:
            break;
    }
}

#pragma mark - private
//打开客户端导航
- (void)openNativeNavi {
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    //初始化起点节点
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //指定起点经纬度
    CLLocationCoordinate2D coor1;
    coor1.latitude = 39.90868;
    coor1.longitude = 116.204;
    start.pt = coor1;
    //指定起点名称
    start.name = @"我的位置";
    //指定起点
    para.startPoint = start;
    
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    //指定终点经纬度
    CLLocationCoordinate2D coor2;
    coor2.latitude = 39.90868;
    coor2.longitude = 116.3956;
    end.pt = coor2;
    //指定终点名称
    end.name = @"天安门";
    //指定终点
    para.endPoint = end;
    
    //指定返回自定义scheme
    para.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    
    //调启百度地图客户端导航
    [BMKNavigation openBaiduMapNavigation:para];
}

//打开地图 poi详情
- (void)openMapPoiDetail {
    BMKOpenPoiDetailOption *opt = [[BMKOpenPoiDetailOption alloc] init];
    opt.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    opt.poiUid = @"d3099bdd81c525dbd1f49ee6";//天安门
    BMKOpenErrorCode code = [BMKOpenPoi openBaiduMapPoiDetailPage:opt];
    NSLog(@"%d", code);
    
    return;
}

//打开地图 poi周边
- (void)openMapPoiNearby {
    BMKOpenPoiNearbyOption *opt = [[BMKOpenPoiNearbyOption alloc] init];
    opt.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    opt.keyword = @"美食";

    opt.location = CLLocationCoordinate2DMake(39.915,116.360582);
    opt.radius = 1000;
    BMKOpenErrorCode code = [BMKOpenPoi openBaiduMapPoiNearbySearch:opt];
    NSLog(@"%d", code);
    return;
}

//打开地图 驾车路线检索
- (void)openMapDrivingRoute {
    BMKOpenDrivingRouteOption *opt = [[BMKOpenDrivingRouteOption alloc] init];
    //    opt.appName = @"SDK调起Demo";
    opt.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    //初始化起点节点
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //指定起点经纬度
    CLLocationCoordinate2D coor1;
    coor1.latitude = 39.90868;
    coor1.longitude = 116.204;
    //指定起点名称
    start.name = @"西直门";
    start.cityName = @"北京";
    //指定起点
    opt.startPoint = start;
    
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    CLLocationCoordinate2D coor2;
    coor2.latitude = 39.90868;
    coor2.longitude = 116.3956;
    end.pt = coor2;
    //指定终点名称
    end.name = @"天安门";
    end.cityName = @"北京";
    opt.endPoint = end;
    BMKOpenErrorCode code = [BMKOpenRoute openBaiduMapDrivingRoute:opt];
    NSLog(@"%d", code);
    return;
}

//打开地图 公交路线检索
- (void)openMapTransitRoute {
    BMKOpenTransitRouteOption *opt = [[BMKOpenTransitRouteOption alloc] init];
    //    opt.appName = @"SDK调起Demo";
    opt.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    //初始化起点节点
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //指定起点经纬度
    CLLocationCoordinate2D coor1;
    coor1.latitude = 39.90868;
    coor1.longitude = 116.204;
    //指定起点名称
    start.name = @"西直门";
    start.pt = coor1;
    //指定起点
    opt.startPoint = start;
    
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    CLLocationCoordinate2D coor2;
    coor2.latitude = 39.90868;
    coor2.longitude = 116.3956;
    end.pt = coor2;
    //指定终点名称
    end.name = @"天安门";
    opt.endPoint = end;
    
    BMKOpenErrorCode code = [BMKOpenRoute openBaiduMapTransitRoute:opt];
    NSLog(@"%d", code);
    return;
}

//打开地图 步行路线检索
- (void)openMapWalkingRoute {
    BMKOpenWalkingRouteOption *opt = [[BMKOpenWalkingRouteOption alloc] init];
    opt.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    //初始化起点节点
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //指定起点经纬度
    CLLocationCoordinate2D coor1;
    coor1.latitude = 39.90868;
    coor1.longitude = 116.204;
    start.pt = coor1;
    //指定起点名称
    start.name = @"西直门";
    //指定起点
    opt.startPoint = start;
    
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    CLLocationCoordinate2D coor2;
    coor2.latitude = 39.90868;
    coor2.longitude = 116.3956;
    end.pt = coor2;
    //指定终点名称
    end.name = @"天安门";
    opt.endPoint = end;
    
    BMKOpenErrorCode code = [BMKOpenRoute openBaiduMapWalkingRoute:opt];
    NSLog(@"%d", code);
    return;
}

//打开客户端步行/骑行导航
- (void)openMapWalkOrRideNavi:(BOOL) walk {
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    //指定终点经纬度
    end.pt = CLLocationCoordinate2DMake(39.90868, 116.3956);
    //指定终点名称
    end.name = @"天安门";
    //指定终点
    para.endPoint = end;
    
    //指定返回自定义scheme
    para.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    
    //调启百度地图客户端
    if (walk) {
        BMKOpenErrorCode code = [BMKNavigation openBaiduMapWalkNavigation:para];
        NSLog(@"调起步行导航：errorcode=%d", code);
    } else {
        BMKOpenErrorCode code = [BMKNavigation openBaiduMapRideNavigation:para];
        NSLog(@"调起骑行导航：errorcode=%d", code);
    }
}

//调起全景
- (void)openMapPanorama {
    BMKOpenPanoramaOption *option = [[BMKOpenPanoramaOption alloc] init];
    //指定返回自定义scheme
    option.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    option.poiUid = @"65e1ee886c885190f60e77ff";
    //调起百度地图全景页面,异步方法
    [_openPanorama openBaiduMapPanorama:option];
}

- (void)onGetOpenPanoramaStatus:(BMKOpenErrorCode)ecode {
    [PromptInfo showText:[NSString stringWithFormat:@"调起全景：errorcode=%d", ecode]];
}

@end