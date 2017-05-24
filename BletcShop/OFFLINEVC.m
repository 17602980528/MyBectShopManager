//
//  OFFLINEVC.m
//  BletcShop
//
//  Created by apple on 2017/5/22.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "OFFLINEVC.h"
#import "HGDQQRCodeView.h"
@interface OFFLINEVC ()
@property (nonatomic,strong)  UIView *QRView;
@end

@implementation OFFLINEVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"优惠券二维码";
    
    self.QRView = [[UIView alloc]initWithFrame:CGRectMake(20, 50, SCREENWIDTH-40, SCREENWIDTH-40)];
    [self.view addSubview:_QRView];
    
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:self.dic[@"uuid"],@"uuid",self.dic[@"coupon_id"],@"coupon_id", nil];
    NSString *codeString = [NSString dictionaryToJson:infoDic];

    [HGDQQRCodeView creatQRCodeWithURLString:codeString superView:self.QRView logoImage:[UIImage imageNamed:@"app_icon3"] logoImageSize:CGSizeMake(SCREENWIDTH*0.2, SCREENWIDTH*0.2) logoImageWithCornerRadius:0];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, self.QRView.bottom+30, SCREENWIDTH-24, 40)];
    label.text=@"提示：该二维码仅供用户进店消费时，提供给商户扫描，商户扫描成功后，可抵扣对应面额的现金优惠。";
    label.numberOfLines=0;
    label.font=[UIFont systemFontOfSize:13.0f];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor blueColor];
    [self.view addSubview:label];
    
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
