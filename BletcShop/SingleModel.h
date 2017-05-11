//
//  SingleModel.h
//  BletcShop
//
//  Created by apple on 17/3/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleModel : NSObject
@property(nonatomic,copy)NSString *shopName;
@property(nonatomic,copy)NSString *advertTitle;//活动大标题
@property(nonatomic,copy)NSString *advertArea;//活动地区
@property(nonatomic,copy)NSString *advertKind;//活动类型
@property(nonatomic,copy)NSString *advertPosition;//活动position
@property(nonatomic,copy)NSString *advertSmallTitle;//活动小标题
@property(nonatomic,copy)NSString *advertDescription;//活动描述
@property(nonatomic,copy)NSString *advertImageUlr;//活动图片
@property(nonatomic,copy)NSString *baseOnCountsOrTime;//按此还是按天数
@property(nonatomic,copy)NSString *counts;//天数／次数
@property(nonatomic,copy)NSString *commmitDate;//提交日期
@property(nonatomic,copy)NSString *advertID;//活动ID
@property(nonatomic)NSInteger advertIndex;
@property(nonatomic,copy)NSString *payPass;
+(SingleModel *)sharedManager;
@end
