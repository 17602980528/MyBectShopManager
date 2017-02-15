//
//  LZDAddVIPViewController.h
//  BletcShop
//
//  Created by Bletc on 16/9/29.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol addVipDelegate <NSObject>

-(void)senderVip_array:(NSArray*)arr;

@end
@interface LZDAddVIPViewController : UIViewController



@property(nonatomic,weak)id<addVipDelegate>delegate;

@end
