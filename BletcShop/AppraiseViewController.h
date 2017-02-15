//
//  AppraiseViewController.h
//  BletcShop
//
//  Created by Bletc on 16/6/1.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"
@interface AppraiseViewController : UIViewController<DLStarRatingDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>


@property (nonatomic , strong) NSDictionary *evaluate_dic;// 所要评价的消费信息

@end
