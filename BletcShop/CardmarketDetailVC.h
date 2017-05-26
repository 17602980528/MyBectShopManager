//
//  CardmarketDetailVC.h
//  BletcShop
//
//  Created by Bletc on 2017/1/16.
//  Copyright © 2017年 bletc. All rights reserved.
//


#import <UIKit/UIKit.h>


#import "CardMarketModel.h"
@interface CardmarketDetailVC : UIViewController

typedef void(^CardmarketDetailVCBlock)();

@property (nonatomic , strong) CardMarketModel *model;// <#Description#>


@property (nonatomic,copy)CardmarketDetailVCBlock block;// <#Description#>

@end
