//
//  CardInfoViewController.h
//  BletcShop
//
//  Created by Bletc on 16/4/20.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "CustomIOSAlertView.h"
@interface CardInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CustomIOSAlertViewDelegate>
@property(nonatomic,retain) UITableView *cardTableView;
//@property(nonatomic,retain)NSMutableArray *cardInfoArray;

@property (nonatomic,retain)UIView *demoView;
@property (nonatomic,retain)UITextField *cardTypeText;
@property (nonatomic,retain)UITextField *cardLevelText;
@property (nonatomic,retain)UITextField *cardMoneyText;
@property (nonatomic , strong) NSDictionary *card_dic;// 卡的信息



@end
