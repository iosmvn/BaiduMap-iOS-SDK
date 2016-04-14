//
//  DistrictSearchDemoViewController.m
//  IphoneMapSdkDemo
//
//  Created by wzy on 16/1/13.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "DistrictSearchDemoViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface DistrictSearchDemoViewController ()<BMKDistrictSearchDelegate> {
    BMKDistrictSearch *_districtSearch;
}

@end

@implementation DistrictSearchDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    _districtSearch = [[BMKDistrictSearch alloc] init];
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _districtSearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self districtSearch];
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _districtSearch.delegate = nil; // 不用时，置nil
}

- (void)districtSearch {
    BMKDistrictSearchOption *option = [[BMKDistrictSearchOption alloc] init];
    option.city = @"北京";
    option.district = @"海淀";
    BOOL flag = [_districtSearch districtSearch:option];
    if (flag) {
        NSLog(@"district检索发送成功");
    } else {
        NSLog(@"district检索发送失败");
    }
}

/**
 *返回行政区域搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKDistrictSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetDistrictResult:(BMKDistrictSearch *)searcher result:(BMKDistrictResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"onGetDistrictResult error: %d", error);
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"\nname:%@\ncode:%d\ncenter latlon:%lf,%lf", result.name, (int)result.code, result.center.latitude, result.center.longitude);
        
        BOOL flag = YES;
        for (NSString *path in result.paths) {
            BMKPolygon* polygon = [self transferPathStringToPolygon:path];
            if (polygon) {
                [_mapView addOverlay:polygon]; // 添加overlay
                if (flag) {
                    [self mapViewFitPolygon:polygon];
                    flag = NO;
                }
            }
        }
    }
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolygon class]]) {
        BMKPolygonView *polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.6];
        polygonView.fillColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:0.4];
        polygonView.lineWidth = 1;
        polygonView.lineDash = YES;
        return polygonView;
    }
    return nil;
}

//根据polygone设置地图范围
- (void)mapViewFitPolygon:(BMKPolygon *) polygon {
    CGFloat ltX, ltY, rbX, rbY;
    if (polygon.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polygon.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polygon.pointCount; i++) {
        BMKMapPoint pt = polygon.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

- (BMKPolygon*)transferPathStringToPolygon:(NSString*) path {
    if (path == nil || path.length < 1) {
        return nil;
    }
    NSArray *pts = [path componentsSeparatedByString:@";"];
    if (pts == nil || pts.count < 1) {
        return nil;
    }
    BMKMapPoint *points = new BMKMapPoint[pts.count];
    NSInteger index = 0;
    for (NSString *ptStr in pts) {
        if (ptStr && [ptStr rangeOfString:@","].location != NSNotFound) {
            NSRange range = [ptStr rangeOfString:@","];
            NSString *xStr = [ptStr substringWithRange:NSMakeRange(0, range.location)];
            NSString *yStr = [ptStr substringWithRange:NSMakeRange(range.location + range.length, ptStr.length - range.location - range.length)];
            if (xStr && xStr.length > 0 && [xStr respondsToSelector:@selector(doubleValue)]
                && yStr && yStr.length > 0 && [yStr respondsToSelector:@selector(doubleValue)]) {
                points[index] = BMKMapPointMake(xStr.doubleValue, yStr.doubleValue);
                index++;
            }
        }
    }
    BMKPolygon *polygon = nil;
    if (index > 0) {
        polygon = [BMKPolygon polygonWithPoints:points count:index];
    }
    delete [] points;
    return polygon;
}

@end