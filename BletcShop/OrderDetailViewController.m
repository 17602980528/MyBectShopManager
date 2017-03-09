//
//  OrderDetailViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/3/9.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "OrderDetailViewController.h"

#import "SelectAddressViewController.h"
#import "LandingController.h"
@interface OrderDetailViewController ()<SelectAddressDelegate>

{
    NSDictionary *receiceInfo;
}
@property (weak, nonatomic) IBOutlet UILabel *acturePrice;
@property (strong, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UIImageView *product_img;
@property (weak, nonatomic) IBOutlet UILabel *product_name;
@property (weak, nonatomic) IBOutlet UILabel *product_price;
@property (weak, nonatomic) IBOutlet UILabel *product_count;
@property (weak, nonatomic) IBOutlet UIView *add_addressView;
@property (weak, nonatomic) IBOutlet UILabel *receive_p_name;
@property (weak, nonatomic) IBOutlet UILabel *receive_p_address;
@property (weak, nonatomic) IBOutlet UILabel *receive_p_phone;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    
    self.product_dic = @{ @"id":@"0001",
                          @"name":@"礼品",
                          @"image_url":@"33.png",
                          @"sum":@"100",
                          @"remain":@"90",
                          @"price":@"20",
                          @"href":@"http://192.168.0.1/index.html",
                          @"state":@"true"
                          
                          };
    
    self.product_name.text = self.product_dic[@"name"];
    self.product_price.text = self.product_dic[@"price"];
    self.acturePrice.text = self.product_dic[@"price"];


}


-(void)senderReceiceInfo:(NSDictionary *)dic{
    
    receiceInfo = dic;
    CGFloat orginY = self.add_addressView.frame.origin.y;
    
    [self.add_addressView removeFromSuperview];
    
    self.receive_p_name.text = dic[@"name"];
    self.receive_p_phone.text = dic[@"phone"];
    self.receive_p_address.text = [dic[@"eare"] stringByAppendingString:dic[@"detailPlace"]];

    self.addressView.frame = CGRectMake(0, orginY, SCREENWIDTH, self.receive_p_address.bottom+10);
    
    [self.view addSubview:self.addressView];
    
    
    NSLog(@"======%@===",dic);
}

- (IBAction)selectAddress:(UITapGestureRecognizer *)sender {
    
    
    
    SelectAddressViewController *VC= [[SelectAddressViewController alloc]init];
    
    VC.delegate = self;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)goToPay:(UIButton *)sender {
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.IsLogin) {
        
        if (!receiceInfo ) {
            
            [self showHudInView:self.view hint:@"请添加收货信息!"];
            
        }else{
            NSString *url = [NSString stringWithFormat:@"%@Extra/mall/exchange",BASEURL];
            
            NSMutableDictionary *paramer =[NSMutableDictionary dictionary];
            
            [paramer setObject:app.userInfoDic[@"uuid"] forKey:@"uuid"];
            [paramer setObject:self.product_dic[@"id"] forKey:@"goods_id"];
            [paramer setObject:self.acturePrice.text forKey:@"sum"];

            [paramer setObject:self.receive_p_address.text forKey:@"address"];
            
            
            
            NSLog(@"paramer------%@",paramer);
            
            [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
                NSLog(@"result----%@",result);
                NSString *message;
                
                if ([result[@"result_code"] integerValue]==1) {
                   message = @"您已兑换成功,商品准备发货!";
                }else{
                    
                    message = @"兑换失败!";
  
                }
               
                UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                
                
                [alt show];
                
            } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"error---%@",error);
            }];
            
        }
 
    }else{
        LandingController *VC = [[LandingController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    
    
    
}


@end
