//
//  NewMessageCell.m
//  BletcShop
//
//  Created by Bletc on 2017/1/12.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NewMessageCell.h"

@interface NewMessageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;


@end


@implementation NewMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype)CellWithTableView:(UITableView*)tableView{
    
    
    NewMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:meaaageID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NewMessageCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.headImg.backgroundColor = [UIColor redColor];
    
    return cell;
}



@end
