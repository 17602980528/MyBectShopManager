//
//  NewPasswordViewController.m
//  BletcShop
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NewPasswordViewController.h"
#import "MainTabBarController.h"
#import "ShopLandController.h"
@interface NewPasswordViewController ()
{
    UITextField *passTF;
    UITextField *newPassTF;
}
@end

@implementation NewPasswordViewController

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
    label.text=@"修改密码";
    label.textAlignment=1;
    label.textColor=[UIColor whiteColor];
    [navView addSubview:label];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 30+64, SCREENWIDTH, 100)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    UILabel *passLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 100, 40)];
    passLab.text=@"新密码:";
    passLab.textAlignment=1;
    [view addSubview:passLab];
    //新密码
    passTF=[[UITextField alloc]initWithFrame:CGRectMake(100, 5, SCREENWIDTH-115, 40)];
    passTF.placeholder=@"请输入6-16位数字，字母活符号";
    passTF.secureTextEntry=YES;
    passTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    [view addSubview:passTF];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.5)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [view addSubview:lineView];
    //确认密码
    UILabel *newPassLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 50.5, 100, 40)];
    newPassLab.text=@"确认密码:";
    newPassLab.textAlignment=1;
    [view addSubview:newPassLab];
    
    newPassTF=[[UITextField alloc]initWithFrame:CGRectMake(100, 50, SCREENWIDTH-115, 40)];
    newPassTF.placeholder=@"请再次输入密码";
    newPassTF.secureTextEntry=YES;
    newPassTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    [view addSubview:newPassTF];
    
    UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setBackgroundColor:[UIColor colorWithRed:24/255.0 green:123/255.0 blue:242/255.0 alpha:1.0]];
    loginBtn.frame=CGRectMake(25, 150+64, SCREENWIDTH-50, 50);
    loginBtn.titleLabel.font=[UIFont systemFontOfSize:20.0];
    [loginBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)loginClick{
    if (![passTF.text isEqualToString:@""]&&![newPassTF.text isEqualToString:@""]&&[passTF.text isEqualToString:newPassTF.text]&&passTF.text.length<=16) {
        //调用修改密码接口,修改成功后给提示
        [self postRequest];
        
    }else if (![passTF.text isEqualToString:newPassTF.text]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不一致" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
    }else if(passTF.text.length>16){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不能大于16位" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
    }
}
-(void)postRequest{
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/reset",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phone forKey:@"phone"];
    //此处需判断是谁进入了该页面，商户还是用户
    [params setObject:self.type forKey:@"type"];
    [params setObject:passTF.text forKey:@"passwd"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"%@", result);

         if ([result[@"result_code"] intValue]==1) {
             //
             if ([self.type isEqualToString:@"m"]) {
                 //去商户端登录界面
                 ShopLandController *shopLoginVC=[[ShopLandController alloc]init];
                 [self presentViewController:shopLoginVC animated:YES completion:nil];
                 
             }else if([self.type isEqualToString:@"u"]){
                 //去用户端
                 

                 NSLog(@"用户端修改密码成功");
                 
             }
         }else
         {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.label.text = NSLocalizedString(@"修改失败", @"HUD message title");
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//用户不存在
- (void)use_notfound
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"用户不存在", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:4.f];
    
}
//没有网络连接提示
- (void)noIntenet
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"请检查网络连接", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //        hud.offset = CGPointMake(0.f,MBProgressMaxOffset);
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:2.f];
    
}

//登录成功提示
- (void)landingSuc
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"登录成功", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:2.f];
    [self.navigationController popViewControllerAnimated:YES];
}
//密码错误
- (void)passwd_wrong
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"用户名或密码错误", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:4.f];
    
}

//判断是否textField输入数字
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string]; //定义一个NSScanner，扫描string
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//保存用户信息到本地
-(void)saveInfo:(NSString*)auserName{
    NSString *url = [NSString stringWithFormat:@"%@Extra/IM/get",BASEURL];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
    [paramer setObject:auserName forKey:@"account"];
    NSLog(@"-saveInfo--%@",paramer);
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSArray *arr = (NSArray *)result;
        if (arr.count!=0) {
            Person *p = [Person modalWith:arr[0][@"nickname"] imgStr:arr[0][@"headimage"]  idstring:arr[0][@"account"]];
            
            [Database savePerdon:p];
        }
        
       
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}
-(void)backRegist{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
