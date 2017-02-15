//
//  LZDAnyView.h
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZDAnyView : UIView
- (instancetype)initImageBlock:(void (^)(void))imageBlock talkBlock:(void (^)(void))talkBlock vedioBlock:(void (^)(void))vedioBlock;

@end
