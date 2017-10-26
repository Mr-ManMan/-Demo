//
//  POISearchViewController.h
//  AMMapDemo
//
//  Created by 满 on 9/7/17.
//  Copyright © 2017 满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@class POISearchViewController;
@protocol PoiSelectDeleate<NSObject>
@optional
-(void)selectPoiWithCoor:(CLLocationCoordinate2D)coor selectType:(NSString *)selectType address:(NSString *)address;
@end

@interface POISearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>
{
    UITableView *baseTableView;
    AMapSearchAPI *searchAPI;
    AMapLocationManager *loctionManager;
    CLLocationCoordinate2D centerCoor;
    UISearchBar *poiSearchBar;
    NSString *city;
}
@property (nonatomic,copy) NSString *selectType;
@property (nonatomic,assign) id<PoiSelectDeleate>poiDeleate;
@end
