//
//  ChangePayPassLastVC.m
//  BletcShop
//
//  Created by apple on 2017/5/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ChangePayPassLastVC.h"
#import "SYPasswordView.h"
#import "SingleModel.h"
#import "LZDUserInfoVC.h"
#import "MoneyPAYViewController.h"
#import "CountPAYViewController.h"
@interface ChangePayPassLastVC ()<UIAlertViewDelegate>
{
    UIButton *button;
}
@property (nonatomic, strong) SYPasswordView *pasView;

@end

@implementation ChangePayPassLastVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"支付密码";
    self.view.backgroundColor=RGB(238, 238, 238);
    
    UILabel *noticeLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 60, SCREENWIDTH, 30)];
    noticeLable.font=[UIFont systemFontOfSize:14.0f];
    noticeLable.textAlignment=NSTextAlignmentCenter;
    noticeLable.text=@"确认新支付密码";
    [self.view addSubview:noticeLable];
    
    self.pasView = [[SYPasswordView alloc] initWithFrame:CGRectMake(16, 100, self.view.frame.size.width - 32, 45)];
    _pasView.delegate=self;
    [self.view addSubview:_pasView];
    
    button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(15, 165, SCREENWIDTH-30, 44);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    button.backgroundColor=RGB(228, 228, 228);
    button.layer.cornerRadius=5.0f;
    button.clipsToBounds=YES;
    [self.view addSubview:button];
    button.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    
}
-(void)passLenghtEqualsToSix:(NSString *)pass{
    if ([pass isEqualToString:self.pass]) {
        button.backgroundColor=NavBackGroundColor;
        button.userInteractionEnabled=YES;
        [button addTarget:self action:@selector(resetNewPwd) forControlEvents:UIControlEventTouchUpInside];
    }else{
        
        
        
        
        
        
        UIAlertController *alertController  =[UIAlertController alertControllerWithTitle:@"两次密码输入不符,请重新输入" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *suer = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.pasView clearUpPassword];

            
            
        }];
        
        [alertController addAction:suer];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

-(void)observationPassLength:(NSString *)pwd{
    if (pwd.length<6) {
     button.backgroundColor=RGB(228, 228, 228);
        button.userInteractionEnabled=NO;
    }
}
//设新密码
-(void)resetNewPwd{
   //掉接口
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/passwd/setPayPasswd",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:[appdelegate.userInfoDic objectForKey:@"uuid"] forKey:@"uuid"];
    [params setObject:self.pass forKey:@"pay_passwd"];
    NSLog(@"paramer===%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"-----%@",result);
         
         if ([result[@"result_code"] intValue]==1) {
             
             AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
             NSMutableDictionary *mutab_dic =[appdelegate.userInfoDic mutableCopy];
             
             [mutab_dic setValue:self.pass forKey:@"pay_passwd"];
             
             appdelegate.userInfoDic = mutab_dic;
             
             UIAlertController *alertController  =[UIAlertController alertControllerWithTitle:@"支付密码已设置成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *suer = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 
                 NSInteger index = 0;
                 for (UIViewController *VC in self.navigationController.viewControllers) {
                     if ([VC isKindOfClass:[LZDUserInfoVC class]]||[VC isKindOfClass:[MoneyPAYViewController class]]||[VC isKindOfClass:[CountPAYViewController class]]) {
                         index = [self.navigationController.viewControllers indexOfObject:VC];
                     }
                 }
                 [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
                 

                 
             }];
             
             [alertController addAction:suer];
             
             [self presentViewController:alertController animated:YES completion:nil];
             
             
//             UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"支付密码已设置成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//             alertView.tag=100;
//             [alertView show];
             
         }else
         {
             UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",result[@"result_code"]] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
             [alertView show];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@", error);
         
     }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
