//
//  ShopVipController.h
//  BletcShop
//
//  Created by Yuan on 16/1/28.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopVipController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)NSString *chaXun;
@property (nonatomic,retain)NSMutableArray *array;
@property (nonatomic,strong)NSMutableDictionary *shopInfo_dic;
@property (nonatomic,retain) UIButton *boyBtn;
@property (nonatomic,retain) UIButton *girlBtn;
@property (nonatomic,retain)UILabel *cardTypeLabel;//ka类型label
@property (nonatomic,retain)UITextField *nikNameText;//昵称
@property (nonatomic,retain)UITextField *phoneText;//手机
@property (nonatomic,retain)UITextField *addressText;//地址
@property (nonatomic,retain)UITextField *yueText;//地址
@property (nonatomic,retain)UITextField *cardNumText;//地址

@property (nonatomic,retain)NSArray *typeArray;


@property (nonatomic,retain)NSMutableArray *editArray;
@property NSInteger editTag;
@property int shopEnter;
@property (nonatomic,retain)UITableView *tabView;
@end
