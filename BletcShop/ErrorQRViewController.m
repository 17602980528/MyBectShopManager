//
//  ErrorQRViewController.m
//  BletcShop
//
//  Created by Bletc on 2016/12/7.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ErrorQRViewController.h"

@interface ErrorQRViewController ()

@end

@implementation ErrorQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扫描结果";
    
    self.errrotextView.text = self.errorString;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
