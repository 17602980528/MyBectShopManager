//
//  GraphicDetailsViewController.h
//  BletcShop
//
//  Created by Bletc on 16/6/24.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface GraphicDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,retain)NSMutableDictionary *infoDic;//商铺信息
@property(nonatomic,retain)NSMutableArray *pictureAndContentArray;//图文
@property(nonatomic,retain)NSMutableArray *pictureArray;//图
@property(nonatomic,retain)NSMutableArray *contentArray;//文
@property(nonatomic,retain)NSMutableArray *modelStateArray;//模版号
@end
