//
//  BonusCashViewController.h
//  BletcShop
//
//  Created by apple on 16/12/22.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BonusCashViewController : UIViewController
@property (nonatomic,copy)NSString *moneyString;// 可提金额;
@property(nonatomic,assign)id delegate;
@end
@protocol BonusCashViewControllerDelegate <NSObject>

-(void)bunosSuccess;

@end
