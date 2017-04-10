//
//  ChouJiangVC.h
//  BletcShop
//
//  Created by Bletc on 2017/4/6.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"
@interface ChouJiangVC : UIViewController
@property (nonatomic,copy)NSString *urlString;// <#Description#>
@property (strong, nonatomic) WebViewJavascriptBridge *javascriptBridge;
@end
