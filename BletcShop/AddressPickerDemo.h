//
//  AddressPickerDemo.h
//  BAddressPickerDemo
//
//  Created by 林洁 on 16/1/13.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectCityDelegate <NSObject>

//选择的城市
-(void)senderSelectCity:(NSString*)selectCity;

@end

@interface AddressPickerDemo : UIViewController

@property(nonatomic,assign) id<SelectCityDelegate>delegate;
@end

