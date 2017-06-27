//
//  MealCardPayVC.m
//  BletcShop
//
//  Created by Bletc on 2017/6/27.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "MealCardPayVC.h"
#import "CardDetailShowProdictCell.h"
#import "PayCustomView.h"
#import "AccessCodeVC.h"
#import "UIImageView+WebCache.h"

@interface MealCardPayVC ()<UITableViewDelegate,UITableViewDataSource,PayCustomViewDelegate>
{
    NSInteger selectRow;
    PayCustomView * Payview;
}
@property (weak, nonatomic) IBOutlet UITableView *table_view;

@property(nonatomic,strong)NSArray *data_A;
@end

@implementation MealCardPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"套餐卡支付";
    self.table_view.estimatedRowHeight = 100;
    self.table_view.rowHeight = UITableViewAutomaticDimension;
    
    [self getDataPost];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_A.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CardDetailShowProdictCell *cell =[tableView dequeueReusableCellWithIdentifier:@"CardDetailShowCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CardDetailShowProdictCell" owner:self options:nil] firstObject];
        cell.selectImg.hidden = NO;
    }
    
    NSDictionary *dic = _data_A[indexPath.row];
    
    
    cell.productName.text=[NSString stringWithFormat:@"%@",dic[@"name"]];
    cell.productPrice.text=[NSString stringWithFormat:@"%@元/次  (剩余%@次)",dic[@"price"],dic[@"option_count"]];
    NSURL * nurl1=[[NSURL alloc] initWithString:[[NSString stringWithFormat:@"%@%@",PRODUCT_IMAGE,dic[@"image"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [cell.productImage sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
    
    
    
    if (indexPath.row ==selectRow) {
        cell.selectImg.image = [UIImage imageNamed:@"settlement_choose_n"];
    }else{
        cell.selectImg.image = [UIImage imageNamed:@"settlement_unchoose_n"];
 
    }
    return cell;
    
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectRow = indexPath.row;
    [self.table_view reloadData];
    
    
    
}
- (IBAction)goToBuy:(id)sender {
    
    
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
            
            
            NSDictionary *dic =self.data_A[selectRow];
              [self payRequest:dic];
            
            
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

-(void)payRequest:(NSDictionary*)option_dic{
    NSString *url = [NSString stringWithFormat:@"%@UserType/MealCard/pay",BASEURL];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:app.userInfoDic[@"uuid"] forKey:@"uuid"];
    [paramer setValue:self.card_dic[@"merchant"] forKey:@"muid"];
    [paramer setValue:self.card_dic[@"card_code"] forKey:@"code"];
    [paramer setValue:option_dic[@"option_id"] forKey:@"option_id"];
    
    
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
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
-(void)getDataPost{
    
    
    [self showHudInView:self.view hint:@"加载中..."];
    
    NSString *url = [NSString stringWithFormat:@"%@UserType/MealCard/getOption",BASEURL];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.card_dic[@"merchant"] forKey:@"muid"];

    [paramer setValue:app.userInfoDic[@"uuid"] forKey:@"uuid"];
    [paramer setValue:self.card_dic[@"card_code"] forKey:@"code"];

    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [self hideHud];
        
        
        self.data_A = result;
        
        [self.table_view reloadData];
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [self hideHud];

    }];

}


-(NSArray *)data_A{
    if (!_data_A) {
        _data_A = [NSArray array];
    }
    return _data_A;
}
@end
