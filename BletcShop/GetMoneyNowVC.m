//
//  GetMoneyNowVC.m
//  BletcShop
//
//  Created by Bletc on 2016/11/14.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "GetMoneyNowVC.h"
#import "BankListViewController.h"
#import "GetMoneySuccessVC.h"
#import "GetMoneyFailVC.h"


@interface GetMoneyNowVC ()<UITextFieldDelegate>
{
    UILabel *bankName;
    UILabel *bankAccount;
    UILabel *allMoney_lab;
    UITextField *text_Field;
}
@property(nonatomic,strong)NSArray*bankArray;  //绑定银行卡
@end

@implementation GetMoneyNowVC
-(NSArray *)bankArray{
    if (!_bankArray) {
        _bankArray = [NSArray array];
    }
    return _bankArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self postSocketMoney];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    
    self.view.backgroundColor = RGB(240, 240, 240);
    
    UIView *View1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 88)];
    View1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:View1];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectBank)];
    [View1 addGestureRecognizer:tap];
    
//    UIImageView *img_view = [[UIImageView alloc]initWithFrame:CGRectMake(13, 17, 52, 56)];
//    img_view.backgroundColor = [UIColor redColor];
//    img_view.hidden = YES;

//    [View1 addSubview:img_view];
    
     bankName = [[UILabel alloc]initWithFrame:CGRectMake(16, 19, SCREENWIDTH-(16), 16)];
    bankName.textColor = RGB(51,51,51);
    bankName.font = [UIFont systemFontOfSize:17];
    [View1 addSubview:bankName];
    
     bankAccount = [[UILabel alloc]initWithFrame:CGRectMake(16, 51, SCREENWIDTH-(16), 15)];
    bankAccount.textColor = RGB(153,153,153);
    bankAccount.font = [UIFont systemFontOfSize:15];
    [View1 addSubview:bankAccount];
    
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-10-7.5, (View1.height-15)/2, 7.5, 15)];
    imageView1.image = [UIImage imageNamed:@"arraw_right"];
    [View1 addSubview:imageView1];

    
    
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
            allMoney_lab.text = @"0.00";
            allMoney_lab.textColor = RGB(153,153,153);
            allMoney_lab.font = [UIFont systemFontOfSize:16];
            allMoney_lab.textAlignment = NSTextAlignmentRight;
            [View2 addSubview:allMoney_lab];
        }
        if (i==1) {
            
             text_Field = [[UITextField alloc]initWithFrame:CGRectMake(SCREENWIDTH-115, 45+(45-30)/2, 100, 30)];
            text_Field.textAlignment= NSTextAlignmentRight;
            text_Field.placeholder= @"输入提现金额";
            text_Field.textColor= RGB(51,51,51);
            text_Field.font = [UIFont systemFontOfSize:16];
            text_Field.delegate= self;
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

-(void)selectBank{
    NSLog(@"选择银行");
    BankListViewController *VC = [[BankListViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];

}
-(void)sureClick{
    NSLog(@"立即提现");
    if (text_Field.text.length==0) {
        [self tishi:@"请输入金额!"];
       

    }else if(![NSString isPureInt: text_Field.text]&&![NSString isPureFloat: text_Field.text]){
        [self tishi:@"请输入数字!"];
        
    }else
        
    if ([self.moneyString floatValue]>=[text_Field.text floatValue]) {
        [self postSocketGetMoney];

    }else{
        [self tishi:@"余额不足!"];

           }
    
}

-(void)postSocketGetMoney
{
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/withdraw",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:appdelegate.userInfoDic[@"nickname"] forKey:@"nickname"];
    [params setObject:text_Field.text forKey:@"sum"];
    [params setObject:[[self.bankArray objectAtIndex:0] objectForKey:@"name"] forKey:@"name"];
    [params setObject:[[self.bankArray objectAtIndex:0] objectForKey:@"bank"] forKey:@"bank"];
    [params setObject:[[self.bankArray objectAtIndex:0] objectForKey:@"number"] forKey:@"acount"];
    NSDateFormatter* matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date  = [NSDate date];
    NSString *NowDate = [matter stringFromDate:date];
    [params setObject:NowDate forKey:@"date"];
    NSLog(@"----%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        
        
        NSLog(@"resultresultresultresultresult%@", result);
        
        if ([result[@"result_code"] intValue]==1) {
            
            GetMoneySuccessVC *VC = [[GetMoneySuccessVC alloc]init];
            VC.dic = params;
            [self.navigationController pushViewController:VC animated:YES];

            
//            [self performSelector:@selector(loadAlterView) withObject:nil afterDelay:0.5];
           
        }else{
            
            GetMoneyFailVC *VC = [[GetMoneyFailVC alloc]init];
            [self.navigationController pushViewController:VC animated:YES];

//            UIAlertView *aletView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"申请失败!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [aletView show];
            
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
-(void)loadAlterView{
//    UIAlertView *a_aletView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"申请成功，三个工作日内，将转入您的银行账户" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [a_aletView show];
    
    GetMoneySuccessVC *VC = [[GetMoneySuccessVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    
    
    
}

-(void)postSocketMoney
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:@"remain" forKey:@"type"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        self.moneyString = [NSString getTheNoNullStr:result[@"remain"] andRepalceStr:@"0.00"];
        self.moneyString = [self.moneyString stringByReplacingOccurrencesOfString:@"元" withString:@""];
        [self postSocketBank];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
/**
 获取绑定银行卡
 */
-(void)postSocketBank
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/bank/bound",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        NSMutableArray *arr = [result copy];

        if (arr.count!=0) {
            
            
            self.bankArray = arr;
            
            bankName.text = arr[0][@"bank"];
            NSString *number_s = arr[0][@"number"];
            if (number_s.length>4) {
                number_s = [number_s substringFromIndex:number_s.length-4];
            }
            
            bankAccount.text =  [NSString stringWithFormat:@"尾号(%@)",number_s];
            allMoney_lab.text = self.moneyString;
 
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
       
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(void)tishi:(NSString *)tishi{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = NSLocalizedString(tishi, @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:2.f];

}
@end
