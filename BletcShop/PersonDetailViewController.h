//
//  PersonDetailViewController.h
//  BletcShop
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonDetailViewController : UIViewController
//@property(nonatomic)NSInteger index;
@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,copy)NSString *totalMoney;
@end
