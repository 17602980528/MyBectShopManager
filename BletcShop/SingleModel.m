//
//  SingleModel.m
//  BletcShop
//
//  Created by apple on 17/3/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "SingleModel.h"

@implementation SingleModel
+(SingleModel *)sharedManager{
    static SingleModel *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
@end
