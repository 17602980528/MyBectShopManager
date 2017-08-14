//
//  AccessCodeVC.m
//  BletcShop
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AccessCodeVC.h"
#import "ChangePayPassVC.h"
@interface AccessCodeVC ()<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *codeTF;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UILabel *phone;
@property(nonatomic,copy)NSString *array_code;
@end

@implementation AccessCodeVC
- (IBAction)commitBtnClick:(id)sender {
    
    [self.codeTF resignFirstResponder];
       if (![self.codeTF.text isEqualToString:@""]) {
           if (self.array_code) {
               if ([self.codeTF.text isEqualToString:self.array_code]) {
                   ChangePayPassVC *vc=[[ChangePayPassVC alloc]init];
                   [self.navigationController pushViewController:vc animated:YES];
               }else{
                   [self showHint:@"验证码输入错误"];
               }
           }else{
                [self showHint:@"验证码输入错误"];
           }
       
    }else{
         [self showHint:@"请输入验证码"];
    }
   

}
- (IBAction)sendBtnClick:(id)sender {
    
    NSString *notice=[NSString stringWithFormat:@"我们将会发送验证码到%@",_phone.text];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"确认手机号码" message:notice delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self getCodeNumber];
}
-(NSString *)array_code{
    if (!_array_code) {
        _array_code = [[NSString alloc]init];
    }
    return _array_code;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"重置支付密码";
     AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    _phone.text=appdelegate.userInfoDic[@"phone"];
    
}
-(void)getCodeNumber{
    NSString *url  = @"http://101.201.100.191/cnconsum/App/Extra/VerifyCode/sendSignMsg";
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithObject:[NSString getSecretStringWithPhone:self.phone.text] forKey:@"base_str"];
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
                [self.sendButton setTitle:@"重发验证码" forState:0];
                self.sendButton.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60 ;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                [self.sendButton setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:0];
                
                self.sendButton.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
