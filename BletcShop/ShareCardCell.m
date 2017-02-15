//
//  ShareCardCell.m
//  BletcShop
//
//  Created by Bletc on 2016/11/2.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShareCardCell.h"
#import "UIImageView+WebCache.h"

@interface ShareCardCell ()

@property (nonatomic , strong) UILabel *name_lab;// 昵称
@property (nonatomic , strong) UIImageView *header_img;// 头像
@property (nonatomic , strong) UILabel *phone_lab;// 手机号
//@property (nonatomic , strong) UIImageView *sex_img;// 性别

@end


@implementation ShareCardCell


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
    choseBtn.frame = CGRectMake(SCREENWIDTH-30, (70-22)/2, 20, 22);
    
    
    
    [choseBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
//    [choseBtn setImage:[UIImage imageNamed:@"de_icon_checkbox_sl"] forState:UIControlStateSelected];
    
    [self.contentView addSubview:choseBtn];
    self.choseBtn = choseBtn;
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, imgV.bottom+10-1, SCREENWIDTH, 1)];
    line.backgroundColor= RGB(234, 234, 234);
    [self.contentView addSubview:line];
    
    
}

-(void)setModel:(shareCardModel *)model{
    

    _model = model;
    self.name_lab.text = [NSString getTheNoNullStr:model.name andRepalceStr:@"未设置"];

    self.phone_lab.text = model.phone_s;
    [self.header_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,model.img_str]] placeholderImage:[UIImage imageNamed:@"userHeader"]];
//    if ([model.sex_str isEqualToString:@"男"]) {
//        self.sex_img.backgroundColor = [UIColor greenColor];
//    }else{
//        self.sex_img.backgroundColor = [UIColor orangeColor];
//        
//    }
}

@end
