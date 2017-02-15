//
//  SelectShopViewController.h
//  BletcShop
//
//  Created by apple on 16/9/29.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectShopViewController : UIViewController
@property(nonatomic,assign)id delegate;
@end

@protocol SelectShopDelegate <NSObject>

-(void)sendNsArr:(NSMutableArray *)arr;

@end
