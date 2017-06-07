//
//  GeneralCell.h
//  BletcShop
//
//  Created by Bletc on 2017/6/6.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cardImg;//图片
@property (weak, nonatomic) IBOutlet UILabel *cardLevel;//级别
@property (weak, nonatomic) IBOutlet UILabel *cardDiscount;//折扣
@property (weak, nonatomic) IBOutlet UILabel *cardPrice;//价格
@property (weak, nonatomic) IBOutlet UILabel *cardEndtime;//有效期

@end
