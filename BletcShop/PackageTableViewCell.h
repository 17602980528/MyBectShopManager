//
//  PackageTableViewCell.h
//  BletcShop
//
//  Created by apple on 2017/6/15.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *chooseTip;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *productPrice;
@property (strong, nonatomic) IBOutlet UIImageView *productImage;

@end
