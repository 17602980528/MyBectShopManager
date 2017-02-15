//
//  MyOderController.h
//  BletcShop
//
//  Created by Yuan on 16/1/26.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
@interface MyOderController : UIViewController<CustomIOSAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) UITableView *myTableView;
@property (nonatomic,retain)NSMutableArray *orderArray;//

@property (nonatomic,retain)UIView *demoView;
@property NSInteger selectRow;//选择行数
@end
