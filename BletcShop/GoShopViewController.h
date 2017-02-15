//
//  GoShopViewController.h
//  BletcShop
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoShopViewController : UIViewController
@property(nonatomic)NSInteger counts;
@property(nonatomic,copy)NSString *imageName;
@property(nonatomic,copy)NSString *shopName;
@property(nonatomic,copy)NSString *allPoint;
@property(nonatomic,copy)NSString *issue;
@property(nonatomic,assign)id delegate;
@end
@protocol GoShopViewControllerDelegate <NSObject>

-(void)awardResult:(NSArray *)awardArr;

@end