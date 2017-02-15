//
//  AddAdminCell.h
//  BletcShop
//
//  Created by Bletc on 2016/11/30.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *identifier = @"addAdmin";

@interface AddAdminCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title_lab;
@property (weak, nonatomic) IBOutlet UITextField *textFileld;

@end
