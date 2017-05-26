//
//  CouponCell.m
//  BletcShop
//
//  Created by Bletc on 2017/3/3.
//  Copyright © 2017年 bletc. All rights reserved.
//

#define waveNum  25

#import "CouponCell.h"
#import "SawtoothView.h"


@implementation CouponCell



+(instancetype)couponCellWithTableView:(UITableView*)tableView{
    
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CouponCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGB(238, 238, 238);
    }
    
    return cell;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(12, 0, SCREENWIDTH-24, 150)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius=5;
    backView.clipsToBounds = YES;
    [self.contentView addSubview:backView];
    
    
    CGFloat R =(backView.width/(waveNum*2+1)/2);

    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, backView.width, 92+R)];
    topView.backgroundColor = RGB(175, 198, 242);
    [backView addSubview:topView];
    
    //添加渐变色
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    
    gradientLayer.colors = @[(__bridge id)RGB(175, 198, 242).CGColor,(__bridge id)RGB(147, 218, 243).CGColor];
    
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(topView.frame), CGRectGetHeight(topView.frame));
    
    [topView.layer addSublayer:gradientLayer];
    
    self.gradientLayer = gradientLayer;
    

    SawtoothView *bottomView = [SawtoothView new];
    
    bottomView.frame = CGRectMake(0, topView.bottom-R, backView.width, 57+R);
    
    [bottomView setColor:[UIColor whiteColor] waveCount:waveNum];
    [backView addSubview:bottomView];
    
    
    
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(11, 23, 60, 60)];
    headImage.image=[UIImage imageNamed:@"5-01"];
    headImage.layer.cornerRadius=headImage.width/2;
    headImage.clipsToBounds=YES;
    [topView addSubview:headImage];
    self.headImg = headImage;
    
    UILabel *shopNameLable=[[UILabel alloc]initWithFrame:CGRectMake(headImage.right+12, 46, topView.width*2/3-83, 15)];
    shopNameLable.text=@"森林雨火锅";
    shopNameLable.font=[UIFont systemFontOfSize:15.0f];
    shopNameLable.textColor=[UIColor whiteColor];
    [topView addSubview:shopNameLable];
    self.shopNamelab = shopNameLable;

    UILabel *Y_lab = [[UILabel alloc]initWithFrame:CGRectMake(topView.width*2/3, 47, 10, 13)];
    Y_lab.text = @"¥";
    Y_lab.textColor = [UIColor whiteColor];
    Y_lab.font = [UIFont systemFontOfSize:17];
    [topView addSubview:Y_lab];
    

    UILabel *couponMoney=[[UILabel alloc]initWithFrame:CGRectMake(Y_lab.right+9, 40, topView.width/3-9-13, 27)];
    couponMoney.text=@"20";
    couponMoney.font=[UIFont systemFontOfSize:36.0f];
    couponMoney.textColor = [UIColor whiteColor];
    [topView addSubview:couponMoney];
    self.couponMoney = couponMoney;
    
   
    UILabel *deadTime=[[UILabel alloc]initWithFrame:CGRectMake(10, 14, bottomView.width-10, 13)];
    deadTime.text=@"使用期限：2017.2.18 ~ 2017.5.18";
    deadTime.font=[UIFont systemFontOfSize:13.0f];
    deadTime.textColor=RGB(102,102,102);
    [bottomView addSubview:deadTime];
    self.deadTime = deadTime;
    
    UILabel *limitLab=[[UILabel alloc]initWithFrame:CGRectMake(10, deadTime.bottom+8, bottomView.width-10, 13)];
    limitLab.text=@"消费满500可用";
    limitLab.font=[UIFont systemFontOfSize:13.0f];
    limitLab.textColor=RGB(102,102,102);
    [bottomView addSubview:limitLab];

    self.limitLab = limitLab;
    
        UIImageView *validateImg = [[UIImageView alloc]init];
        
        validateImg.bounds = CGRectMake(0, 0, backView.height*0.8, backView.height*0.8);
        validateImg.center = CGPointMake(SCREENWIDTH -backView.height*0.8, backView.center.y);
    validateImg.layer.cornerRadius = validateImg.height/2;
    validateImg.layer.masksToBounds = YES;
    validateImg.hidden = NO;
    validateImg.image = [UIImage imageNamed:@"WechatIMG16"];
//        validateImg.backgroundColor = RGB(234, 234, 234);
        [self addSubview:validateImg];
 
    self.showImg = validateImg;
    
    UIImageView *onlineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(backView.width-40, 0, 40, 40)];
    onlineImageView.image=[UIImage imageNamed:@"线上角标"];
    [backView addSubview:onlineImageView];
    self.onlineState=onlineImageView;
    
}
-(void)setShopNamelab:(UILabel *)shopNamelab{
    _shopNamelab = shopNamelab;
}

-(void)setGradientLayer:(CAGradientLayer *)gradientLayer{
    
    _gradientLayer = gradientLayer;

    
}
@end
