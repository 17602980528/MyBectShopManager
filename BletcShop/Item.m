//
//  Item.m
//  iqiyi_ios_sdk_demo
//
//  Created by 苏 瑞强 on 13-4-20.
//  Copyright (c) 2013年 meiwen li. All rights reserved.
//

#import "Item.h"

@implementation Item

//===========================================================
//  Keyed Archiving
//
//===========================================================
-(id)initWithDict:(NSDictionary*)dict
{
    if (self=[super init]) {
        self.filePath = [dict objectForKey:@"filePath"];
        if ((id)self.filePath==[NSNull null]) {
            self.filePath = nil;
        }
        self.fileId = [dict objectForKey:@"fileId"];
        if ((id)self.fileId==[NSNull null]) {
            self.fileId = nil;
        }
        self.params = [dict objectForKey:@"params"];
        //YOU CAN ADD HERE OTHER PARAMS
        self.progress = [[dict objectForKey:@"percent"] floatValue];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.fileName forKey:@"fileName"];
    [encoder encodeObject:self.filePath forKey:@"filePath"];
    [encoder encodeObject:self.fileType forKey:@"fileType"];
    [encoder encodeObject:self.fileId forKey:@"fileId"];
    [encoder encodeObject:self.params forKey:@"params"];
    //YOU CAN ADD HERE OTHER PARAMS
}


- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        _fileName = [decoder decodeObjectForKey:@"fileName"] ;
        _filePath = [decoder decodeObjectForKey:@"filePath"] ;
        _fileType = [decoder decodeObjectForKey:@"fileType"] ;
        _fileId = [decoder decodeObjectForKey:@"fileId"] ;
        _params = [decoder decodeObjectForKey:@"params"];
    }
    return self;
}


@end
