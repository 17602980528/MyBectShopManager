//
//  ErrorQRViewController.h
//  BletcShop
//
//  Created by Bletc on 2016/12/7.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorQRViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *errrotextView;

@property (nonatomic,copy)NSString *errorString;// <#Description#>

@end
