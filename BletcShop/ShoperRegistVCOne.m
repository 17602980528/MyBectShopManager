//
//  ShoperRegistVCOne.m
//  BletcShop
//
//  Created by Bletc on 2017/6/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ShoperRegistVCOne.h"
#import "ShoperRegistVCTwo.h"
#import "ToolManager.h"
@interface ShoperRegistVCOne ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@end

@implementation ShoperRegistVCOne

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTextFieldLeftImageView:self.phoneTF leftImageName:@"手机"];
   
    
    
}
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)ert:(id)sender {
//    if (![ToolManager validateMobile:self.phoneTF.text]) {
//        [self showHint:@"手机号格式不正确!"];
//        
//        
//    }else{
        ShoperRegistVCTwo *VC = [[ShoperRegistVCTwo alloc]init];
        VC.phone =self.phoneTF.text;
        [self presentViewController:VC animated:YES completion:nil];

//    }
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)setTextFieldLeftImageView:(UITextField *)textField leftImageName:(NSString *)imageName
{
    // 设置左边图片
    UIImageView *leftView     = [[UIImageView alloc] init];
    leftView.image            = [UIImage imageNamed:imageName];
    leftView.bounds = CGRectMake(0, 0, 30, 30);
//    leftView.height = 30;
//    leftView.width = 30;
    
    // 设置leftView的内容居中
    leftView.contentMode      = UIViewContentModeCenter;
    textField.leftView        = leftView;
    
    // 设置左边的view永远显示
    textField.leftViewMode    = UITextFieldViewModeAlways;
    
    // 设置右边永远显示清除按钮
    textField.clearButtonMode = UITextFieldViewModeAlways;
}

@end
