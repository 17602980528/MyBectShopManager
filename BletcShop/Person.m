//
//  Person.m
//  BletcShop
//
//  Created by Bletc on 16/9/5.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "Person.h"

@implementation Person
+ (instancetype)modalWith:(NSString *)name imgStr:(NSString*)imgStr  idstring:(NSString *)idString;
{
    Person *p = [[Person alloc]init];
    p.name = name;
    p.imgStr = imgStr;
//    p.ID = ID_No;
    p.idstring = idString;
    return p;
}

@end
