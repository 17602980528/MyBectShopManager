//
//  RegisterController.m
//  BletcShop
//
//  Created by Yuan on 16/2/24.
//  Copyright © 2016年 bletc. All rights reserved.
//

#define UPSIZE 80
#import "RegisterController.h"
#import "SuccessController.h"
#import "MBProgressHUD.h"
#import "CIA_SDK/CIA_SDK.h"
@interface RegisterController ()
@property (nonatomic,strong)UIView *demoView;

@property(nonatomic,strong)UITextField *phoneText;
@property(nonatomic,strong)UITextField *passText;
@property(nonatomic,strong)UITextField *passwordText2;
@property(nonatomic,strong)UITextField *recommend_person;
@property(nonatomic,strong)NSArray *array_code;
@property(nonatomic,weak)UITextField *numText;
@end

@implementation RegisterController
{

    
    UIView *topView;
}
-(NSArray *)array_code{
    if (!_array_code) {
        _array_code = [[NSArray alloc]init];
    }
    return _array_code;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户注册";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    打开触摸 添加单击手势
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    [self _initUI];
}

-(void)_initUI
{
     topView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT*0.15,SCREENWIDTH,260+60)];
    [self.view addSubview:topView];
    
    _phoneText = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, topView.width-120, 50)];
    _phoneText.delegate = self;
    _phoneText.placeholder = @"请输入您的手机号";
//    PhoneText.keyboardType = UIKeyboardTypeNumberPad;
    _phoneText.font = [UIFont systemFontOfSize:15];
    _phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [topView addSubview:_phoneText];
//    self.phoneText = PhoneText;
    UITextField *numText = [[UITextField alloc]initWithFrame:CGRectMake(10, _phoneText.bottom, topView.width-20, 50)];
    numText.delegate = self;
    numText.placeholder = @"请输入您的验证码";
    numText.delegate= self;
    numText.keyboardType = UIKeyboardTypeNumberPad;
    numText.font = [UIFont systemFontOfSize:15];
    numText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.numText = numText;
    [topView addSubview:numText];
    UITextField *passText = [[UITextField alloc]initWithFrame:CGRectMake(10, numText.bottom, topView.width-20, 50)];
    passText.placeholder = @"请输入您的密码(6位以上字母数字组合)";
    passText.font = [UIFont systemFontOfSize:15];
    passText.delegate = self;
    passText.secureTextEntry = YES;
    passText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [topView addSubview:passText];
    self.passText = passText;
    UITextField *passwordText2 = [[UITextField alloc]initWithFrame:CGRectMake(10, passText.bottom, SCREENWIDTH-30, 50)];
    passwordText2.secureTextEntry = YES;
    passwordText2.font = [UIFont systemFontOfSize:15];
    passwordText2.placeholder = @"请重复密码";
    passwordText2.delegate = self;
    passwordText2.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordText2 = passwordText2;
    [topView addSubview:passwordText2];
    
    _recommend_person = [[UITextField alloc]initWithFrame:CGRectMake(10, passwordText2.bottom, topView.width-20, 50)];
    _recommend_person.placeholder = @"请输入您推荐人手机号";
    _recommend_person.font = [UIFont systemFontOfSize:15];
//    _recommend_person.delegate = self;
    [topView addSubview:_recommend_person];
    _recommend_person.hidden=YES;
    
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, topView.width, 0.3)];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.3;
    [topView addSubview:line];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, _phoneText.bottom, topView.width, 0.3)];
    line1.backgroundColor = [UIColor grayColor];
    line1.alpha = 0.3;
    [topView addSubview:line1];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, numText.bottom, topView.width, 0.3)];
    line2.backgroundColor = [UIColor grayColor];
    line2.alpha = 0.3;
    [topView addSubview:line2];
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, passText.bottom, topView.width, 0.3)];
    line3.backgroundColor = [UIColor grayColor];
    line3.alpha = 0.3;
    [topView addSubview:line3];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, passwordText2.bottom, topView.width, 0.3)];
    line4.backgroundColor = [UIColor grayColor];
    line4.alpha = 0.3;
    [topView addSubview:line4];
    
    UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(0, _recommend_person.bottom, topView.width, 0.3)];
    line5.backgroundColor = [UIColor grayColor];
    line5.alpha = 0.3;
    [topView addSubview:line5];
    line5.hidden=YES;
    
    UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    timeBtn.frame = CGRectMake(_phoneText.right+5, 10, topView.width-_phoneText.right-10,30);
    timeBtn.backgroundColor = NavBackGroundColor;
    [timeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.getCodeBtn = timeBtn;
    [timeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    timeBtn.layer.cornerRadius = 10;
    timeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [timeBtn addTarget:self action:@selector(getProCode) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:timeBtn];
//    UIButton *timeBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    self.valBtn = timeBtn1;
//    timeBtn1.frame = CGRectMake(_phoneText.right+5, 60, topView.width-_phoneText.right-10,30);
//    timeBtn1.backgroundColor = NavBackGroundColor;
//    [timeBtn1 setTitle:@"点击验证" forState:UIControlStateNormal];
//    [timeBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [timeBtn1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    timeBtn1.layer.cornerRadius = 10;
//    timeBtn1.titleLabel.font = [UIFont systemFontOfSize:15];
//    [timeBtn1 addTarget:self action:@selector(validationCode) forControlEvents:UIControlEventTouchUpInside];
//    [topView addSubview:timeBtn1];
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(30, _recommend_person.bottom+25, SCREENWIDTH-60, 35);
    nextBtn.backgroundColor = NavBackGroundColor;
    nextBtn.layer.cornerRadius = 10;
    [nextBtn setTitle:@"注册" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:nextBtn];
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
    if (_phoneText.text.length==11) {
        [self TimeNumAction];
        NSString *url  = @"http://101.201.100.191/smsVertify/Demo/SendTemplateSMS.php";
        
        NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithObject:_phoneText.text forKey:@"phone"];;
        [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _array_code = result;
                NSLog(@"----%@",_array_code);
                
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

- (void)validationCode {
    // 校验验证码
    
    NSLog(@"=%@==%@",_array_code,_numText.text);
    
    if (_array_code[0] == _numText.text) {
        
        [self registclick];
        
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
    [UIView animateWithDuration:0.5 animations:^{
        topView.frame = CGRectMake(0, SCREENHEIGHT*0.15,SCREENWIDTH,260+60);
    }];

    
    [self.view endEditing:YES];
    
    
}
//下一页
-(void)nextAction

{
    NSLog(@" %@==%@==%@==%@",self.phoneText.text,self.passText.text,self.numText.text,_recommend_person.text);
    
    if ([self.phoneText.text isEqual:@""] || [self.passText.text isEqual:@""] || [self.numText.text isEqual:@""]) {
        
       
            [self textExample:@"手机号 密码或验证码不能为空"];

        
    }else if (![self.passText.text isEqualToString:self.passwordText2.text]) {
            
            [self textExample:@"密码输入不一致,请重新输入"];
            
        }
    else if (![self.numText.text isEqual:@""]) {
        [UIView animateWithDuration:0.5 animations:^{
            topView.frame = CGRectMake(0, SCREENHEIGHT*0.15,SCREENWIDTH,260+60);
        }];
        [self validationCode];
        

        
        

    }
    

}
//验证码倒计时
-(void)TimeAction:(UIButton *)btn
{
    if ([self.phoneText.text isEqual: @""])
    {
        [self textExample:@"手机号码不能为空"];
        
    }else
    {
        [self getProCode];
        __block int timeout = 59; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    btn.userInteractionEnabled = YES;
                });
            }else{
                int seconds = timeout % 60 ;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //NSLog(@"____%@",strTime);
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    [btn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [UIView commitAnimations];
                    btn.userInteractionEnabled = NO;
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
}
//提示遮罩
- (void)textExample:(NSString *)tishi {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(tishi, @"HUD message title");

    hud.label.font = [UIFont systemFontOfSize:13];
    [hud hideAnimated:YES afterDelay:1];
}




-(void)registclick
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/register",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_phoneText.text forKey:@"phone"];
    [params setObject:_passText.text forKey:@"passwd"];
    [params setObject:@"无人推荐" forKey:@"referrer"];//_recommend_person.text
    

    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result ==%@", result);
        if ([result[@"result_code"] intValue]==1) {
            NSLog(@"成功");
            
            SuccessController *sucVC = [[SuccessController alloc]init];
            sucVC.phoneNum = self.phoneText.text;
            sucVC.passWord = self.passText.text;
            [self.navigationController pushViewController:sucVC animated:YES];
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
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==self.recommend_person) {
        
        [UIView animateWithDuration:0.5 animations:^{
            topView.frame = CGRectMake(0, SCREENHEIGHT*0.15-UPSIZE,SCREENWIDTH,260+60);
            
        }];

        

        [self NewAddVipAction];
    }
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        topView.frame = CGRectMake(0, SCREENHEIGHT*0.15,SCREENWIDTH,260+60);

    }];

    return YES;
}

-(void)NewAddVipAction
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    [alertView setContainerView:[self createDemoView]];
    
    
    alertView.parentView = self.view;
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"是", @"否", nil]];
    
    [alertView setDelegate:self];
    
    [alertView setUseMotionEffects:true];
    
    [alertView show];
}

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 150)];
    self.demoView = demoView;
    demoView.frame=CGRectMake(0, 0, 290, 50);
    UILabel *numlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, demoView.width, 50)];
    numlabel.textAlignment = NSTextAlignmentCenter;
    numlabel.text = @"您通过在线用户推荐,入驻平台?";
    numlabel.font = [UIFont systemFontOfSize:16];
    [demoView addSubview:numlabel];
    return demoView;
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    
    
    if (alertView.tag==0&&buttonIndex==1) {
        
        self.recommend_person.text = @"无人推荐";
        [_recommend_person resignFirstResponder];
        [alertView close];
        
        [UIView animateWithDuration:0.5 animations:^{
            topView.frame = CGRectMake(0, SCREENHEIGHT*0.15,SCREENWIDTH,260+60);
            
        }];
        

        
    }
    else if (alertView.tag==0&&buttonIndex==0)
    {
        self.recommend_person.text =@"";
        self.recommend_person.placeholder = @"请输入您的推荐人手机号";
    }
    [alertView close];
}
@end
