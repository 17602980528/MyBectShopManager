//
//  CustomeAlertView.h
//  BletcShop
//
//  Created by apple on 16/7/23.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomeAlertView : UIView
@property (nonatomic,strong)UILabel *lab1;
@property(nonatomic,strong)UILabel *lab2;
@property(nonatomic,strong)UILabel *lab3;
@property(nonatomic,strong) UILabel *lab4;

@property(nonatomic,strong)UIView *view1;
@property(nonatomic,strong)UIView *view2;
@property(nonatomic,strong)UIView *view3;
@property(nonatomic,strong)UIView *view4;

@property(nonatomic,weak)id delegate;
@property(nonatomic)NSInteger state;
-(id)init;
@end

@protocol CustomeAlertViewDelegate <NSObject>

-(void)ClickBtnAtIndex:(NSInteger)index state:(NSInteger)state;

@end