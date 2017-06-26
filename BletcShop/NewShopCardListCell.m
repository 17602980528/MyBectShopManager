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
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 85, 50)];
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 0.5;
    imageView.layer.borderColor = RGB(180, 180, 180).CGColor;
    
    self.cardImg = imageView;
    [self addSubview:imageView];
    
    UIView *bot_view = [[UIView alloc]initWithFrame:CGRectMake(0, 35, imageView.width, 15)];
    bot_view.backgroundColor = [UIColor whiteColor];
    [imageView addSubview:bot_view];
    
    UILabel *vipLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, imageView.width, 35)];
    vipLab.textAlignment = NSTextAlignmentCenter;
    vipLab.textColor = [UIColor whiteColor];
    [imageView addSubview:vipLab];
    self.vipLab = vipLab;
    
    UILabel *content_lab = [[UILabel alloc]init];
    self.content_lab = content_lab;

    content_lab.font = [UIFont systemFontOfSize:13];
    content_lab.numberOfLines =1;
    content_lab.textColor = RGB(51,51,51);
    
//    CGFloat height_lab =  [UILabel getSizeWithLab:content_lab andMaxSize:CGSizeMake(SCREENWIDTH-85-70, 50)].height;
    content_lab.frame = CGRectMake(imageView.right+10, imageView.top, SCREENWIDTH-(imageView.right+10), 13);
    [self addSubview:content_lab];
    
    
    UILabel *cardPriceLable=[[UILabel alloc]initWithFrame:CGRectMake(content_lab.left, imageView.bottom-12, 120, 14)];
    cardPriceLable.textAlignment=NSTextAlignmentLeft;
    cardPriceLable.font=[UIFont systemFontOfSize:15.0f];
    cardPriceLable.textColor=[UIColor redColor];
    [self addSubview:cardPriceLable];
    
    self.cardPriceLable = cardPriceLable;
    
    UILabel *discountLable=[[UILabel alloc]initWithFrame:CGRectMake(content_lab.left, content_lab.bottom+5, 35, 13)];
    discountLable.font=[UIFont systemFontOfSize:10.0f];
    discountLable.textColor=[UIColor whiteColor];
    discountLable.backgroundColor = RGB(240,153,68);
    discountLable.layer.cornerRadius = 3;
    discountLable.layer.masksToBounds = YES;
    discountLable.textAlignment=NSTextAlignmentCenter;
    [self addSubview:discountLable];
    self.discountLable = discountLable;
    
    
    UILabel *timeLable=[[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, imageView.bottom-8, SCREENWIDTH-(imageView.right+10+50), 8)];
    timeLable.font=[UIFont systemFontOfSize:8.0f];
    timeLable.textColor=RGB(148,148,148);
    timeLable.textAlignment =NSTextAlignmentRight;
    [self addSubview:timeLable];
    
    self.timeLable = timeLable;
    
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 70, SCREENWIDTH, 1)];
    line.backgroundColor = RGB(234, 234, 234);
    [self addSubview:line];
    
}

//-(void)setDiscountLable:(UILabel *)discountLable{
//    _discountLable = discountLable;
//    
//    
//   CGRect frame = _discountLable.frame ;
//    
//    CGFloat ww = [discountLable.text boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_discountLable.font} context:nil].size.width;
//    
//    frame.size.width = ww +5;
//    _discountLable.frame = frame;
//}
@end
