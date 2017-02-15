//
//  shareCardModel.m
//  BletcShop
//
//  Created by Bletc on 2016/11/2.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "shareCardModel.h"

@implementation shareCardModel

-(shareCardModel*)initModelWithDictionary:(NSDictionary*)dic;
{
    self.name = dic[@"name"];
    self.sex_str = dic[@"sex"];
    self.phone_s = dic[@"phone"];
    
    
    self.img_str = dic[@"headimage"];
    
    return self;
}
@end
