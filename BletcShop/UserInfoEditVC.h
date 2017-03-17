//
//  UserInfoEditVC.h
//  BletcShop
//
//  Created by Bletc on 2017/3/15.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UserInfoEditVCBlock)(NSDictionary *result_dic);

@interface UserInfoEditVC : UIViewController
@property (nonatomic,copy)NSString *leibie;// 修改的类目

@property (nonatomic,copy)UserInfoEditVCBlock resultBlock;//

@property (nonatomic,copy)NSString *whoPush;// <#Description#>


@end
