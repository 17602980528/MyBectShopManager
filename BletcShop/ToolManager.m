
//
//  ToolManager.m
//  BletcShop
//
//  Created by Bletc on 16/9/12.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ToolManager.h"

@implementation ToolManager

+ (BOOL) validateMobile:(NSString *)mobile
{
    
    NSString *phoneRegex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    flag = [pred evaluateWithObject:identityCard];
    return flag;

    
}

+(BOOL)validateBankAccount:(NSString *)account{
    
    NSString *accountReg = @"^([0-9]{16}|[0-9]{19})$";
    
    NSPredicate *accountPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",accountReg];
    return [accountPre evaluateWithObject:account];
}

@end
