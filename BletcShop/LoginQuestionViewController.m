//
//  LoginQuestionViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/2/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "LoginQuestionViewController.h"
#import "ShopTabBarController.h"
@interface LoginQuestionViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *identifierTF;


@property(nonatomic,strong)NSDictionary *infoDic;
@end

@implementation LoginQuestionViewController

-(NSDictionary *)infoDic{
    if (!_infoDic) {
        _infoDic = [NSDictionary dictionary];
    }
    return _infoDic;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录遇到问题";
    

}

- (IBAction)logionBtnClick:(UIButton *)sender {
    
    
    NSString *url = [NSString stringWithFormat:@"%@Extra/login/accountVertify",BASEURL];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.userType forKey:@"type"];

    [paramer setValue:self.nameTF.text forKey:@"name"];
    [paramer setValue:self.identifierTF.text forKey:@"id"];
  
    /*
     
     U:
     时尚
     
     610121197803282878
     
     
     M:
     刘波
     
     1234567890
     
     */
    
    
    NSLog(@"-paramer---%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result ===%@",result);
        NSDictionary *result_D = (NSDictionary*)result;
        
        if ([result_D[@"result_code"] isEqualToString:@"access"] ) {
            
            if ([self.userType isEqualToString:@"u"]) {
                [self postRequestLogin:result_D[@"phone"] andPassWord:result_D[@"passwd"]];
            }else if ([self.userType isEqualToString:@"m"]){
                
                [self.nameTF resignFirstResponder];
                [self.identifierTF resignFirstResponder];
                
                self.infoDic = result_D;
                    [self addAlert];
                        }
            
        }else  if ([result_D[@"result_code"] isEqualToString:@"not_found"] ){
            
            [self use_notfound];
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error ===%@",error);

    }];

    
}

/**
 用户登录
 
 @param user     账户
 @param passWord 密码
 */
-(void)postRequestLogin:(NSString *)user andPassWord:(NSString*)passWord
{
    
    DebugLog(@"是否登录环信===%d",[EMClient sharedClient].isLoggedIn);
    
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [app loginOutBletcShop];
    
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/login",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:user forKey:@"phone"];
    [params setObject:passWord forKey:@"passwd"];
    NSLog(@"postRequestLogin user = %@-%@",user,passWord);
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         
         NSLog(@"result  ==%@", result);
         
         NSArray *arr = result[@"info"];
         
         NSDictionary *user_dic = arr[0];
         
         if ([[result objectForKey:@"result_code"]  isEqualToString: @"login_access"]) {
             NSLog(@"成功");
             
             
             
             //登录环信
             
             [[EMClient sharedClient]loginWithUsername:user_dic[@"uuid"] password:@"000000" completion:^(NSString *aUsername, EMError *aError) {
                 if (!aError) {
                     NSLog(@"登录成功");
                     dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                         [self hideHud];
                         
                         [self saveInfo:user_dic[@"uuid"]];
                         [self landingSuc];
                         
                         
                         
                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                    [defaults setObject:@"no" forKey:@"remeber"];
                             
                             [[EMClient sharedClient].options setIsAutoLogin:NO];
                             
                         
                         [defaults setObject:user_dic[@"phone"] forKey:@"userID"];
                         
                         [defaults setValue:user_dic[@"passwd"] forKey:@"userpwd"];
                         [defaults synchronize];
                         
                         
                         AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                         appdelegate.userInfoDic = [NSMutableDictionary dictionaryWithDictionary:user_dic];
                         appdelegate.IsLogin = YES;
                         //                        [appdelegate socketConnectHost];
                         
                         
                         
                     });
                     
                 }else{
                     NSLog(@"登录失败==%@",aError.errorDescription);
                     [self hideHud];
                     
                     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                     hud.mode = MBProgressHUDModeText;
                     hud.label.text = NSLocalizedString(aError.errorDescription, @"HUD message title");
                     hud.label.font = [UIFont systemFontOfSize:13];
                     [hud hideAnimated:YES afterDelay:3.f];
                     
                     
                 }
                 
             }];
             
             
             
             
             
             
         }else if ([[result objectForKey:@"result_code"] isEqualToString:@"passwd_wrong"])
         {
             [self hideHud];
             
             [self passwd_wrong];
             
         }else if ([[result objectForKey:@"result_code"] isEqualToString:@"incomplete"]){
             [self hideHud];
             
             UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您已注册成功，是否完善信息？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
             [alertView show];
             
             
         }else{
             [self hideHud];
             
             [self use_notfound];
         }
         
     }failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         
         NSLog(@"%@", error);
     }];
    
}


-(void)postRequestSeller:(NSString *)name andPassWord:(NSString *)password andState:(NSString *)log_type
{
    
    //用户端若是登录状态,则退出后再登录商户端
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [app loginOutBletcShop];
    
    
    [self showHudInView:self.view hint:@"正在登陆..."];
    

    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/login/login",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:name forKey:@"phone"];
    [params setObject:password forKey:@"passwd"];
    [params setObject:log_type forKey:@"login_type"];
    
    NSLog(@"postRequestSeller-----%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSDictionary *userInfo = result[@"info"];

         NSLog(@"postRequestSeller-result%@", result);
         if ([result[@"result_code"]  isEqualToString: @"access"]) {
             NSLog(@"成功");
             
             
             [[EMClient sharedClient]loginWithUsername:userInfo[@"muid"] password:@"000000" completion:^(NSString *aUsername, EMError *aError) {
                 if (!aError) {
                     NSLog(@"商户登录成功");
                     
                     
                     dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                         
                         [self saveInfo:[NSString stringWithFormat:@"%@",userInfo[@"muid"]]];
                         
                         [app repeatLoadAPI];
                         
                         app.shopInfoDic =(NSMutableDictionary*)userInfo;
                         NSUserDefaults *use_name = [NSUserDefaults standardUserDefaults];
                         
                             [[EMClient sharedClient].options setIsAutoLogin:NO];
                             
                         
                         
                         //本地保存商户信息
                         [use_name setObject:userInfo forKey:userInfo[@"muid"]];
                         //信息是否完善
                         [use_name setObject:result[@"result_code"] forKey:@"wangyongle"];
                         [use_name synchronize];
                         
                         NSMutableDictionary  *shopUser_dic = [NSMutableDictionary dictionaryWithDictionary:result[@"info"]];

                         
                         [self landingSuc:shopUser_dic];
                         
                         
                     });
                     
                 }else{
                     NSLog(@"商户登录失败==%@",aError.errorDescription);
                     [self hideHud];
                     
                     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                     hud.mode = MBProgressHUDModeText;
                     hud.label.text = NSLocalizedString(aError.errorDescription, @"HUD message title");
                     hud.label.font = [UIFont systemFontOfSize:13];
                     [hud hideAnimated:YES afterDelay:3.f];
                 }
             }];
             
           
             
         }else
         {
             [self.navigationController popViewControllerAnimated:YES];
             
         }
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //[self noIntenet];
         NSLog(@"%@", error);
     }];
    
}
//登录成功提示
- (void)landingSuc:(NSMutableDictionary*)mutdia
{
    
    ShopTabBarController *shopvc = [[ShopTabBarController alloc]init];
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        appdelegate.shopInfoDic = mutdia;
    appdelegate.shopIsLogin= YES;
    [appdelegate repeatLoadAPI];

    [self presentViewController:shopvc animated:YES completion:nil];
    
    
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


//选择登陆者
-(void)addAlert
{

    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择登录身份" delegate:self cancelButtonTitle:nil otherButtonTitles:@"注册人",@"管理员", nil];
    alertView.tag=999;
    [alertView show];
    

    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==999) {
        NSString *userType;
        
        switch (buttonIndex) {
            case 0:
                userType = @"register";
                break;
            case 1:
                userType = @"admin";
                break;

                
            default:
                break;
        }
        
        [self postRequestSeller:self.infoDic[@"phone"] andPassWord:self.infoDic[@"passwd"] andState:userType];
        
        
    }
}
//用户名或密码空提示
- (void)textExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"用户名或密码不能为空", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    //    [hud setColor:[UIColor blackColor]];
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    hud.userInteractionEnabled = YES;
    
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
    [self.navigationController popToRootViewControllerAnimated:YES];
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

@end
