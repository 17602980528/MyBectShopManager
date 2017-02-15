//
//  LZDButton.m
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LZDButton.h"

@implementation LZDButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)click:(LZDButton*)sender{
    if (_block) {
        _block(sender);
    }
}

+(instancetype)creatLZDButton{
    return [LZDButton buttonWithType:UIButtonTypeCustom];
}
@end
