//
//  ViewController.h
//  AMMapDemo
//
//  Created by 满 on 9/5/17.
//  Copyright © 2017 满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AMapNaviCompositeManagerDelegate>
{    
    __weak IBOutlet UITableView *baseTableView;
    AMapNaviCompositeManager *compositeManager;
}

@end

