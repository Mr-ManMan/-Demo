//
//  Header.h
//  AMMapDemo
//
//  Created by 满 on 9/5/17.
//  Copyright © 2017 满. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define MAMapKey @"82d723999b6816378b8d4f8e82caa5e1"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height



#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MBProgressHUD+LXExtension/MBProgressHUD+LXExtension.h"

//地图封装
#import "CLLocation+Sino.h"//火星坐标转换
#import "CommonUtility.h"//地图可显示区域设置
#import "LineDashPolyline.h"//虚线描点
#import "SpeechSynthesizer.h"//导航语音合成

#import "ViewController.h"
#import "BaseSetViewController.h"
#import "HeadingViewController.h"
#import "PolylineViewController.h"
#import "AnimAnnViewController.h"
#import "POISearchViewController.h"
#import "RoutePlanViewController.h"

#endif /* Header_h */
