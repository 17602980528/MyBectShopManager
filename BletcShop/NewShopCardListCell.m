//
//  NewShopCardListCell.m
//  BletcShop
//
//  Created by Bletc on 2017/5/12.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NewShopCardListCell.h"

@implementation NewShopCardListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}
-(void)initSubviews{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 80, 50)];
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 0.5;
    imageView.layer.borderColor = RGB(180, 180, 180).CGColor;
    
    self.cardImg = imageView;
    [self addSubview:imageView];
    
    UIView *bot_view = [[UIView alloc]initWithFrame:CGRectMake(0, 35, 80, 15)];
    bot_view.backgroundColor = [UIColor whiteColor];
    [imageView addSubview:bot_view];
    
    UILabel *vipLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
    vipLab.textAlignment = NSTextAlignmentCenter;
    vipLab.textColor = [UIColor whiteColor];
    [imageView addSubview:vipLab];
    self.vipLab = vipLab;
    
    UILabel *content_lab = [[UILabel alloc]init];
    self.content_lab = content_lab;

    content_lab.font = [UIFont systemFontOfSize:14];
    content_lab.numberOfLines =1;
//    CGFloat height_lab =  [UILabel getSizeWithLab:content_lab andMaxSize:CGSizeMake(SCREENWIDTH-85-70, 50)].height;
    content_lab.frame = CGRectMake(imageView.right+10, imageView.top, SCREENWIDTH-85-70-2, 23);
    [self addSubview:content_lab];
    
    
    UILabel *cardPriceLable=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-120-15, 23-5, 120, 14)];
    cardPriceLable.textAlignment=NSTextAlignmentRight;
    cardPriceLable.font=[UIFont systemFontOfSize:14.0f];
    cardPriceLable.textColor=[UIColor redColor];
    [self addSubview:cardPriceLable];
    
    self.cardPriceLable = cardPriceLable;
    
    UILabel *discountLable=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-120-15, cardPriceLable.bottom+5, 120, 14)];
    discountLable.font=[UIFont systemFontOfSize:13.0f];
    discountLable.textColor=[UIColor grayColor];
    discountLable.textAlignment=NSTextAlignmentRight;
    [self addSubview:discountLable];
    self.discountLable = discountLable;
    UILabel *timeLable=[[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, content_lab.bottom+3, content_lab.width, 20)];
    timeLable.font=[UIFont systemFontOfSize:13.0f];
    timeLable.textColor=[UIColor grayColor];
    [self addSubview:timeLable];
    
    self.timeLable = timeLable;
}
@end
