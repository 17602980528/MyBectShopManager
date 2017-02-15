//
//  CardVipCell.m
//  BletcShop
//
//  Created by Yuan on 16/1/26.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "CardVipCell.h"

@interface CardVipCell()

@property (weak, nonatomic) IBOutlet UIImageView *CardImg;
@property (weak, nonatomic) IBOutlet UILabel *CardeName;
@property (weak, nonatomic) IBOutlet UILabel *CardMoney;
@property (weak, nonatomic) IBOutlet UIButton *Depoist;
@property (weak, nonatomic) IBOutlet UILabel *BuyTimes;
- (IBAction)DepoistAction:(id)sender;

@end

@implementation CardVipCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.Depoist.layer.cornerRadius = 8;
    self.CardImg.layer.cornerRadius = 8;
    self.CardImg.image = [UIImage imageNamed:@"Card"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)DepoistAction:(id)sender {
    NSLog(@"充值");
}
@end
