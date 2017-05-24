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
