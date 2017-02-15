//
//  Mycell.h
//  BletcShop
//
//  Created by Yuan on 16/1/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Myitem;

@interface Mycell : UITableViewCell

@property(nonatomic,strong)Myitem *cellItem;

+(Mycell *)cellForTableView:(UITableView *)tableView;
@end
