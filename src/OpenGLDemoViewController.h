//
//  OpenGLDemoViewController.h
//  IphoneMapSdkDemo
//
//  Created by wzy on 14-11-14.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface OpenGLDemoViewController : UIViewController <BMKMapViewDelegate>{
    IBOutlet BMKMapView* _mapView;
    
}


@end
