//
//  PoiSearchDemoViewController.h
//  BaiduMapApiDemo
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface PoiSearchDemoViewController : UIViewController<BMKMapViewDelegate, BMKPoiSearchDelegate> {
	IBOutlet BMKMapView* _mapView;
	IBOutlet UITextField* _cityText;
	IBOutlet UITextField* _keyText;
    IBOutlet UIButton* _nextPageButton;
    BMKPoiSearch* _poisearch;
    int curPage;
}

-(IBAction)onClickOk;
-(IBAction)onClickNextPage;
- (IBAction)textFiledReturnEditing:(id)sender;
@end
