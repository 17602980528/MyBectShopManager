//
//  CheckOldPassVC.m
//  BletcShop
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CheckOldPassVC.h"
#import "SYPasswordView.h"
#import "ChangePayPassVC.h"
@interface CheckOldPassVC ()<SYPasswordViewDelegate>
@property (nonatomic, strong) SYPasswordView *pasView;
@end

@implementation CheckOldPassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"支付密码";
    self.view.backgroundColor=RGB(238, 238, 238);
    
    UILabel *noticeLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 60, SCREENWIDTH, 30)];
    noticeLable.font=[UIFont systemFontOfSize:14.0f];
    noticeLable.textAlignment=NSTextAlignmentCenter;
    noticeLable.text=@"请输入原支付密码";
    [self.view addSubview:noticeLable];
    
    self.pasView = [[SYPasswordView alloc] initWithFrame:CGRectMake(16, 100, self.view.frame.size.width - 32, 45)];
    _pasView.delegate=self;
    [self.view addSubview:_pasView];
}
-(void)passLenghtEqualsToSix:(NSString *)pass{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/passwd/checkPayPasswd",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.userInfoDic objectForKey:@"uuid"] forKey:@"uuid"];
    [params setObject:pass forKey:@"pay_passwd"];
    NSLog(@"paramer===%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"-----%@",result);
         
         if ([result[@"result_code"] isEqualToString:@"access"]) {
             
             AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
             NSMutableDictionary *mutab_dic =[appdelegate.userInfoDic mutableCopy];
             
             NSLog(@"self.pswText.text==%@",pass);
             
             [mutab_dic setValue:pass forKey:@"pay_passwd"];
             
             appdelegate.userInfoDic = mutab_dic;
    
             ChangePayPassVC *vc=[[ChangePayPassVC alloc]init];
             [self.navigationController pushViewController:vc animated:YES];
            
             
         }else
         {
             UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"原支付密码错误" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
             [alertView show];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@", error);
         
     }];
    [self.pasView.textField resignFirstResponder];

}
-(void)observationPassLength:(NSString *)pwd{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.checkOldPwd
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
