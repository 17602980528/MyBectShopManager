//
//  RoyTableViewCell.h
//  BletcShop
//
//  Created by apple on 16/12/13.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoyTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *shopNameLable;
@property(nonatomic,strong)UILabel *cardLevelLable;
@property(nonatomic,strong)UILabel *cardPriceLable;
@property(nonatomic,strong)UILabel *cardDescription;
@property(nonatomic,strong)UIButton *editButton;
@property(nonatomic,strong)UIButton *deleteButton;
@property(nonatomic,strong)UIButton *onOrOffButton;
@end
