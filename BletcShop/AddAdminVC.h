//
//  AddAdminVC.h
//  BletcShop
//
//  Created by Bletc on 2016/11/30.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddAdminVCDelegate <NSObject>

-(void)reloadAPI;

@end
@interface AddAdminVC : UIViewController

@property NSInteger editTag;
@property (nonatomic,strong)NSDictionary *edit_dic;//需要编辑的数据

@property (nonatomic , assign) id<AddAdminVCDelegate> delegate;// 

@end
