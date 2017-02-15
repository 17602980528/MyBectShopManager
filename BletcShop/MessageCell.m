//
//  MessageCell.m
//  WoLaiYe
//
//  Created by 鲁征东 on 16/6/24.
//  Copyright © 2016年 鲁征东. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
}


+(instancetype)messageCellWithTableView:(UITableView *)tableView
{
    MessageCell *cell =[tableView dequeueReusableCellWithIdentifier:message];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageCell" owner:self options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}
-(void)setModel:(Message *)model{
    _model = model;
    DebugLog(@"model.avatar---%@",model.avatar);
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"-1-01"]];
    
    self.titlelab.text = model.title;
    self.desLab.text = model.subTitle;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
