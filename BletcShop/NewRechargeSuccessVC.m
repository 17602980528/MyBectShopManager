//
//  NewRechargeSuccessVC.m
//  BletcShop
//
//  Created by Bletc on 2016/11/24.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NewRechargeSuccessVC.h"

@interface NewRechargeSuccessVC ()
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *money_lab;

@end

@implementation NewRechargeSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"交易结果";
    self.money_lab.text = self.money_s;
    self.sureBtn.hidden = YES;

}
- (IBAction)sureClick:(UIButton *)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
