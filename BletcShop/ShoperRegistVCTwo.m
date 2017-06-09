//
//  ShoperRegistVCTwo.m
//  BletcShop
//
//  Created by Bletc on 2017/6/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ShoperRegistVCTwo.h"
#import "ShoerRegistThree.h"
@interface ShoperRegistVCTwo ()
@property(nonatomic,strong)NSArray *array_code;
@property (weak, nonatomic) IBOutlet UIButton *senderBtn;

@end

@implementation ShoperRegistVCTwo
-(NSArray *)array_code{
    if (!_array_code) {
        _array_code = [NSArray array];
    }
    return _array_code;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTextFieldLeftImageView:self.codeTf leftImageName:@"钥匙"];
    [self  getCodeNumber];

}
- (IBAction)goback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)nextClick:(UIButton *)sender {
    
    ShoerRegistThree *VC = [[ShoerRegistThree alloc]init];
    VC.phone = self.phone;
    VC.referralPhone = self.referralPhone;
    [self presentViewController:VC animated:YES completion:nil];
    
    if ([self.array_code[0] isEqualToString:self.codeTf.text]) {
        
        
    }else{
        
        
        [self showHint:@"请重新输入验证码!"];
    }
    
   
}

//重新发验证码
- (IBAction)senderCodeClick:(UIButton *)sender {
}


-(void)getCodeNumber{
    NSString *url  = @"http://101.201.100.191/smsVertify/Demo/SendTemplateSMS.php";
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithObject:self.phone forKey:@"phone"];
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
               [self.senderBtn setTitle:@"0s" forState:0];
//                self.senderBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60 ;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                [self.senderBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:0];
                
//                self.senderBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)setTextFieldLeftImageView:(UITextField *)textField leftImageName:(NSString *)imageName
{
    // 设置左边图片
    UIImageView *leftView     = [[UIImageView alloc] init];
    leftView.image            = [UIImage imageNamed:imageName];
    leftView.bounds = CGRectMake(0, 0, 30, 30);
   
    
    // 设置leftView的内容居中
    leftView.contentMode      = UIViewContentModeCenter;
    textField.leftView        = leftView;
    
    // 设置左边的view永远显示
    textField.leftViewMode    = UITextFieldViewModeAlways;
    
}

@end
