//
//  BonusCashViewController.m
//  BletcShop
//
//  Created by apple on 16/12/22.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "BonusCashViewController.h"

@interface BonusCashViewController ()<UITextFieldDelegate>
{
    UILabel *allMoney_lab;
    UITextField *text_Field;
}
@end

@implementation BonusCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"红包提现";
    self.view.backgroundColor = RGB(240, 240, 240);
    
    UIView *View1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 88)];
    View1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:View1];
    
    UILabel *noticeLable=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, SCREENWIDTH-30, 60)];
    noticeLable.text=@"提现金额将存入您的钱包，提现成功后可到我的钱包首页进行查看";
    noticeLable.numberOfLines=0;
    noticeLable.textColor=[UIColor lightGrayColor];
    noticeLable.font=[UIFont systemFontOfSize:15.0f];
    [View1 addSubview:noticeLable];
    NSArray *title_A = @[@"可提金额",@"提现金额"];
    
    UIView *View2 = [[UIView alloc]initWithFrame:CGRectMake(0, View1.bottom+10, SCREENWIDTH, title_A.count*45)];
    View2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:View2];
    
    for (int i = 0; i < title_A.count; i ++) {
        UILabel *title_lab = [[UILabel alloc]initWithFrame:CGRectMake(12, i*45, 100, 45)];
        title_lab.text = title_A[i];
        title_lab.textColor = RGB(51,51,51);
        title_lab.font = [UIFont systemFontOfSize:16];
        [View2 addSubview:title_lab];
        if (i==0) {
            allMoney_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-15, 45)];
            allMoney_lab.text = self.moneyString;
            allMoney_lab.textColor = RGB(153,153,153);
            allMoney_lab.font = [UIFont systemFontOfSize:16];
            allMoney_lab.textAlignment = NSTextAlignmentRight;
            [View2 addSubview:allMoney_lab];
        }
        if (i==1) {
            
            text_Field = [[UITextField alloc]initWithFrame:CGRectMake(SCREENWIDTH-215, 45+(45-30)/2, 200, 30)];
            text_Field.textAlignment= NSTextAlignmentRight;
            text_Field.delegate = self;
            text_Field.placeholder= @"提现金额(100的整数倍)";
            text_Field.textColor= RGB(51,51,51);
            text_Field.keyboardType = UIKeyboardTypeNumberPad;
            text_Field.clearsOnBeginEditing = YES;
            text_Field.font = [UIFont systemFontOfSize:16];
            [View2 addSubview:text_Field];
        }
    }
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(12, View2.bottom +37, SCREENWIDTH-24, 50);
    button.backgroundColor = NavBackGroundColor;
    [button setTitle:@"立即提现" forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.layer.cornerRadius =5;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:RGB(255,255,255) forState:0];
    [self.view addSubview: button];

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    int sss = [textField.text intValue]/100;
    
    text_Field.text = [NSString stringWithFormat:@"%d",sss*100];
    
    
}

//提现
-(void)sureClick{
    
    [text_Field resignFirstResponder];

    if ([text_Field.text floatValue]<=[allMoney_lab.text floatValue]) {
        
        
        NSString *ss = [NSString stringWithFormat:@"本次提现金额%@元",text_Field.text];
        
        
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:ss message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"提现" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self postRequest];
        }];
        [alertController addAction:cancle];
        [alertController addAction:sure];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"提现金额过大，请重新输入", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:1.f];
    }
}

-(void)postRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/withdrawRedPacket",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:text_Field.text forKey:@"sum"];
    NSLog(@"%@====%@",appdelegate.userInfoDic[@"uuid"],text_Field.text);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray* result)
     {
         NSLog(@"%@",result);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         //hud.frame = CGRectMake(0, 64, 375, 667);
         // Set the annular determinate mode to show task progress.
         hud.mode = MBProgressHUDModeText;
         
         hud.label.text = NSLocalizedString(@"提现成功", @"HUD message title");
         hud.label.font = [UIFont systemFontOfSize:13];
         // Move to bottm center.
         //    hud.offset = CGPointMake(0.f, );
         hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
         [hud hideAnimated:YES afterDelay:2.f];
         [text_Field resignFirstResponder];
         
         if ([_delegate respondsToSelector:@selector(bunosSuccess)]) {
             [_delegate bunosSuccess];
         }
         [self performSelector:@selector(goBack) withObject:nil afterDelay:2];
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         //hud.frame = CGRectMake(0, 64, 375, 667);
         // Set the annular determinate mode to show task progress.
         hud.mode = MBProgressHUDModeText;
         
         hud.label.text = NSLocalizedString(@"提现失败", @"HUD message title");
         hud.label.font = [UIFont systemFontOfSize:13];
         // Move to bottm center.
         //    hud.offset = CGPointMake(0.f, );
         hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
         [hud hideAnimated:YES afterDelay:2.f];
     }];
    
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
