//
//  PolylineViewController.m
//  AMMapDemo
//
//  Created by 满 on 9/6/17.
//  Copyright © 2017 满. All rights reserved.
//

#import "PolylineViewController.h"

@interface PolylineViewController ()
{
    NSMutableArray *pointArr;
    NSMutableArray *colorArr;//画彩色路线颜色数组
}
@end

@implementation PolylineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    baseMapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    baseMapView.delegate = self;
    [self.view addSubview:baseMapView];
    /*
     116.403546,39.914129
     116.404336,39.914126
     116.405508,39.914153
     116.405881,39.913915
     116.405832,39.913562
     116.405899,39.91315
     116.405904,39.912234
     116.405931,39.911476
     116.405949,39.910674
     */
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
    
    [self loadPolyline];
}
-(void)loadPolyline
{
    NSMutableArray *colorIndexArr = [[NSMutableArray alloc]init];
    colorArr = [[NSMutableArray alloc]init];
    CLLocationCoordinate2D coor[pointArr.count];
    for (int i=0; i<pointArr.count; i++)
    {
        coor[i].latitude = [pointArr[i][@"lat"] doubleValue];
        coor[i].longitude = [pointArr[i][@"lng"]doubleValue];

        //火星坐标转换(只是一个例子)
//        CLLocation *location = [[CLLocation alloc]initWithLatitude:[pointArr[i][@"lat"] doubleValue] longitude:[pointArr[i][@"lng"]doubleValue]];
//        CLLocation *newLoction = [location locationMarsFromEarth];
//        coor[i] = newLoction.coordinate;
        
        //彩色线处理
        [colorIndexArr addObject:[NSNumber numberWithInt:i]];
        if (i <= 2)
        {
            [colorArr addObject:[UIColor redColor]];
        }
        else if (i <= 5)
        {
            [colorArr addObject:[UIColor greenColor]];
        }
        else if (i < pointArr.count)
        {
            [colorArr addObject:[UIColor orangeColor]];
        }
    }
    //单一颜色的路线
//    polyline = [MAPolyline polylineWithCoordinates:coor count:pointArr.count];
//    [baseMapView addOverlay:polyline];
//    //圈入地图可视范围内
//    [baseMapView setVisibleMapRect:[CommonUtility mapRectForOverlays:@[polyline]] edgePadding:UIEdgeInsetsMake(50, 50, 50, 50) animated:YES];
    
    //MAMultiPolyline 彩色路线
    MAMultiPolyline *multiPolyline = [MAMultiPolyline polylineWithCoordinates:coor count:pointArr.count drawStyleIndexes:colorIndexArr];
    [baseMapView addOverlay:multiPolyline];
    //圈入地图可视范围内
    [baseMapView setVisibleMapRect:[CommonUtility mapRectForOverlays:@[multiPolyline]] edgePadding:UIEdgeInsetsMake(50, 50, 50, 50) animated:YES];
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        if ([overlay isKindOfClass:[MAMultiPolyline class]])
        {//彩色线
            MAMultiColoredPolylineRenderer *multiRenerer = [[MAMultiColoredPolylineRenderer alloc]initWithMultiPolyline:(MAMultiPolyline *)overlay];
            multiRenerer.strokeColors = colorArr;
            multiRenerer.gradient = NO;//是否渐变
            multiRenerer.lineWidth = 6;
            return multiRenerer;
        }
        else
        {//单一颜色的线
            MAPolylineRenderer *renderer = [[MAPolylineRenderer alloc]initWithPolyline:polyline];
            renderer.strokeColor = [UIColor orangeColor];
            renderer.lineWidth = 6;
            return renderer;
        }
    }
    return nil;
}
@end
