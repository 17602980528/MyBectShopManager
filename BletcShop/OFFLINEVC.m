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
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSDictionary *dic = @{@"muid":appdelegate.shopInfoDic[@"muid"],@"uuid":self.dic[@"uuid"],@"coupon_id":self.dic[@"coupon_id"]};
    
    NSString *codeString = [NSString dictionaryToJson:dic];

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
