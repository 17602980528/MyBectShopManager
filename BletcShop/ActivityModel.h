//
//  ActivityModel.h
//  BletcShop
//
//  Created by Bletc on 2016/11/10.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject

@property (nonatomic,copy)NSString *activity;// 活动id
@property (nonatomic,copy)NSString *merchant;// 店铺注册id
@property (nonatomic,copy)NSString *Image_url;// 广告图片
@property (nonatomic,copy)NSString *text;// 广告文字
@property (nonatomic,copy)NSString *store;// 店铺名
@property (nonatomic,copy)NSString *sold;// 已售
@property (nonatomic,copy)NSString *latitude;// 纬度
@property (nonatomic,copy)NSString *longtitude;// 经度

-(ActivityModel*)initWithDic:(NSDictionary*)dic;
@end
