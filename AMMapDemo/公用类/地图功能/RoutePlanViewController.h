//
//  RoutePlanViewController.h
//  AMMapDemo
//
//  Created by 满 on 9/7/17.
//  Copyright © 2017 满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@interface RoutePlanViewController : UIViewController<MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate,AMapNaviDriveManagerDelegate,AMapNaviDriveViewDelegate>
{
    MAMapView *baseMapView;
    AMapLocationManager *loctionManager;
    AMapSearchAPI *searchAPI;
    MAPointAnnotation *selfAnn;
    MAPointAnnotation *startAnn;
    MAPointAnnotation *endAnn;
    AMapNaviDriveManager *navManager;
    AMapNaviDriveView *navView;
}
@end
