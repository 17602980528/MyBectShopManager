//
//  SelectAddressViewController.h
//  BletcShop
//
//  Created by Bletc on 2017/3/9.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectAddressDelegate <NSObject>

@optional

-(void)senderReceiceInfo:(NSDictionary*)dic;


@end

@interface SelectAddressViewController : UIViewController

@property (nonatomic , weak)  id<SelectAddressDelegate> delegate;// <#Description#>


@end
