//
//  NewUserAccessCodeVC.m
//  BletcShop
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NewUserAccessCodeVC.h"
#import "NewUserSetPassVC.h"
@interface NewUserAccessCodeVC ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *proCodeTF;
@property (strong, nonatomic) IBOutlet UIButton *getCodeBtn;
@property(nonatomic,strong)NSArray *array_code;
@end

@implementation NewUserAccessCodeVC
- (IBAction)goNextBtnClick:(id)sender {
#ifdef DEBUG
    NewUserSetPassVC *vc=[[NewUserSetPassVC alloc]init];
    vc.phoneNum=self.phoneNum;
    [self.navigationController pushViewController:vc animated:YES];
#else
      [self validationCode];
#endif
  
}
-(void)getProCode
{

        [self TimeNumAction];
        NSString *url  = @"http://101.201.100.191/smsVertify/Demo/SendTemplateSMS.php";
        
        NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithObject:self.phoneNum forKey:@"phone"];
        [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _array_code = result;
                NSLog(@"----%@",_array_code);
                
            });
            
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取验证码失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }];
}
-(void)TimeNumAction
{        //[self getProCode];
        __block int timeout = 59; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.getCodeBtn setTitle:@"0s" forState:UIControlStateNormal];
                });
            }else{
                int seconds = timeout % 60 ;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //NSLog(@"____%@",strTime);
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
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
- (void)validationCode {
    // 校验验证码
    NSLog(@"=%@==%@",_array_code,_proCodeTF.text);
    if (_proCodeTF.text&&_proCodeTF.text.length>0) {
        if (_array_code[0] == _proCodeTF.text) {
            NewUserSetPassVC *vc=[[NewUserSetPassVC alloc]init];
            vc.phoneNum=self.phoneNum;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }else {
            [self alert:@"验证码输入错误"];
        }
    }else{
         [self alert:@"请输入验证码"];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"获取验证码";
    _proCodeTF.delegate=self;
    _proCodeTF.returnKeyType=UIReturnKeyDone;
    [self setTextFieldLeftImageView:_proCodeTF leftImageName:@"钥匙"];
#ifdef DEBUG
    
#else
    [self getProCode];
#endif
   
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
