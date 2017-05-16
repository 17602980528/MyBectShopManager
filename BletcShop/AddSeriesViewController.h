//
//  AddSeriesViewController.h
//  BletcShop
//
//  Created by Bletc on 2017/5/16.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSeriesViewController : UIViewController
@property(nonatomic,assign)id delegate;
@property(nonatomic,copy)NSString *cardTypes;
@end
@protocol AddSeriesViewControllerDelegate <NSObject>

-(void)addCardCodeAndTypes:(NSString *)names type:(NSString *)types muid:(NSString *)muid;

@end
