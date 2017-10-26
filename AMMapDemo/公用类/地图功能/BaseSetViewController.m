//
//  BaseSetViewController.m
//  AMMapDemo
//
//  Created by 满 on 9/5/17.
//  Copyright © 2017 满. All rights reserved.
//

#import "BaseSetViewController.h"
#import "Header.h"
@interface BaseSetViewController ()

@end

@implementation BaseSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseMapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.baseMapView.zoomLevel = 14;//缩放比例
//    self.baseMapView.showsScale = YES;//显示缩放比例尺
//    self.baseMapView.showsCompass = YES;//显示罗盘
//    self.baseMapView.mapType = MAMapTypeStandard;//地图类型 普通地图< 卫星地图< 夜间视图< 导航视图< 公交视图
    [self.view addSubview:self.baseMapView];
    //自己位置(小蓝点)设置
    self.baseMapView.showsUserLocation = YES;//显示自己的位置
    self.baseMapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    self.baseMapView.customizeUserLocationAccuracyCircleRepresentation = YES;//去掉我的位置的蓝色的圈
}


@end
