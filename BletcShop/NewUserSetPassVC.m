//
//  NewUserSetPassVC.m
//  BletcShop
//
//  Created by apple on 2017/6/9.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NewUserSetPassVC.h"

@interface NewUserSetPassVC ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *firstPass;
@property (strong, nonatomic) IBOutlet UITextField *confirmPass;

@end

@implementation NewUserSetPassVC
- (IBAction)registBtnClick:(id)sender {
    [self.view endEditing:YES];
    if (_firstPass.text.length==0||_confirmPass.text.length==0) {
        [self alert:@"密码长度不能小于6位"];
    }else{
        if ([_firstPass.text isEqual:_confirmPass.text]) {
            [self registclick];
        }else{
            [self alert:@"两次密码不一致，请检查"];
        }
    }
}
- (void)alert:(NSString *)msg {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)registclick
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/register",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:self.phoneNum forKey:@"phone"];
    [params setObject:_firstPass.text forKey:@"passwd"];
    [params setObject:@"无人推荐" forKey:@"referrer"];//_recommend_person.text

    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result ==%@", result);
        if ([result[@"result_code"] intValue]==1) {
            NSLog(@"成功");
            //登录进去
            [self postRequest];
        }else if ([result[@"result_code"] isEqualToString:@"phone_duplicate"]){
            [self showHint:@"该手机号已被注册"];
        }else if([result[@"result_code"] isEqualToString:@"referrer_not_exist"]){
            
            [self showHint:@"推荐人不存在"];
            
        }else{
            [self showHint:@"请重新注册"];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        
    }];
    
}
- (void)showHint:(NSString *)hint
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 10.f;
    hud.yOffset = 180;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}
-(void)postRequest
{
    //商户端若是登录状态,则退出后再登录商户端
    
    DebugLog(@"是否登录环信===%d",[EMClient sharedClient].isLoggedIn);
    
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [app loginOutBletcShop];

    [self showHudInView:self.view hint:@"注册成功,正在登陆..."];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/login",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneNum forKey:@"phone"];
    [params setObject:_firstPass.text forKey:@"passwd"];
    NSLog(@"params-----%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result  ==%@", result);
        
        NSArray *arr = result[@"info"];
        
        NSDictionary *user_dic = arr[0];
        
        if ([[result objectForKey:@"result_code"]  isEqualToString: @"login_access"]) {
            NSLog(@"成功");
            
            //登录环信
            
            [[EMClient sharedClient]loginWithUsername:user_dic[@"uuid"] password:@"000000" completion:^(NSString *aUsername, EMError *aError) {
                if (!aError) {
                    NSLog(@"登录成功");
                    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [self hideHud];
                        
                        //[self saveInfo:user_dic[@"uuid"]];
                        [self showHint:@"登录成功"];
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
                        [defaults setObject:@"no" forKey:@"remeber"];
        
                        [[EMClient sharedClient].options setIsAutoLogin:YES];
                        [defaults setObject:user_dic[@"phone"] forKey:@"userID"];
                        
                        [defaults setValue:user_dic[@"passwd"] forKey:@"userpwd"];
                        [defaults synchronize];
                        
                        
                        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                        appdelegate.userInfoDic = [NSMutableDictionary dictionaryWithDictionary:user_dic];
                        appdelegate.IsLogin = YES;
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    });
                    
                }else{
                    NSLog(@"登录失败==%@",aError.errorDescription);
                    [self hideHud];
                    [self showHint:aError.errorDescription];
                    
                }
                
            }];
            
        }else if ([[result objectForKey:@"result_code"] isEqualToString:@"passwd_wrong"])
        {
            [self hideHud];
            
            [self showHint:@"用户名或密码错误"];
            
        }else if ([[result objectForKey:@"result_code"] isEqualToString:@"incomplete"]){
            [self hideHud];
            
//            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您已注册成功，是否完善信息？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
//            [alertView show];
            
            
        }else{
            [self hideHud];
            [self showHint:@"用户不存在"];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHud];
        
        [self showHint:@"请检查网络连接"];
        NSLog(@"%@", error);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"设置密码";
    [self setTextFieldLeftImageView:_firstPass leftImageName:@"锁心"];
    [self setTextFieldLeftImageView:_confirmPass leftImageName:@"锁心"];
    _firstPass.returnKeyType=UIReturnKeyDone;
    _confirmPass.returnKeyType=UIReturnKeyDone;
    _firstPass.delegate=self;
    _confirmPass.delegate=self;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
