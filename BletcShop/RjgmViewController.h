//
//  RjgmViewController.h
//  BletcShop
//
//  Created by Bletc on 16/4/20.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RjgmViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic,retain)NSString *moneyString;
@property (nonatomic,retain)NSMutableArray *moneyArray;

@property (nonatomic,retain)UITextField *moneyText;
@property (nonatomic,retain)UIView *demoView;



@end
