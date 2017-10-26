//
//  ViewController.m
//  AMMapDemo
//
//  Created by 满 on 9/5/17.
//  Copyright © 2017 满. All rights reserved.
//

#import "ViewController.h"
#import "Header.h"

@interface ViewController ()
{
    NSArray *titleArr;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AMMapDemo";
    titleArr = @[@"地图基本设置",@"设备方向跟踪",@"描点画线",@"点平滑移动",@"POI搜索",@"出行路线规划和驾车导航",@"导航"];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = titleArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        BaseSetViewController *baseSetVc = [[BaseSetViewController alloc]init];
        baseSetVc.title = titleArr[indexPath.row];
        [self.navigationController pushViewController:baseSetVc animated:YES];
    }
    else if (indexPath.row == 1)
    {
        HeadingViewController *headingVc = [[HeadingViewController alloc]init];
        headingVc.title = titleArr[indexPath.row];
        [self.navigationController pushViewController:headingVc animated:YES];
    }
    else if (indexPath.row == 2)
    {
        PolylineViewController *polylineVc = [[PolylineViewController alloc]init];
        polylineVc.title = titleArr[indexPath.row];
        [self.navigationController pushViewController:polylineVc animated:YES];
    }
    else if (indexPath.row == 3)
    {
        AnimAnnViewController *animAnnVc = [[AnimAnnViewController alloc]init];
        animAnnVc.title = titleArr[indexPath.row];
        [self.navigationController pushViewController:animAnnVc animated:YES];
    }
    else if (indexPath.row == 4)
    {
        POISearchViewController *poiSearchVc = [[POISearchViewController alloc]init];
        poiSearchVc.title = titleArr[indexPath.row];
        [self.navigationController pushViewController:poiSearchVc animated:YES];
    }
    else if (indexPath.row == 5)
    {
        RoutePlanViewController *routePlanVc = [[RoutePlanViewController alloc]init];
        routePlanVc.title = titleArr[indexPath.row];
        [self.navigationController pushViewController:routePlanVc animated:YES];
    }
    else if (indexPath.row == 6)
    {
        compositeManager = [[AMapNaviCompositeManager alloc]init];
        compositeManager.delegate = self;
        [compositeManager presentRoutePlanViewControllerWithOptions:nil];
    }
}
@end
