//
//  UPgradeVC.m
//  BletcShop
//
//  Created by Bletc on 2016/11/21.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "UPgradeVC.h"
#import "PayMentController.h"
#import "ValuePickerView.h"

@interface UPgradeVC ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *card_level;
@property (weak, nonatomic) IBOutlet UILabel *price_lab;
@property (weak, nonatomic) IBOutlet UIButton *selectCard;

@property(nonatomic,strong)NSMutableArray *selectCard_A;//可升级卡数组
@property(copy,nonatomic)NSString   *level;//卡的级别
@property(copy,nonatomic)NSString   *adviceString;//提示语
@property (nonatomic, strong) ValuePickerView *pickerView;

@property float cha;

@end

@implementation UPgradeVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"升级";
    self.cha = 0.0;
    self.level =self.card_dic[@"card_level"];
    

    self.card_level.text = self.level;
    self.price_lab.text = @"0.00";
    
    for (int i=0; i<self.resultArray.count; i++) {
        
        
        NSString* price1 = [self.resultArray objectAtIndex:i][@"price"];
        if ([price1 floatValue]>[self.card_dic[@"price"] floatValue]) {
            [self.selectCard_A addObject:[self.resultArray objectAtIndex:i]];
        }
    }

    if (self.selectCard_A.count<1)
    {
        if([[UIDevice currentDevice].systemVersion floatValue]>=8.0)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的卡已是最高级别!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"您的卡已是最高级别！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }else{
        
        self.pickerView = [[ValuePickerView alloc]init];

    }

    

}
- (IBAction)goUPGradeClick:(UIButton *)sender {
    
    NSLog(@"升级");
    
    if ([self.price_lab.text floatValue]<self.cha)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"充值金额不够!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        
        [self postCardIfRequest];
        
        
    }

}
//此会员卡是否被办理过
-(void)postCardIfRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/stateGet",BASEURL];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:self.card_dic[@"merchant"] forKey:@"muid"];
    [params setObject:self.card_dic[@"card_code"] forKey:@"cardCode"];
    [params setObject:self.level forKey:@"cardLevel"];
    [params setObject:self.card_dic[@"card_type"] forKey:@"cardType"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"%@",result);
        
        
        if ([result[@"result_code"] isEqualToString:@"false"])
        {
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            appdelegate.payCardType = self.level;
            appdelegate.moneyText = self.price_lab.text;
            
            
            
            if ([self.adviceString isEqualToString:@"您的余额足够,可直接升级"]&&!(self.cha<0)) {
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:self.adviceString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];

                [alertView show];
                
            }
            else if([self.card_dic[@"card_type"] isEqualToString:self.level]){
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                
                hud.label.text = NSLocalizedString(@"您要升级的卡已存在,不能升级", @"HUD message title");
                hud.label.font = [UIFont systemFontOfSize:13];
                [hud hideAnimated:YES afterDelay:3.f];
                
            }else{
                [self choicePayType];
                
            }
            
            
        }else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"您要升级的卡已存在,不能升级", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            [hud hideAnimated:YES afterDelay:3.f];
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        [self postRequestUpgradeNoMoney];

    }
}
-(void)postRequestUpgradeNoMoney
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/setLevel",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:appdelegate.payCardType forKey:@"new_level"];
    
    
    [params setObject:appdelegate.cardInfo_dic[@"merchant"] forKey:@"muid"];
    [params setObject:appdelegate.cardInfo_dic[@"card_code"] forKey:@"cardCode"];
    [params setObject:appdelegate.cardInfo_dic[@"card_level"] forKey:@"cardLevel"];
    [params setObject:appdelegate.moneyText forKey:@"sum"];
    
    
    DebugLog(@"------%@",params);
    
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        UIViewController *view =[appdelegate getCurrentRootViewController];
        NSLog(@"%@", result);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if ([result[@"result_code"] intValue]==1) {
            hud.label.text = NSLocalizedString(@"升级成功", @"HUD message title");
            
            hud.label.font = [UIFont boldSystemFontOfSize:14];
            //    [hud setColor:[UIColor blackColor]];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            hud.userInteractionEnabled = YES;
            
            [hud hideAnimated:YES afterDelay:4.f];
            
            
            
            
            {
                NSMutableDictionary  *card_dic = [NSMutableDictionary dictionaryWithDictionary:appdelegate.cardInfo_dic];
                
                [card_dic setValue:self.level forKey:@"card_level"];
                appdelegate.cardInfo_dic =  card_dic;
                
            }
            
            
            
        }else
        {
            hud.label.text = NSLocalizedString(@"请求失败 请重试", @"HUD message title");
            
            hud.label.font = [UIFont systemFontOfSize:13];
            //    [hud setColor:[UIColor blackColor]];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            hud.userInteractionEnabled = YES;
            
            [hud hideAnimated:YES afterDelay:2.f];
            
            
        }
        [self performSelector:@selector(poptoview) withObject:nil afterDelay:4];
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
-(void)poptoview{
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] animated:YES];

}
//订单信息
-(void)choicePayType
{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appdelegate.moneyText = self.price_lab.text;
    
    PayMentController *VC = [[PayMentController alloc]init];
    VC.orderInfoType = 4;
    VC.level = self.level;
    VC.moneyString = self.price_lab.text;
    
    VC.card_dic = self.card_dic;
    [self.navigationController pushViewController:VC animated:YES];
    

}


- (IBAction)selectCardlevel:(UIButton *)sender {
    NSLog(@"选卡级别");
    
    
    NSMutableArray *muta_A = [NSMutableArray array];
    for (NSDictionary *dic in self.selectCard_A) {
        [muta_A addObject:dic[@"level"]];
        
    }
    
    
    self.pickerView.dataSource =muta_A;
    
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSLog(@"--------%@",value);
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        weakSelf.card_level.text= stateArr[0];
        
        
        NSDictionary *dic = weakSelf.selectCard_A[[stateArr[1] intValue]-1];
        
        weakSelf.card_level.text = dic[@"level"];
        weakSelf.level = dic[@"level"];
        weakSelf.price_lab.text = [NSString stringWithFormat:@"%.2f",[dic[@"price"] floatValue]];
        
        NSString *priceMy = weakSelf.card_dic[@"card_remain"];;
        
        
        
        if ([priceMy floatValue]>=[dic[@"price"] floatValue]) {
            weakSelf.adviceString = @"您的余额足够,可直接升级";
            weakSelf.cha = 0.00;
        }else if ([priceMy floatValue]<[dic[@"price"] floatValue]) {
            weakSelf.cha =[dic[@"price"] floatValue]-[priceMy floatValue];
            NSString *chaStr = [[NSString alloc]initWithFormat:@"您需要充值%.2f便可升级",weakSelf.cha];
            weakSelf.adviceString = chaStr ;
        }
        
        weakSelf.price_lab.text = [NSString stringWithFormat:@"%.2f",weakSelf.cha ];
    };
    
    [self.pickerView show];

}



-(NSMutableArray *)selectCard_A{
    if (!_selectCard_A) {
        _selectCard_A = [NSMutableArray array];
    }
    return _selectCard_A;
}

@end
