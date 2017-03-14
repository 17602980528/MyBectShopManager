//
//  PayBaseOnlineDaysVC.m
//  BletcShop
//
//  Created by apple on 17/3/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PayBaseOnlineDaysVC.h"
#import "GoToPayForAdvertistTableVC.h"
@interface PayBaseOnlineDaysVC ()

@end

@implementation PayBaseOnlineDaysVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"发布广告";
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(goNextVC)];
    self.navigationItem.rightBarButtonItem=rightItem;
}
-(void)goNextVC{
    GoToPayForAdvertistTableVC *VC=[[GoToPayForAdvertistTableVC alloc]init];
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
