//
//  BookItem.h
//  StorageAndLayout_i7_Demo
//
//  Created by guo on 13-8-10.
//  Copyright (c) 2013年 guo5. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookItem : NSObject
@property (nonatomic, strong) NSString *bookName;
@property (nonatomic, strong) NSAttributedString *content;
-(id)initWithBookName:(NSString *)bookName;
@end
