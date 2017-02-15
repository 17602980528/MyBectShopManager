//
//  BookItem.m
//  StorageAndLayout_i7_Demo
//
//  Created by guo on 13-8-10.
//  Copyright (c) 2013年 guo5. All rights reserved.
//

#import "BookItem.h"

@interface BookItem ()
{
    NSMutableAttributedString *_attributedText;
}
@end

@implementation BookItem
-(id)initWithBookName:(NSString *)bookName
{
    self = [super init];
    if (self) {
        self.bookName = bookName;
    }
    return self;
}

-(NSAttributedString *)content
{
    NSURL *url = nil;
    url = [[NSBundle mainBundle] URLForResource:self.bookName withExtension:nil];
    NSMutableAttributedString *attributedTextHolder = [[NSMutableAttributedString alloc] initWithFileURL:url options:@{} documentAttributes:nil error:nil];
    [attributedTextHolder addAttribute:NSFontAttributeName value:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] range:NSMakeRange(0, attributedTextHolder.length)];
    _attributedText = [attributedTextHolder copy];
    return _attributedText;
}

@end
