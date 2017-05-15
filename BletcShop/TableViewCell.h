//
//  TableViewCell.h
//  BletcShop
//
//  Created by apple on 2017/5/12.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLable;
@property (strong, nonatomic) IBOutlet UILabel *apriseLable;
@property (strong, nonatomic) IBOutlet UILabel *timeLable;

@end
