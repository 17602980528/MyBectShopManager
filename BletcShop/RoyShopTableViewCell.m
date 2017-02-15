//
//  RoyShopTableViewCell.m
//  BletcShop
//
//  Created by apple on 16/9/29.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "RoyShopTableViewCell.h"

@implementation RoyShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 创建子视图
        [self _initUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}
-(void)_initUI{
    self.headIamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 12.5, 75, 75)];
    
    [self addSubview:self.headIamgeView];
    
    self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(95, 10, SCREENWIDTH-95-100, 40)];
    self.nameLabel.numberOfLines = 2;
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    
    [self addSubview:self.nameLabel];
    
    self.bianHaoLable=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-100, 8, 100, 35)];
    self.bianHaoLable.textAlignment=1;
    
    self.bianHaoLable.font=[UIFont systemFontOfSize:15.0f];
    [self addSubview:self.bianHaoLable];
    
    self.cuCunLabel=[[UILabel alloc]initWithFrame:CGRectMake(95, 62.5, 120, 30)];
    self.cuCunLabel.font=[UIFont systemFontOfSize:15.0f];
    self.cuCunLabel.textColor=[UIColor lightGrayColor];
    [self addSubview:_cuCunLabel];
    
    self.priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-100, 62.5, 100, 30)];
    self.priceLabel.font=[UIFont systemFontOfSize:15.0f];
    self.priceLabel.textColor=[UIColor redColor];
    self.priceLabel.textAlignment=1;
    
    [self addSubview:self.priceLabel];
    
    self.choseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.choseBtn.frame=CGRectMake(SCREENWIDTH-50, 30, 40, 40);
    [self.choseBtn setImage:[UIImage imageNamed:@"de_icon_checkbox_n"] forState:UIControlStateNormal];
    [self.choseBtn setImage:[UIImage imageNamed:@"de_icon_checkbox_sl"] forState:UIControlStateSelected];
    [self addSubview:self.choseBtn];
    
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 100-1, SCREENWIDTH, 1)];
    line.backgroundColor= RGB(234, 234, 234);
    [self.contentView addSubview:line];


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
