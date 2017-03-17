//
//  HomeViewCell.h
//  BletcShop
//
//  Created by Bletc on 2016/11/4.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeShopModel.h"

static NSString *identifier = @"HomeViewCellID";

@interface HomeViewCell : UITableViewCell

@property (nonatomic , strong) HomeShopModel *model;// <#Description#>

-(CGFloat)cellHeightWithModel:(HomeShopModel*)model;

+(instancetype)homeViewCellWithTableView:(UITableView*)tableView;

@end
