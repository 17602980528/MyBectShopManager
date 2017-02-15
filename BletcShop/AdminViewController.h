//
//  AdminViewController.h
//  BletcShop
//
//  Created by Bletc on 16/4/21.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
@interface AdminViewController : UIViewController<CustomIOSAlertViewDelegate>
@property (nonatomic,retain)UIView *demoView;
@property (nonatomic,retain) UIButton *boyBtn;
@property (nonatomic,retain) UIButton *girlBtn;
@property (nonatomic,retain)NSString *clerkString;
@property (nonatomic,retain)UILabel *clerkLabel;//店员权限
@property (nonatomic,retain)NSArray *array;
@property (nonatomic,retain)UITableView *TabSc;

@property (nonatomic,retain)UITextField *nameText;
@property (nonatomic,retain)UITextField *passText;
@property (nonatomic,retain)UITextField *phoneText;
@property (nonatomic,retain)NSString *sexString;
@property (nonatomic,strong)NSDictionary *edit_dic;//需要编辑的数据
@property NSInteger editTag;
//是否打开权限选择
@property BOOL ifOpenQX;
@end
