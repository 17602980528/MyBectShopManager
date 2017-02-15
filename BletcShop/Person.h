//
//  Person.h
//  BletcShop
//
//  Created by Bletc on 16/9/5.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
//@property(nonatomic,assign) NSInteger ID;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *imgStr;
@property(nonatomic,copy)NSString *idstring;


+ (instancetype)modalWith:(NSString *)name imgStr:(NSString*)imgStr  idstring:(NSString *)idString;

@end
