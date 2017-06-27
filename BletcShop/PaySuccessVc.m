//
//  PaySuccessVc.m
//  BletcShop
//
//  Created by Bletc on 2016/11/23.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "PaySuccessVc.h"
#import "CardVipController.h"

@interface PaySuccessVc ()
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *card_level;
@property (weak, nonatomic) IBOutlet UILabel *card_code;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *topBackView;

@end

@implementation PaySuccessVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"交易结果";
    NSString *string = @"购买成功，获得300积分";
    NSLog(@"-----%@",self.card_dic);
    
    self.card_code.text = self.card_dic[@"card_code"];

    if (self.orderInfoType==1) {
        self.sureButton.hidden= YES;
        string = [NSString stringWithFormat:@"购买成功，获得%d积分",(int)[self.money_str floatValue]];
        
        self.card_level.text = [NSString stringWithFormat:@"%@会员",self.card_dic[@"level"]];
        self.card_code.text = self.card_dic[@"code"];

        
    }


    if (self.orderInfoType==2) {
       string = [NSString stringWithFormat:@"续卡成功，获得%d积分",(int)[self.money_str floatValue]];
        self.card_level.text = [NSString stringWithFormat:@"%@会员",self.card_dic[@"card_level"]];


    }
    if (self.orderInfoType==4) {
        string = [NSString stringWithFormat:@"升级成功，获得%d积分",(int)[self.money_str floatValue]];
        self.card_level.text = [NSString stringWithFormat:@"%@会员",self.type_new];

        
    }

    

    UILabel *lable =[[UILabel alloc]init];
    lable.text = string;
    lable.textColor = RGB(51,51,51);
    lable.font = [UIFont systemFontOfSize:21];
    CGFloat ww = [lable.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lable.font} context:nil].size.width;
    
    lable.frame = CGRectMake((SCREENWIDTH-ww)/2+10, (167-21)/2, ww, 21);
    [self.topBackView addSubview:lable];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-ww)/2-27, (167-27)/2, 27, 27)];
    imgView.image = [UIImage imageNamed:@"checkbox_yes"];
    [self.topBackView addSubview:imgView];
    

    

    [self getShopName];
    

}
- (IBAction)sureClick:(UIButton *)sender {
    
 
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/**
 获取商户名
 */
-(void)getShopName{
    
    

    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/accountGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.card_dic[@"muid"] forKey:@"muid"];
    [params setValue:@"store" forKey:@"type"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result----%@",result);
        self.shopName.text = [NSString getTheNoNullStr:result[@"store"] andRepalceStr:@""];
        
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}

@end
