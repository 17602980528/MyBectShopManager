//
//  LZDTextView.h
//  BletcShop
//
//  Created by 鲁征东 on 16/9/1.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZDTextView : UITextView
{
    UIColor *_contentColor;
    BOOL _editing;
}
@property(strong, nonatomic) NSString *placeholder;
@property(strong, nonatomic) UIColor *placeholderColor;

@end
