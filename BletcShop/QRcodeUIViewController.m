//
//  QRcodeUIViewController.m
//  BletcShop
//
//  Created by Bletc on 16/8/16.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "QRcodeUIViewController.h"
#import "HGDQQRCodeView.h"

#import "ScanViewController.h"

@interface QRcodeUIViewController ()
@property (nonatomic,strong)  UIView *QRView;
@property (strong, nonatomic)  UILabel *msglabel;

@end

@implementation QRcodeUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"分享二维码";

    self.QRView = [[UIView alloc]initWithFrame:CGRectMake(20, 50, SCREENWIDTH-40, SCREENWIDTH-40)];
    [self.view addSubview:_QRView];
    
//    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//
//
//        NSString *codeString = [NSString stringWithFormat:@"http://101.201.100.191/VipCard/APP_HTML/register.html?phone=%@",appdelegate.userInfoDic[@"phone"]];
//

    
    
    [HGDQQRCodeView creatQRCodeWithURLString:self.codeString superView:self.QRView logoImage:[UIImage imageNamed:@"app_icon3"] logoImageSize:CGSizeMake(SCREENWIDTH*0.2, SCREENWIDTH*0.2) logoImageWithCornerRadius:0];
    
    
    
//    UIButton *getQRCode = [[UIButton alloc]init];
//    getQRCode.bounds= CGRectMake(0, 0, 100, 40);
//    getQRCode.center = CGPointMake(CGRectGetMidX(_QRView.frame), CGRectGetMaxY(_QRView.frame)+50);
//    
//    [getQRCode setTitleColor:[UIColor blueColor] forState:0];
//    [getQRCode setTitle:@"读取二维码" forState:0];
//    getQRCode.backgroundColor = [UIColor greenColor];
//    [getQRCode addTarget:self action:@selector(getQrCodeClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:getQRCode];
    
    


}

-(void)getQrCodeClick{
    
    ScanViewController  *VC = [[ScanViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
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
