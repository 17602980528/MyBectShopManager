//
//  AddVIPModel.m
//  BletcShop
//
//  Created by Bletc on 16/9/29.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "AddVIPModel.h"

@implementation AddVIPModel
-(AddVIPModel*)initModelWithDictionary:(NSDictionary*)dic;
{
    self.name = dic[@"user"];
    self.sex_str = dic[@"sex"];
    self.phone_s = dic[@"phone"];
    
    
    self.img_str = dic[@"headimage"];

    return self;
}
@end
