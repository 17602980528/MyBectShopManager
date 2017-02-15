//
//  ResetPhoneNextVC.m
//  BletcShop
//
//  Created by Bletc on 2017/2/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ResetPhoneNextVC.h"

@interface ResetPhoneNextVC ()
@property (weak, nonatomic) IBOutlet UILabel *topLab;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property(nonatomic,strong)NSArray *array_code;

@end

@implementation ResetPhoneNextVC
-(NSArray *)array_code{
    if (!_array_code) {
        _array_code = [[NSArray alloc]init];
    }
    return _array_code;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更换手机号";
    self.topLab.text = [NSString stringWithFormat:@"请输入%@收到的短信验证码",self.phone];
    [self getCodeNumber];
    
    
   
}

- (IBAction)sendBtnClick:(UIButton *)sender {
    
    [self getCodeNumber];
}
- (IBAction)nextBtn:(UIButton *)sender {
    
    [self.codeTF resignFirstResponder];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

-(void)getCodeNumber{
    NSString *url  = @"http://101.201.100.191/smsVertify/Demo/SendTemplateSMS.php";
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithObject:self.phone forKey:@"phone"];;
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"-result---%@",result);
        [self TimeNumAction];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _array_code = result;
            
        });
        
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
