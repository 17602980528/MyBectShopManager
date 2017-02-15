//
//  LZDChartViewController.h
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LZDRootController.h"
#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"

@interface LZDChartViewController : LZDRootController
@property (nonatomic,copy)NSString *username;

@property (nonatomic) EMChatType chatType;


//头像昵称用
@property (nonatomic , strong) NSArray *userInfo;// 用户信息


@end
