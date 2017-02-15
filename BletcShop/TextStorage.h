//
//  TextStorage.h
//  StorageAndLayout_i7_Demo
//
//  Created by guo on 13-8-10.
//  Copyright (c) 2013年 guo5. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookItem.h"

NSString *const DefaultTokenName;

@interface TextStorage : NSTextStorage
@property (nonatomic, strong) NSString     *fontName;
@property (nonatomic, copy)   NSDictionary *tokens; // a dictionary, keyed by text snippets（小片段）, with attributes we want to add
@property (nonatomic, strong) BookItem     *bookItem;
@end
