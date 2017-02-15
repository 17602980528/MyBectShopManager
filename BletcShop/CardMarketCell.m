//
//  CardMarketCell.m
//  BletcShop
//
//  Created by Bletc on 2017/1/16.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CardMarketCell.h"
#import "UIImageView+WebCache.h"

@interface CardMarketCell ()
@property(nonatomic,weak)UIView *line1;
@property(nonatomic,weak)UIImageView *imgView;
@property(nonatomic,weak)UILabel *nickNamelab;
@property(nonatomic,weak)UILabel *timeLab;

@property(nonatomic,weak)UILabel *descripLab;

@property(nonatomic,weak)UILabel *shopLab;
@property(nonatomic,weak)UILabel *addresslab;

@property(nonatomic,weak)UIView *line;


@end
@implementation CardMarketCell



+(instancetype)creatCellWithTableView:(UITableView*)tableView
{
    CardMarketCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[CardMarketCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initSubViews];

    }
    return self;

}

-(void)initSubViews{
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(17, 11, 46, 46)];
    imgView.layer.cornerRadius = imgView.width/2;
    imgView.backgroundColor = RGB(32,149,242);
    [self.contentView addSubview:imgView];
    self.imgView = imgView;
    
    UILabel *nickNamelab = [[UILabel alloc]initWithFrame:CGRectMake(73, 12, 200, 14)];
    nickNamelab.text = @"洛天依";
    nickNamelab.textColor = RGB(51,51,51);
    nickNamelab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:nickNamelab];
    self.nickNamelab = nickNamelab;
    
    UILabel *pricelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 14, SCREENWIDTH- 29, 12)];
    pricelab.textColor = RGB(245,70,17);
    pricelab.text = @"￥438.00";
    pricelab.textAlignment = NSTextAlignmentRight;
    pricelab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:pricelab];
    self.pricelab = pricelab;
    
    UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(73, 38, 100, 12)];
    timeLab.font = [UIFont systemFontOfSize:12];
    timeLab.textColor = RGB(102,102,102);
    timeLab.text = @"26分钟前";
    [self.contentView addSubview:timeLab];
    self.timeLab = timeLab;
    
    UILabel *shopLab = [[UILabel alloc]initWithFrame:CGRectMake(18, imgView.bottom +11, SCREENWIDTH-20, 16)];
    shopLab.text = @"Kiss宠物生活馆";
    shopLab.textColor = RGB(32,149,242);
    shopLab.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:shopLab];
    self.shopLab = shopLab;
    
    
    UILabel *descripLab = [[UILabel alloc]init];
    descripLab.textColor = RGB(51,51,51);
    descripLab.numberOfLines= 0;
    descripLab.text = @"【转让】现有卡一张(9.0折卡),9.9折转让,需要的朋友尽快下手";
    
    descripLab.font = [UIFont systemFontOfSize:15];
    CGFloat descrip_height = [self getSizeWithLab:descripLab andMaxSize:CGSizeMake(SCREENWIDTH-36, MAXFLOAT)].height;
    
    descripLab.frame = CGRectMake(18, shopLab.bottom+13, SCREENWIDTH-36, descrip_height);
    
    [self.contentView addSubview:descripLab];
    
    self.descripLab = descripLab;
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, descripLab.bottom +11, SCREENWIDTH-24, 1)];
    line.backgroundColor = RGB(234,234,234);
    [self.contentView addSubview:line];
    
    self.line = line;
    
    UILabel *addresslab = [[UILabel alloc]initWithFrame:CGRectMake(18, line.bottom +10, SCREENWIDTH-25, 13)];
    addresslab.text = @"来自高新区 富鱼路";;
    addresslab.textColor = RGB(102,102,102);
    addresslab.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:addresslab];
    
    self.addresslab = addresslab;
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, addresslab.bottom +10, SCREENWIDTH, 10)];
    line1.backgroundColor = RGB(240, 240, 240);
    [self.contentView addSubview:line1];
    
    self.line1 = line1;
      
    
}
-(void)setModel:(CardMarketModel *)model{
    
    _model = model;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,_model.headimage]] placeholderImage:[UIImage imageNamed:@"user.png"]];

    self.nickNamelab.text = _model.nickname;
    self.timeLab.text = [_model.datetime sinaWeiboCreatedAtString];
    self.shopLab.text = _model.store;
    
    NSString *type;
    if ([_model.method isEqualToString:@"transfer"]) {
        type = @"转让";
        self.descripLab.text = [NSString stringWithFormat:@"【%@】现有%@%@元%@%@一张(%.1f折卡),%.1f折%@,需要的朋友尽快下手",type,_model.store,_model.card_remain,_model.card_level,_model.card_type,[_model.rule floatValue]*0.1,[_model.rate floatValue]*0.1,type];

    }else{
        type = @"分享";
        self.descripLab.text = [NSString stringWithFormat:@"【%@】现有%@%@元%@%@一张(%g折卡),需要的朋友尽快下手,手续费仅(%@%%)",type,_model.store,_model.card_remain,_model.card_level,_model.card_type,[_model.rule floatValue]*0.1,_model.rate];


    }
    self.addresslab.text = [NSString stringWithFormat:@"来自%@",_model.address];
    self.pricelab.text = [NSString stringWithFormat:@"¥%@",_model.card_remain];
    
    CGFloat descrip_height = [self getSizeWithLab:self.descripLab andMaxSize:CGSizeMake(SCREENWIDTH-36, MAXFLOAT)].height;
    
    self.descripLab.frame = CGRectMake(18, self.shopLab.bottom+13, SCREENWIDTH-36, descrip_height);
    
    self.line.frame = CGRectMake(12, self.descripLab.bottom +11, SCREENWIDTH-24, 1);
    
    self.addresslab.frame = CGRectMake(18, self.line.bottom +10, SCREENWIDTH-25, 13);
    self.line1.frame = CGRectMake(0, self.addresslab.bottom +10, SCREENWIDTH, 10);

   
    
    
}
-(CGFloat)cellHeightWithModel:(CardMarketModel *)model
{    
    [self setModel:model];
    
    
    return self.line1.bottom;
    
    
}

-(CGSize)getSizeWithLab:(UILabel*)lable andMaxSize:(CGSize)size{
    
    CGSize SZ = [lable.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:lable.font} context:nil].size ;
    
    return SZ
    ;
}
@end
