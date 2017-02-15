//
//  CommenDataViewController.h
//  BletcShop
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommenDataViewController : UIViewController
@property(nonatomic,assign)NSInteger tag;

-(void)totalDataRequest:(NSString *)record_type dateType:(NSString *)type page:(NSString *)pag;

@end
