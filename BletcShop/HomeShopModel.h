//
//  HomeShopModel.h
//  BletcShop
//
//  Created by Bletc on 2016/11/4.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeShopModel : NSObject

@property(nonatomic,copy)NSString *img_url; //图片
@property(nonatomic,copy)NSString *title_S;//商铺名
@property(nonatomic,copy) NSString *subTitl; //折扣描述
@property(nonatomic,copy) NSString *addTitl; //赠送描述
@property(nonatomic,copy) NSString *soldCount; //销量
@property(nonatomic,copy) NSString *muid; //销量

@property (nonatomic,copy)NSString *latitude;// 纬度
@property (nonatomic,copy)NSString *longtitude;// 经度


@property(nonatomic,copy)NSString *stars; //评分
@property(nonatomic,assign) CGFloat cellHight;


//长条广告的数据

@property (nonatomic,copy)NSString *remark;// 长条广告标记

@property(nonatomic,copy)NSString *long_img_url; //广告图



-(HomeShopModel*)initWithDictionary:(NSDictionary*)dic;


@end
