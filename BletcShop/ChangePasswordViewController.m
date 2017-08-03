//
//  ChangePasswordViewController.m
//  BletcShop
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "NewPasswordViewController.h"
@interface ChangePasswordViewController ()
{
    UITextField *phoneTF;
    UITextField *nameTF;
    UITextField *cardTF;
    UITextField *certifyTF;
}
@property(nonatomic,strong)NSArray *array_code;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[[UIColor alloc]initWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    navView.backgroundColor = NavBackGroundColor;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 18, 70, 44)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backRegist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
    [navView addSubview:btn];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-50, 18, 100, 44)];
    label.font=[UIFont systemFontOfSize:19.0f];
    label.text=@"忘记密码";
    label.textAlignment=1;
    label.textColor=[UIColor whiteColor];
    [navView addSubview:label];
    
    phoneTF=[[UITextField alloc]initWithFrame:CGRectMake(15, 84, SCREENWIDTH-25, 40)];
    phoneTF.borderStyle=UITextBorderStyleRoundedRect;
    phoneTF.keyboardType=UIKeyboardTypeNumberPad;
    phoneTF.placeholder=@"手机号码";
    [self.view addSubview:phoneTF];
    //用户信息
    UILabel *userInfoLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 80+64, 100, 40)];
    userInfoLab.text=@"用户信息";
    [self.view addSubview:userInfoLab];
    //real姓名
    nameTF=[[UITextField alloc]initWithFrame:CGRectMake(15, 120+64, SCREENWIDTH-30, 40)];
    nameTF.placeholder=@"真实姓名";
    nameTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:nameTF];
    //用户身份号码
    cardTF=[[UITextField alloc]initWithFrame:CGRectMake(15, 175+64, SCREENWIDTH-30, 40)];
    cardTF.placeholder=@"身份证号码";
    cardTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:cardTF];
    //短信校验码
    certifyTF=[[UITextField alloc]initWithFrame:CGRectMake(15, 225+64, 120, 40)];
    certifyTF.placeholder=@"短信校验码";
    certifyTF.keyboardType=UIKeyboardTypeNumberPad;
    certifyTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:certifyTF];
    //点击校验
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneBtn.frame = CGRectMake(145, 225+64, SCREENWIDTH-145-15, 40);
    [phoneBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [phoneBtn setBackgroundColor:[UIColor colorWithRed:84/255.0 green:188/255.0 blue:156/255.0 alpha:1.0]];
    phoneBtn.layer.cornerRadius = 5;
    //self.getCodeBtn = phoneBtn;
    [phoneBtn addTarget:self action:@selector(getProCode) forControlEvents:UIControlEventTouchUpInside];
    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:phoneBtn];
    self.getCodeBtn=phoneBtn;
    //下一步
    UIButton *nextBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextBtn setBackgroundColor:[UIColor colorWithRed:66/255.0 green:68/255.0 blue:70/255.0 alpha:1.0]];
    nextBtn.frame=CGRectMake(15, 280+64, SCREENWIDTH-30, 40);
    nextBtn.layer.cornerRadius=5.0;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)getProCode
{
    if (phoneTF.text.length==11) {

        //[self showIndicatorView];
        
        NSString *url  = @"http://101.201.100.191/cnconsum/App/Extra/VerifyCode/sendSignMsg";
        
        NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithObject:[NSString getSecretStringWithPhone:phoneTF.text] forKey:@"base_str"];
        [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            NSLog(@"-result---%@",result);
            if (result) {
                if ([result[@"state"] isEqualToString:@"access"]) {
                    [self TimeNumAction];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _array_code = result[@"sms_code"];
                    });
                }else if ([result[@"state"] isEqualToString:@"sign_check_fail"]){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验签失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }else if([result[@"state"] isEqualToString:@"time_out"]){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"时间超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }else if([result[@"state"] isEqualToString:@"num_invalidate"]){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号格式错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
            
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }];
        
    }else{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码格式有误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
    }
    
}
-(void)TimeNumAction
{
    if ([phoneTF.text isEqual: @""])
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
                    [self.getCodeBtn setTitle:@"获取短息验证码" forState:UIControlStateNormal];
                    self.getCodeBtn.userInteractionEnabled = YES;
                    [self.getCodeBtn setBackgroundColor:[UIColor colorWithRed:84/255.0 green:188/255.0 blue:156/255.0 alpha:1.0]];
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
-(void)nextBtnClick{
    
#ifdef DEBUG
    [self postRequest];

#else
  
    if (![phoneTF.text isEqualToString:@""]&&![nameTF.text isEqualToString:@""]&&![certifyTF.text isEqualToString:@""]&&![cardTF.text isEqualToString:@""]&&phoneTF.text.length==11&&cardTF.text.length==18&&[_array_code[0] isEqualToString:certifyTF.text]) {
        [self postRequest];
    }else if (phoneTF.text.length!=11){
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码格式有误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alertView show];
    }else if (cardTF.text.length!=18){
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"身份证号码有误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alertView show];
    }else if (![_array_code[0] isEqualToString:certifyTF.text]){
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码有误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alertView show];
    }else if ([nameTF.text isEqualToString:@""]){
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"姓名不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alertView show];
    }
    
#endif

}
-(void)postRequest{
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/passwd/accountVerify",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phoneTF.text forKey:@"phone"];
    //此处需判断是谁进入了该页面，商户还是用户
    [params setObject:self.type forKey:@"type"];
    [params setObject:nameTF.text forKey:@"name"];
    [params setObject:cardTF.text forKey:@"id"];
    
    DebugLog(@"===%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"%@", result)
         ;
         if ([result[@"result_code"] isEqualToString:@"access"]) {
        
             NewPasswordViewController *newVC=[[NewPasswordViewController alloc]init];
             newVC.type=self.type;
             newVC.phone=phoneTF.text;

             [self presentViewController:newVC animated:YES completion:nil];
             
         }else if([result[@"result_code"] isEqualToString:@"not_found"])
         {
             [self tishi:@"用户不存在"];
         
         }else if([result[@"result_code"] isEqualToString:@"name_wrong"])
         {
             [self tishi:@"姓名错误"];
             
         }else if([result[@"result_code"] isEqualToString:@"id_wrong"])
         {
             [self tishi:@"身份证号错误"];
             
         }else{
             
             [self tishi:result[@"result_code"]];

         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@", error);
         
     }];

    
}
-(void)backRegist{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/**
 提示

 @param tishi 提示内容
 */
-(void)tishi:(NSString*)tishi{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(tishi, @"HUD message title");
    
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    hud.userInteractionEnabled = YES;
    
    [hud hideAnimated:YES afterDelay:2.f];
}

@end
