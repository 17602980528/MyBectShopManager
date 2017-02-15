//
//  Myitem.m
//  BletcShop
//
//  Created by Yuan on 16/1/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "Myitem.h"

@implementation Myitem
+(instancetype)itemsWithImg:(NSString *)img title:(NSString *)title vcClass:(Class)vcClass
{
    Myitem *item = [[Myitem alloc] init];
    item.img = img;
    item.title = title;
    item.vcClass = vcClass;
    
    return item;
}
@end
