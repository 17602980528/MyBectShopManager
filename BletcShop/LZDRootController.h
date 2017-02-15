//
//  LZDRootController.h
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LZDContentView.h"

@interface LZDRootController : UIViewController

@property (nonatomic , strong) AppDelegate *myAppDelegate;

@property (nonatomic , weak) LZDContentView *contentView;// 控制器的View


-(void)setChartDelegate;
@end
