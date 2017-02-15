
//
//  NSDictionary+Log.m
//  字典NSDictionary
//
//  Created by 609972942 on 14-10-12.
//  Copyright (c) 2014年 ios初学. All rights reserved.
//

#import "NSDictionary+Log.h"

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale{
    
//  返回将要拼接的字符串
    NSMutableString *valueString=[NSMutableString stringWithCapacity:self.count];
//  返回value
    NSString *value=[NSString string];
//  返回key
    NSString *string=[NSString string];
    
//  按系统形式拼接
    [valueString appendString:@"{"];
//  遍历字典
    for (id obj in self) {
//      打印遍历的所有key
//        NSLog(@"%@",obj);
        value=[self valueForKey:obj];
//      打印遍历的所有value
//        NSLog(@"%@",value);
        
        [valueString appendFormat:@"\n\t%@ = \"%@\";",obj,value];
    }
//  按系统形式拼接
    [valueString appendString:@"\n}"];
//  打印
    NSLog(@"%@",valueString);
    return string;
}


//字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];  
    
    if(err) {  
        
        NSLog(@"json解析失败：%@",err);  
        
        return nil;  
        
    }  
    
    return dic;  
    
}
@end
