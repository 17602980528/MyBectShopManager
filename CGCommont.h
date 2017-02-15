//
//  CGCommont.h
//  test
//
//  Created by 杜康 on 15/11/19.
//  Copyright (c) 2015年 DuKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

CG_INLINE CGRect CGRectMakeNew(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    
    CGRect rect;
    
    rect.origin.x = x * myDelegate.autoSizeScaleX;
    rect.origin.y = y * myDelegate.autoSizeScaleY;
    
    rect.size.width = width * myDelegate.autoSizeScaleX;
    rect.size.height = height * myDelegate.autoSizeScaleY;
    
    return rect;
}
