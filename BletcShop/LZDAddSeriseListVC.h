//
//  LZDAddSeriseListVC.h
//  BletcShop
//
//  Created by Bletc on 2017/6/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^reloadAPIBlock)();

@interface LZDAddSeriseListVC : UIViewController
@property (nonatomic,copy)reloadAPIBlock  block;// 刷新数据使用
@property (nonatomic,copy)NSString *cardTypeName;// 添加计次还是储值卡

@end
