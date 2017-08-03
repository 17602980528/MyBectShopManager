//
//  ShoperRegistVCTwo.m
//  BletcShop
//
//  Created by Bletc on 2017/6/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ShoperRegistVCTwo.h"
#import "ShoerRegistThree.h"
#import "UIImageView+WebCache.h"
@interface ShoperRegistVCTwo ()<UITextFieldDelegate>

{
    UIView *imageCodeBgView;
    UIImageView *codeImageView;
    UITextField *tf;
}

@property(nonatomic,strong)NSArray *array_code;
@property (weak, nonatomic) IBOutlet UIButton *senderBtn;

@end

@implementation ShoperRegistVCTwo
- (IBAction)showImageCode:(id)sender {
    imageCodeBgView.hidden=NO;
    [self AccessImageCodeReuqst];
}

-(NSArray *)array_code{
    if (!_array_code) {
        _array_code = [NSArray array];
    }
    return _array_code;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTextFieldLeftImageView:self.codeTf leftImageName:@"钥匙"];
    //[self  getCodeNumber];
    
    imageCodeBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    imageCodeBgView.backgroundColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.3];
    UIView *alert = [[UIView alloc]initWithFrame:CGRectMake(13, 100, SCREENWIDTH-26, 202)];
    alert.backgroundColor=[UIColor whiteColor];
    alert.layer.cornerRadius=10.0f;
    alert.clipsToBounds=YES;
    [imageCodeBgView addSubview:alert];
    
    UILabel *topLable=[[UILabel alloc]initWithFrame:CGRectMake((alert.width-156)/2, 21, 156, 14)];
    topLable.text=@"请先输入字符进行验证";
    topLable.textAlignment=NSTextAlignmentCenter;
    topLable.font=[UIFont systemFontOfSize:15.0f];
    topLable.textColor=RGB(51, 51, 51);
    [alert addSubview:topLable];
    
    UIButton *cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame=CGRectMake(alert.width-60, 10, 60, 30);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:RGB(119, 119, 119) forState:UIControlStateNormal];
    cancelButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [alert addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(removeAlertPage) forControlEvents:UIControlEventTouchUpInside];
    
    codeImageView=[[UIImageView alloc]initWithFrame:CGRectMake((alert.width-156)/2, topLable.bottom+20, 156, 37)];
    codeImageView.image=[UIImage imageNamed:@"字符占位"];
    codeImageView.backgroundColor=RGB(229, 229, 229);
    codeImageView.layer.cornerRadius=4.0f;
    codeImageView.clipsToBounds=YES;
    codeImageView.userInteractionEnabled=YES;
    [alert addSubview:codeImageView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImageCode:)];
    [codeImageView addGestureRecognizer:tap];
    
    tf=[[UITextField alloc]initWithFrame:CGRectMake(13, codeImageView.bottom+25, alert.width-26, 50)];
    tf.returnKeyType=UIReturnKeyDone;
    tf.placeholder=@"请输入字符";
    tf.delegate=self;
    tf.borderStyle=UITextBorderStyleRoundedRect;
    [alert addSubview:tf];
    
    [tf addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    
    
//    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [self.view addSubview:imageCodeBgView];
    
    [self AccessImageCodeReuqst];

}
-(void)removeAlertPage{
    codeImageView.image=[UIImage imageNamed:@"字符占位"];
    imageCodeBgView.hidden=YES;
}
- (IBAction)goback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)nextClick:(UIButton *)sender {
    
   
#ifdef DEBUG
    
    
    ShoerRegistThree *VC = [[ShoerRegistThree alloc]init];
    VC.phone = self.phone;
    VC.referralPhone = self.referralPhone;
    [self presentViewController:VC animated:YES completion:nil];

#else
    if ([self.array_code[0] isEqualToString:self.codeTf.text]) {
        
        ShoerRegistThree *VC = [[ShoerRegistThree alloc]init];
        VC.phone = self.phone;
        VC.referralPhone = self.referralPhone;
        [self presentViewController:VC animated:YES completion:nil];
        
    }else{
        
        
        [self showHint:@"请重新输入验证码!"];
    }

    
    
#endif
    
  
    
   
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
//刷新图片
-(void)changeImageCode:(UITapGestureRecognizer *)tap{
    [self AccessImageCodeReuqst];
}
-(void)AccessImageCodeReuqst{
    NSString *url  = @"http://101.201.100.191/cnconsum/App/Extra/VerifyCode/get";
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithObject:self.phone forKey:@"phone"];
    NSLog(@"paramer============%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"result============%@",result);
        if (result) {
            if ([result[@"result_code"]integerValue]==1) {
                NSURL * nurl=[[NSURL alloc] initWithString:[[CODEIMAGE stringByAppendingString:result[@"image"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [codeImageView sd_setImageWithURL:nurl placeholderImage:[UIImage imageNamed:@"字符占位"] options:SDWebImageRetryFailed];
            }
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}

-(void)assignImageCodeReuqst{
    NSString *url  = @"http://101.201.100.191/cnconsum/App/Extra/VerifyCode/checkV2";
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithObject:[NSString getSecretStringWithPhone:self.phone] forKey:@"base_str"];
    [paramer setObject:tf.text forKey:@"code"];
    NSLog(@"paramer============%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"result============%@",result);
        if (result) {
            if ([result[@"state"] isEqualToString:@"access"]) {
                [self TimeNumAction];
                imageCodeBgView.hidden=YES;
                codeImageView.image=[UIImage imageNamed:@"字符占位"];
                tf.text=@"";
                [tf resignFirstResponder];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _array_code = result[@"sms_code"];
                    NSLog(@"----%@",_array_code);
                    
                });
            }else{
                [self AccessImageCodeReuqst];
            }
        }        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

-(void)valueChanged:(UITextField *)textFeild{
    NSLog(@"????????%@",textFeild.text);
    if (textFeild.text.length==5) {
        //http://101.201.100.191/cnconsum/App/Extra/VerifyCode/check
        [self assignImageCodeReuqst];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
