//
//  CardCodeTypeVC.h
//  BletcShop
//
//  Created by apple on 2017/5/2.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardCodeTypeVC : UIViewController
@property(nonatomic,assign)id delegate;
@property(nonatomic,copy)NSString *cardTypes;
@end
@protocol CardCodeTypeVCDelegate <NSObject>

-(void)addCardCodeAndTypes:(NSString *)names type:(NSString *)types muid:(NSString *)muid;

@end
