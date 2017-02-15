//
//  AdvertiseCell.h
//  BletcShop
//
//  Created by Bletc on 2016/11/7.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

#import "ActivityModel.h"
static NSString *advertiseID = @"advertiseID";

@interface AdvertiseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *shopName_lab;
@property (weak, nonatomic) IBOutlet UILabel *distance_lab;
@property (weak, nonatomic) IBOutlet UILabel *sale_count;
@property (weak, nonatomic) IBOutlet UILabel *des_lab;
@property (weak, nonatomic) IBOutlet UIButton *goLooK;


@property (nonatomic , strong) ActivityModel *model;// <#Description#>

+(instancetype)advertiseCellIntiWithTableView:(UITableView*)tableView;
@end
