//
//  ConvertCostVC.h
//  BletcShop
//
//  Created by apple on 17/2/28.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConvertCostVC : UIViewController
@property(nonatomic,copy)NSString *imageNameString;
@property(nonatomic,copy)NSString *shopNameString;
@property(nonatomic,copy)NSString *totalPoint;
@property(nonatomic,copy)NSString *shopNeedPoint;
@property(nonatomic,copy)NSString *converRecordCount;
@property(nonatomic,strong)NSDictionary *infoDic;
@end
