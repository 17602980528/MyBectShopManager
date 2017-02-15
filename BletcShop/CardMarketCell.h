//
//  CardMarketCell.h
//  BletcShop
//
//  Created by Bletc on 2017/1/16.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CardMarketModel.h"
static NSString *identifier = @"CardMarketCellID";

@interface CardMarketCell : UITableViewCell
@property (nonatomic , weak) UILabel *pricelab;


@property (nonatomic , strong) CardMarketModel *model;// <#Description#>



+(instancetype)creatCellWithTableView:(UITableView*)tableView;

-(CGFloat)cellHeightWithModel:(CardMarketModel *)model;
@end
