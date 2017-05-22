//
//  ScanViewController.h
//  WoLaiYe
//
//  Created by 鲁征东 on 16/6/21.
//  Copyright © 2016年 鲁征东. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>


@interface ScanViewController : UIViewController
@property(nonatomic)NSString *shopOrUser;
@property(nonatomic,assign)id delegate;
@end
@protocol ScanViewControllerDelegate <NSObject>

@optional
-(void)sendResult:(NSString *)state;
@end
