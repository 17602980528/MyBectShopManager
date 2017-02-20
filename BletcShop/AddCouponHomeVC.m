//
//  AddCouponHomeVC.m
//  BletcShop
//
//  Created by apple on 17/2/20.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AddCouponHomeVC.h"
#import "AddCouponVC.h"
@interface AddCouponHomeVC ()

@end

@implementation AddCouponHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(238, 238, 238);
    self.navigationItem.title=@"优惠券";
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addCoupon)];
    self.navigationItem.rightBarButtonItem=rightItem;
}
-(void)addCoupon{
    AddCouponVC *couponVC=[[AddCouponVC alloc]init];
    [self.navigationController pushViewController:couponVC animated:YES];
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
