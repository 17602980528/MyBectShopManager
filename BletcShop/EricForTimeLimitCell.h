//
//  EricForTimeLimitCell.h
//  BletcShop
//
//  Created by apple on 2017/6/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EricForTimeLimitCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *oldPrice;
@property (strong, nonatomic) IBOutlet UILabel *nowPrice;
@property (strong, nonatomic) IBOutlet UILabel *deadTime;
@property (strong, nonatomic) IBOutlet UILabel *cardName;
@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;


@end
