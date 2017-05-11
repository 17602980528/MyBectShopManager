//
//  NewChangePsWordViewController.m
//  BletcShop
//
//  Created by apple on 16/11/19.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NewChangePsWordViewController.h"

@interface NewChangePsWordViewController ()

@end

@implementation NewChangePsWordViewController
{
    UIImageView *imageView;
    int index;
    UILabel *showPass;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(240, 240, 240);
    self.navigationItem.title=@"登录密码";
    UIBarButtonItem *saveButton=[[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    self.navigationItem.rightBarButtonItem=saveButton;

    UILabel *oldPassLabel=[[UILabel alloc]initWithFrame:CGRectMake(13, 0, SCREENWIDTH-13, 44)];
    oldPassLabel.text=@"旧密码";
    oldPassLabel.textAlignment=NSTextAlignmentLeft;
    oldPassLabel.font=[UIFont systemFontOfSize:15.0f];
    [self.view addSubview:oldPassLabel];
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREENWIDTH, 44)];
    view1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view1];
    
    self.oldPswText=[[UITextField alloc]initWithFrame:CGRectMake(12, 0, SCREENWIDTH-24, 44)];
    self.oldPswText.placeholder=@"6-16位字符，字母区分大小写";
    self.oldPswText.font=[UIFont systemFontOfSize:15.0f];
    [view1 addSubview:self.oldPswText];
    
    UILabel *PassLabel=[[UILabel alloc]initWithFrame:CGRectMake(13, 88, SCREENWIDTH-13, 44)];
    PassLabel.text=@"新密码";
    PassLabel.textAlignment=NSTextAlignmentLeft;
    PassLabel.font=[UIFont systemFontOfSize:15.0f];
    [self.view addSubview:PassLabel];
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, 132, SCREENWIDTH, 44)];
    view2.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view2];
    
    self.pswdText=[[UITextField alloc]initWithFrame:CGRectMake(12, 0, SCREENWIDTH-24, 44)];
    self.pswdText.placeholder=@"6-16位字符，字母区分大小写";
    self.pswdText.secureTextEntry=YES;
    self.pswdText.font=[UIFont systemFontOfSize:15.0f];
    [view2 addSubview:self.pswdText];
    
    UIView *hiddenOrShow=[[UIView alloc]initWithFrame:CGRectMake(0, 176, SCREENWIDTH, 50)];
    hiddenOrShow.userInteractionEnabled=YES;
    [self.view addSubview:hiddenOrShow];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [hiddenOrShow addGestureRecognizer:tap];
    
    
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(13, 10, 13, 13)];
    imageView.image=[UIImage imageNamed:@"de_icon_checkbox_n"];
    [hiddenOrShow addSubview:imageView];
    
    showPass=[[UILabel alloc]initWithFrame:CGRectMake(31, 10, 50, 12)];
    showPass.text=@"显示密码";
    showPass.font=[UIFont systemFontOfSize:12.0f];
    showPass.textAlignment=NSTextAlignmentLeft;
    [hiddenOrShow addSubview:showPass];
    
    index=0;
}
-(void)tapClick{
    index++;
    if (index%2==1) {
        self.pswdText.secureTextEntry=NO;
        imageView.image=[UIImage imageNamed:@"de_icon_checkbox_sl"];
        showPass.text=@"隐藏密码";
    }else{
        self.pswdText.secureTextEntry=YES;
        imageView.image=[UIImage imageNamed:@"de_icon_checkbox_n"];
        showPass.text=@"显示密码";
    }
    
}
-(void)saveBtnClick{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSDictionary *dic = [NSDictionary dictionary];
    
    if ([self.type_login isEqualToString:@"shop"]) {
        
       dic =appdelegate.shopInfoDic;
    }else{
        
        dic =appdelegate.userInfoDic;

        
    }

    
    if (![[dic objectForKey:@"passwd"] isEqualToString:self.oldPswText.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"原密码输入错误", @"HUD message title");
        
        hud.label.font = [UIFont systemFontOfSize:13];
//        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        hud.userInteractionEnabled = YES;
        
        [hud hideAnimated:YES afterDelay:2.f];
    }else if ([self.oldPswText.text isEqualToString:self.pswdText.text])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"新密码和原密码相同", @"HUD message title");
        
        hud.label.font = [UIFont systemFontOfSize:13];
        //    [hud setColor:[UIColor blackColor]];
       
        hud.userInteractionEnabled = YES;
        
        [hud hideAnimated:YES afterDelay:2.f];
    }else if (self.pswdText.text.length<6){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"新密码长度不能小于6位", @"HUD message title");
        
        hud.label.font = [UIFont systemFontOfSize:13];
        //    [hud setColor:[UIColor blackColor]];
        
        hud.userInteractionEnabled = YES;
        
        [hud hideAnimated:YES afterDelay:2.f];
    }else if(self.pswdText.text.length>16){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"密码长度不能大于16位", @"HUD message title");
        
        hud.label.font = [UIFont systemFontOfSize:13];
        //    [hud setColor:[UIColor blackColor]];
        
        hud.userInteractionEnabled = YES;
        
        [hud hideAnimated:YES afterDelay:2.f];
    }
    else{
        
        if ([self.type_login isEqualToString:@"shop"]) {
            
            [self postChangeShopPsw];
        }else{
            
            
            [self postChangePsw];
            
        }

        
           }

}
   /**
 改变用户密码
 */
-(void)postChangePsw
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountSet",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.userInfoDic objectForKey:@"uuid"] forKey:@"uuid"];
    [params setValue:@"passwd" forKey:@"type"];
    [params setObject:self.oldPswText.text forKey:@"pwd_old"];
    [params setObject:self.pswdText.text forKey:@"pwd_new"];
    
    NSLog(@"%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"%@", result);
         
         if ([result[@"result_code"] intValue]==1) {
             
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.label.text = NSLocalizedString(@"修改成功", @"HUD message title");
             
             hud.label.font = [UIFont systemFontOfSize:13];
             //    [hud setColor:[UIColor blackColor]];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             hud.userInteractionEnabled = YES;
             
             [hud hideAnimated:YES afterDelay:2.f];
             
             NSMutableDictionary *new_dic = [appdelegate.userInfoDic mutableCopy];
             [new_dic setValue:result[@"para"] forKey:result[@"type"]];
             appdelegate.userInfoDic = new_dic;
             
         }else
         {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.label.text = NSLocalizedString(@"修改失败!", @"HUD message title");
             
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

//修改商户密码
-(void)postChangeShopPsw
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/accountSet",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    [params setObject:@"passwd" forKey:@"type"];
    [params setObject:self.oldPswText.text forKey:@"pwd_old"];
    [params setObject:self.pswdText.text forKey:@"pwd_new"];
    
    NSLog(@"paramer===%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"-----%@",result);
         
         if ([result[@"result_code"] intValue]==1) {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.label.text = NSLocalizedString(@"密码修改成功", @"HUD message title");
             
             hud.label.font = [UIFont systemFontOfSize:13];
             //    [hud setColor:[UIColor blackColor]];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             hud.userInteractionEnabled = YES;
             
             [hud hideAnimated:YES afterDelay:2.f];
             AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
             NSMutableDictionary *mutab_dic =[appdelegate.shopInfoDic mutableCopy];
             
             
             
             
             NSLog(@"self.pswText.text==%@",self.pswdText.text);
             
             [mutab_dic setValue:self.pswdText.text forKey:@"passwd"];
             
             
             NSUserDefaults *use_name = [NSUserDefaults standardUserDefaults];
             [use_name removeObjectForKey:@"passwd"];
             [use_name synchronize];

             appdelegate.shopInfoDic = mutab_dic;
             
             
             
         }else
         {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.label.text = NSLocalizedString(result[@"result_code"], @"HUD message title");
             
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
