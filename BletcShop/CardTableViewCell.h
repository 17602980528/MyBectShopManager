//
//  CardTableViewCell.h
//  BletcShop
//
//  Created by Bletc on 16/3/31.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *descriptionLable;
@property (retain, nonatomic) IBOutlet UIImageView *cardImg;
@property (retain, nonatomic) IBOutlet UIView *backView;
@end
