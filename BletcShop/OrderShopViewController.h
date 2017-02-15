//
//  OrderShopViewController.h
//  BletcShop
//
//  Created by Bletc on 16/5/6.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
@interface OrderShopViewController : UIViewController<CustomIOSAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationBarDelegate>
@property (nonatomic,retain) UITableView *myTableView;
@property (nonatomic,retain)UISegmentedControl *segmentControl;
@property (nonatomic,retain)NSMutableArray *waitArray;//未处理数组
@property (nonatomic,retain)NSMutableArray *overArray;//已处理
@property (nonatomic,retain)CustomIOSAlertView *alertView;
@property (nonatomic,retain)UIView *demoView;
@property NSInteger selectRow;
@property NSInteger selectTag;


@end
