//
//  ShoppingCell.m
//  BletcShop
//
//  Created by Yuan on 16/1/26.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShoppingCell.h"

@interface ShoppingCell()

@property (weak, nonatomic) IBOutlet UIButton *NewCardBtn;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *CellImg;
@property (weak, nonatomic) IBOutlet UILabel *LongLabel;
@property (weak, nonatomic) IBOutlet UILabel *PrefreLbel;
- (IBAction)BtnAction:(id)sender;

@end

@implementation ShoppingCell

- (void)awakeFromNib {
    
    
    // Initialization code
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 94, SCREENWIDTH, 1)];
    view.backgroundColor = [UIColor grayColor];
    view.alpha = 0.3;
    [self addSubview:view];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.PrefreLbel.numberOfLines = 0;
    self.LongLabel.textColor = [UIColor grayColor];
    self.PrefreLbel.textColor = [UIColor grayColor];
    self.NewCardBtn.layer.cornerRadius = 7;
    self.PrefreLbel.text = @"[高新]  双人体验免费办卡,充值1000元立即赠送300元 多种套餐可选,欢迎您的光临";
    self.CellImg.image = [UIImage imageNamed:@"6-01"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)BtnAction:(id)sender {
    NSLog(@"办卡");
}
@end
