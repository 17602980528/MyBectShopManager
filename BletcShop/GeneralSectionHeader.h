//
//  GeneralSectionHeader.h
//  BletcShop
//
//  Created by Bletc on 2017/6/6.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralSectionHeader : UITableViewHeaderFooterView
@property (nonatomic , weak) UIButton *addBtn;// <#Description#>
@property (nonatomic , weak) UIImageView *leftImg;// 小箭头
@property (nonatomic , weak) UILabel *titleLab;//标题

@property (nonatomic , assign) BOOL fold;// 是否折叠


@end
