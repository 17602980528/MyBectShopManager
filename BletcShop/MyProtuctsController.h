//
//  MyProtuctsController.h
//  BletcShop
//
//  Created by Yuan on 16/1/28.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
@interface MyProtuctsController : UIViewController<CustomIOSAlertViewDelegate>
@property (nonatomic,retain)UITextField *proCodeText;//编号
@property (nonatomic,retain)UITextField *proNameText;//名称
@property (nonatomic,retain)UITextField *proNumText;//数量
@property (nonatomic,retain)UITextField *proPriceText;//价格

@property (nonatomic,retain)NSMutableDictionary *editDic;
@property NSInteger editTag;
@end
