//
//  KeyChainStore.h
//  BletcShop
//
//  Created by apple on 17/3/28.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;
@end
