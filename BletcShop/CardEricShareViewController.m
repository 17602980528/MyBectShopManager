//
//  CardEricShareViewController.m
//  BletcShop
//
//  Created by apple on 17/1/12.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CardEricShareViewController.h"
#import "CheckTransferStateAndEditOrRemoveCardViewController.h"

@interface CardEricShareViewController ()
{
    NSInteger rule;
}
@end

@implementation CardEricShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(240, 240, 240);
    self.navigationItem.title=@"会员卡分享";
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, SCREENHEIGHT-64-10-90)];
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    rule = 100- [self.dic[@"rule"] intValue];

    
    NSArray *titleArray=@[@"会员卡编号",@"会员卡类型",@"会员卡级别",@"手续费率(%)"];
   // NSLog(@"%@",self.dic);
    NSMutableArray *contentArray=[[NSMutableArray alloc]initWithCapacity:0];
    for (int i=0; i<4; i++) {
        if (i==0) {
            [contentArray addObject:self.dic[@"card_code"]];
        }else if (i==1){
            [contentArray addObject:self.dic[@"card_type"]];
        }else if (i==2){
            [contentArray addObject:self.dic[@"card_level"]];
        }else if (i==3){
            [contentArray addObject:self.dic[@"card_remain"]];
        }
        
    }
    for (int i=0; i<4; i++) {
        
        UILabel *cardCode=[[UILabel alloc]initWithFrame:CGRectMake(15, i*44, 95, 43)];
        cardCode.textAlignment=0;
        cardCode.text=titleArray[i];
        cardCode.font=[UIFont systemFontOfSize:16.0f];
        [bgView addSubview:cardCode];
        
        if (i==3) {
            UITextField *discountTF=[[UITextField alloc]initWithFrame:CGRectMake(120, i*44, SCREENWIDTH-120, 43)];
            discountTF.keyboardType=UIKeyboardTypeNumberPad;
            discountTF.placeholder=[NSString stringWithFormat:@"最高手续费率不超过%ld",rule];
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
    button.frame=CGRectMake(12, 44*4+36, SCREENWIDTH-24, 50);
    button.backgroundColor=NavBackGroundColor;
    [button setTitle:@"确定分享" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:18.0f];
    [bgView addSubview:button];
    [button addTarget:self action:@selector(shareOwnership) forControlEvents:UIControlEventTouchUpInside];
    
    
}
//
-(void)shareOwnership{
    
    UITextField *tf=[self.view viewWithTag:10086];
    [tf resignFirstResponder];
    
    
    
    if (tf.text.length>0) {
        if ([tf.text floatValue]<=rule) {
            [self postRequest:self.dic[@"card_remain"] disCount:tf.text];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = [NSString stringWithFormat:@"手续费率不能大于%ld",rule];
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:1.f];
        }
        
    }else{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请输入手续费率", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:1.f];
    }

}
-(void)postRequest:(NSString *)money disCount:(NSString *)discount
{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/upToShare",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.dic[@"merchant"] forKey:@"muid"];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:self.dic[@"card_code"] forKey:@"cardCode"];
    [params setObject:self.dic[@"card_type"] forKey:@"cardType"];
    [params setObject:self.dic[@"card_temp_color"] forKey:@"image_url"];
    [params setObject:self.dic[@"card_level"] forKey:@"cardLevel"];
    [params setObject:money forKey:@"sum"];
    [params setObject:discount forKey:@"rate"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         
         NSLog(@"======%@",result);
         if ([result[@"result_code"] integerValue]==1) {
             //去下个页面
             CheckTransferStateAndEditOrRemoveCardViewController *vc=[[CheckTransferStateAndEditOrRemoveCardViewController alloc]init];
             vc.index=1;
             vc.disCount=discount;
             vc.state=1;
             vc.dic=self.dic;
             [self.navigationController pushViewController:vc animated:YES];
         }else if ([result[@"result_code"] integerValue]==1062){
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.label.text = NSLocalizedString(@"该卡已分享或已转让", @"HUD message title");
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
//    [paramss setObject:@"share" forKey:@"method"];
//    [paramss setObject:discount forKey:@"rate"];
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
