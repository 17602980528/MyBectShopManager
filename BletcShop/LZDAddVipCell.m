//
//  LZDAddVipCell.m
//  BletcShop
//
//  Created by Bletc on 16/9/29.
//  Copyright © 2016年 bletc. All rights reserved.
//


#import "LZDAddVipCell.h"
#import "UIImageView+WebCache.h"
@interface LZDAddVipCell ()
@property (nonatomic , strong) UILabel *name_lab;// 昵称
@property (nonatomic , strong) UIImageView *header_img;// 头像
@property (nonatomic , strong) UILabel *phone_lab;// 手机号
@property (nonatomic , strong) UIImageView *sex_img;// 性别

@end

@implementation LZDAddVipCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 创建子视图
        [self _initUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}
-(void)_initUI{
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 50, 50)];
    imgV.layer.cornerRadius = imgV.width/2;
    imgV.clipsToBounds = YES;
    imgV.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:imgV];
    self.header_img = imgV;
    
//    UIImageView *sex_img = [[UIImageView alloc]initWithFrame:CGRectMake(37+15, 37+10, 13, 13)];
//    sex_img.backgroundColor = [UIColor greenColor];
//    sex_img.layer.cornerRadius = sex_img.width/2;
//    [self.contentView addSubview:sex_img];
//    sex_img.clipsToBounds = YES;
//    self.sex_img = sex_img;
    
    UILabel *name_lab = [[UILabel alloc]initWithFrame:CGRectMake(imgV.right+10, 10, SCREENWIDTH,20 )];
    name_lab.textColor = [UIColor blackColor];
    name_lab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:name_lab];
    self.name_lab = name_lab;
    
    UILabel *phone_lab = [[UILabel alloc]initWithFrame:CGRectMake(imgV.right+10, imgV.bottom-20, SCREENWIDTH, 20)];
    phone_lab.textColor = [UIColor grayColor];
    phone_lab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:phone_lab];
    self.phone_lab = phone_lab;
    
    
    
    UIButton *choseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    choseBtn.frame = CGRectMake(SCREENWIDTH-25, (70-15)/2, 15, 15);
//    [choseBtn setImage:[UIImage imageNamed:@"weigouxuan"] forState:UIControlStateNormal];
//    [choseBtn setImage:[UIImage imageNamed:@"gouxuan@"] forState:UIControlStateSelected];
    
    [choseBtn setImage:[UIImage imageNamed:@"de_icon_checkbox_n"] forState:UIControlStateNormal];
    [choseBtn setImage:[UIImage imageNamed:@"de_icon_checkbox_sl"] forState:UIControlStateSelected];

    [self.contentView addSubview:choseBtn];
    self.choseBtn = choseBtn;
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, imgV.bottom+10-1, SCREENWIDTH, 1)];
    line.backgroundColor= RGB(234, 234, 234);
    [self.contentView addSubview:line];
    

}

-(void)setVipModel:(AddVIPModel *)vipModel{
    _vipModel = vipModel;
    self.name_lab.text = vipModel.name;
    self.phone_lab.text = vipModel.phone_s;
    [self.header_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,vipModel.img_str]] placeholderImage:[UIImage imageNamed:@"userHeader"]];
    if ([vipModel.sex_str isEqualToString:@"男"]) {
        self.sex_img.backgroundColor = [UIColor greenColor];
    }else{
        self.sex_img.backgroundColor = [UIColor orangeColor];

    }
}

@end
