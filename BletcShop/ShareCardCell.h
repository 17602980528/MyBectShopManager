//
//  ShareCardCell.h
//  BletcShop
//
//  Created by Bletc on 2016/11/2.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shareCardModel.h"
@interface ShareCardCell : UITableViewCell


@property (nonatomic , strong) shareCardModel *model;// <#Description#>

@property(nonatomic,strong)UIButton *choseBtn;


@end
