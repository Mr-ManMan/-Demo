//
//  POISearchViewController.m
//  AMMapDemo
//
//  Created by 满 on 9/7/17.
//  Copyright © 2017 满. All rights reserved.
//

#import "POISearchViewController.h"

@interface POISearchViewController ()
{
    NSArray *searchPoiArr;
    NSArray *poiArr;
    BOOL isSearch;
}
@end

@implementation POISearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    baseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    baseTableView.delegate = self;
    baseTableView.dataSource = self;
    [self.view addSubview:baseTableView];
    baseTableView.tableFooterView = [UIView new];
    
    poiSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    poiSearchBar.placeholder = @"搜索";
    poiSearchBar.delegate = self;
    baseTableView.tableHeaderView = poiSearchBar;
    
    isSearch = NO;
    searchPoiArr = [[NSArray alloc]init];
    poiArr = @[@"酒店",@"网吧",@"超市",@"饭店",@"电影院",@"公交站",@"公共厕所"];
    
    searchAPI = [[AMapSearchAPI alloc]init];
    searchAPI.delegate = self;
    
    loctionManager = [[AMapLocationManager alloc]init];
    loctionManager.delegate = self;
    [loctionManager startUpdatingLocation];
}
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    centerCoor = location.coordinate;
    //逆地理解析出当前城市
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc]init];
    request.location = [AMapGeoPoint locationWithLatitude:centerCoor.latitude longitude:centerCoor.longitude];
    [searchAPI AMapReGoecodeSearch:request];
}
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    AMapAddressComponent *component = response.regeocode.addressComponent;
    if (component.city.length != 0)
    {
        city = component.city;
    }
    else
    {
        city = component.province;
    }
//    NSLog(@"~~~当前地址~~~%@~~~~%@",response.regeocode.formattedAddress,city);
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length != 0)
    {
        AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc]init];
        request.cityLimit = YES;
        request.city = city;
        request.keywords = searchBar.text;
        [searchAPI AMapPOIKeywordsSearch:request];
        [MBProgressHUD lx_showActivityIndicatorWithText:@"正在搜索" toView:self.view];
    }
    else
    {
        isSearch = NO;
        [baseTableView reloadData];
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (searchBar.text.length == 0)
    {
        isSearch = NO;
        [baseTableView reloadData];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    if (searchBar.text.length != 0)
    {
        AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc]init];
        request.cityLimit = YES;
        request.city = city;
        request.keywords = searchBar.text;
        [searchAPI AMapPOIKeywordsSearch:request];
        [MBProgressHUD lx_showActivityIndicatorWithText:@"正在搜索" toView:self.view];
    }
    else
    {
        isSearch = NO;
        [baseTableView reloadData];
    }
}
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
//    NSLog(@"~~~~~~~~%@",response.pois);
    [MBProgressHUD lx_hideHUDForView:self.view animated:YES];
    [MBProgressHUD lx_showTextHUDWithText:@"搜索成功!" toView:self.view];
    isSearch = YES;
    searchPoiArr = response.pois;
    [baseTableView reloadData];
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [MBProgressHUD lx_hideHUDForView:self.view animated:YES];
    [MBProgressHUD lx_showTextHUDWithText:@"搜索失败!" toView:self.view];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearch == YES)
    {
        return searchPoiArr.count;
    }
    return poiArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (isSearch == YES)
    {
        cell.textLabel.text = [searchPoiArr[indexPath.row] name];
    }
    else
    {
        cell.textLabel.text = poiArr[indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearch == NO)
    {
        poiSearchBar.text = poiArr[indexPath.row];
        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc]init];
        request.location = [AMapGeoPoint locationWithLatitude:centerCoor.latitude longitude:centerCoor.longitude];
        request.keywords = poiArr[indexPath.row];
        [searchAPI AMapPOIAroundSearch:request];
        [MBProgressHUD lx_showActivityIndicatorWithText:@"正在搜索" toView:self.view];
    }
    else if (isSearch == YES)
    {
        if (self.selectType.length != 0)
        {
            if ([self.poiDeleate respondsToSelector:@selector(selectPoiWithCoor:selectType:address:)])
            {
                AMapGeoPoint *point = [(AMapPOI*)searchPoiArr[indexPath.row] location];
                [self.poiDeleate selectPoiWithCoor:CLLocationCoordinate2DMake(point.latitude, point.longitude) selectType:self.selectType  address:[(AMapPOI*)searchPoiArr[indexPath.row] name]];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}
@end
