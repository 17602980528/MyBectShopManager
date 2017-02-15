//
//  ShopAllInfoTableViewCell.m
//  BletcShop
//
//  Created by Bletc on 16/6/24.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShopAllInfoTableViewCell.h"

@implementation ShopAllInfoTableViewCell

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
    }
    return self;
}


-(void)_initUI
{
    UIButton *eidiBtn = [[UIButton alloc]init];
    //    eidiBtn.backgroundColor = [UIColor redColor];
    [eidiBtn setTitle:@"删除" forState:UIControlStateNormal];
    [eidiBtn setTitleColor:ButtonGreenColor forState:UIControlStateNormal];
    [eidiBtn setTitleColor:ButtonGreenColor forState:UIControlStateNormal];
    eidiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview: eidiBtn];
    self.deleteBtn = eidiBtn;
    UIImageView *imageLab = [[UIImageView alloc]init];
    //    xnameLab.backgroundColor = [UIColor redColor];
    //    xnameLab.text = @"BLetc";
    
    [self addSubview:imageLab];
    self.imageLabel = imageLab;
    
    UILabel *contetLab = [[UILabel alloc]init];
    //    sexLab.backgroundColor = [UIColor redColor];
    
    contetLab.font = [UIFont systemFontOfSize:12];
    contetLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:contetLab];
    self.introduceShopLabel = contetLab;
    

    //    线
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor grayColor];
    line1.alpha = 0.3;
    [self addSubview:line1];
    self.view1 = line1;
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = [UIColor grayColor];
    line2.alpha = 0.3;
    [self addSubview:line2];
    self.view2 = line2;
    // 调用子视图
    UIView *line3 = [[UIView alloc]init];
    line3.backgroundColor = [UIColor grayColor];
    line3.alpha = 0.3;
    [self addSubview:line3];
    self.view3 = line3;
    UIView *line4 = [[UIView alloc]init];
    line4.backgroundColor = [UIColor grayColor];
    line4.alpha = 0.3;
    [self addSubview:line4];
    self.view4 = line4;
    [self setNeedsLayout];
    
}



//用父类布局子类
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.deleteBtn.frame = CGRectMakeNew(0, 0, 80, 80);
    self.imageLabel.frame = CGRectMake(self.deleteBtn.width+1, 0, 100, 80);
    self.introduceShopLabel.frame = CGRectMake(self.deleteBtn.width+self.imageLabel.width+2, 0, SCREENWIDTH-self.deleteBtn.width-self.imageLabel.width-5, 80);
    self.view1.frame = CGRectMake(self.deleteBtn.width, 0, 1, 80);
    self.view2.frame = CGRectMake(self.deleteBtn.width+self.imageLabel.width+1, 0, 1, 80);
    self.view3.frame = CGRectMake(self.deleteBtn.width+self.imageLabel.width+self.introduceShopLabel.width+2, 0, 1, 80);
    //self.view4.frame = CGRectMake(0, self.height-1, SCREENWIDTH*2, 1);
    
    
//    self.deleteBtn.frame = CGRectMakeNew(0, 0, 80, 80);
//    self.imageLabel.frame = CGRectMakeNew(self.deleteBtn.width+1,0 , (SCREENWIDTH-self.deleteBtn.width)/2-10, 80);
//    self.introduceShopLabel.frame = CGRectMake(self.imageLabel.width+self.deleteBtn.width+2, 0, (SCREENWIDTH-self.deleteBtn.width)/2-1, 80);
//    
//    self.view1.frame = CGRectMake(self.deleteBtn.width, 0, 1, 80);
//    self.view2.frame = CGRectMake(self.imageLabel.width+self.deleteBtn.width+1, 0, 1, 80);
////    self.view3.frame = CGRectMake(self.imageLabel.width+self.introduceShopLabel.width+2+self.deleteBtn.width, 0, 1, 80);
//    self.view3.frame = CGRectMake(0, self.height-1, SCREENWIDTH*2, 1);
//    //self.view7.frame = CGRectMake(0, self.height-1, SCREENWIDTH*2, 1);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
