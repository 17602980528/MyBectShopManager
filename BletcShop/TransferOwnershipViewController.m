//
//  TransferOwnershipViewController.m
//  BletcShop
//
//  Created by apple on 17/1/11.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "TransferOwnershipViewController.h"
#import "CheckTransferStateAndEditOrRemoveCardViewController.h"
@interface TransferOwnershipViewController ()

@end

@implementation TransferOwnershipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"会员卡转让";
    self.view.backgroundColor=RGB(240, 240, 240);
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, SCREENHEIGHT-64-10-90)];
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    NSArray *titleArray=@[@"会员卡编号",@"会员卡类型",@"会员卡级别",@"余额",@"转让金额",@"折扣率(%)"];
    NSLog(@"%@",self.dic);
    NSMutableArray *contentArray=[[NSMutableArray alloc]initWithCapacity:0];
    for (int i=0; i<6; i++) {
        if (i==0) {
            [contentArray addObject:self.dic[@"card_code"]];
        }else if (i==1){
            [contentArray addObject:self.dic[@"card_type"]];
        }else if (i==2){
            [contentArray addObject:self.dic[@"card_level"]];
        }else if (i==3){
            [contentArray addObject:self.dic[@"card_remain"]];
        }else if (i==4){
            [contentArray addObject:@""];
        }else if (i==5){
            [contentArray addObject:@""];
        }
    }
    for (int i=0; i<6; i++) {
        
        UILabel *cardCode=[[UILabel alloc]initWithFrame:CGRectMake(15, i*44, 95, 43)];
        cardCode.textAlignment=0;
        cardCode.text=titleArray[i];
        cardCode.font=[UIFont systemFontOfSize:16.0f];
        [bgView addSubview:cardCode];
        
        if (i==5) {
            UITextField *discountTF=[[UITextField alloc]initWithFrame:CGRectMake(120, i*44, SCREENWIDTH-120, 43)];
            discountTF.keyboardType=UIKeyboardTypeNumberPad;
            discountTF.placeholder=@"请输入您的折扣：1～100";
            [bgView addSubview:discountTF];
            discountTF.tag=10086;
        }else{
            UILabel *codeLable=[[UILabel alloc]initWithFrame:CGRectMake(120, i*44, SCREENWIDTH-120, 43)];
            codeLable.text=contentArray[i];
            codeLable.font=[UIFont systemFontOfSize:16.0f];
            codeLable.textAlignment=0;
            [bgView addSubview:codeLable];
            if (i==4) {
                codeLable.tag=10010;
            }
        }
        UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(15, i*44+43, SCREENWIDTH-30, 1)];
        line1.backgroundColor=RGB(234, 234, 234);
        [bgView addSubview:line1];
        
    }
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius=5.0f;
    button.clipsToBounds=YES;
    button.frame=CGRectMake(12, 310, SCREENWIDTH-24, 50);
    button.backgroundColor=NavBackGroundColor;
    [button setTitle:@"确定转让" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:18.0f];
    [bgView addSubview:button];
    [button addTarget:self action:@selector(transferOwnership) forControlEvents:UIControlEventTouchUpInside];
}
//转让
-(void)transferOwnership{
   
    UILabel *realMoney=[self.view viewWithTag:10010];
    UITextField *tf=[self.view viewWithTag:10086];
    CGFloat money=[self.dic[@"card_remain"] floatValue];
    CGFloat lastMoney=money *[tf.text floatValue]/100;
    realMoney.text=[NSString stringWithFormat:@"%.2f",lastMoney];
    [tf resignFirstResponder];
    if (tf.text.length>0) {
        if ([tf.text floatValue]<=100) {
            [self postRequest:self.dic[@"card_remain"] disCount:tf.text realMoney:realMoney.text];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"转让折扣率不能大于100", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:1.f];
        }
        
    }else{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请输入转让折扣率", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:1.f];
    }
}
-(void)postRequest:(NSString *)money disCount:(NSString *)disCount realMoney:(NSString *)realMoney
{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/upToTransfer",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.dic[@"merchant"] forKey:@"muid"];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:self.dic[@"card_code"] forKey:@"cardCode"];
    [params setObject:self.dic[@"card_type"] forKey:@"cardType"];
    [params setObject:self.dic[@"card_temp_color"] forKey:@"image_url"];
    [params setObject:self.dic[@"card_level"] forKey:@"cardLevel"];
    [params setObject:money forKey:@"sum"];
    [params setObject:disCount forKey:@"rate"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         
         NSLog(@"======%@",result);
         if ([result[@"result_code"] integerValue]==1) {
             //去下个页面
             CheckTransferStateAndEditOrRemoveCardViewController *vc=[[CheckTransferStateAndEditOrRemoveCardViewController alloc]init];
             vc.index=0;
             vc.realMoney=realMoney;
             vc.disCount=disCount;
             vc.dic=self.dic;
             vc.state=1;
             [self.navigationController pushViewController:vc animated:YES];
         }else if ([result[@"result_code"] integerValue]==1062){
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.label.text = NSLocalizedString(@"该卡已转让或已分享", @"HUD message title");
             hud.label.font = [UIFont systemFontOfSize:13];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             [hud hideAnimated:YES afterDelay:1.f];
             
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    
    
    
//    NSString *urlRate =[[NSString alloc]initWithFormat:@"%@UserType/card/rateSet",BASEURL];
//    NSMutableDictionary *paramss = [NSMutableDictionary dictionary];
//    [paramss setObject:self.dic[@"merchant"] forKey:@"muid"];
//    [paramss setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
//    [paramss setObject:self.dic[@"card_code"] forKey:@"cardCode"];
//    [paramss setObject:self.dic[@"card_level"] forKey:@"cardLevel"];
//    [paramss setObject:@"transfer" forKey:@"method"];
//    [paramss setObject:disCount forKey:@"rate"];
//    
//    [KKRequestDataService requestWithURL:urlRate params:paramss httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
//     {
//         
//         NSLog(@"======%@",result);
//         if ([result[@"result_code"] integerValue]==1) {
//             //去下个页面
//         }else if ([result[@"result_code"] integerValue]==1062){
//             
//             
//         }
//         
//     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"%@", error);
//     }];

    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    UILabel *realMoney=[self.view viewWithTag:10010];
    UITextField *tf=[self.view viewWithTag:10086];
    CGFloat money=[self.dic[@"card_remain"] floatValue];
    CGFloat lastMoney=money *[tf.text floatValue]/100;
    realMoney.text=[NSString stringWithFormat:@"%.2f",lastMoney];
    
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
