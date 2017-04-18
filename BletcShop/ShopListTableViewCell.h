//
//  ShopListTableViewCell.h
//  BletcShop
//
//  Created by Bletc on 16/8/4.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"

@interface ShopListTableViewCell : UITableViewCell
@property (nonatomic , strong) UIImageView *shopImageView;// <#Description#>
@property (nonatomic , strong) UILabel *nameLabel;// <#Description#>
@property (nonatomic , strong) UILabel *distanceLabel;// <#Description#>
@property (nonatomic , strong)  UILabel *sellerLabel;// <#Description#>
@property (nonatomic , strong) DLStarRatingControl *dlCtrl;// <#Description#>
@property (nonatomic , strong)  UILabel *sheContent;// <#Description#>
@property (nonatomic , strong) UILabel *giveContent;
@property (nonatomic,strong) UILabel *couponLable;
@end
