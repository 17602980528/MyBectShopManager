//
//  Item.h
//  iqiyi_ios_sdk_demo
//
//  Created by 苏 瑞强 on 13-4-20.
//  Copyright (c) 2013年 meiwen li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject<NSCoding>
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *fileType;
@property (nonatomic, copy) NSString *fileId;
@property (nonatomic, copy) NSString* fileDesc;
@property (nonatomic) float     progress;
@property (nonatomic, strong)  NSDictionary* params;
-(id)initWithDict:(NSDictionary*)dict;
@end
