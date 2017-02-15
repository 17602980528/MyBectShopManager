//
//  CardMarketModel.m
//  BletcShop
//
//  Created by Bletc on 2017/1/16.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CardMarketModel.h"
#import "CardMarketCell.h"
@implementation CardMarketModel

-(CGFloat)cellHight{
    
    CardMarketCell *cell = [[CardMarketCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    _cellHight = [cell cellHeightWithModel:self];
    
    return _cellHight;
}

-(CardMarketModel*)intiWithDictionary:(NSDictionary *)dic;
{
    
    self.headimage = [NSString getTheNoNullStr:dic[@"headimage"] andRepalceStr:@""];
    self.nickname = [NSString getTheNoNullStr:dic[@"nickname"] andRepalceStr:@""];
    self.uuid = [NSString getTheNoNullStr:dic[@"uuid"] andRepalceStr:@""];

    self.method = [NSString getTheNoNullStr:dic[@"method"] andRepalceStr:@""];
    self.store = [NSString getTheNoNullStr:dic[@"store"] andRepalceStr:@""] ;
    self.card_remain = [NSString getTheNoNullStr:dic[@"card_remain"] andRepalceStr:@""];
    self.card_level = [NSString getTheNoNullStr:dic[@"card_level"] andRepalceStr:@""];
    self.card_code = [NSString getTheNoNullStr:dic[@"card_code"] andRepalceStr:@""];
    self.rule = [NSString getTheNoNullStr:dic[@"rule"] andRepalceStr:@""];

    self.datetime = [NSString getTheNoNullStr:dic[@"datetime"] andRepalceStr:@""];
    self.card_type = [NSString getTheNoNullStr:dic[@"card_type"] andRepalceStr:@""];
    self.rate = [NSString getTheNoNullStr:dic[@"rate"] andRepalceStr:@""];
    self.address = [NSString getTheNoNullStr:dic[@"address"] andRepalceStr:@""];
    self.muid = [NSString getTheNoNullStr:dic[@"muid"] andRepalceStr:@""];

    
    return self;
}
@end
