//
//  MoreInfoViewController.h
//  BletcShop
//
//  Created by Bletc on 16/4/5.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOPDropDownMenu.h"

@interface MoreInfoViewController : UIViewController<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, weak) DOPDropDownMenu *menu;//下拉列表

@end
