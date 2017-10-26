//
//  BaseSetViewController.h
//  AMMapDemo
//
//  Created by 满 on 9/5/17.
//  Copyright © 2017 满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@interface BaseSetViewController : UIViewController<AMapLocationManagerDelegate>

@property (nonatomic,strong) MAMapView *baseMapView;

@property (nonatomic,strong) AMapLocationManager *locationManager;//定位

@end
