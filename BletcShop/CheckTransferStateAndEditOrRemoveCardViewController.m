//
//  CheckTransferStateAndEditOrRemoveCardViewController.m
//  BletcShop
//
//  Created by apple on 17/1/11.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CheckTransferStateAndEditOrRemoveCardViewController.h"

@interface CheckTransferStateAndEditOrRemoveCardViewController ()<UIAlertViewDelegate>

@end

@implementation CheckTransferStateAndEditOrRemoveCardViewController
{
    __block UILabel *cardDiscount;
    __block UILabel *cardRealMoney;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=RGB(240, 240, 240);
    
    self.navigationItem.title=@"转让状态";
    if (self.index==1 && self.state ==0) {
        self.navigationItem.title=@"分享状态";

    }
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 216)];
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *businessState=[[UILabel alloc]initWithFrame:CGRectMake(18, 13, 100, 14)];
    businessState.text=@"交易状态";
    businessState.font=[UIFont systemFontOfSize:15.0f];
    businessState.textAlignment=NSTextAlignmentLeft;
    businessState.textColor=RGB(102, 102, 102);
    [bgView addSubview:businessState];
    
    UILabel *businessStatess=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-63, 13, 50, 14)];
    
    businessStatess.font=[UIFont systemFontOfSize:15.0f];
    businessStatess.textAlignment=NSTextAlignmentLeft;
    businessStatess.textColor=RGB(102, 102, 102);
    [bgView addSubview:businessStatess];
    
    UILabel *shopName=[[UILabel alloc]initWithFrame:CGRectMake(18, 48, SCREENWIDTH-18, 14)];
    shopName.text=[NSString stringWithFormat:@"店铺名称：%@",[NSString getTheNoNullStr:self.dic[@"store"] andRepalceStr:@""]];
    shopName.font=[UIFont systemFontOfSize:15.0f];
    shopName.textAlignment=NSTextAlignmentLeft;
    shopName.textColor=RGB(102, 102, 102);
    [bgView addSubview:shopName];
    
    UILabel *cardStyle=[[UILabel alloc]initWithFrame:CGRectMake(18, 75, SCREENWIDTH-18, 14)];
    cardStyle.text=[NSString stringWithFormat:@"卡片类型：%@-%@",[NSString getTheNoNullStr:self.dic[@"card_level"] andRepalceStr:@""],[NSString getTheNoNullStr:self.dic[@"card_type"] andRepalceStr:@""]];
    cardStyle.font=[UIFont systemFontOfSize:15.0f];
    cardStyle.textAlignment=NSTextAlignmentLeft;
    cardStyle.textColor=RGB(102, 102, 102);
    [bgView addSubview:cardStyle];
    
    UILabel *cardRetain=[[UILabel alloc]initWithFrame:CGRectMake(18, 102, SCREENWIDTH-18, 14)];
    cardRetain.text=[NSString stringWithFormat:@"卡片余额：%@",[NSString getTheNoNullStr:self.dic[@"card_remain"] andRepalceStr:@""]];
    cardRetain.font=[UIFont systemFontOfSize:15.0f];
    cardRetain.textAlignment=NSTextAlignmentLeft;
    cardRetain.textColor=RGB(102, 102, 102);
    [bgView addSubview:cardRetain];
    
    CGFloat discount_new=[[NSString getTheNoNullStr:self.disCount andRepalceStr:@"0.0"] floatValue]/10.0f;
    cardDiscount=[[UILabel alloc]initWithFrame:CGRectMake(18, 130, SCREENWIDTH/2-18, 14)];
    
    cardDiscount.font=[UIFont systemFontOfSize:15.0f];
    cardDiscount.textAlignment=NSTextAlignmentLeft;
    cardDiscount.textColor=RGB(102, 102, 102);
    [bgView addSubview:cardDiscount];
    
    cardRealMoney=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-138, 130, 120, 14)];
    cardRealMoney.font=[UIFont systemFontOfSize:15.0f];
    cardRealMoney.textAlignment=NSTextAlignmentCenter;
    cardRealMoney.textColor=RGB(241,49,18);
    [bgView addSubview:cardRealMoney];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(17, 163, SCREENWIDTH-34, 1)];
    lineView.backgroundColor=RGB(246,246,246);
    [bgView addSubview:lineView];
    
//    UIButton *editBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    editBtn.frame=CGRectMake(SCREENWIDTH-76*2-22-20, 177, 76, 30);
//    editBtn.layer.cornerRadius=3.0f;
//    [editBtn setTitleColor:RGB(102,102,102) forState:UIControlStateNormal];
//    editBtn.clipsToBounds=YES;
//    editBtn.layer.borderColor=[RGB(204,204,204)CGColor];
//    editBtn.layer.borderWidth=1.0f;
//    [editBtn setTitle:@"编辑内容" forState:UIControlStateNormal];
//    editBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
//    [bgView addSubview:editBtn];
//    [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cancerBtn.frame=CGRectMake(SCREENWIDTH-76-22, 177, 76, 30);
    cancerBtn.layer.cornerRadius=3.0f;
    [cancerBtn setTitleColor:RGB(102,102,102) forState:UIControlStateNormal];
    cancerBtn.clipsToBounds=YES;
    cancerBtn.layer.borderColor=[RGB(204,204,204)CGColor];
    cancerBtn.layer.borderWidth=1.0f;
    cancerBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [bgView addSubview:cancerBtn];
    [cancerBtn addTarget:self action:@selector(cancerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    if (self.index==0) {
         businessStatess.text=@"转让中";
        cardDiscount.text=[NSString stringWithFormat:@"转让折扣： %.1f折",discount_new];
        [cancerBtn setTitle:@"取消转让" forState:UIControlStateNormal];
        if (self.state==0) {
            cardRealMoney.text=[NSString stringWithFormat:@"￥: %@",[NSString getTheNoNullStr:_realMoney andRepalceStr:@"0.0"]];
        }else if (self.state==1){
            cardRealMoney.text=[NSString stringWithFormat:@"￥: %@",_realMoney];
        }
        
    }else if (self.index==1){
        businessStatess.text=@"分享中";
        cardRealMoney.text = @"";
        cardDiscount.text=[NSString stringWithFormat:@"分享收益率： %@%%",self.disCount];
        [cancerBtn setTitle:@"取消分享" forState:UIControlStateNormal];
    }
    
    [self acccessDiscout];
}
////编辑内容
//-(void)editBtnClick{
//    
//    NSString *notice=@"";
//    if (self.index==0) {
//        notice=@"编辑会取消转让，是否继续？";
//    }else if (self.index==1){
//        notice=@"编辑会取消分享，是否继续？";
//    }
//    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:notice delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
//    [alertView show];
//}
//取消转让
-(void)cancerBtnClick{
    
    if (_index==0) {
        [self postRequest:@"transfer"];
    }else if (_index==1){
        [self postRequest:@"share"];
    }
}

-(void)postRequest:(NSString *)transferOrShare
{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/moveFromMarket",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.dic[@"merchant"] forKey:@"muid"];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:self.dic[@"card_code"] forKey:@"cardCode"];
    [params setObject:self.dic[@"card_level"] forKey:@"cardLevel"];
    [params setObject:transferOrShare forKey:@"method"];
    NSLog(@"%@",params);
    NSLog(@"%@",self.navigationController.viewControllers);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {//pop 出时判断state决定返回那一层
         
         NSLog(@"======%@",result);
         
         if ([result[@"result_code"] integerValue]==1) {
             if (_state==0) {
                 [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
             }else if (_state==1){
                 [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
             }
            
         }else if ([result[@"result_code"] integerValue]==1062){
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.label.text = NSLocalizedString(@"请勿重复取消", @"HUD message title");
             hud.label.font = [UIFont systemFontOfSize:13];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             [hud hideAnimated:YES afterDelay:2.f];
         }else if ([result[@"result_code"] integerValue]==0){
             
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    
}
-(void)acccessDiscout{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/rateGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.dic[@"merchant"] forKey:@"muid"];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:self.dic[@"card_code"] forKey:@"cardCode"];
    [params setObject:self.dic[@"card_level"] forKey:@"cardLevel"];
    if (_index==0) {
        [params setObject:@"transfer" forKey:@"method"];
    }else if (_index==1){
        [params setObject:@"share" forKey:@"method"];
    }
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         
         NSLog(@"======%@",result);
         if (result) {

             
             CGFloat realmoney= [self.dic[@"card_remain"]floatValue]*[result[@"rate"] integerValue]/100.0f;
             cardRealMoney.text=[NSString stringWithFormat:@"￥: %.2f",realmoney];
             
             if (self.index ==0) {
                 cardDiscount.text=[NSString stringWithFormat:@"转让折扣： %.1f折",[result[@"rate"] integerValue]/10.0f];

             }else{
                 cardDiscount.text=[NSString stringWithFormat:@"分享收益率： %@%%",result[@"rate"]];
                 cardRealMoney.text = @"";

             }
            
         }else if ([result[@"result_code"] integerValue]==1062){
            
             
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex==1) {
        //取消转让并编辑
        
    }
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
