//
//  ChoiceAdminAlertView.h
//  BletcShop
//
//  Created by Bletc on 16/8/9.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoiceAdminAlertView : UIView
@property (nonatomic,strong)UILabel *lab1;
@property(nonatomic,strong)UILabel *lab2;
@property(nonatomic,weak)id delegate;
@property(nonatomic)NSInteger state;
-(id)init;
@end
@protocol ChoiceAlertViewDelegate <NSObject>

-(void)ChoiceAdminClick:(NSInteger)state;

@end