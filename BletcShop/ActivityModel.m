//
//  ActivityModel.m
//  BletcShop
//
//  Created by Bletc on 2016/11/10.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ActivityModel.h"



@implementation ActivityModel
-(ActivityModel*)initWithDic:(NSDictionary*)dic{

    self.activity = [NSString getTheNoNullStr:dic[@"id"] ? dic[@"id"] :dic[@"activity"] andRepalceStr:@""];
    self.merchant = [NSString getTheNoNullStr:dic[@"merchant"] andRepalceStr:@""];
    if ([self.activity intValue]==1) {
        
        
        self.Image_url = [NSString stringWithFormat:@"%@%@",THIER_ADVERTIMAGE,[NSString getTheNoNullStr:dic[@"image_url"] andRepalceStr:@""]];

    }
    
    if ([self.activity intValue]==2) {
        self.Image_url = [NSString stringWithFormat:@"%@%@",THIER_ADVERTIMAGE,[NSString getTheNoNullStr:dic[@"image_url"] andRepalceStr:@""]];
        
    }
    if ([self.activity intValue]==3) {
        
        self.Image_url = [NSString stringWithFormat:@"%@%@",THIER_ADVERTIMAGE,[NSString getTheNoNullStr:dic[@"image_url"] andRepalceStr:@""]];
        
    }
    if ([self.activity intValue]==4) {
        
        self.Image_url = [NSString stringWithFormat:@"%@%@",FOUR_ADVERTIMAGE,[NSString getTheNoNullStr:dic[@"advert_image_url"] andRepalceStr:@""]];
        
    }

    self.text = [NSString getTheNoNullStr:dic[@"info"] andRepalceStr:@""];
    self.store = [NSString getTheNoNullStr:dic[@"title"] andRepalceStr:@""];
    self.sold = [NSString stringWithFormat:@"已售%@单",[NSString getTheNoNullStr:dic[@"sold"] andRepalceStr:@"0"]];
    self.latitude = [NSString getTheNoNullStr:dic[@"latitude"] andRepalceStr:@""];
    self.longtitude = [NSString getTheNoNullStr:dic[@"longtitude"] andRepalceStr:@""];

    
    return self;
}

@end
