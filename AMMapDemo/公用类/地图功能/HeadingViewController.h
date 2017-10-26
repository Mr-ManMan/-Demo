//
//  HeadingViewController.h
//  AMMapDemo
//
//  Created by 满 on 9/5/17.
//  Copyright © 2017 满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@interface HeadingViewController : UIViewController<MAMapViewDelegate,AMapLocationManagerDelegate>

@property (nonatomic,strong) MAMapView *baseMapView;

@property (nonatomic,strong) AMapLocationManager *locationManager;//定位

@property (nonatomic,strong) MAPointAnnotation *selfAnnotation;//自定义自己的位置

@property (nonatomic,strong) MAPointAnnotation *otherAnntation;//添加的其他的点标记
@end
