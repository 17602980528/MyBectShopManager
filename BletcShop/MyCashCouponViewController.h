//
//  MyCashCouponViewController.h
//  BletcShop
//
//  Created by Bletc on 16/7/26.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
// 新建一个协议，协议的名字一般是由“类名+Delegate”
@protocol ViewControllerBDelegate <NSObject>

// 代理传值方法
- (void)sendValue:(NSDictionary *)value;

@end
@interface MyCashCouponViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *data;
@property (nonatomic,strong)NSMutableArray *couponArray;

@property int useCoupon;
// 委托代理人，代理一般需使用弱引用(weak)
@property (weak, nonatomic) id<ViewControllerBDelegate> delegate;
@end
