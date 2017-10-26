//
//  HeadingViewController.m
//  AMMapDemo
//
//  Created by 满 on 9/5/17.
//  Copyright © 2017 满. All rights reserved.
//

#import "HeadingViewController.h"

@interface HeadingViewController ()
{
    CGFloat angle;
}
@end

@implementation HeadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.baseMapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.baseMapView.zoomLevel = 14;//缩放比例
    self.baseMapView.showsUserLocation = NO;//显示自己的位置 自定义
    self.baseMapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;//追踪用户的location与heading更新
    self.baseMapView.customizeUserLocationAccuracyCircleRepresentation = YES;//去掉我的位置的蓝色的圈
    self.baseMapView.delegate = self;
    [self.view addSubview:self.baseMapView];
    
    self.locationManager = [[AMapLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];//开启定位
    
    self.otherAnntation = [[MAPointAnnotation alloc]init];
    self.otherAnntation.coordinate = CLLocationCoordinate2DMake(39.832136, 116.34095);
    self.otherAnntation.title = @"其他";
    self.otherAnntation.subtitle = @"其他";
    [self.baseMapView addAnnotation:self.otherAnntation];
    
    
}
#pragma mark -----AMapLocationManagerDelegate---
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    if (!self.selfAnnotation)
    {
        self.selfAnnotation = [[MAPointAnnotation alloc]init];
        self.selfAnnotation.title = @"我的位置";
        self.selfAnnotation.subtitle = @"我的位置";
        [self.baseMapView addAnnotation:self.selfAnnotation];
    }
    self.selfAnnotation.coordinate = location.coordinate;
    //让地图上的所有的点标记显示在地图可视范围内
//    [self.baseMapView setVisibleMapRect:[CommonUtility minMapRectForAnnotations:@[self.selfAnnotation,self.otherAnntation]] edgePadding:UIEdgeInsetsMake(50, 50, 50, 50) animated:YES];
}
#pragma mark -----MAMapViewDelegate----
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    angle = userLocation.heading.trueHeading;
    [self animation];
}
-(void)animation
{
    UIImageView *imgView = [self.view viewWithTag:100];
    //动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    imgView.transform = CGAffineTransformMakeRotation(angle * (M_PI/180.0));
    [UIView commitAnimations];
}
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    MAAnnotationView *annView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"reuse"];
    if (!annView)
    {
        annView = [[MAAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"reuse"];
    }
    annView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
    annView.draggable = YES;        //设置标注可以拖动，默认为NO

    if ([annotation.title isEqualToString:@"我的位置"])
    {
        //annView.bounds = CGRectMake(0, 0, 53, 53);//可设置大小
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"selfLocImg"]];
        imgView.center = annView.center;
        imgView.bounds = CGRectMake(0, 0, 30, 30);
        imgView.tag = 100;
        [annView addSubview:imgView];
    }
    if ([annotation.title isEqualToString:@"其他"])
    {
        annView.bounds = CGRectMake(0, 0, 53, 53);
        annView.image = [UIImage imageNamed:@"otherAnnImg"];
    }
    return annView;
}
@end
