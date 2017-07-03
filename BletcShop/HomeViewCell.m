//
//  HomeViewself.m
//  BletcShop
//
//  Created by Bletc on 2016/11/4.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "HomeViewCell.h"
#import "ShaperView.h"
#import "DLStarRatingControl.h"
#import "UIImageView+WebCache.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface HomeViewCell ()
{
    UIView *lineView;
}
@property (nonatomic,weak) UIImageView *img_v;  //图片
@property (nonatomic,weak) UILabel *subTitle;//折扣描述
@property(nonatomic,weak)UILabel * title_lab;//标题
@property(nonatomic,weak)UILabel * distance_lab;//距离
@property(nonatomic,weak) DLStarRatingControl* dlCtrl;//评分

@property(nonatomic,weak)UILabel *seller_Label;//销量
@property(nonatomic,weak)UILabel *give_Lab;//赠送描述
@property(nonatomic,weak)UILabel *coupon_Lable;
@property(nonatomic,weak)UILabel *brandLabel;//行业分类
@end
@implementation HomeViewCell

+(instancetype)homeViewCellWithTableView:(UITableView*)tableView;
{
    HomeViewCell*cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HomeViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        
        
        
    }
    
    return self;
}


-(void)initSubViews{
    
    UIImageView *shopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 64, 64)];
    shopImageView.layer.cornerRadius = 5;
    shopImageView.layer.masksToBounds = YES;
    //    shopImageView.backgroundColor = [UIColor orangeColor];
    [self addSubview:shopImageView];
    self.img_v = shopImageView;
    
    //店名
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, SCREENWIDTH-100, 20)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    nameLabel.text = @"何军早想";
    nameLabel.textColor = [UIColor blackColor];
    [self addSubview:nameLabel];
    self.title_lab = nameLabel;
    
    
    //评分
    
    DLStarRatingControl* dlCtrl = [[DLStarRatingControl alloc]initWithFrame:CGRectMake(-40, 0, 160, 35) andStars:5 isFractional:YES star:[UIImage imageNamed:@"result_small_star_disable_iphone"] highlightStar:[UIImage imageNamed:@"redstar"]];
    
    dlCtrl.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    dlCtrl.userInteractionEnabled = NO;
    
    self.dlCtrl = dlCtrl;
    UILabel *starLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 38, 95, 24)];
    starLabel.backgroundColor = [UIColor clearColor];
    starLabel.textAlignment = NSTextAlignmentLeft;
    starLabel.font = [UIFont systemFontOfSize:15];
    
    [starLabel addSubview:dlCtrl];
    [self addSubview:starLabel];
    
    //距离
    UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 63, 150, 12)];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.textAlignment = NSTextAlignmentLeft;
    distanceLabel.font = [UIFont systemFontOfSize:12];
    distanceLabel.text = @"1km";
    [self addSubview:distanceLabel];
    self.distance_lab = distanceLabel;
    //销售额
    UILabel *sellerLabel=[[UILabel alloc]initWithFrame:CGRectMake(90+95+20, 40, SCREENWIDTH-90-95-20-62, 12)];
    sellerLabel.text=@"已售258笔";
    sellerLabel.font=[UIFont systemFontOfSize:12.0f];
    sellerLabel.textAlignment=NSTextAlignmentLeft;
    [self addSubview:sellerLabel];
    self.seller_Label = sellerLabel;
    
    //虚线
    ShaperView *viewr=[[ShaperView alloc]initWithFrame:CGRectMake(90, 85, SCREENWIDTH-90, 1)];
    ShaperView *viewt= [viewr drawDashLine:viewr lineLength:3 lineSpacing:3 lineColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f]];
    [self addSubview:viewt];
    
    //折扣
    
    UILabel *sheLab=[[UILabel alloc]initWithFrame:CGRectMake(90, 97, 15, 15)];
    sheLab.backgroundColor=[UIColor colorWithRed:238/255.0 green:94/255.0 blue:44/255.0f alpha:1.0];
    sheLab.text=@"折";
    sheLab.textAlignment=1;
    sheLab.textColor=[UIColor whiteColor];
    sheLab.font=[UIFont systemFontOfSize:12.0f];
    [self addSubview:sheLab];
    
    UILabel *shelab_1 = [[UILabel alloc]initWithFrame:CGRectMake(sheLab.right+5, sheLab.top, SCREENWIDTH-sheLab.right-5, 15)];
    shelab_1.text = @"首单只需支付1元免费加一款造型";
    shelab_1.textColor = RGB(102,102,102);
    shelab_1.font = sheLab.font;
    [self addSubview:shelab_1];
    self.subTitle =  shelab_1;
    
    //增
    UILabel *giveLab=[[UILabel alloc]initWithFrame:CGRectMake(90, 117, 15, 15)];
    giveLab.backgroundColor=[UIColor colorWithRed:86/255.0 green:171/255.0 blue:228/255.0f alpha:1.0];
    giveLab.text=@"赠";
    giveLab.textAlignment=1;
    giveLab.textColor=[UIColor whiteColor];
    giveLab.font=[UIFont systemFontOfSize:12.0f];
    [self addSubview:giveLab];
    
    UILabel *giveLab_1 = [[UILabel alloc]initWithFrame:CGRectMake(giveLab.right+5, giveLab.top, SCREENWIDTH-giveLab.right-5, 15)];
    giveLab_1.text = @"单次消费满500送50抵用劵";
    giveLab_1.textColor = RGB(102,102,102);
    giveLab_1.font = giveLab.font;
    [self addSubview:giveLab_1];
    
    self.give_Lab = giveLab_1;
    
    
    UILabel *brandLabel=[[UILabel alloc]initWithFrame:CGRectMake(32, 10, 44, 12)];
    brandLabel.textAlignment=1;
    brandLabel.text=@"品牌";
    brandLabel.font=[UIFont systemFontOfSize:10.0f];
    [self addSubview:brandLabel];
    brandLabel.backgroundColor=[UIColor colorWithRed:255/255.0 green:210/255.0 blue:0 alpha:1];
    self.brandLabel = brandLabel;
    
    
    
    
    lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 139, SCREENWIDTH, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f];
    [self addSubview:lineView];
    
    UILabel *couponLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-52, 40-1.5, 15, 15)];
    couponLab.backgroundColor=[UIColor colorWithRed:238/255.0 green:94/255.0 blue:44/255.0f alpha:1.0];
    couponLab.text=@"券";
    couponLab.textAlignment=1;
    couponLab.textColor=[UIColor whiteColor];
    couponLab.font=[UIFont systemFontOfSize:12.0f];
    [self addSubview:couponLab];
    self.coupon_Lable=couponLab;
    
}

-(void)setModel:(HomeShopModel *)model{
    
    
    _model = model;
    
    [self.img_v sd_setImageWithURL:[NSURL URLWithString:self.model.img_url] placeholderImage:[UIImage imageNamed:@"icon3.png"]];
    
    
    if ([_model.subTitl floatValue]>0.0 && [_model.subTitl floatValue]<100.0) {
        self.subTitle.text = [NSString stringWithFormat:@"%.1f折",[_model.subTitl floatValue]/10];
        
    }else{
        self.subTitle.text  = @"暂无折扣!";
        
    }
    
    self.title_lab.text = _model.title_S;
    //    self.give_Lab.text = _model.addTitl;
    
    if ([_model.addTitl floatValue]>0.0) {
        self.give_Lab.text = [NSString stringWithFormat:@"办卡就送%@",_model.addTitl];
        
    }else{
        self.give_Lab.text  = @"暂无活动!";
        
    }
    
    self.seller_Label.text = [NSString stringWithFormat:@"已售%@笔",_model.soldCount];
    self.dlCtrl.rating = [_model.stars floatValue];
    
    
    CLLocationCoordinate2D c1 = (CLLocationCoordinate2D){[self.model.latitude doubleValue], [self.model.longtitude doubleValue]};
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    CLLocationCoordinate2D c2 = appdelegate.userLocation.location.coordinate;
    
    BMKMapPoint a=BMKMapPointForCoordinate(c1);
    BMKMapPoint b=BMKMapPointForCoordinate(c2);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(a,b);
    int meter = (int)distance;
    if (meter>1000) {
        self.distance_lab.text = [[NSString alloc]initWithFormat:@"%.1fkm",meter/1000.0];
    }else
        self.distance_lab.text = [[NSString alloc]initWithFormat:@"%dm",meter];
    
    if ([_model.coupon_exists isEqualToString:@"yes"]) {
        self.coupon_Lable.hidden=NO;
    }else{
        self.coupon_Lable.hidden=YES;
    }
    CGFloat width= [self calculateRowWidth:self.model.trade];
    self.brandLabel.frame=CGRectMake(76-width, 10, width, 12);
    self.brandLabel.text=self.model.trade;
    
}

-(CGFloat)cellHeightWithModel:(HomeShopModel *)model{
    
    _model = model;
    
    CGFloat h = CGRectGetMaxY(lineView.frame);
    
    return h;
    
}
- (CGFloat)calculateRowWidth:(NSString *)string {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 12)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}
@end
