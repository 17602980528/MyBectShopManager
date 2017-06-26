//
//  ChooseProductVC.h
//  BletcShop
//
//  Created by apple on 2017/6/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseProductVC : UIViewController
@property (nonatomic,retain)NSDictionary *choiceCard;
@property (nonatomic,assign)id delegate;
@property (strong,nonatomic)NSArray *normalArray;
@property (strong,nonatomic)NSArray *recArray;
@end
@protocol ChooseProductVCDelegate <NSObject>

-(void)weChoosedPruductDic:(NSArray *)array;

@end
