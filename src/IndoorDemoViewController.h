//
//  IndoorDemoViewController.h
//  IphoneMapSdkDemo
//
//  Created by wzy on 16/5/23.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#ifndef IndoorDemoViewController_h
#define IndoorDemoViewController_h

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface IndoorDemoViewController : UIViewController<BMKMapViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *keyworkField;

- (IBAction)indoorSearchAction:(id)sender;


@end

@interface BMKIndoorFloorCell : UITableViewCell

@property (strong, nonatomic) UILabel *floorTitleLabel;

@end

#endif /* IndoorDemoViewController_h */
