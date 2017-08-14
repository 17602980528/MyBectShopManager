//
//  ResetPhoneNextVC.m
//  BletcShop
//
//  Created by Bletc on 2017/2/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ResetPhoneNextVC.h"
#import "BindCustomView.h"
@interface ResetPhoneNextVC ()
@property (weak, nonatomic) IBOutlet UILabel *topLab;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property(nonatomic,copy)NSString *array_code;

@end

@implementation ResetPhoneNextVC
{
     BindCustomView *myalertView;
}
-(NSString *)array_code{
    if (!_array_code) {
        _array_code = [[NSString alloc]init];
    }
    return _array_code;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更换手机号";
    self.topLab.text = [NSString stringWithFormat:@"请输入%@收到的短信验证码",self.phone];
    [self getCodeNumber];
    
    
   
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (myalertView) {
        [myalertView removeFromSuperview];
    }
}
- (IBAction)sendBtnClick:(UIButton *)sender {
    
    [self getCodeNumber];
}
- (IBAction)nextBtn:(UIButton *)sender {
    
    [self.codeTF resignFirstResponder];
    
    
    if ([self.codeTF.text isEqualToString:[NSString getTheNoNullStr:self.array_code andRepalceStr:@""]]) {
        if ([self.whoPush isEqualToString:@"商户"]) {
            [self postShopRequest];
        }else{
            
            [self postRequest];

        }
    }else{
        [self showHint:@"验证码输入错误"];
    }
    
    
}
//商户改手机号
-(void)postShopRequest{
    {
        
        
        NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/accountSet",BASEURL];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
        
        [params setObject:@"phone" forKey:@"type"];
        [params setObject:self.phone forKey:@"para"];
        
        NSLog(@"params===%@",params);
        
        [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
         {
             NSLog(@"result----%@",result);
             
             if ([result[@"result_code"] integerValue]==1) {
                 myalertView=[[BindCustomView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
                 
                 myalertView.phoneLable.text = [NSString stringWithFormat:@"您的新手机号：%@",self.phone];
                 [myalertView.completeBtn addTarget:self action:@selector(removeAlertViewFromCurrentVC:) forControlEvents:UIControlEventTouchUpInside];
                 [self.view addSubview:myalertView];
                 AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                 NSMutableDictionary *mutab_dic =[appdelegate.shopInfoDic mutableCopy];
                 
                 [mutab_dic setObject:self.phone forKey:@"phone"];
                 appdelegate.shopInfoDic = mutab_dic;

                 
             }else if([result[@"result_code"] integerValue]==1062){
                 
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                 
                 hud.label.text = NSLocalizedString(@"该手机号在平台已存在!", @"HUD message title");
                 
                 hud.label.font = [UIFont systemFontOfSize:13];
                 hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                 hud.userInteractionEnabled = YES;
                 
                 [hud hideAnimated:YES afterDelay:2.f];
                 
             }else{
                 
                 
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                 
                 hud.label.text = NSLocalizedString(@"请求失败 请重试", @"HUD message title");
                 
                 hud.label.font = [UIFont systemFontOfSize:13];
                 //    [hud setColor:[UIColor blackColor]];
                 hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                 hud.userInteractionEnabled = YES;
                 
                 [hud hideAnimated:YES afterDelay:2.f];
             }
             
             
             
             
         } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"%@", error);
             
         }];
        
    }
    
}
//用户改手机号
-(void)postRequest{
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountSet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
        [params setObject:@"phone" forKey:@"type"];
        [params setObject:self.phone forKey:@"para"];
    
    NSLog(@"params===%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result----%@",result);
         
         if ([result[@"result_code"] integerValue]==1) {
             
             AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
             NSMutableDictionary *mutab_dic =[appdelegate.userInfoDic mutableCopy];
             
             [mutab_dic setObject:self.phone forKey:@"phone"];
             appdelegate.userInfoDic = mutab_dic;

             myalertView=[[BindCustomView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
             
             myalertView.phoneLable.text = [NSString stringWithFormat:@"您的新手机号：%@",self.phone];
             [myalertView.completeBtn addTarget:self action:@selector(removeAlertViewFromCurrentVC:) forControlEvents:UIControlEventTouchUpInside];
             [self.view addSubview:myalertView];
             
             
            

             

         }else if([result[@"result_code"] integerValue]==1062){
             
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

             hud.label.text = NSLocalizedString(@"该手机号在平台已存在!", @"HUD message title");
             
             hud.label.font = [UIFont systemFontOfSize:13];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             hud.userInteractionEnabled = YES;
             
             [hud hideAnimated:YES afterDelay:2.f];

         }else{
             
             
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
             
             hud.label.text = NSLocalizedString(@"请求失败 请重试", @"HUD message title");
             
             hud.label.font = [UIFont systemFontOfSize:13];
             //    [hud setColor:[UIColor blackColor]];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             hud.userInteractionEnabled = YES;
             
             [hud hideAnimated:YES afterDelay:2.f];
         }
         
         
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@", error);
         
     }];
    
}
-(void)removeAlertViewFromCurrentVC:(UIButton *)sender{
    [myalertView removeFromSuperview];
    //pop到需要的页面
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

-(void)getCodeNumber{
    NSString *url  = @"http://101.201.100.191/cnconsum/App/Extra/VerifyCode/sendSignMsg";
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithObject:[NSString getSecretStringWithPhone:self.phone] forKey:@"base_str"];
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"-result---%@",result);
        if (result) {
            if ([result[@"state"] isEqualToString:@"access"]) {
                [self TimeNumAction];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.array_code = [NSString stringWithFormat:@"%@",result[@"sms_code"]];
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
    

    
    
}

-(void)TimeNumAction
{
   
    
        __block int timeout = 59; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.sendBtn setTitle:@"重发验证码" forState:0];
                    self.sendBtn.userInteractionEnabled = YES;
                });
            }else{
                int seconds = timeout % 60 ;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                  
                   [self.sendBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:0];

                    self.sendBtn.userInteractionEnabled = NO;
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
