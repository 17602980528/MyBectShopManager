//
//  ShoppingViewController.h
//  BletcShop
//
//  Created by wuzhengdong on 16/1/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "DOPDropDownMenu.h"
@interface ShoppingViewController : UIViewController
@property (nonatomic,retain)NSString *menuTitle;
@property (nonatomic,copy)NSString *classifyString;
@property (nonatomic,copy)NSString *ereaString;
@property (nonatomic,copy)NSString *streetString;

@property(nonatomic)int indexss;


@end
