//
//  LandingController.m
//  BletcShop
//
//  Created by Yuan on 16/2/23.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LandingController.h"
#import "RegisterController.h"
#import "MBProgressHUD.h"
#import "CIA_SDK/CIA_SDK.h"
#import "SuccessController.h"
#import "ChangePasswordViewController.h"
#import "LoginQuestionViewController.h"

#import <UMSocialCore/UMSocialCore.h>

#import "thirdlogVC.h"
#import "NewUserRegistVC.h"
@interface LandingController ()
@property(nonatomic,weak)UITextField *userText;
@property(nonatomic,weak)UITextField *passText;
@property(nonatomic,weak)UIButton *stateBtn;
@property(nonatomic,strong)NSArray *array_code;
@property(nonatomic,strong)NSArray *array_test;//测试号码
@end

@implementation LandingController
{
    UITextField *UserText;
}

-(NSArray *)array_code{
    if (!_array_code) {
        _array_code = [[NSArray alloc]init];
    }
    return _array_code;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.socketPort = 30001;
    self.socketHost = SOCKETHOST;//@"http://192.168.0.117";
    self.navigationItem.title = @"用户登录";
    self.view.backgroundColor = [UIColor whiteColor];
    //    self.ifCIASuccess=NO;
    self.ifRemeber = YES;
    self.view.userInteractionEnabled = YES;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREENWIDTH-75, 0, 60, 40);
    [button setTitle:@"注册" forState:0];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [button addTarget:self action:@selector(CreatAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    _array_test=app.superAccoutArray;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    [self _initUI];
}
-(void)_initUI
{
    
    UIView *landView = [[UIView alloc]initWithFrame:CGRectMake(0, 95, SCREENHEIGHT, 150)];
    [self.view addSubview:landView];
    
    if (SCREENHEIGHT<667) {
        landView.frame = CGRectMake(0, 95-30, SCREENHEIGHT, 150);
    }
    
    UserText = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
    UserText.placeholder = @"手机号";
    
    UserText.keyboardType = UIKeyboardTypeNumberPad;
    UserText.font = [UIFont systemFontOfSize:15];
    UserText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userText = UserText;
    [landView addSubview:UserText];
    
    [self setTextFieldLeftImageView:self.userText leftImageName:@"手机"];
    
//    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    phoneBtn.frame = CGRectMake(SCREENWIDTH-100, 10, 100, 30);
//    [phoneBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [phoneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    [phoneBtn setBackgroundColor:NavBackGroundColor];
//    phoneBtn.layer.cornerRadius = 10;
//    self.getCodeBtn = phoneBtn;
//    [phoneBtn addTarget:self action:@selector(getProCode) forControlEvents:UIControlEventTouchUpInside];
//    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [landView addSubview:phoneBtn];
    
//    UITextField *proText = [[UITextField alloc]initWithFrame:CGRectMake(10, UserText.bottom, SCREENWIDTH-10, 50)];
//    proText.delegate = self;
//    proText.keyboardType = UIKeyboardTypeNumberPad;
//    proText.font = [UIFont systemFontOfSize:15];
//    proText.placeholder = @"请输入您的验证码";
//    proText.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.proText = proText;
//    [landView addSubview:proText];
//    
    //    UIButton *proBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    proBtn.frame = CGRectMake(SCREENWIDTH-100, UserText.bottom+10, 70, 30);;
    //    self.valBtn = proBtn;
    //    [proBtn setTitle:@"点击验证" forState:UIControlStateNormal];
    //    [proBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [proBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //    [proBtn setBackgroundColor:NavBackGroundColor];
    //    proBtn.layer.cornerRadius = 10;
    //    [proBtn addTarget:self action:@selector(validationCode) forControlEvents:UIControlEventTouchUpInside];
    //    proBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    //
    //    [landView addSubview:proBtn];
    
    UITextField *passText = [[UITextField alloc]initWithFrame:CGRectMake(10, UserText.bottom, SCREENWIDTH-20, 50)];
    passText.secureTextEntry = YES;
    passText.font = [UIFont systemFontOfSize:15];
    passText.placeholder = @"密码";
    passText.delegate = self;
    passText.clearButtonMode = UITextFieldViewModeWhileEditing;
    passText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    self.passText = passText;
    [landView addSubview:passText];
    
     [self setTextFieldLeftImageView:passText leftImageName:@"锁"];

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, landView.width, 0.3)];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.3;
    [landView addSubview:line];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, UserText.bottom, landView.width, 0.3)];
    line1.backgroundColor = [UIColor grayColor];
    line1.alpha = 0.3;
    [landView addSubview:line1];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, passText.bottom, landView.width, 0.3)];
    line2.backgroundColor = [UIColor grayColor];
    line2.alpha = 0.3;
    [landView addSubview:line2];
//    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, proText.bottom, landView.width, 0.3)];
//    line3.backgroundColor = [UIColor grayColor];
//    line3.alpha = 0.3;
//    [landView addSubview:line3];
    UIButton *LandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    LandBtn.frame = CGRectMake(30, landView.bottom+10, SCREENWIDTH-60, 40);
    [LandBtn setTitle:@"登录" forState:UIControlStateNormal];
    [LandBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [LandBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [LandBtn setBackgroundColor:NavBackGroundColor];
    LandBtn.layer.cornerRadius = 10;
    [LandBtn addTarget:self action:@selector(LandingAction:) forControlEvents:UIControlEventTouchUpInside];
    LandBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:LandBtn];
    //是否记住用户名密码
    UIButton *ChoseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ChoseBtn.frame = CGRectMake(30, LandBtn.bottom+15, 15, 15);
    ChoseBtn.selected=YES;
    [ChoseBtn setImage:[UIImage imageNamed:@"xuan"] forState:UIControlStateNormal];
    [ChoseBtn setImage:[UIImage imageNamed:@"xuan1"] forState:UIControlStateSelected];
    [ChoseBtn addTarget:self action:@selector(ChoseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.stateBtn=ChoseBtn;
    [self.view addSubview:ChoseBtn];
    
    UILabel *agreeLabe = [[UILabel alloc]initWithFrame:CGRectMake(ChoseBtn.right+1, LandBtn.bottom+15, 100, 15)];
    //    agreeLabe.backgroundColor  = [UIColor redColor];
    agreeLabe.text = @"记住密码";
    agreeLabe.textColor = [UIColor grayColor];
    agreeLabe.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:agreeLabe];
    
    UIView *clickView=[[UIView alloc]initWithFrame:CGRectMake(20, LandBtn.bottom+5, 116, 35)];
    clickView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:clickView];
    
    UITapGestureRecognizer *recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick)];
    [clickView addGestureRecognizer:recognizer];
    
    UIButton *forgetBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame=CGRectMake(SCREENWIDTH-130, LandBtn.bottom+15, 100, 15);
    [forgetBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font=[UIFont systemFontOfSize:11.0f];
    [self.view addSubview:forgetBtn];
    [forgetBtn addTarget:self action:@selector(changePassword) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *degistView=[[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-180)/2, LandBtn.bottom+50, 180, 30)];
    [self.view addSubview:degistView];
    
    
    //    UILabel *degistLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 100, 20)];
    //    degistLabel.text=@"还没有账号?";
    //    degistLabel.textAlignment=1;
    //    degistLabel.textColor=[UIColor grayColor];
    //    degistLabel.font=[UIFont systemFontOfSize:13.0f];
    //    [degistView addSubview:degistLabel];
    //
    //    UIButton *CreatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    CreatBtn.frame = CGRectMake(100, 0, 80, 30);
    //    [CreatBtn setTitle:@"现在注册" forState:UIControlStateNormal];
    //    [CreatBtn setTitleColor:NavBackGroundColor forState:UIControlStateNormal];
    //    CreatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    //    CreatBtn.layer.borderWidth=1.0;
    //    CreatBtn.layer.borderColor=[NavBackGroundColor CGColor];
    //    //CreatBtn.layer.cornerRadius = 10;
    //    [CreatBtn addTarget:self action:@selector(CreatAction) forControlEvents:UIControlEventTouchUpInside];
    //    [degistView addSubview:CreatBtn];
    
    
    UIView *otherLoginView = [[UIView alloc]initWithFrame:CGRectMake(0, degistView.top, SCREENWIDTH, 100)];
    
    [self.view addSubview:otherLoginView];
    
    
    
    UIView*hengxian=[[UIView alloc]initWithFrame:CGRectMake(12, 10-0.5, SCREENWIDTH-24, 1)];
    hengxian.backgroundColor=RGB(234, 234, 234);
    [otherLoginView addSubview:hengxian];
    
    UILabel *labb = [[UILabel alloc]initWithFrame:CGRectMake((SCREENWIDTH-110)/2, 0, 110, 20)];
    labb.text = @"其他方式登录";
    labb.backgroundColor = [UIColor whiteColor];
    labb.textColor = [UIColor darkGrayColor];
    labb.font =[UIFont systemFontOfSize:15];
    labb.textAlignment = NSTextAlignmentCenter;
    [otherLoginView addSubview:labb];
    
    
    for (int i =0; i < 3; i ++) {
        UIButton *buttonlog = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH/4*i +SCREENWIDTH/8, labb.bottom+21, SCREENWIDTH/4, 49)];
        buttonlog.tag = 1000+i;
        
        [buttonlog addTarget:self action:@selector(logOtherway:) forControlEvents:UIControlEventTouchUpInside];
        
        [otherLoginView addSubview:buttonlog];
        
        UIImageView *imagev = [[UIImageView alloc]init];
        imagev.bounds = CGRectMake(0, 0, 44, 44);
        imagev.center = buttonlog.center;
        
        UILabel *thirdlab = [[UILabel alloc]init];
        thirdlab.bounds  = CGRectMake(0, 0, buttonlog.width, 20);
        thirdlab.center = CGPointMake(imagev.center.x, imagev.bottom +thirdlab.height/2+3);
        thirdlab.textColor = RGB(51, 51, 51);
        thirdlab.font = [UIFont systemFontOfSize:13];
        thirdlab.textAlignment  = NSTextAlignmentCenter;
        [otherLoginView addSubview:thirdlab];
        
        if (i==0) {
            imagev.image =[UIImage imageNamed:@"icon-qq"];
            thirdlab.text = @"QQ";
        }
        
        if (i==1) {
            imagev.image =[UIImage imageNamed:@"icon-weixin"];
            thirdlab.text = @"微信";
            
        }
        
        if (i==2) {
            imagev.image =[UIImage imageNamed:@"icon-weibo"];
            thirdlab.text = @"新浪";
            
        }
        
        [otherLoginView addSubview:imagev];
        
        [otherLoginView bringSubviewToFront:buttonlog];
        
    }
    
    
    UIButton *questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    questionBtn.frame = CGRectMake(0, SCREENHEIGHT-64-44, SCREENWIDTH, 30);
    [questionBtn setTitle:@"登录遇到问题" forState:0];
    questionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [questionBtn setTitleColor:RGB(51, 51, 51) forState:0];
    [questionBtn addTarget:self action:@selector(questionClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:questionBtn];
    
    
}

-(void)questionClick{
    LoginQuestionViewController *VC= [[LoginQuestionViewController alloc]init];
    VC.userType = @"u";
    [self.navigationController pushViewController:VC animated:YES];
    
    
    
}
-(void)logOtherway:(UIButton*)sender{
    
    NSLog(@"----%ld",sender.tag);
    
    UMSocialPlatformType platType ;
    NSString *type;
    
    
    switch (sender.tag-1000) {
        case 0:
            platType = UMSocialPlatformType_QQ;
            type = @"qq";
            
            break;
        case 1:
            platType = UMSocialPlatformType_WechatSession;
            type = @"wechat";
            
            break;
        case 2:
            platType = UMSocialPlatformType_Sina;
            type = @"sina";
            
            break;
            
        default:
            break;
    }
    
    [[UMSocialManager defaultManager]getUserInfoWithPlatform:platType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        NSLog(@"error--------%@",error);
        
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.gender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        
        if (resp.uid.length>0) {
            [self getIfBind:resp.uid andType:type];
            
        }
        
        
        
    }];
    
    
}
-(void)ChoseAction:(UIButton *)btn
{
    btn.selected =! btn.selected;
    NSLog(@"勾选");
    if (btn.selected == YES) {
        self.ifRemeber = YES;
    }else if(btn.selected == NO)
    {
        self.ifRemeber = NO;
    }
    
}
-(void)LandingAction:(UIButton *)btn
{
    
    
    
#ifdef DEBUG
    
    if ([self.userText.text  isEqualToString: @""]||[self.passText.text isEqualToString:@""]) {
        [self textExample];
    }else{
        [self postRequest];
        
    }
    
    NSLog(@"==DEBUG==");
#else
    
    if ([pgy_OR_AppStore isEqualToString:@"1"]) {
        
        if ([self.userText.text  isEqualToString: @""]||[self.passText.text isEqualToString:@""]) {
            [self textExample];
        }else{
            [self postRequest];
            
        }
    }else{
        
        
        if ([self.userText.text  isEqualToString: @""]||[self.passText.text isEqualToString:@""]) {
            [self textExample];
        }else if([self checkPhoneNumIfExistsInTestList]){
            [self postRequest];
//        }else if ([self.proText.text  isEqualToString: @""]) {
//            
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            
//            hud.mode = MBProgressHUDModeText;
//            hud.label.text = NSLocalizedString(@"请输入验证码", @"HUD message title");
//            hud.label.font = [UIFont systemFontOfSize:13];
//            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
//            hud.userInteractionEnabled = YES;
//            
//            [hud hideAnimated:YES afterDelay:2.f];
//            
        }
        
        else if ([self.userText.text  isEqual: @"111"]&&[self.passText.text isEqual:@"111"]) {
            [self postRequest];
        }else{
            [self postRequest];
 
        }
//        else if (![self.proText.text  isEqualToString: @""])
//        {
//            
//            [self validationCode];
//            
//            
//        }
        
    }
    
    
    
    
#endif
    
}
-(BOOL)checkPhoneNumIfExistsInTestList{
    for (int i=0; i<_array_test.count; i++) {
        NSDictionary *dic=_array_test[i];
        if ([self.userText.text isEqualToString:dic[@"phone"]]) {
            return YES;
        }
    }
    return NO;
}
//手机号登录
-(void)PhoneAction
{
    
}
//注册
-(void)CreatAction
{
    NSLog(@"注册");
    NewUserRegistVC *regisVc = [[NewUserRegistVC alloc]init];
    [self.navigationController pushViewController:regisVc animated:YES];
}
//登录请求
-(void)postRequest
{
    //商户端若是登录状态,则退出后再登录商户端
    
    DebugLog(@"是否登录环信===%d",[EMClient sharedClient].isLoggedIn);
    
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [app loginOutBletcShop];
    
    
    
    [self showHudInView:self.view hint:@"正在登陆..."];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/login",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.userText.text forKey:@"phone"];
    [params setObject:self.passText.text forKey:@"passwd"];
    
    
    
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
                        
                        [self saveInfo:user_dic[@"uuid"]];
                        [self landingSuc];
                        
                        
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        
                        if (self.ifRemeber) {
                            [defaults setObject:@"yes" forKey:@"remeber"];
                            
                            [[EMClient sharedClient].options setIsAutoLogin:YES];
                            
                        }else
                        {
                            [defaults setObject:@"no" forKey:@"remeber"];
                            
                            [[EMClient sharedClient].options setIsAutoLogin:NO];
                            
                        }
                        
                        [defaults setObject:user_dic[@"phone"] forKey:@"userID"];
                        
                        [defaults setValue:user_dic[@"passwd"] forKey:@"userpwd"];
                        [defaults synchronize];
                        
                        
                        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                        appdelegate.userInfoDic = [NSMutableDictionary dictionaryWithDictionary:user_dic];
                        
                        
                        appdelegate.IsLogin = YES;
                        //                        [appdelegate socketConnectHost];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadAPI)]) {
                            [self.delegate reloadAPI];
                            
                        }
                        
                    });
                    
                }else{
                    NSLog(@"登录失败==%@",aError.errorDescription);
                    [self hideHud];
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = NSLocalizedString(aError.errorDescription, @"HUD message title");
                    hud.label.font = [UIFont systemFontOfSize:13];
                    [hud hideAnimated:YES afterDelay:3.f];
                    
                    
                }
                
            }];
            
        }else if ([[result objectForKey:@"result_code"] isEqualToString:@"passwd_wrong"])
        {
            [self hideHud];
            
            [self passwd_wrong];
            
        }else{
            [self hideHud];
            
            [self use_notfound];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHud];
        
        [self noIntenet];
        NSLog(@"%@", error);
    }];
    
}


//完善信息界面

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        SuccessController *wholeInfo=[[SuccessController alloc]init];
        wholeInfo.phoneNum=self.userText.text;
        wholeInfo.passWord=self.passText.text;
        
        [self.navigationController pushViewController:wholeInfo animated:YES];
        
        
    }
}


//判断是否textField输入数字
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string]; //定义一个NSScanner，扫描string
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//用户名或密码空提示
- (void)textExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"用户名或密码不能为空", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    //    [hud setColor:[UIColor blackColor]];
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    hud.userInteractionEnabled = YES;
    
    [hud hideAnimated:YES afterDelay:2.f];
}
//登录成功提示
- (void)landingSuc
{
    
  
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"登录成功", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:2.f];
    [self.navigationController popViewControllerAnimated:YES];
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
    [hud hideAnimated:YES afterDelay:4.f];
    
}
//用户不存在
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
    [hud hideAnimated:YES afterDelay:4.f];
    
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
//点击空白收起键盘X
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    
    [self.view endEditing:YES];
    
    
}
-(void)TimeNumAction
{
    if ([self.userText.text isEqual: @""])
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

-(void)getProCode
{
    if (UserText.text.length==11) {
        NSLog(@"%@",_proText.text);
        [self TimeNumAction];
        //[self showIndicatorView];
        
        NSString *url  = @"http://101.201.100.191/smsVertify/Demo/SendTemplateSMS.php";
        
        NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithObject:UserText.text forKey:@"phone"];;
        [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            NSLog(@"-result---%@",result);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _array_code = result;
                
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
    NSLog(@"=%@==%@",_array_code,_proText.text);
    
    if (_array_code[0] == _proText.text) {
        
        //        self.ifCIASuccess = YES;
        [self postRequest];
        
        //        [self.valBtn setTitle:@"验证成功" forState:UIControlStateNormal];
        //        [self.valBtn setBackgroundColor:tableViewBackgroundColor];
        //        self.valBtn.userInteractionEnabled = NO;
        return;
    }else     {
        [self alert:@"验证码输入错误"];
    }
    
    
}
- (void)alert:(NSString *)msg {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    if (textField==self.proText&&self.proText.text.length==6) {
//        [self validationCode];
//    }
//    return YES;
//}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewClick{
    self.stateBtn.selected =! self.stateBtn.selected;
    NSLog(@"勾选");
    if (self.stateBtn.selected == YES) {
        self.ifRemeber = YES;
    }else if(self.stateBtn.selected == NO)
    {
        self.ifRemeber = NO;
    }
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
-(void)changePassword{
    ChangePasswordViewController *changeVC=[[ChangePasswordViewController alloc]init];
    changeVC.type=@"u";
    [self presentViewController:changeVC animated:YES completion:nil];
}


/**
 查询是否绑定UID
 
 @param uid <#uid description#>
 @param type <#type description#>
 */
-(void)getIfBind:(NSString *)uid andType:(NSString *)type{
    
    NSString *url = [NSString stringWithFormat:@"%@UserType/bind/get",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:uid forKey:@"uid"];
    
    [paramer setValue:type forKey:@"type"];
    
    NSLog(@"paramer====%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"resutl ======%@",result);
        
        if ([result[@"result_code"] isEqualToString:@"binded"]) {
            //绑定账号直接登录
            NSString *phone = [NSString getTheNoNullStr:result[@"phone"] andRepalceStr:@"null"];
            NSString *passwd = [NSString getTheNoNullStr:result[@"passwd"] andRepalceStr:@"null"];
            
            
            
            [self showHudInView:self.view hint:@"正在登陆..."];
            
            
            
            [self postRequestLogin:phone andPassWord:passwd];
        }
        
        if ([result[@"result_code"] isEqualToString:@"no_bind"]) {
            //没有绑定就去绑定账号;
            
            
            thirdlogVC *VC = [[thirdlogVC alloc]init];
            
            VC.uid = uid;
            VC.Auth_type = type;
            
            [self.navigationController pushViewController:VC animated:YES];
            
            
            
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"====%@",error);
    } ];
    
}


/**
 用户登录
 
 @param user     账户
 @param passWord 密码
 */
-(void)postRequestLogin:(NSString *)user andPassWord:(NSString*)passWord
{
    
    DebugLog(@"是否登录环信===%d",[EMClient sharedClient].isLoggedIn);
    
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [app loginOutBletcShop];
    
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/login",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:user forKey:@"phone"];
    [params setObject:passWord forKey:@"passwd"];
    NSLog(@"postRequestLogin user = %@-%@",user,passWord);
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         
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
                         
                         [self saveInfo:user_dic[@"uuid"]];
                         [self landingSuc];
                         
                         
                         
                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         
                         if (self.ifRemeber) {
                             [defaults setObject:@"yes" forKey:@"remeber"];
                             
                             [[EMClient sharedClient].options setIsAutoLogin:YES];
                             
                         }else
                         {
                             [defaults setObject:@"no" forKey:@"remeber"];
                             
                             [[EMClient sharedClient].options setIsAutoLogin:NO];
                             
                         }
                         
                         [defaults setObject:user_dic[@"phone"] forKey:@"userID"];
                         
                         [defaults setValue:user_dic[@"passwd"] forKey:@"userpwd"];
                         [defaults synchronize];
                         
                         
                         AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                         appdelegate.userInfoDic = [NSMutableDictionary dictionaryWithDictionary:user_dic];
                         appdelegate.IsLogin = YES;
                         //                        [appdelegate socketConnectHost];
                         
                         
                       
                         
                     });
                     
                 }else{
                     NSLog(@"登录失败==%@",aError.errorDescription);
                     [self hideHud];
                     
                     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                     hud.mode = MBProgressHUDModeText;
                     hud.label.text = NSLocalizedString(aError.errorDescription, @"HUD message title");
                     hud.label.font = [UIFont systemFontOfSize:13];
                     [hud hideAnimated:YES afterDelay:3.f];
                     
                     
                 }
                 
             }];
             
             
             
             
             
             
         }else if ([[result objectForKey:@"result_code"] isEqualToString:@"passwd_wrong"])
         {
             [self hideHud];
             
             [self passwd_wrong];
             
         }else if ([[result objectForKey:@"result_code"] isEqualToString:@"incomplete"]){
             [self hideHud];
             
             UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您已注册成功，是否完善信息？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
             [alertView show];
             
             
         }else{
             [self hideHud];
             
             [self use_notfound];
         }
         
     }failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         
         NSLog(@"%@", error);
     }];
    
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
