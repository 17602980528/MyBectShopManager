//
//  ConvertRecordCell.h
//  BletcShop
//
//  Created by Bletc on 2017/6/30.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConvertRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *state_lab;//发送中状态
@property (weak, nonatomic) IBOutlet UILabel *state_m;//还没发货的状态
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end
