//
//  FeedBackViewController.h
//  BletcShop
//
//  Created by Bletc on 16/5/27.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate>
@property (retain, nonatomic)UITextView *textView;
@property (retain, nonatomic)UILabel *placeholder;
@property (retain, nonatomic)UITextField *contactText;
@end
