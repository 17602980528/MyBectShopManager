//
//  ExperienceCardGoToPayVC.m
//  BletcShop
//
//  Created by Bletc on 2017/6/28.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ExperienceCardGoToPayVC.h"
#import "PayCustomView.h"
#import "AccessCodeVC.h"
#import "ChangePayPassVC.h"
@interface ExperienceCardGoToPayVC ()<PayCustomViewDelegate,UIAlertViewDelegate>
{
    PayCustomView * Payview;

}
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *card_des;//价格

@end

@implementation ExperienceCardGoToPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"体验卡支付";
    
    self.card_des.text = [NSString stringWithFormat:@"%@元",_card_dic[@"price"]];
    
    
//    [self goToPayClick:self.sureBtn];
    

}
- (IBAction)goToPayClick:(id)sender {
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *pay_passwd= [NSString getTheNoNullStr:appdelegate.userInfoDic[@"pay_passwd"] andRepalceStr:@""];
    
    
    
    if ([pay_passwd isEqualToString:@"未设置"]) {
        
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有设置支付密码!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
        alt.tag = 888;
        [alt show];
        
    }else{
        
        Payview=[[PayCustomView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        Payview.delegate=self;
        
        [Payview.forgotButton addTarget:self action:@selector(forgetPayPass) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:Payview];
        
    }
    
    
    
    
    
}

#pragma mark PayCustomViewDelegate 密码

-(void)confirmPassRightOrWrong:(NSString *)pass
{
    [self checkPayPassWd:pass];
}
-(void)checkPayPassWd:(NSString *)payPassWd{
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/passwd/checkPayPasswd",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:payPassWd forKey:@"pay_passwd"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result---_%@",result);
        if ([result[@"result_code"] isEqualToString:@"access"]) {
            [Payview removeFromSuperview];
            
            
            [self payRequest];
            
            
        }else{
            
            
            [self showHint:@"支付密码错误,请重新输入!"];
            
        }
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


-(void)forgetPayPass{
    AccessCodeVC *vc=[[AccessCodeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)payRequest{
    NSString *url = [NSString stringWithFormat:@"%@UserType/ExperienceCard/pay",BASEURL];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:app.userInfoDic[@"uuid"] forKey:@"uuid"];
    [paramer setValue:self.card_dic[@"merchant"] forKey:@"muid"];
    [paramer setValue:self.card_dic[@"card_code"] forKey:@"code"];
    
    
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"-----%@",result);
        if ([result[@"result_code"] intValue]==1) {
            
            
            SoundPaly *sound=[SoundPaly sharedManager:@"sms-received1" type:@"caf"];
            [sound play];
            
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"支付成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                self.refresheDate();
                
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
            
            [alertController addAction:sure];
            
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==888) {
        NSLog(@"去设置");
        if (buttonIndex==1) {
            ChangePayPassVC *vc=[[ChangePayPassVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        //得到输入框
        
    }
    
}
@end
