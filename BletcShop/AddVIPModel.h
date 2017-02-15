//
//  AddVIPModel.h
//  BletcShop
//
//  Created by Bletc on 16/9/29.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddVIPModel : NSObject
@property (nonatomic , weak) NSString *name;// 昵称
@property (nonatomic , weak) NSString *phone_s;// 手机号
@property (nonatomic , weak) NSString *img_str;// touxiang
@property (nonatomic , weak) NSString *sex_str;// 性别

-(AddVIPModel*)initModelWithDictionary:(NSDictionary*)dic;
@end
