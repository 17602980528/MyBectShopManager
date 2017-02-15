//
//  CanPayCardViewController.h
//  BletcShop
//
//  Created by Bletc on 16/6/6.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"

@interface CanPayCardViewController : UIViewController
@property(nonatomic,retain)NSMutableArray *payCardArray;//可支付的卡
@property (nonatomic,copy)NSString *muid;// <#Description#>

@end
