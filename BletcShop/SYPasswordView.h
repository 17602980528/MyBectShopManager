//
//  SYPasswordView.h
//  PasswordDemo
//
//  Created by aDu on 2017/2/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYPasswordView : UIView<UITextFieldDelegate>
@property(nonatomic,assign)id delegate;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *dotArray; //用于存放黑色的点点

- (void)clearUpPassword;

@end
@protocol SYPasswordViewDelegate <NSObject>

-(void)passLenghtEqualsToSix:(NSString *)pass;
-(void)observationPassLength:(NSString *)pwd;
@end
