//
//  ShoerRegistThree.m
//  BletcShop
//
//  Created by Bletc on 2017/6/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ShoerRegistThree.h"
#import "ShopTabBarController.h"
@interface ShoerRegistThree ()
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UITextField *surePassWordTF;

@end

@implementation ShoerRegistThree


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTextFieldLeftImageView:self.passWordTF leftImageName:@"锁"];
    [self setTextFieldLeftImageView:self.surePassWordTF leftImageName:@"锁"];

}
- (IBAction)goback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)completeRegistClick:(UIButton *)sender {
    if ([self.passWordTF.text length]<6||[self.passWordTF.text length]>16){
        [self showHint:@"请设置一个6-16位的密码"];
    }else if (!self.surePassWordTF.text){
        [self showHint:@"请确认密码"];
    }else if (![self.passWordTF.text isEqualToString:self.surePassWordTF.text]){
        [self showHint:@"密码不一致"];
    }else{
        
        [_passWordTF resignFirstResponder];
        [_surePassWordTF resignFirstResponder];
        [self postRequest];
        
    }
}
-(void)postRequest{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/register/register",BASEURL ];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phone forKey:@"phone"];
    [params setObject:self.passWordTF.text forKey:@"passwd"];
    
    [params setObject:self.referralPhone.length ?  self.referralPhone:@"无人推荐" forKey:@"referrer"];
    
    __block typeof(self) tempSelf = self;
    
    DebugLog(@"url==%@\n params=%@",url,params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        NSDictionary *result_dic = (NSDictionary*)result;
        if ([result_dic[@"result_code"] intValue]==1) {
            
            
            NSUserDefaults *use_name = [NSUserDefaults standardUserDefaults];
            [use_name setObject:tempSelf.phone forKey:@"sellerID"];
            [use_name setObject:tempSelf.passWordTF.text forKey:@"sellerToken"];
            [use_name synchronize];
            [self performSelector:@selector(goLognLand) withObject:nil afterDelay:1.f];
        }else if ([result_dic[@"result_code"] isEqualToString:@"phone_duplicate"]){
            
            [self showHint:@"手机号已注册"];
            
           
            
            
        }else if ([result_dic[@"result_code"] isEqualToString:@"referrer_not_exist"]){
            
            [self showHint:@"推荐人不存在"];

            
            
        }else{
            
            [self showHint:result_dic[@"result_code"]];
            
           
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error.description==%@", error.description);
    }];
    
}





-(void)goLognLand{
    //用户端若是登录状态,则退出后再登录商户端
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [app loginOutBletcShop];
    
    
    [self showHudInView:self.view hint:@"您已注册成功,正在登陆..."];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/login/login",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phone forKey:@"phone"];
    [params setObject:self.passWordTF.text forKey:@"passwd"];
        [params setObject:@"register" forKey:@"login_type"];
    
    
    DebugLog(@"params===%@==url=%@",params,url);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         
         NSDictionary *result_dic = (NSDictionary*)result;
         
         NSDictionary *userInfo = result_dic[@"info"];
         
         
         NSLog(@"商户登录请求result==%@", result);
         
         if ([result_dic[@"result_code"] isEqualToString:@"access"]){
             
             //登录环信
             
             [[EMClient sharedClient]loginWithUsername:userInfo[@"muid"] password:@"000000" completion:^(NSString *aUsername, EMError *aError) {
                 if (!aError) {
                     NSLog(@"商户登录成功");
                     dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                         
                         
                         
                         app.shopIsLogin = YES;
                         app.shopInfoDic =(NSMutableDictionary*)userInfo;
                         [app repeatLoadAPI];
                         
                         NSUserDefaults *use_name = [NSUserDefaults standardUserDefaults];
                         
                        [use_name setObject:@"no" forKey:@"remeberShop"];
                             [[EMClient sharedClient].options setIsAutoLogin:NO];
                             
                         
                         //本地保存商户信息
                         [use_name setObject:userInfo forKey:userInfo[@"muid"]];
                         //信息是否完善
                         [use_name setObject:result_dic[@"result_code"] forKey:@"wangyongle"];
                         [use_name synchronize];
                         
                         [self landingSuc];
                     });
                     
                 }else{
                     NSLog(@"商户登录失败==%@",aError.errorDescription);
                     
                     [self showHint:aError.errorDescription];
                     
                    
                 }
             }];
             
             
             
         }
         else if ([result_dic[@"result_code"] isEqualToString:@"fail"])
         {
             
             [self showHint:[NSString stringWithFormat:@"%@",result_dic[@"tip"]]];
             
         }else
         {
             
             [self showHint:@"登录失败,请重新尝试"];
         }
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self showHint:@"网络不好!"];

     }];
    
}


//登录成功提示
- (void)landingSuc
{
    
    [self hideHud];
    
    
    ShopTabBarController *shopvc = [[ShopTabBarController alloc]init];
    
    [self presentViewController:shopvc animated:YES completion:nil];
    
    
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
