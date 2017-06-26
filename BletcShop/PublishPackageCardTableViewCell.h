//
//  PublishPackageCardTableViewCell.h
//  BletcShop
//
//  Created by apple on 2017/6/23.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishPackageCardTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *productImage;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *productPrice;
@property (strong, nonatomic) IBOutlet UIButton *decreseButton;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *totalCount;
@property (nonatomic)NSInteger productCount;
@property (strong, nonatomic) IBOutlet UILabel *countLable;
@end
