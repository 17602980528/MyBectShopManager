//
//  VipManagerTableViewCell.m
//  BletcShop
//
//  Created by Bletc on 16/4/22.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "VipManagerTableViewCell.h"

@implementation VipManagerTableViewCell

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
    [eidiBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [eidiBtn setTitleColor:ButtonGreenColor forState:UIControlStateNormal];
    [eidiBtn setTitleColor:ButtonGreenColor forState:UIControlStateNormal];
    eidiBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview: eidiBtn];
    self.eiditBtn = eidiBtn;
    
    UIButton *buyBtn = [[UIButton alloc]init];
    //    buyBtn.backgroundColor = [UIColor redColor];
    [buyBtn setTitle:@"消费记录" forState:UIControlStateNormal];
    [buyBtn setTitleColor:ButtonGreenColor forState:UIControlStateNormal];
    [buyBtn setTitleColor:ButtonGreenColor forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:buyBtn];
    self.buyBtn = buyBtn;
    
    UILabel *xnameLab = [[UILabel alloc]init];
    //    xnameLab.backgroundColor = [UIColor redColor];
    //    xnameLab.text = @"BLetc";
    xnameLab.font = [UIFont systemFontOfSize:12];
    xnameLab.numberOfLines = 0;
    xnameLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:xnameLab];
    self.xnameLab = xnameLab;
    
    UILabel *sexLab = [[UILabel alloc]init];
    //    sexLab.backgroundColor = [UIColor redColor];
    sexLab.text = @"男";
    sexLab.font = [UIFont systemFontOfSize:12];
    sexLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:sexLab];
    self.sexLab = sexLab;
    
    UILabel *phoneLab = [[UILabel alloc]init];
    //    phoneLab.backgroundColor = [UIColor redColor];
    phoneLab.text = @"13279230181";
    phoneLab.numberOfLines = 0;
    phoneLab.font = [UIFont systemFontOfSize:12];
    phoneLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:phoneLab];
    self.phoneLab = phoneLab;
    
    UILabel *adressLab = [[UILabel alloc]init];
    //    adressLab.backgroundColor = [UIColor redColor];
    adressLab.text = @"陕西省西安市科技二路宏源大厦";
    adressLab.font = [UIFont systemFontOfSize:12];
    adressLab.numberOfLines = 0;
    [self addSubview:adressLab];
    self.adressLab = adressLab;
    
    UILabel *codeLab = [[UILabel alloc]init];
    codeLab.text = @"710000";
    codeLab.textAlignment =NSTextAlignmentCenter;
    codeLab.font = [UIFont systemFontOfSize:12];
    //    codeLab.backgroundColor = [UIColor redColor];
    [self addSubview:codeLab];
    self.codeLab = codeLab;
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
    
    UIView *line5 = [[UIView alloc]init];
    line5.backgroundColor = [UIColor grayColor];
    line5.alpha = 0.3;
    [self addSubview:line5];
    self.view5 = line5;
    
    UIView *line6 = [[UIView alloc]init];
    line6.backgroundColor = [UIColor grayColor];
    line6.alpha = 0.3;
    [self addSubview:line6];
    self.view6 = line6;
    
    UIView *line7 = [[UIView alloc]init];
    line7.backgroundColor = [UIColor grayColor];
    line7.alpha = 0.3;
    [self addSubview:line7];
    self.view7 = line7;
    
    // 调用子视图
    
    [self setNeedsLayout];
    
}



//用父类布局子类
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.xnameLab.frame = CGRectMakeNew(0, 0, 130, 50);
    self.sexLab.frame = CGRectMake(self.xnameLab.width+1, 0, 92, 50);
    self.phoneLab.frame = CGRectMake(self.xnameLab.width+self.sexLab.width+2, 0, 150, 50);
    self.eiditBtn.frame = CGRectMake(self.xnameLab.width+self.sexLab.width+self.phoneLab.width+5, 0, 70, 50);
    //self.buyBtn.frame = CGRectMake(self.xnameLab.width+self.sexLab.width+self.phoneLab.width+self.eiditBtn.width+6,0 , 80, 50);
    self.view1.frame = CGRectMake(self.xnameLab.width, 0, 1, 50);
    self.view2.frame = CGRectMake(self.xnameLab.width+self.sexLab.width+1, 0, 1, 50);
    self.view3.frame = CGRectMake(self.xnameLab.width+self.sexLab.width+self.phoneLab.width+2, 0, 1, 50);
    self.view4.frame = CGRectMake(self.xnameLab.width+self.sexLab.width+self.phoneLab.width+self.eiditBtn.width+3, 0, 1, 50);
    //self.view5.frame = CGRectMake(self.xnameLab.width+self.sexLab.width+self.phoneLab.width+self.eiditBtn.width+self.buyBtn.width+4, 0, 1, 50);

//    self.eiditBtn.frame = CGRectMakeNew(0, 0, 70, 50);
//    self.buyBtn.frame = CGRectMake(self.eiditBtn.width+1, 0, 80, 50);
//    self.xnameLab.frame = CGRectMake(self.eiditBtn.width+self.buyBtn.width+2, 0, 130, 50);
//    self.sexLab.frame = CGRectMake(self.eiditBtn.width+self.buyBtn.width+self.xnameLab.width+3, 0, 92, 50);
//    self.phoneLab.frame = CGRectMake(self.eiditBtn.width+self.buyBtn.width+self.xnameLab.width+self.sexLab.width+4, 0, 150, 50);
////    self.adressLab.frame = CGRectMake(self.eiditBtn.width+self.buyBtn.width+self.xnameLab.width+self.sexLab.width+self.phoneLab.width+5, 0, 152, 50);
////    self.codeLab.frame = CGRectMake(self.eiditBtn.width+self.buyBtn.width+self.xnameLab.width+self.sexLab.width+self.phoneLab.width+self.adressLab.width+6,0 , 100, 50);
//    self.view1.frame = CGRectMake(self.eiditBtn.width, 0, 1, 50);
//    self.view2.frame = CGRectMake(self.eiditBtn.width+self.buyBtn.width+1, 0, 1, 50);
//    self.view3.frame = CGRectMake(self.eiditBtn.width+self.buyBtn.width+self.xnameLab.width+2, 0, 1, 50);
//    self.view4.frame = CGRectMake(self.eiditBtn.width+self.buyBtn.width+self.xnameLab.width+self.sexLab.width+3, 0, 1, 50);
//    self.view5.frame = CGRectMake(self.eiditBtn.width+self.buyBtn.width+self.xnameLab.width+self.sexLab.width+self.phoneLab.width+4, 0, 1, 50);
    self.view6.frame = CGRectMake(0, self.height-1, SCREENWIDTH*2, 1);
    //self.view7.frame = CGRectMake(0, self.height-1, SCREENWIDTH*2, 1);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
