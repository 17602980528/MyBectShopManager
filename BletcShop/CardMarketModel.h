//
//  CardMarketModel.h
//  BletcShop
//
//  Created by Bletc on 2017/1/16.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardMarketModel : NSObject
@property (nonatomic , assign) CGFloat cellHight;// <#Description#>


@property (nonatomic,copy)NSString *nickname;// 昵称
@property (nonatomic,copy)NSString *card_remain;// 余额
@property (nonatomic,copy)NSString *datetime;// 时间
@property (nonatomic,copy)NSString *store;// 店铺
@property (nonatomic,copy)NSString *method;// 类型(转让/分享)
@property (nonatomic,copy)NSString *card_level;// 卡级别
@property (nonatomic,copy)NSString *card_type;// 卡类型
@property (nonatomic,copy)NSString *card_code;// 卡类型
@property (nonatomic,copy)NSString *rule;// 折扣率

@property (nonatomic,copy)NSString *rate;// 手续费
@property (nonatomic,copy)NSString *uuid;// 用户uuid
@property (nonatomic,copy)NSString *muid;// 商户muid
@property (nonatomic,copy)NSString *address;// 地址
@property (nonatomic,copy)NSString *headimage;// 头像


-(CardMarketModel*)intiWithDictionary:(NSDictionary *)dic;
@end
