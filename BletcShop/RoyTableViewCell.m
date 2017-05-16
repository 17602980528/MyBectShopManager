//
//  RoyTableViewCell.m
//  BletcShop
//
//  Created by apple on 16/12/13.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "RoyTableViewCell.h"

@implementation RoyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        // 创建子视图
        UIView *bgview=[[UIView alloc]initWithFrame:CGRectMake(12, 10, SCREENWIDTH-24, 200)];
        bgview.layer.cornerRadius=8.0f;
        bgview.layer.borderWidth=1.0f;
        bgview.layer.borderColor=[RGB(240, 240, 240)CGColor];
        bgview.clipsToBounds=YES;
        bgview.backgroundColor=[UIColor whiteColor];
        [self addSubview:bgview];
        
        _shopNameLable=[[UILabel alloc]initWithFrame:CGRectMake(14, 14, SCREENWIDTH-24-28, 17)];
        _shopNameLable.font=[UIFont systemFontOfSize:18.0f];
        [bgview addSubview:_shopNameLable];
        
        _cardLevelLable=[[UILabel alloc]initWithFrame:CGRectMake(14, 45, 160, 17)];
        _cardLevelLable.font=[UIFont systemFontOfSize:18.0f];
        [bgview addSubview:_cardLevelLable];
        
        _cardPriceLable=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-24-120, 45, 100, 17)];
        _cardPriceLable.font=[UIFont systemFontOfSize:13.0f];
        _cardPriceLable.textAlignment=1;
        _cardPriceLable.textColor=[UIColor grayColor];
        [self addSubview:_cardPriceLable];
        
        UIView *describeView=[[UIView alloc]initWithFrame:CGRectMake(12, 77, SCREENWIDTH-24-24, 74)];
        describeView.backgroundColor=[UIColor whiteColor];
        describeView.layer.cornerRadius=5.0f;
        describeView.layer.borderWidth=1.0f;
        describeView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        [bgview addSubview:describeView];
        
        UILabel *checkLb=[[UILabel alloc]init];
        checkLb.frame=CGRectMake(SCREENWIDTH-24-24-50-14, 22, 50, 30);
        checkLb.backgroundColor=RGB(227, 45, 45);
        checkLb.layer.cornerRadius=5.0f;
        checkLb.clipsToBounds=YES;
        checkLb.textColor=[UIColor whiteColor];
        checkLb.textAlignment=1;
        checkLb.text=@"查看";
        checkLb.font=[UIFont systemFontOfSize:15.0f];
        [describeView addSubview:checkLb];
        
        _cardDescription=[[UILabel alloc]initWithFrame:CGRectMake(12, 14, SCREENWIDTH-24-24-80-20, 60)];
        _cardDescription.font=[UIFont systemFontOfSize:14.0f];
        _cardDescription.numberOfLines=0;
        _cardDescription.textColor=[UIColor grayColor];
        [describeView addSubview:_cardDescription];
        
        _editButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.frame=CGRectMake(12, describeView.bottom+10, 80, 30);
        _editButton.backgroundColor=RGB(240, 240, 240);
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        _editButton.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        [bgview addSubview:_editButton];
        
        _deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame=CGRectMake(102, describeView.bottom+10, 80, 30);
        _deleteButton.backgroundColor=RGB(240, 240, 240);
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _deleteButton.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        [bgview addSubview:_deleteButton];
        
        _onOrOffButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _onOrOffButton.frame=CGRectMake(describeView.right-12-80, describeView.bottom+10, 80, 30);
        _onOrOffButton.backgroundColor=RGB(240, 240, 240);
        [_onOrOffButton setTitle:@"上架" forState:UIControlStateNormal];
        [_onOrOffButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _onOrOffButton.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        [bgview addSubview:_onOrOffButton];
        
        
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
