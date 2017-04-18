//
//  ShopListTableViewself.m
//  BletcShop
//
//  Created by Bletc on 16/8/4.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShopListTableViewCell.h"

#import "ShaperView.h"
#import "DLStarRatingControl.h"
@implementation ShopListTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self crectSubviews];
    }
    return self;
}

-(void)crectSubviews{
    
    
    UIImageView *shopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 64, 64)];
    shopImageView.layer.cornerRadius = 5;
    shopImageView.layer.masksToBounds = YES;
    [self addSubview:shopImageView];
    //店名
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, SCREENWIDTH-90, 20)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    nameLabel.numberOfLines = 0;
    nameLabel.text = @"";
    [self addSubview:nameLabel];
    
    //距离
    UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 63, 150, 12)];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.textAlignment = NSTextAlignmentLeft;
    distanceLabel.font = [UIFont systemFontOfSize:12];
    distanceLabel.text = @"1000米";
    [self addSubview:distanceLabel];
    //销售额
    UILabel *sellerLabel=[[UILabel alloc]initWithFrame:CGRectMake(90+95+20, 40, SCREENWIDTH-90-95-20-62, 12)];
    sellerLabel.font=[UIFont systemFontOfSize:12.0f];
    sellerLabel.textAlignment=NSTextAlignmentLeft;
    [self addSubview:sellerLabel];
    
    ShaperView *viewr=[[ShaperView alloc]initWithFrame:CGRectMake(90, 85, SCREENWIDTH-90, 1)];
    ShaperView *viewt= [viewr drawDashLine:viewr lineLength:3 lineSpacing:3 lineColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f]];
    [self addSubview:viewt];
    
    UILabel *sheLab=[[UILabel alloc]initWithFrame:CGRectMake(90, 97, 15, 15)];
    sheLab.backgroundColor=[UIColor colorWithRed:238/255.0 green:94/255.0 blue:44/255.0f alpha:1.0];
    sheLab.text=@"折";
    sheLab.textAlignment=1;
    sheLab.textColor=[UIColor whiteColor];
    sheLab.font=[UIFont systemFontOfSize:12.0f];
    [self addSubview:sheLab];
    
    UILabel *sheContent=[[UILabel alloc]initWithFrame:CGRectMake(114, 97, SCREENWIDTH-114, 15)];
    sheContent.textAlignment=NSTextAlignmentLeft;
    sheContent.font=[UIFont systemFontOfSize:12.0f];
    
    [self addSubview:sheContent];
    
    UILabel *giveLab=[[UILabel alloc]initWithFrame:CGRectMake(90, 117, 15, 15)];
    giveLab.backgroundColor=[UIColor colorWithRed:86/255.0 green:171/255.0 blue:228/255.0f alpha:1.0];
    giveLab.text=@"赠";
    giveLab.textAlignment=1;
    giveLab.textColor=[UIColor whiteColor];
    giveLab.font=[UIFont systemFontOfSize:12.0f];
    [self addSubview:giveLab];
    
    UILabel *giveContent=[[UILabel alloc]initWithFrame:CGRectMake(114, 117, SCREENWIDTH-114, 15)];
    giveContent.textAlignment=NSTextAlignmentLeft;
    giveContent.font=[UIFont systemFontOfSize:12.0f];
    
    [self addSubview:giveContent];
    
    UILabel *brandLabel=[[UILabel alloc]initWithFrame:CGRectMake(52, 10, 24, 12)];
    brandLabel.textAlignment=1;
    brandLabel.text=@"品牌";
    brandLabel.font=[UIFont systemFontOfSize:11.0f];
    [self addSubview:brandLabel];
    brandLabel.backgroundColor=[UIColor colorWithRed:255/255.0 green:210/255.0 blue:0 alpha:1];
    
    DLStarRatingControl* dlCtrl = [[DLStarRatingControl alloc]initWithFrame:CGRectMake(-40, 0, 160, 35) andStars:5 isFractional:YES star:[UIImage imageNamed:@"result_small_star_disable_iphone"] highlightStar:[UIImage imageNamed:@"redstar"]];
    dlCtrl.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    dlCtrl.userInteractionEnabled = NO;
    dlCtrl.rating =0.0;
    
    UILabel *starLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 38, 95, 15)];
    starLabel.backgroundColor = [UIColor clearColor];
    starLabel.textAlignment = NSTextAlignmentLeft;
    starLabel.font = [UIFont systemFontOfSize:15];
    
    [starLabel addSubview:dlCtrl];
    [self addSubview:starLabel];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 139, SCREENWIDTH, 1)];
    
    lineView.backgroundColor=[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f];
    [self addSubview:lineView];
    
    UILabel *couponLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-52, 40-1.5, 15, 15)];
    couponLab.backgroundColor=[UIColor colorWithRed:238/255.0 green:94/255.0 blue:44/255.0f alpha:1.0];
    couponLab.text=@"券";
    couponLab.textAlignment=1;
    couponLab.textColor=[UIColor whiteColor];
    couponLab.font=[UIFont systemFontOfSize:12.0f];
    [self addSubview:couponLab];
    
    
    self.couponLable=couponLab;
    self.shopImageView = shopImageView;
    self.nameLabel = nameLabel;
    self.distanceLabel =distanceLabel;
    self.sellerLabel =sellerLabel;
    self.dlCtrl = dlCtrl;
    self.sheContent = sheContent;
    self.giveContent = giveContent;
    
}

@end
