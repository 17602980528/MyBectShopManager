//
//  RealChooseChangePayPassVC.m
//  BletcShop
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "RealChooseChangePayPassVC.h"
#import "ChangePayPassVC.h"
#import "CheckOldPassVC.h"
#import "AccessCodeVC.h"
@interface RealChooseChangePayPassVC ()

@property (strong, nonatomic) IBOutlet UILabel *payPassTitle;
@end

@implementation RealChooseChangePayPassVC
- (IBAction)changePayClick:(id)sender {
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if ([appdelegate.userInfoDic[@"pay_passwd"] isEqualToString:@"未设置"]) {
        ChangePayPassVC *passVC=[[ChangePayPassVC alloc]init];
        [self.navigationController pushViewController:passVC animated:YES];
    }else{
        CheckOldPassVC *passVC=[[CheckOldPassVC alloc]init];
        [self.navigationController pushViewController:passVC animated:YES];
    }
    
}
- (IBAction)forgotPayPwd:(id)sender {
    AccessCodeVC *forgotVC=[[AccessCodeVC alloc]init];
    [self.navigationController pushViewController:forgotVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if ([appdelegate.userInfoDic[@"pay_passwd"] isEqualToString:@"未设置"]) {
        _payPassTitle.text=@"设置支付密码";
    }else{
        _payPassTitle.text=@"修改支付密码";
    }
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
