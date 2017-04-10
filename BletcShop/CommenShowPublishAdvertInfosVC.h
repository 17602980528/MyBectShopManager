//
//  CommenShowPublishAdvertInfosVC.h
//  BletcShop
//
//  Created by apple on 17/3/17.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommenShowPublishAdvertInfosVC : UITableViewController
@property(nonatomic,strong)NSDictionary *infoDic;
@property(nonatomic,copy)NSString *applyState;
@property(nonatomic,assign)id dele;
@end
@protocol CommenShowPublishAdvertInfosVCDelegate <NSObject>

-(void)refreshTableView;

@end
