//
//  GetMoneySuccessVC.m
//  BletcShop
//
//  Created by Bletc on 2016/11/23.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "GetMoneySuccessVC.h"

@interface GetMoneySuccessVC ()
@property (weak, nonatomic) IBOutlet UILabel *money_lab;
@property (weak, nonatomic) IBOutlet UILabel *dateTime_lab;
@property (weak, nonatomic) IBOutlet UILabel *bank_lab;

@end

@implementation GetMoneySuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"交易详情";
    NSLog(@"------%@",self.dic);
    
    self.money_lab.text = [NSString getTheNoNullStr:_dic[@"sum"] andRepalceStr:@""];
    self.dateTime_lab.text = [NSString getTheNoNullStr:_dic[@"date"] andRepalceStr:@""];
    self.bank_lab.text = [NSString getTheNoNullStr:_dic[@"bank"] andRepalceStr:@""];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
