//
//  ProfessionEditVC.h
//  BletcShop
//
//  Created by Bletc on 2017/3/15.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ProfessionEditVCBlock)(NSDictionary*dic);
@interface ProfessionEditVC : UIViewController

@property (nonatomic,copy)ProfessionEditVCBlock prodessionBlock;// <#Description#>

@end
