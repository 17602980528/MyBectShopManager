//
//  ShopRegisterController.m
//  BletcShop
//
//  Created by Yuan on 16/3/15.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShopRegisterController.h"
#import "CIA_SDK/CIA_SDK.h"
#import "NextRegistViewController.h"
#import "NewNextViewController.h"
#import "ShopTabBarController.h"

@interface ShopRegisterController ()
@property(nonatomic,assign)NSInteger state;
@property BOOL ifRemeber;

@end

@implementation ShopRegisterController


-(NSArray *)data_code{
    if (!_data_code) {
        _data_code = [NSArray array];
    }
    return _data_code;
}
-(void)backRegist
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.ifCIASuccess = NO;
    self.navigationItem.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    [self initRegistView];
    
}
-(void)initRegistView
{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    navView.backgroundColor = NavBackGroundColor;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 18, 70, 44)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backRegist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
    [navView addSubview:btn];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 18, SCREENWIDTH, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:19.0f];
    label.text=@"商户注册";
    label.textAlignment=1;
    label.textColor=[UIColor whiteColor];
    [navView addSubview:label];
    UIView *landView = [[UIView alloc]initWithFrame:CGRectMake(0, (SCREENHEIGHT-300)/2-30, SCREENWIDTH, 250)];
    [self.view addSubview:landView];
    
    self.phoneText = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-100, 50)];
    self.phoneText.placeholder = @"请输入您的手机号";
    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneText.font = [UIFont systemFontOfSize:15];
    self.phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [landView addSubview:self.phoneText];
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneBtn.frame = CGRectMake(SCREENWIDTH-100, 10, 100, 30);
    [phoneBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [phoneBtn setBackgroundColor:NavBackGroundColor];
    phoneBtn.layer.cornerRadius = 10;
    self.getCodeBtn = phoneBtn;
    [phoneBtn addTarget:self action:@selector(getProCode) forControlEvents:UIControlEventTouchUpInside];
    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [landView addSubview:phoneBtn];
    
    UITextField *proText = [[UITextField alloc]initWithFrame:CGRectMake(10, self.phoneText.bottom, SCREENWIDTH-30, 50)];
    proText.delegate = self;
    proText.keyboardType = UIKeyboardTypeNumberPad;
    proText.font = [UIFont systemFontOfSize:15];
    proText.placeholder = @"请输入您的验证码";
    proText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.proText = proText;
    [landView addSubview:proText];
    
    UITextField *passwordText = [[UITextField alloc]initWithFrame:CGRectMake(10, proText.bottom, SCREENWIDTH-30, 50)];
    passwordText.secureTextEntry = YES;
    passwordText.font = [UIFont systemFontOfSize:15];
    passwordText.placeholder = @"请输入您的密码(6位以上数字字母组合)";
    passwordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordText.returnKeyType=UIReturnKeyDone;
    passwordText.delegate=self;
    self.passwordText = passwordText;
    [landView addSubview:passwordText];
    
    UITextField *passwordText2 = [[UITextField alloc]initWithFrame:CGRectMake(10, passwordText.bottom, SCREENWIDTH-30, 50)];
    passwordText2.secureTextEntry = YES;
    passwordText2.font = [UIFont systemFontOfSize:15];
    passwordText2.placeholder = @"请重复密码(6位以上数字字母组合)";
    passwordText2.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordText2.returnKeyType=UIReturnKeyDone;
    passwordText2.delegate=self;
    self.passwordText2 = passwordText2;
    [landView addSubview:passwordText2];
    
//    UITextField *showQuanTF=[[UITextField alloc]initWithFrame:CGRectMake(10, passwordText2.bottom, SCREENWIDTH-30, 50)];
//    showQuanTF.placeholder=@"有无推荐人";
//    showQuanTF.delegate=self;
//    showQuanTF.keyboardType=UIKeyboardTypeNumberPad;
//    showQuanTF.font=[UIFont systemFontOfSize:15.0f];
//    [landView addSubview:showQuanTF];
//    self.showQuanTextfield=showQuanTF;
    //
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, landView.width, 0.3)];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.3;
    [landView addSubview:line];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, self.phoneText.bottom, landView.width, 0.3)];
    line1.backgroundColor = [UIColor grayColor];
    line1.alpha = 0.3;
    [landView addSubview:line1];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, proText.bottom, landView.width, 0.3)];
    line2.backgroundColor = [UIColor grayColor];
    line2.alpha = 0.3;
    [landView addSubview:line2];
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, passwordText.bottom, landView.width, 0.3)];
    line3.backgroundColor = [UIColor grayColor];
    line3.alpha = 0.3;
    [landView addSubview:line3];
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, passwordText2.bottom, landView.width, 0.3)];
    line4.backgroundColor = [UIColor grayColor];
    line4.alpha = 0.3;
    [landView addSubview:line4];
    //+++++++++
//    UIView *line5=[[UIView alloc]initWithFrame:CGRectMake(0, showQuanTF.bottom, landView.width, 0.3)];
//    line5.backgroundColor=[UIColor grayColor];
//    line5.alpha=0.3;
//    [landView addSubview:line5];
    //
    
    UIButton *LandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    LandBtn.frame = CGRectMake(80, landView.bottom+10, SCREENWIDTH-160, 35);
    [LandBtn setTitle:@"注册" forState:UIControlStateNormal];
    [LandBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [LandBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [LandBtn setBackgroundColor:NavBackGroundColor];
    LandBtn.layer.cornerRadius = 10;
    [LandBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    LandBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:LandBtn];
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField==self.proText&&self.proText.text.length==4) {
        //        [self validationCode];
    }
    return YES;
}


-(void)nextAction
{
         
        
        if ([self.phoneText.text isEqualToString:@""]||[self.passwordText.text isEqualToString:@""]||[self.passwordText2.text isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"请检查信息是否填写完整", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:3.f];
            
            ;
        }else if (_data_code[0] != _proText.text)
        {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"验证码错误", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:3.f];
            
            
        } else if ([self.passwordText.text length]<6||[self.passwordText.text length]>16) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"请设置一个6-16位的密码", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
        else
        {
            if([self.passwordText.text isEqualToString:self.passwordText2.text])
            {
                
                [self postRequest];
                
                
                
            }
            else
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.frame = CGRectMake(0, 64, 375, 667);
                // Set the annular determinate mode to show task progress.
                hud.mode = MBProgressHUDModeText;
                
                hud.label.text = NSLocalizedString(@"密码不一致,请重新输入", @"HUD message title");
                hud.label.font = [UIFont systemFontOfSize:13];
                // Move to bottm center.
                //    hud.offset = CGPointMake(0.f, );
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                [hud hideAnimated:YES afterDelay:3.f];
            }
        }

    
    
    

}

-(void)postRequest{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/register/register",BASEURL ];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneText.text forKey:@"phone"];
    [params setObject:self.passwordText.text forKey:@"passwd"];
    [params setObject:@"无人推荐" forKey:@"referrer"];
    
    __block ShopRegisterController *tempSelf = self;
    
    DebugLog(@"url==%@\n params=%@",url,params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        NSDictionary *result_dic = (NSDictionary*)result;
        if ([result_dic[@"result_code"] intValue]==1) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"您已注册成功", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:1.f];
            
            NSUserDefaults *use_name = [NSUserDefaults standardUserDefaults];
            [use_name setObject:tempSelf.phoneText.text forKey:@"sellerID"];
            [use_name setObject:tempSelf.passwordText.text forKey:@"sellerToken"];
            [use_name synchronize];
            [self performSelector:@selector(gotoNextVC) withObject:nil afterDelay:1.f];
        }else if ([result_dic[@"result_code"] isEqualToString:@"phone_duplicate"]){
            
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"手机号已注册", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:1.f];
            
            
        }else if ([result_dic[@"result_code"] isEqualToString:@"referrer_not_exist"]){
            
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"推荐人不存在", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:1.f];
            
            
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(result_dic[@"result_code"], @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:1.f];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error.description==%@", error.description);
    }];
    
}

//菊花圈
-(void)showIndicatorView {
    activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activity.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
    activity.color = [UIColor grayColor];
    
    activity.hidesWhenStopped = YES;
    [activity startAnimating];
    [self.view setUserInteractionEnabled:NO]; //禁止操作
    
    [self.view addSubview:activity];
}
-(void)dismissIndicatorView{
    [activity stopAnimating];  //关闭动画
    [activity removeFromSuperview];
    [self.view setUserInteractionEnabled:YES];
}
- (void)showAlertDialog:(NSString *) title withMsg: (NSString *) msg {
    if([[UIDevice currentDevice].systemVersion floatValue]>=8.0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title  message:msg  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                 {
                                     // 回调在block里面
                                     // to do..
                                 }];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
        [alertView show];
    }
}
-(void)TimeNumAction
{
    if ([self.phoneText.text isEqual: @""])
    {
        //[self textExample];
        
    }else
    {
        //[self getProCode];
        __block int timeout = 59; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    self.getCodeBtn.userInteractionEnabled = YES;
                    [self.getCodeBtn setBackgroundColor:NavBackGroundColor];
                });
            }else{
                int seconds = timeout % 60 ;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //NSLog(@"____%@",strTime);
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                    self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [UIView commitAnimations];
                    self.getCodeBtn.userInteractionEnabled = NO;
                    [self.getCodeBtn setBackgroundColor:tableViewBackgroundColor];
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
}
-(void)getProCode
{
    if (self.phoneText.text.length==11) {
        [self TimeNumAction];
        
        NSString *url  = @"http://101.201.100.191/smsVertify/Demo/SendTemplateSMS.php";
        
        NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithObject:self.phoneText.text forKey:@"phone"];;
        [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            NSLog(@"-result---%@",result);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _data_code = result;
                
            });
            
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }];
        
    }else{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码格式有误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
    }
    
}
- (void)validationCode {
    // 校验验证码
    
    NSLog(@"=%@==%@",_data_code,_proText.text);
    
    if (_data_code[0] == _proText.text) {
        
        _ifCIASuccess = YES;
        
        
        return;
    }else     {
        [self alert:@"验证码输入错误"];
    }
    
}
- (void)alert:(NSString *)msg {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
//点击空白结束编辑 收起键盘
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    
    [self.view endEditing:YES];
    
    
}
-(void)gotoNextVC{
    [self goLognLand];
    self.state =0;
    //    NewNextViewController *nextRegisVc = [[NewNextViewController alloc]init];
    //
    //    nextRegisVc.phoneString = [[NSUserDefaults standardUserDefaults] objectForKey:@"sellerID"];//self.phoneText.text;
    //    nextRegisVc.pswString = [[NSUserDefaults standardUserDefaults] objectForKey:@"sellerToken"];//self.passwordText.text;
    //    [self presentViewController:nextRegisVc animated:YES completion:nil];
}



-(void)goLognLand{
    //用户端若是登录状态,则退出后再登录商户端
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [app loginOutBletcShop];
    
    
    [self showHudInView:self.view hint:@"正在登陆..."];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/login",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneText.text forKey:@"phone"];
    [params setObject:self.passwordText.text forKey:@"passwd"];
    if (self.state==0) {
        [params setObject:@"register" forKey:@"login_type"];
    }
    else if (self.state==1) {
        [params setObject:@"admin" forKey:@"login_type"];
    }
    
    DebugLog(@"params===%@==url=%@",params,url);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         
         NSDictionary *result_dic = (NSDictionary*)result;
         
         NSDictionary *userInfo = result_dic[@"info"];
         
         
         NSLog(@"商户登录请求result==%@", result);
         
         if ([result_dic[@"result_code"] isEqualToString:@"incomplete"]||[result_dic[@"result_code"] isEqualToString:@"user_auth_fail"]||[result_dic[@"result_code"] isEqualToString:@"user_not_auth"]||[result_dic[@"result_code"]  isEqualToString: @"login_access"]||[result_dic[@"result_code"]  isEqualToString: @"auditing"]||[result_dic[@"result_code"]  isEqualToString: @"complete_not_auth"]){
             
             //登录环信
             
             [[EMClient sharedClient]loginWithUsername:userInfo[@"muid"] password:@"000000" completion:^(NSString *aUsername, EMError *aError) {
                 if (!aError) {
                     NSLog(@"商户登录成功");
                     dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                         
                         //                        [self saveInfo:[NSString stringWithFormat:@"m_%@",self.userText.text]];
                         
                         
                         app.shopIsLogin = YES;
                         app.shopInfoDic =(NSMutableDictionary*)userInfo;
                         [app repeatLoadAPI];

                         NSUserDefaults *use_name = [NSUserDefaults standardUserDefaults];
                         
                         if (self.ifRemeber) {
                             [use_name setObject:@"yes" forKey:@"remeberShop"];
                             [[EMClient sharedClient].options setIsAutoLogin:YES];
                             
                         }else
                         {
                             [use_name setObject:@"no" forKey:@"remeberShop"];
                             [[EMClient sharedClient].options setIsAutoLogin:NO];
                             
                         }
                         
//                         [use_name setObject:[UserArr objectAtIndex:0] forKey:@"sellerID"];
 //                        [use_name setObject:[UserArr objectAtIndex:3] forKey:@"sellerToken"];
 //                        [use_name setObject:[UserArr objectAtIndex:30] forKey:@"sellerState"];
                         
                         
                         //本地保存商户信息
                         [use_name setObject:userInfo forKey:userInfo[@"muid"]];
                         //信息是否完善
                         [use_name setObject:result_dic[@"result_code"] forKey:@"wangyongle"];
                         [use_name synchronize];
//                         [app socketConnectHostShop];
                         
                         [self landingSuc];
                     });
                     
                 }else{
                     NSLog(@"商户登录失败==%@",aError.errorDescription);
                     
                     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                     hud.mode = MBProgressHUDModeText;
                     hud.label.text = NSLocalizedString(aError.errorDescription, @"HUD message title");
                     hud.label.font = [UIFont systemFontOfSize:13];
                     [hud hideAnimated:YES afterDelay:3.f];
                 }
             }];
             
             [self hideHud];
             
             
         }
         else if ([result_dic[@"result_code"] isEqualToString:@"passwd_wrong"])
         {
             [self hideHud];
             
             [self passwd_wrong];
         }else if ([result_dic[@"result_code"] isEqualToString:@"user_not_found"])
         {
             [self hideHud];
             
             [self use_notfound];
         }
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}

//保存用户信息到本地
-(void)saveInfo:(NSString*)auserName{
    NSString *url = [NSString stringWithFormat:@"%@Extra/IM/get",BASEURL];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
    [paramer setObject:auserName forKey:@"account"];
    NSLog(@"-saveInfo--%@",paramer);
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSArray *arr = (NSArray *)result;
        
        if (arr.count!=0) {
            Person *p = [Person modalWith:arr[0][@"nickname"] imgStr:arr[0][@"headimage"]  idstring:arr[0][@"account"]];
            
            [Database savePerdon:p];
        }
      
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}
//登录成功提示
- (void)landingSuc
{
    
    NSLog(@"self.userText.text length%ld",[self.phoneText.text length]);
    ShopTabBarController *shopvc = [[ShopTabBarController alloc]init];
//    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    appdelegate.shopPersonInfo = array;
    
    [self presentViewController:shopvc animated:YES completion:nil];
    
    
}
//密码错误
- (void)passwd_wrong
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"用户名或密码错误", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:3.f];
    
}
- (void)use_notfound
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"用户不存在", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:3.f];
    
}
//没有网络连接提示
- (void)noIntenet
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"请检查网络连接", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //        hud.offset = CGPointMake(0.f,MBProgressMaxOffset);
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:2.f];
    
}


//没有网络连接提示
//登录成功提示
- (void)landingSuc:(NSMutableArray*)array
{
    
    NSLog(@"self.userText.text length%ld",[self.phoneText.text length]);
    ShopTabBarController *shopvc = [[ShopTabBarController alloc]init];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appdelegate.shopPersonInfo = array;
    
    [self presentViewController:shopvc animated:YES completion:nil];
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];//取消第一响应者
    
    return YES;
}

@end
