//
//  GetMoneyVC.m
//  BletcShop
//
//  Created by Bletc on 16/9/20.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "GetMoneyVC.h"

@interface GetMoneyVC ()<UITextFieldDelegate,UIAlertViewDelegate>

@property(nonatomic,weak)UITextField *moneyText;;

@end

@implementation GetMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(243, 243, 243);
    self.navigationItem.title = @"提现";
    UIView *bigBackView=[[UIView alloc]initWithFrame:CGRectMake(15, 20, SCREENWIDTH-30, 206)];
    bigBackView.layer.cornerRadius=16;
    bigBackView.clipsToBounds=YES;
    [self.view addSubview:bigBackView];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UILabel*account_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-30, 44)];
    account_lab.backgroundColor = RGB(234, 234, 234);

    NSString *account =app.shopInfoDic[@"account"];
    
    NSRange range = NSMakeRange(account.length-3, 3);
    account = [account substringWithRange:range];
    account_lab.text = [NSString stringWithFormat:@"  银行卡   %@(%@)",app.shopInfoDic[@"bank"],account];
    account_lab.font = [UIFont systemFontOfSize:18];
    account_lab.textColor = [UIColor darkGrayColor];
    [bigBackView addSubview:account_lab];
    
    
    UIView *back_view = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREENWIDTH-30, 84.5)];
    back_view.backgroundColor=[UIColor whiteColor];
    [bigBackView addSubview:back_view];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, back_view.height/2)];
    lable.text = @"提现金额";
    lable.font = [UIFont systemFontOfSize:18];
    lable.textColor = [UIColor darkGrayColor];
    [back_view addSubview:lable];
    
    UILabel *monLab=[[UILabel alloc]initWithFrame:CGRectMake(30, back_view.height/2, 30, 30)];
    monLab.text=@"￥";
    monLab.textColor=[UIColor darkGrayColor];
    monLab.font=[UIFont systemFontOfSize:24.0f];
    [back_view addSubview:monLab];
    
    UITextField *shangjiaText = [[UITextField alloc]initWithFrame:CGRectMake(60, back_view.height/2, SCREENWIDTH-50-40, 30)];
    

    shangjiaText.borderStyle = UITextBorderStyleNone;
    shangjiaText.delegate = self;
    shangjiaText.tag = 101;
    shangjiaText.textColor=[UIColor darkGrayColor];
    shangjiaText.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    shangjiaText.font = [UIFont systemFontOfSize:24];

    self.moneyText = shangjiaText;
    [back_view addSubview:shangjiaText];
    
    
    UIView *back_view1 = [[UIView alloc]initWithFrame:CGRectMake(0, back_view.bottom, SCREENWIDTH, 84)];
    back_view1.backgroundColor=[UIColor whiteColor];
    [bigBackView addSubview:back_view1];
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(15, 80, SCREENWIDTH-30-30, 1)];
    line.backgroundColor= RGB(234, 234, 234);
    [back_view addSubview:line];
    
    UILabel *lab_m = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREENWIDTH, 20)];
    lab_m.textColor= [UIColor grayColor];
    lab_m.text = [NSString stringWithFormat:@"当前零钱余额%@,",self.sum_string];
    lab_m.font =[UIFont systemFontOfSize:14];
    [back_view1 addSubview:lab_m];
    CGFloat www = [lab_m.text boundingRectWithSize:CGSizeMake(SCREENWIDTH, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lab_m.font} context:nil].size.width;
    lab_m.frame =CGRectMake(15, 1, www, 20);
    
    LZDButton *all_btn = [LZDButton creatLZDButton];
    all_btn.frame = CGRectMake(lab_m.right, 0, 80, 20);
    [all_btn setTitle:@"全部提现" forState:0];
    [all_btn setTitleColor:NavBackGroundColor forState:0];
    all_btn.titleLabel.font = lab_m.font;
    [back_view1 addSubview:all_btn];
    
    all_btn.block = ^(LZDButton*b){
        self.moneyText.text = [self.sum_string componentsSeparatedByString:@"元"][0];
    };
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, lab_m.bottom, SCREENWIDTH, 63)];
    lab.text = @"预计24小时内到账";
    lab.font=[UIFont systemFontOfSize:14.0f];
    lab.textColor = [UIColor grayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [back_view1 addSubview:lab];
    
    LZDButton *btn = [LZDButton creatLZDButton];
    btn.frame = CGRectMake(20, back_view1.bottom+50, SCREENWIDTH-40, 44);
    [btn setTitle:@"确定" forState:0];
    btn.backgroundColor = NavBackGroundColor;
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds= YES;
    [self.view addSubview:btn];
    btn.block = ^(LZDButton *b){
        
        NSString* sum = [self.sum_string componentsSeparatedByString:@"元"][0];
        
        if([self.moneyText.text isEqualToString:@""])
        {
            [self tishi:@"请填写提现金额"];
            
        }else if([self.moneyText.text floatValue]<=0.000)
        {
            [self tishi:@"提现金额不能少于零"];
            
        }else if ([self.moneyText.text floatValue]>[sum floatValue]){
            [self tishi:@"可提现金额不足"];
            
        }else{
            [self rigmAction];
            
        }
        
    };
    
    
}

-(void)rigmAction

{
    NSString *ss = [NSString stringWithFormat:@"确定提现%@元",_moneyText.text];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:ss preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"提现" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self postRequest];
        
    }];

    
    [alertController addAction:cancel];
    [alertController addAction:sure];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    
   }

-(void)postRequest{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/withdrawApp",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //    [params setObject:[appdelegate.shopUserInfoArray objectAtIndex:0] forKey:@"merchant"];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:self.moneyText.text forKey:@"sum"];
    
    //    NSDateFormatter* matter = [[NSDateFormatter alloc]init];
    //    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSDate* date  = [NSDate date];
    //    NSString *NowDate = [matter stringFromDate:date];
    //    [params setObject:NowDate forKey:@"date"];
    
    NSLog(@"params==%@", params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);
        NSDictionary *dic = (NSDictionary *)result;
        if ([dic[@"result_code"] intValue]==1) {
            
            [self showTiShi:@"提现申请成功,三个工作日到账?" LeftBtn_s:@"确定" RightBtn_s:@""];
            
            
        }
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    

}
-(void)tishi:(NSString*)str{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = NSLocalizedString(str, @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    [hud hideAnimated:YES afterDelay:3.f];
}

-(void)showTiShi:(NSString *)content LeftBtn_s:(NSString*)left RightBtn_s:(NSString*)right{
    
    
    UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:left otherButtonTitles: nil];
    
    altView.tag =9999;
    [altView show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==9999) {
        if (buttonIndex==0) {
            
            self.block();
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
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
