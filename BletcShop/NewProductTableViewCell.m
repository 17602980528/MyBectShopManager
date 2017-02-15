//
//  NewProductTableViewCell.m
//  BletcShop
//
//  Created by apple on 16/11/23.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NewProductTableViewCell.h"

@implementation NewProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 商品图像
        self.headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 60, 60)];
        [self addSubview:_headImageView];
        //商品名称
        self.pruductName=[[UILabel alloc]initWithFrame:CGRectMake(self.headImageView.right+10, self.headImageView.top, SCREENWIDTH-self.headImageView.right-10-90, 40)];
        //_pruductName.textAlignment=1;
        self.pruductName.numberOfLines=2;
        _pruductName.font=[UIFont systemFontOfSize:16.0f];
        [self addSubview:_pruductName];
        //商品编号
        self.pruductCode=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-70-20, _pruductName.top, 70, 40)];
        _pruductCode.textAlignment=NSTextAlignmentRight;
        _pruductCode.numberOfLines=2;
        _pruductCode.textColor=RGB(102, 102, 102);
        _pruductCode.font=[UIFont systemFontOfSize:15.0f];
        [self addSubview:_pruductCode];
        //商品价格
        self.pruductPrice=[[UILabel alloc]initWithFrame:CGRectMake(232-20, _headImageView.bottom-14, SCREENWIDTH-232,14)];
       self.pruductPrice.textAlignment=NSTextAlignmentRight;
        _pruductPrice.textColor=RGB(242, 102, 102);
        _pruductPrice.font=[UIFont systemFontOfSize:15.0f];
        [self addSubview:_pruductPrice];
        //商品库存
        self.pruductRemain=[[UILabel alloc]initWithFrame:CGRectMake(_pruductName.left,_pruductPrice.top, 120, 14)];
        _pruductRemain.textColor=RGB(102, 102, 102);
        _pruductRemain.font=[UIFont systemFontOfSize:15.0f];
        [self addSubview:_pruductRemain];
        
        
    }
    return self;
}



@end
