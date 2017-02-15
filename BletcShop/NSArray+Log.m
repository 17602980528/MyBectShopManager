//
//  NSArray+Log.m
//  Array
//
//  Created by 609972942 on 15/5/13.
//  Copyright (c) 2015年 ios初学. All rights reserved.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)


- (NSString *)descriptionWithLocale:(id)locale{
    NSMutableString *string= [[NSMutableString alloc]initWithCapacity:self.count + 2];
    
    [string appendString:@"("];
    
//    for (id object in self) {
//        [string appendFormat:@"\n\t\"%@\",",object];
//    }
    
    for (NSInteger i =0; i < self.count; i ++) {
        NSString *c = [self objectAtIndex:i];
        [string appendFormat:@"\n\t\"%@\",",c];
    }
    
    [string appendString:@"\n)"];
    
    return string;
}

@end
