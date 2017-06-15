//
//  AddMoneyOrCountCell.h
//  BletcShop
//
//  Created by Bletc on 2017/6/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMoneyOrCountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *textTF;
@property (weak, nonatomic) IBOutlet UIImageView *xiaojiantou;
@property (weak, nonatomic) IBOutlet UIView *btnBackView;
@property (weak, nonatomic) IBOutlet UIButton *btn_yes;
@property (weak, nonatomic) IBOutlet UIButton *btn_no;

@property (weak, nonatomic) IBOutlet UILabel *unitLab;


@end
