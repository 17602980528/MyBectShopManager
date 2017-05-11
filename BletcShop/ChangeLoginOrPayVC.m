//
//  ChangeLoginOrPayVC.m
//  BletcShop
//
//  Created by apple on 2017/5/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ChangeLoginOrPayVC.h"
#import "NewChangePsWordViewController.h"
#import "RealChooseChangePayPassVC.h"
@interface ChangeLoginOrPayVC ()

@end

@implementation ChangeLoginOrPayVC
- (IBAction)changeLoginClick:(id)sender {
    NewChangePsWordViewController *passVC=[[NewChangePsWordViewController alloc]init];
    [self.navigationController pushViewController:passVC animated:YES];
}
- (IBAction)changePayClick:(id)sender {
    RealChooseChangePayPassVC *passVC=[[RealChooseChangePayPassVC alloc]init];
    [self.navigationController pushViewController:passVC animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
