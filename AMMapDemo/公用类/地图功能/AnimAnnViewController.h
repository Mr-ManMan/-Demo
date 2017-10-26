//
//  AnimAnnViewController.h
//  AMMapDemo
//
//  Created by 满 on 9/6/17.
//  Copyright © 2017 满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@interface AnimAnnViewController : UIViewController<MAMapViewDelegate>
{
    MAMapView *baseMapView;
    MAAnimatedAnnotation *animAnn;
}
@end
