//
//  AddproductVC.h
//  BletcShop
//
//  Created by Bletc on 2016/11/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddProductDelegate <NSObject>

-(void)reloadTheAPI;


@end
@interface AddproductVC : UIViewController
@property NSInteger editTag;
@property (nonatomic , strong) NSDictionary *product_dic;

@property(nonatomic,assign)id<AddProductDelegate> delegate;
@end
