//
//  TextStorage.m
//  StorageAndLayout_i7_Demo
//
//  Created by guo on 13-8-10.
//  Copyright (c) 2013年 guo5. All rights reserved.
//

#import "TextStorage.h"

NSString *const DefaultTokenName = @"DefaultTokenName";

@interface TextStorage ()
{
    NSMutableAttributedString *_storingText; // 存储的文字
    BOOL _dynamicTextNeedsUpdate;            // 文字是否需要更新
}
@end

@implementation TextStorage

// get fontName Snell RoundHand
-(NSString *)fontName
{
    NSArray *fontFamily = [UIFont familyNames];
    NSString *str = fontFamily[2];
    // NSLog(@"%@", str);
    return str;
}

// initial
-(id)init
{
    self = [super init];
    if (self) {
        _storingText = [[NSMutableAttributedString alloc] init];
    }
    return self;
}

// Must override NSAttributedString primitive method
// 返回保存的文字
-(NSString *)string
{
    return [_storingText string];
}

// 获取指定范围内的文字属性
-(NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_storingText attributesAtIndex:location effectiveRange:range];
}

// Must override NSMutableAttributedString primitive method
// 设置指定范围内的文字属性
-(void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [self beginEditing];
    [_storingText setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0]; // Notifies and records a recent change.  If there are no outstanding -beginEditing calls, this method calls -processEditing to trigger post-editing processes.  This method has to be called by the primitives after changes are made if subclassed and overridden.  editedRange is the range in the original string (before the edit).
    [self endEditing];
}

// 修改指定范围内的文字
-(void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    [self beginEditing];
    [_storingText replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedAttributes | NSTextStorageEditedCharacters range:range changeInLength:str.length - range.length];
    _dynamicTextNeedsUpdate = YES;
    [self endEditing];
}

// Sends out -textStorage:willProcessEditing, fixes the attributes, sends out -textStorage:didProcessEditing, and notifies the layout managers of change with the -processEditingForTextStorage:edited:range:changeInLength:invalidatedRange: method.  Invoked from -edited:range:changeInLength: or -endEditing.
-(void)processEditing
{
    if (_dynamicTextNeedsUpdate) {
        _dynamicTextNeedsUpdate = NO;
        [self performReplacementsForCharacterChangeInRange:[self editedRange]];
    }
    [super processEditing];
}

- (void)performReplacementsForCharacterChangeInRange:(NSRange)changedRange
{
    NSRange extendedRange = NSUnionRange(changedRange, [[_storingText string] lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(changedRange, [[_storingText string] lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    
    [self applyTokenAttributesToRange:extendedRange];
}

- (void)applyTokenAttributesToRange:(NSRange)searchRange
{
    NSDictionary *defaultAttributes = [self.tokens objectForKey:DefaultTokenName];
    
    [[_storingText string] enumerateSubstringsInRange:searchRange options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        NSDictionary *attributesForToken = [self.tokens objectForKey:substring];
        if(!attributesForToken)
            attributesForToken = defaultAttributes;
        
        if(attributesForToken)
            [self addAttributes:attributesForToken range:substringRange];
        else
            NSLog(@"attributesForToken == nil");
    }];
}

@end
