//
//  PlatCouponsVC.h
//  BletcShop
//
//  Created by Bletc on 2017/5/26.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PlatCouponsVCBlock)(NSDictionary *couponInfo);

@interface PlatCouponsVC : UITableViewController
@property int useCoupon;//100代表从购买卡进入
@property (nonatomic,copy)NSString *muid;// <#Description#>

@property (nonatomic,copy)NSString *moneyString;


@property (nonatomic,copy)PlatCouponsVCBlock block;//

@end
