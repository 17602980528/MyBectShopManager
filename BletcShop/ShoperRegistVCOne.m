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
@property (weak, nonatomic) IBOutlet UITextField *referralTF;

@end

@implementation ShoperRegistVCOne

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTextFieldLeftImageView:self.phoneTF leftImageName:@"手机"];
   
    [self setTextFieldLeftImageView:self.referralTF leftImageName:@"推荐人"];

    
}
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)ert:(id)sender {
    
    if (self.referralTF.text.length!=0) {
        if ( [ToolManager validateMobile:self.referralTF.text] && [ToolManager validateMobile:self.phoneTF.text]) {
            
           if(![_referralTF.text isEqualToString:_phoneTF.text]) {
               
               [self validationPhone];
               
             

           }else{
               
               [self showHint:@"推荐人不能为自己!"];

           }
            
                   }else {
            
            [self showHint:@"手机号格式不正确!"];
        }

        
    }else{
        
        if ( [ToolManager validateMobile:self.phoneTF.text]) {
            
            [self validationPhone];

        }else{
            
            [self showHint:@"手机号格式不正确!"];
        }

        
    }

    
}


-(void)validationPhone{
    
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/register/register_check",BASEURL];
    
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:_phoneTF.text forKey:@"phone"];
    
    [paramer setValue:_referralTF.text forKey:@"referrer"];

    if (self.referralTF.text.length==0) {
        [paramer setValue:@"无人推荐" forKey:@"referrer"];
        
    }
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"====%@===%@",paramer,result);
        
        if ([result[@"result_code"] isEqualToString:@"phone_duplicate"]) {
            [self showHint:@"手机号已注册,请直接登录"];
        }else if ([result[@"result_code"] isEqualToString:@"referrer_not_found"]){
            [self showHint:@"推荐人手机号不存在"];

        }else{
           
            
            ShoperRegistVCTwo *VC = [[ShoperRegistVCTwo alloc]init];
            VC.phone =self.phoneTF.text;
            
            if (self.referralTF.text.length!=0) {
                VC.referralPhone = self.referralTF.text;

            }
            
            [self presentViewController:VC animated:YES completion:nil];
            
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

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
