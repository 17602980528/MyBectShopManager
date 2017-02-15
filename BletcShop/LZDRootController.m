//
//  LZDRootController.m
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LZDRootController.h"

@interface LZDRootController ()

@end

@implementation LZDRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    LZDContentView *contentView =[[LZDContentView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.myAppDelegate = delegate;


}
-(void)setChartDelegate{
    
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
