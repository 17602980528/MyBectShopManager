//
//  UPgradeVC.h
//  BletcShop
//
//  Created by Bletc on 2016/11/21.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPgradeVC : UIViewController
/**
 卡的信息
 */
@property (nonatomic , strong) NSDictionary *card_dic;

@property(nonatomic,retain)NSMutableArray *resultArray;//点击升级按钮 返回数据


@end
