//
//  SweetNoticeVC.m
//  BletcShop
//
//  Created by apple on 17/3/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "SweetNoticeVC.h"

@interface SweetNoticeVC ()

@end

@implementation SweetNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"使用须知";
    self.noticeLable.text=self.infoDic[@"content"];
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
