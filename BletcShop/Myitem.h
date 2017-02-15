//
//  Myitem.h
//  BletcShop
//
//  Created by Yuan on 16/1/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Myitem : NSObject
//图片
@property (nonatomic, copy) NSString *img;

//标题
@property (nonatomic, copy) NSString *title;

//cell将要做的事情
@property (nonatomic, assign) Class vcClass;

+(instancetype)itemsWithImg:(NSString *)img title:(NSString *)title vcClass:(Class)vcClass;
@end
