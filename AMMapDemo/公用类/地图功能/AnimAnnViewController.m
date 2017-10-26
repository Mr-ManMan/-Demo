//
//  AnimAnnViewController.m
//  AMMapDemo
//
//  Created by 满 on 9/6/17.
//  Copyright © 2017 满. All rights reserved.
//

#import "AnimAnnViewController.h"

@interface AnimAnnViewController ()
{
    NSMutableArray *pointArr;
}
@end

@implementation AnimAnnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    baseMapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    baseMapView.delegate = self;
    [self.view addSubview:baseMapView];
    
    animAnn = [[MAAnimatedAnnotation alloc]init];
    animAnn.title = @"动画";
    animAnn.coordinate = CLLocationCoordinate2DMake(39.914129, 116.403546);//设置初始位置
    [baseMapView addAnnotation:animAnn];
    
    pointArr = [[NSMutableArray alloc]init];
    NSDictionary *dic0 = @{@"lat":[NSNumber numberWithDouble:39.914129],@"lng":[NSNumber numberWithDouble:116.403546]};
    NSDictionary *dic1 = @{@"lat":[NSNumber numberWithDouble:39.914126],@"lng":[NSNumber numberWithDouble:116.404336]};
    NSDictionary *dic2 = @{@"lat":[NSNumber numberWithDouble:39.914153],@"lng":[NSNumber numberWithDouble:116.405508]};
    NSDictionary *dic3 = @{@"lat":[NSNumber numberWithDouble:39.913915],@"lng":[NSNumber numberWithDouble:116.405881]};
    NSDictionary *dic4 = @{@"lat":[NSNumber numberWithDouble:39.913562],@"lng":[NSNumber numberWithDouble:116.405832]};
    NSDictionary *dic5 = @{@"lat":[NSNumber numberWithDouble:39.91315],@"lng":[NSNumber numberWithDouble:116.405899]};
    NSDictionary *dic6 = @{@"lat":[NSNumber numberWithDouble:39.912234],@"lng":[NSNumber numberWithDouble:116.405904]};
    NSDictionary *dic7 = @{@"lat":[NSNumber numberWithDouble:39.911476],@"lng":[NSNumber numberWithDouble:116.405931]};
    NSDictionary *dic8 = @{@"lat":[NSNumber numberWithDouble:39.910674],@"lng":[NSNumber numberWithDouble:116.405949]};
    [pointArr addObject:dic0];
    [pointArr addObject:dic1];
    [pointArr addObject:dic2];
    [pointArr addObject:dic3];
    [pointArr addObject:dic4];
    [pointArr addObject:dic5];
    [pointArr addObject:dic6];
    [pointArr addObject:dic7];
    [pointArr addObject:dic8];
    
    CLLocationCoordinate2D coor[pointArr.count];
    for (int i=0; i<pointArr.count; i++)
    {
        coor[i].latitude = [pointArr[i][@"lat"] doubleValue];
        coor[i].longitude = [pointArr[i][@"lng"]doubleValue];
    }
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coor count:pointArr.count];
    [baseMapView addOverlay:polyline];
    //圈入地图可视范围内
    [baseMapView setVisibleMapRect:[CommonUtility mapRectForOverlays:@[polyline]] edgePadding:UIEdgeInsetsMake(50, 50, 50, 50) animated:YES];

    //只是简单的匀速移动
    [animAnn addMoveAnimationWithKeyCoordinates:coor count:9 withDuration:30 withName:nil completeCallback:^(BOOL isFinished) {
    }];
    //暂停
//    for (MAAnnotationMoveAnimation *animation in [self.annotation allMoveAnimations]) {
//        [animation cancel];
//    }
}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *renderer = [[MAPolylineRenderer alloc]initWithPolyline:(MAPolyline *)overlay];
        renderer.strokeColor = [UIColor orangeColor];
        renderer.lineWidth = 6;
        return renderer;
    }
    return nil;
}

-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    MAAnnotationView *annView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"reuse"];
    if (!annView)
    {
        annView = [[MAAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"reuse"];
    }
    annView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
    annView.draggable = YES;
    if ([annotation.title isEqualToString:@"动画"])
    {
        annView.image = [UIImage imageNamed:@"carImg"];
    }
    return annView;
}

@end
