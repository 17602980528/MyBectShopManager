//
//  MessageCell.h
//  WoLaiYe
//
//  Created by 鲁征东 on 16/6/24.
//  Copyright © 2016年 鲁征东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import "UIImageView+WebCache.h"
static NSString *message = @"message";


@interface MessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UIButton *jujueBtn;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;

@property(nonatomic,strong)Message *model;


+(instancetype)messageCellWithTableView:(UITableView *)tableView;
//-(CGFloat)cellHightWithModel:(Message*)model;
@end
