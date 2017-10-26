//
//  RoutePlanViewController.m
//  AMMapDemo
//
//  Created by 满 on 9/7/17.
//  Copyright © 2017 满. All rights reserved.
//

#import "RoutePlanViewController.h"

@interface RoutePlanViewController ()<PoiSelectDeleate>
{
    UIView *routeTypeView;
    UIView *lineView;//选中的出行方式下的线
    NSInteger selectRouteType;//选中的出行方式,默认为0 驾车
    MAPolyline *polyLine;
}
@end

@implementation RoutePlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self routeTypeView];
    baseMapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-64)*0.06+64, SCREEN_WIDTH, (SCREEN_HEIGHT-64)*0.94)];
    baseMapView.delegate = self;
    [self.view insertSubview:baseMapView atIndex:0];
    
    loctionManager = [[AMapLocationManager alloc]init];
    loctionManager.delegate = self;
    [loctionManager startUpdatingLocation];
    
    searchAPI = [[AMapSearchAPI alloc]init];
    searchAPI.delegate = self;
    
    [self initDriveView];
    navManager = [[AMapNaviDriveManager alloc]init];
    navManager.delegate = self;
    [navManager addDataRepresentative:navView];
    navView.hidden = YES;
}
#pragma mark ------导航
- (void)initDriveView
{
    if (navView == nil)
    {
        navView = [[AMapNaviDriveView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        navView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [navView setDelegate:self];
        
        [self.view addSubview:navView];
    }
}
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    [MBProgressHUD lx_hideHUDForView:self.view animated:YES];
    [MBProgressHUD lx_showTextHUDWithText:@"导航调用成功!" toView:self.view];
    navView.hidden = NO;
    [navManager startEmulatorNavi];
}
- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView
{
    navView.hidden = YES;
    [navManager stopNavi];
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
}
- (void)driveViewTrunIndicatorViewTapped:(AMapNaviDriveView *)driveView
{
    
}
- (BOOL)driveManagerIsNaviSoundPlaying:(AMapNaviDriveManager *)driveManager
{
    return [[SpeechSynthesizer sharedSpeechSynthesizer] isSpeaking];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}
#pragma mark -------地图, 画线
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    if (!selfAnn)
    {
        selfAnn = [[MAPointAnnotation alloc]init];
        selfAnn.title = @"我的位置";
        [baseMapView addAnnotation:selfAnn];
        [baseMapView setCenterCoordinate:location.coordinate animated:YES];
    }
    selfAnn.coordinate = location.coordinate;
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
        annView.image = [UIImage imageNamed:@"selfLocImg"];
    }
    if ([annotation.title isEqualToString:@"出发地"])
    {
        annView.image = [UIImage imageNamed:@"otherAnnImg"];
    }
    if ([annotation.title isEqualToString:@"目的地"])
    {
        annView.image = [UIImage imageNamed:@"destinationImg"];
    }
    return annView;
}
-(void)routeTypeView
{
    routeTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, (SCREEN_HEIGHT-64)*0.06)];
    routeTypeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:routeTypeView];
    NSArray *typeArr = @[@"驾车",@"步行",@"骑行"];
    for (int i=0; i<3; i++)
    {
        UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typeBtn.frame = CGRectMake(SCREEN_WIDTH*i/3, 0, SCREEN_WIDTH/3, (SCREEN_HEIGHT-64)*0.06-3);
        [typeBtn setTitle:typeArr[i] forState:UIControlStateNormal];
        typeBtn.tag = 100+i;
        [typeBtn addTarget:self action:@selector(routeTypeSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [routeTypeView addSubview:typeBtn];
    }
    for (int i=0; i<2; i++)
    {
        UIButton *pointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pointBtn.frame = CGRectMake(SCREEN_WIDTH*0.5*i, (SCREEN_HEIGHT-64)*0.92+64, SCREEN_WIDTH*0.5, (SCREEN_HEIGHT-64)*0.08);
        switch (i) {
            case 0:
                [pointBtn setTitle:@"选择起点" forState:UIControlStateNormal];
                break;
            case 1:
                [pointBtn setTitle:@"选择终点" forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
        pointBtn.tag = 200+i;
        [pointBtn addTarget:self action:@selector(pointSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [pointBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        pointBtn.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:pointBtn];
    }
    selectRouteType = 0;
    [self selectTypeWithLineViewX];
}
-(void)routeTypeSelectBtnClick:(UIButton *)btn
{
    selectRouteType = btn.tag - 100;
    [self selectTypeWithLineViewX];
    [self routeLine];
}
-(void)selectTypeWithLineViewX
{
    if (!lineView)
    {
        lineView = [[UIView alloc]init];
        lineView.frame = CGRectMake(0, (SCREEN_HEIGHT-64)*0.06-3, SCREEN_WIDTH/3, 3);
        lineView.backgroundColor = [UIColor greenColor];
        [routeTypeView addSubview:lineView];
    }
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint point = lineView.frame.origin;
        point.x = SCREEN_WIDTH*selectRouteType/3;
        lineView.frame = CGRectMake(point.x, point.y, SCREEN_WIDTH/3, 3);
    }];
}
-(void)pointSelectBtnClick:(UIButton *)btn
{
    POISearchViewController *poiSearchVc = [[POISearchViewController alloc]init];
    poiSearchVc.title = btn.titleLabel.text;
    poiSearchVc.poiDeleate = self;
    switch (btn.tag-200) {
        case 0:
            poiSearchVc.selectType = @"origin";
            break;
        case 1:
            poiSearchVc.selectType = @"destination";
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:poiSearchVc animated:YES];
}
-(void)selectPoiWithCoor:(CLLocationCoordinate2D)coor selectType:(NSString *)selectType address:(NSString *)address
{
    NSLog(@"~~~~~~~~%f~~~~%f",coor.latitude,coor.longitude);
    if ([selectType isEqualToString:@"origin"])
    {
        if (!startAnn)
        {
            startAnn = [[MAPointAnnotation alloc]init];
            startAnn.title = @"出发地";
            [baseMapView addAnnotation:startAnn];
        }
        startAnn.subtitle = address;
        startAnn.coordinate = coor;
        if (endAnn)
        {
            [self routeLine];
        }
    }
    else if ([selectType isEqualToString:@"destination"])
    {
        if (!endAnn)
        {
            endAnn = [[MAPointAnnotation alloc]init];
            endAnn.title = @"目的地";
            [baseMapView addAnnotation:endAnn];
        }
        endAnn.subtitle = address;
        endAnn.coordinate = coor;
        [self routeLine];
    }
    
    [baseMapView setVisibleMapRect:[CommonUtility minMapRectForAnnotations:baseMapView.annotations] edgePadding:UIEdgeInsetsMake(SCREEN_HEIGHT*0.2, SCREEN_WIDTH*0.2, SCREEN_HEIGHT*0.2, SCREEN_WIDTH*0.2) animated:YES];
}
-(void)routeLine
{
    AMapRouteSearchBaseRequest *request = nil;
    if (selectRouteType == 0)
    {
        request = [[AMapDrivingRouteSearchRequest alloc]init];
    }
    else if (selectRouteType == 1)
    {
        request = [[AMapWalkingRouteSearchRequest alloc]init];
    }
    else if (selectRouteType == 2)
    {
        request = [[AMapRidingRouteSearchRequest alloc]init];
    }
    if (!startAnn)
    {
        request.origin = [AMapGeoPoint locationWithLatitude:selfAnn.coordinate.latitude longitude:selfAnn.coordinate.longitude];
    }
    else
    {
        request.origin = [AMapGeoPoint locationWithLatitude:startAnn.coordinate.latitude longitude:startAnn.coordinate.longitude];
    }
    if (endAnn)
    {
        request.destination = [AMapGeoPoint locationWithLatitude:endAnn.coordinate.latitude longitude:endAnn.coordinate.longitude];
        if (selectRouteType == 0)
        {
            [searchAPI AMapDrivingRouteSearch:(AMapDrivingRouteSearchRequest *)request];
        }
        else if (selectRouteType == 1)
        {
            [searchAPI AMapWalkingRouteSearch:(AMapWalkingRouteSearchRequest *)request];
        }
        else if (selectRouteType == 2)
        {
            [searchAPI AMapRidingRouteSearch:(AMapRidingRouteSearchRequest *)request];
        }
        [MBProgressHUD lx_showActivityIndicatorWithText:@"正在路径规划" toView:self.view];
    }
}
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    NSLog(@"~~~~~~route~~~%@",response.route);
    [MBProgressHUD lx_hideHUDForView:self.view animated:YES];
    [MBProgressHUD lx_showTextHUDWithText:@"路径规划成功!" toView:self.view];
    //取第一条路线显示
    CLLocationCoordinate2D coor[response.route.paths[0].steps.count+2];
    coor[0] = selfAnn.coordinate;
    if (startAnn)
    {
        coor[0] = startAnn.coordinate;
    }
    for (int i=0; i<response.route.paths[0].steps.count; i++)
    {
        AMapStep *step = response.route.paths[0].steps[i];
        NSArray *pointStrArr = [step.polyline componentsSeparatedByString:@";"];
        for (NSString *pointStr in pointStrArr)
        {
            NSArray *latLngArr = [pointStr componentsSeparatedByString:@","];
            coor[i+1] = CLLocationCoordinate2DMake([latLngArr[1] doubleValue], [latLngArr[0] doubleValue]);
        }
    }
    coor[response.route.paths[0].steps.count+1] = endAnn.coordinate;
    if (!polyLine)
    {
        polyLine = [[MAPolyline alloc]init];
        [baseMapView addOverlay:polyLine];
    }
    [polyLine setPolylineWithCoordinates:coor count:response.route.paths[0].steps.count+2];
    
    [baseMapView setVisibleMapRect:[CommonUtility mapRectForOverlays:@[polyLine]] edgePadding:UIEdgeInsetsMake(50, 50, 50, 50) animated:YES];
    
    //开启导航
    [navManager calculateDriveRouteWithStartPoints:@[request.origin] endPoints:@[request.destination] wayPoints:nil drivingStrategy:17];
    [MBProgressHUD lx_showActivityIndicatorWithText:@"正在调用导航" toView:self.view];

}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [MBProgressHUD lx_hideHUDForView:self.view animated:YES];
    [MBProgressHUD lx_showTextHUDWithText:@"路径规划失败!" toView:self.view];
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if (overlay == polyLine)
    {
        MAPolylineRenderer *renderer = [[MAPolylineRenderer alloc]initWithPolyline:polyLine];
        renderer.lineWidth = 6;
        renderer.strokeColor = [UIColor orangeColor];
        return renderer;
    }
    return nil;
}
@end
