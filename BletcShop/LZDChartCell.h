//
//  LZDChartCell.h
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+XMGResizing.h"
#import "Person.h"
@protocol LZDChartCellShowImageDelegate <NSObject>

/**
 *  显示大图
 */

-(void)chartCellWithMessage:(EMMessage *)message;

@end


@interface LZDChartCell : UITableViewCell
/** 消息模型 */
@property (nonatomic, strong) EMMessage *message;

@property (nonatomic, assign)CGFloat rowHeight;

@property(nonatomic,assign) id<LZDChartCellShowImageDelegate> delegate;

@property (nonatomic , strong) Person *my_P;// 我的信息;
@property (nonatomic , strong) Person *user_P;// 用户信息;


@end
