//
//  Mycell.m
//  BletcShop
//
//  Created by Yuan on 16/1/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "Mycell.h"
#import "Myitem.h"

@interface Mycell ()

@property(nonatomic,weak) UILabel *desLab;
@end


@implementation Mycell

+(Mycell *)cellForTableView:(UITableView *)tableView
{
    static NSString *inde = @"cell";
    Mycell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
    
    if (cell==nil) {
        cell = [[Mycell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = RGB(51,51,51);
    }
    
    
    return cell;
}
-(void)setCellItem:(Myitem *)cellItem
{
    _cellItem = cellItem;
    self.textLabel.text = cellItem.title;
    self.imageView.image = [UIImage imageNamed:self.cellItem.img];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
