//
//  NewModelImageViewController.h
//  BletcShop
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewModelImageViewController : UIViewController
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,assign)id delegate;
@end
@protocol NewModelImageViewControllerDelegate <NSObject>

-(void)changeUserImage:(UIImage *)image;

@end