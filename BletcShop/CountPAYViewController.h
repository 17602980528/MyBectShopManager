//
//  CountPAYViewController.h
//  BletcShop
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountPAYViewController : UIViewController

/**
 卡的信息
 */
@property (nonatomic , strong) NSDictionary *card_dic;


@property(nonatomic)float all;
@property(nonatomic)int payCount;
@end
