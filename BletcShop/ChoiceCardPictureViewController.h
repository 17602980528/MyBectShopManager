//
//  ChoiceCardPictureViewController.h
//  BletcShop
//
//  Created by Bletc on 16/8/1.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChoiceCardDelegate <NSObject>

// 代理传值方法
- (void)sendCardValue:(NSDictionary *)value;

@end

@interface ChoiceCardPictureViewController : UIViewController


@property (nonatomic,retain)NSMutableArray *allCards;
@property (nonatomic,retain)UIScrollView *scrollView;
// 委托代理人，代理一般需使用弱引用(weak)
@property (weak, nonatomic) id<ChoiceCardDelegate> delegate;
@end
