//
//  RailNameConfirmVC.m
//  BletcShop
//
//  Created by apple on 2017/6/9.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "RailNameConfirmVC.h"
#import "ToolManager.h"
@interface RailNameConfirmVC ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *realNameTF;
@property (strong, nonatomic) IBOutlet UITextField *idCardNumTF;

@end

@implementation RailNameConfirmVC
- (IBAction)commitConfirmBtnClick:(id)sender {
    if (_realNameTF.text.length==0) {
        [self alert:@"请输入您的真实姓名"];
    }else if(![ToolManager validateIdentityCard:_idCardNumTF.text]){
         [self alert:@"身份证号码格式有误"];
    }else{
        [self postRequest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实名认证";
    [self setTextFieldLeftImageView:_realNameTF leftImageName:@"姓名she"];
    [self setTextFieldLeftImageView:_idCardNumTF leftImageName:@"身份she"];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)alert:(NSString *)msg {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}
-(void)postRequest
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/info/realNameAuth",BASEURL];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:_realNameTF.text forKey:@"name"];
    [params setObject:_idCardNumTF.text forKey:@"id"];
   
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"%@",result);
         if ([result[@"result_code"]integerValue]==1) {
             [self alert:@"提交成功，等待审核"];
         }else{
              [self alert:@"提交失败"];
         }
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
           [self alert:@"请检查网络"];
     }];
    
}
@end
