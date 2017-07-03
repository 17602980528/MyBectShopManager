//
//  CustomeAlertView.h
//  BletcShop
//
//  Created by apple on 16/7/23.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomeAlertViewDelegate <NSObject>

-(void)ClickBtnAtIndex:(NSInteger)index state:(NSInteger)state;

@end

@interface CustomeAlertView : UIView

@property(nonatomic,weak)id delegate;
@property(nonatomic)NSInteger state;

-(instancetype)initWithArray:(NSArray*)array;

@end

