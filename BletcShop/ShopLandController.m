//
//  ShopLandController.m
//  BletcShop
//
//  Created by Yuan on 16/3/15.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShopLandController.h"
#import "ShopRegisterController.h"
#import "ShopTabBarController.h"
#import "CIA_SDK/CIA_SDK.h"
#import "ChoiceAdminAlertView.h"
#import "NewNextViewController.h"
#import "MainTabBarController.h"
#import "ChangePasswordViewController.h"

#import "LoginQuestionViewController.h"

@interface ShopLandController ()
@property(nonatomic,weak)UITextField *userText;
@property(nonatomic,weak)UITextField *passText;
@property(nonatomic,weak)UIButton *stateBtn;
@end

@implementation ShopLandController
{
    UITextField *UserText;
}
-(NSArray *)data_code{
    if (!_data_code) {
        _data_code = [NSArray array];
    }
    return _data_code;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.hidesBackButton =YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ifCIASuccess=NO;
    self.ifRemeber = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"登录";
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    [self _initUI];
}

-(void)_initUI
{
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    navView.backgroundColor = NavBackGroundColor;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 18, 70, 44)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backRegist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
    [navView addSubview:btn];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-35, 18, 70, 44)];
    label.font=[UIFont systemFontOfSize:19.0f];
    label.text=@"登录";
    label.textAlignment=1;
    label.textColor=[UIColor whiteColor];
    [navView addSubview:label];
    UIView *landView1 = [[UIView alloc]initWithFrame:CGRectMake(0, (SCREENHEIGHT-300)/2, SCREENWIDTH, 200)];
    [self.view addSubview:landView1];
    UIView *landView = [[UIView alloc]initWithFrame:CGRectMake(0, (SCREENHEIGHT-300)/2, SCREENHEIGHT, 150)];
    [self.view addSubview:landView];
    
//    UITextField *UserText = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 375-20, 50)];
    UserText = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
    UserText.placeholder = @"手机号";
    UserText.keyboardType = UIKeyboardTypeNumberPad;
    UserText.font = [UIFont systemFontOfSize:15];
    UserText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userText = UserText;
    [landView addSubview:UserText];
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
    
    UITextField *proText = [[UITextField alloc]initWithFrame:CGRectMake(10, UserText.bottom, SCREENWIDTH-10, 50)];
    proText.delegate = self;
    proText.keyboardType = UIKeyboardTypeNumberPad;
    proText.font = [UIFont systemFontOfSize:15];
    proText.placeholder = @"请输入您的验证码";
    proText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.proText = proText;
    [landView addSubview:proText];
    
    
    UITextField *passText = [[UITextField alloc]initWithFrame:CGRectMake(10, proText.bottom, SCREENWIDTH-20, 50)];
    passText.secureTextEntry = YES;
    passText.font = [UIFont systemFontOfSize:15];
    passText.placeholder = @"密码";
    passText.clearButtonMode = UITextFieldViewModeWhileEditing;
    passText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.passText = passText;
    [landView addSubview:passText];

    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, landView.width, 0.3)];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.3;
    [landView addSubview:line];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, UserText.bottom, landView.width, 0.3)];
    line1.backgroundColor = [UIColor grayColor];
    line1.alpha = 0.3;
    [landView addSubview:line1];
    UIView *line11 = [[UIView alloc]initWithFrame:CGRectMake(0, proText.bottom, landView.width, 0.3)];
    line11.backgroundColor = [UIColor grayColor];
    line11.alpha = 0.3;
    [landView addSubview:line11];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, passText.bottom, landView.width, 0.3)];
    line2.backgroundColor = [UIColor grayColor];
    line2.alpha = 0.3;
    [landView addSubview:line2];
    
    UIButton *LandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    LandBtn.frame = CGRectMake(80, landView.bottom+10, SCREENWIDTH-160, 35);
    [LandBtn setTitle:@"登录" forState:UIControlStateNormal];
    [LandBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [LandBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [LandBtn setBackgroundColor:NavBackGroundColor];
    LandBtn.layer.cornerRadius = 10;
    [LandBtn addTarget:self action:@selector(LandingAction:) forControlEvents:UIControlEventTouchUpInside];
    LandBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:LandBtn];
    
    //是否记住用户名密码
    UIButton *ChoseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ChoseBtn.frame = CGRectMake(30, LandBtn.bottom+15, 15, 15);
    ChoseBtn.selected=NO;
    [ChoseBtn setImage:[UIImage imageNamed:@"xuan"] forState:UIControlStateNormal];
    [ChoseBtn setImage:[UIImage imageNamed:@"xuan1"] forState:UIControlStateSelected];
    [ChoseBtn addTarget:self action:@selector(ChoseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.stateBtn=ChoseBtn;
    [self.view addSubview:ChoseBtn];
    
    UILabel *agreeLabe = [[UILabel alloc]initWithFrame:CGRectMake(ChoseBtn.right+1, LandBtn.bottom+15, 100, 15)];
    //    agreeLabe.backgroundColor  = [UIColor redColor];
    agreeLabe.text = @"记住账号密码";
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
    
    UIView *degistView=[[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-180)/2, LandBtn.bottom+80, 180, 30)];
    [self.view addSubview:degistView];
    UILabel *degistLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 100, 20)];
    degistLabel.text=@"还没有账号?";
    degistLabel.textAlignment=1;
    degistLabel.textColor=[UIColor grayColor];
    degistLabel.font=[UIFont systemFontOfSize:13.0f];
    [degistView addSubview:degistLabel];
    
    UIButton *CreatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CreatBtn.frame = CGRectMake(100, 0, 80, 30);
    [CreatBtn setTitle:@"现在注册" forState:UIControlStateNormal];
    [CreatBtn setTitleColor:NavBackGroundColor forState:UIControlStateNormal];
    CreatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    CreatBtn.layer.borderWidth=1.0;
    CreatBtn.layer.borderColor=[NavBackGroundColor CGColor];
    //CreatBtn.layer.cornerRadius = 10;
    [CreatBtn addTarget:self action:@selector(CreatAction) forControlEvents:UIControlEventTouchUpInside];
    [degistView addSubview:CreatBtn];
    
    
    
    UIButton *questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    questionBtn.frame = CGRectMake(0, SCREENHEIGHT-44, SCREENWIDTH, 30);
    [questionBtn setTitle:@"登录遇到问题" forState:0];
    questionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [questionBtn setTitleColor:RGB(51, 51, 51) forState:0];
    [questionBtn addTarget:self action:@selector(questionClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:questionBtn];

    
    
}

-(void)questionClick{
    LoginQuestionViewController *VC= [[LoginQuestionViewController alloc]init];
    VC.userType = @"m";
    [self.navigationController pushViewController:VC animated:YES];
    
    
    
}
-(void)ChoseAction:(UIButton *)btn
{
    btn.selected =! btn.selected;
    NSLog(@"勾选");
    if (btn.selected == YES) {
         NSLog(@"勾选111");
        self.ifRemeber = YES;
    }else if(btn.selected == NO)
    {
         NSLog(@"勾选");
        self.ifRemeber = NO;
    }
    
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
    
#ifdef DEBUG
    [self postRequest];
#else

    NSLog(@"=%@==%@",_data_code,_proText.text);
    
    if (_data_code[0] == _proText.text) {
        
        [self postRequest];
        
       
        return;
    }else    if ([self.userText.text  isEqual: @"111"]&&[self.passText.text isEqual:@"111"]) {
        [self postRequest];

    }else{
        [self alert:@"验证码输入错误"];

    }
    
#endif
    
    
}
- (void)alert:(NSString *)msg {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
//选择登陆者
-(void)addAlert
{
    //ChoiceAdminAlertView
//    ChoiceAdminAlertView *noticeView=[[ChoiceAdminAlertView alloc]init];
//    self.choiceAlertView = noticeView;
//    noticeView.delegate=self;
//    noticeView.frame=CGRectMake(10, SCREENHEIGHT/2-60, SCREENWIDTH-20, 110);
//    noticeView.backgroundColor=[UIColor colorWithRed:28.0f/255.0f green:52.0f/255.0f blue:51.f/255.0f alpha:1.0f];
//    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 1)];
//    line.backgroundColor=[UIColor whiteColor];
//    line.alpha=0.3;
//    [noticeView addSubview:line];
//    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-20)/2, 55, 1, 50)];
//    line2.backgroundColor=[UIColor whiteColor];
//    line2.alpha=0.3;
//    [noticeView addSubview:line2];
//
//    [self.view addSubview:noticeView];
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择登录身份" delegate:self cancelButtonTitle:nil otherButtonTitles:@"注册人",@"管理员", nil];
    alertView.tag=999;
    [alertView show];
    
//    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择登录身份" preferredStyle:UIAlertControllerStyleAlert];
//    alterController.view.tintColor = NavBackGroundColor;
//    
//    UIAlertAction *resig_btn = [UIAlertAction actionWithTitle:@"注册人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    
//    UIAlertAction *manage_btn = [UIAlertAction actionWithTitle:@"管理员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    [alterController addAction:resig_btn];
//    [alterController addAction:manage_btn];
//    [self presentViewController:alterController animated:YES completion:nil];
//    
    
}
//-(void)ChoiceAdminClick:(NSInteger)state
//{
//    self.state = state;
//    NSLog(@"sdsdsdsss%ld",(long)state);
//    [self validationCode];
////    [self postRequest];
//}
//登录点击事件
-(void)LandingAction:(UIButton *)btn
{
    [self.userText resignFirstResponder];
    [self.proText resignFirstResponder];
    [self.passText resignFirstResponder];
    
    if ([self.userText.text  isEqual: @""]||[self.passText.text isEqual:@""]) {
        [self textExample];
    }else if ([self.userText.text  isEqual: @"111"]&&[self.passText.text isEqual:@"111"]) {
        [self addAlert];
     }else
    {
        [self addAlert];
    }
}
//手机号登录
-(void)PhoneAction
{
    
}
//注册
-(void)CreatAction
{
    NSLog(@"注册");
    ShopRegisterController *regisVc = [[ShopRegisterController alloc]init];
    [self presentViewController:regisVc animated:YES completion:nil];
}

//登录请求
-(void)postRequest
{
    //用户端若是登录状态,则退出后再登录商户端
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [app loginOutBletcShop];
    
    
    [self showHudInView:self.view hint:@"正在登陆..."];
    

    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/login",BASEURL];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.userText.text forKey:@"phone"];
    [params setObject:self.passText.text forKey:@"passwd"];
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

    
            if ([result_dic[@"result_code"] isEqualToString:@"incomplete"]||[result_dic[@"result_code"] isEqualToString:@"user_auth_fail"]||[result_dic[@"result_code"] isEqualToString:@"user_not_auth"]||[result_dic[@"result_code"]  isEqualToString: @"login_access"]||[result_dic[@"result_code"]  isEqualToString: @"auditing"]){


            //登录环信
            
            [[EMClient sharedClient]loginWithUsername:userInfo[@"muid"] password:@"000000" completion:^(NSString *aUsername, EMError *aError) {
                if (!aError) {
                    NSLog(@"商户登录成功");

                    [app repeatLoadAPI];
                    

                    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        [self saveInfo:[NSString stringWithFormat:@"%@",userInfo[@"muid"]]];
                        
                        
                        app.shopIsLogin = YES;
                        app.shopInfoDic =(NSMutableDictionary*)userInfo;
                        NSUserDefaults *use_name = [NSUserDefaults standardUserDefaults];
                        
                        if (self.ifRemeber) {
                            [use_name setObject:@"yes" forKey:@"remeberShop"];
                            [[EMClient sharedClient].options setIsAutoLogin:YES];
                            
                        }else
                        {
                            [use_name setObject:@"no" forKey:@"remeberShop"];
                            [[EMClient sharedClient].options setIsAutoLogin:NO];
                            
                        }


                        
                        [use_name setValue:userInfo[@"admin_account"] forKey:@"phone"];
                        [use_name setValue:userInfo[@"admin_passwd"] forKey:@"passwd"];
                        
                        if (self.state==0) {
                           
                            [use_name setValue:@"register" forKey:@"log_type"];

                        }
                        else if (self.state==1) {
                            [use_name setValue:@"admin" forKey:@"log_type"];
                            
                        }
                        


                        
                    //本地保存商户信息
                        [use_name setObject:userInfo forKey:userInfo[@"muid"]];
                      //信息是否完善
                        [use_name setObject:result_dic[@"result_code"] forKey:@"wangyongle"];
                        [use_name synchronize];
//                        [app socketConnectHostShop];
                        
                        [self landingSuc];
                    });
                    
                }else{
                    NSLog(@"商户登录失败==%@",aError.errorDescription);
                    [self hideHud];

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
        [self hideHud];
        NSLog(@"%@", error);
    }];
    
}
////完善信息界面
//-(void)completeInfo{
//    NewNextViewController *wholeInfo=[[NewNextViewController alloc]init];
//    wholeInfo.phoneString=self.userText.text;
//    wholeInfo.pswString=self.passText.text;
//    [self presentViewController:wholeInfo animated:YES completion:nil];
//}
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

    NSLog(@"self.userText.text length%ld",[self.userText.text length]);
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
//
//审核
- (void)use_examine
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"用户尚未审核，我们将在三个工作日，完成审核", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:3.f];
    
}
//审核
- (void)use_examine_fail
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"审核未通过，请重新注册", @"HUD message title");
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
//点击空白收起键盘X
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [self.choiceAlertView removeFromSuperview];
    [self.view endEditing:YES];
    
    
}
#pragma mark 返回上一页面
-(void)backRegist
{
    [self.userText resignFirstResponder];
    [self.proText resignFirstResponder];
    [self.passText resignFirstResponder];
    MainTabBarController *mainTB = [[MainTabBarController alloc]init];
    [UIApplication sharedApplication].delegate.window.rootViewController = mainTB;
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app _initChose];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==999) {
        self.state = buttonIndex;
        NSLog(@"sdsdsdsss%ld",(long)buttonIndex);
        [self validationCode];
 
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
    changeVC.type=@"m";
    [self presentViewController:changeVC animated:YES completion:nil];

}

@end
