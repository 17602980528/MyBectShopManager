//
//  ChangePayPassVC.m
//  BletcShop
//
//  Created by apple on 2017/5/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ChangePayPassVC.h"
#import "SYPasswordView.h"
#import "ChangePayPassLastVC.h"
@interface ChangePayPassVC ()<SYPasswordViewDelegate>
@property (nonatomic, strong) SYPasswordView *pasView;
@end

@implementation ChangePayPassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"支付密码";
    self.view.backgroundColor=RGB(238, 238, 238);
    
    UILabel *noticeLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 60, SCREENWIDTH, 30)];
    noticeLable.font=[UIFont systemFontOfSize:14.0f];
    noticeLable.textAlignment=NSTextAlignmentCenter;
    noticeLable.text=@"设置新支付密码";
    [self.view addSubview:noticeLable];
    
    self.pasView = [[SYPasswordView alloc] initWithFrame:CGRectMake(16, 100, self.view.frame.size.width - 32, 45)];
    _pasView.delegate=self;
    [self.view addSubview:_pasView];
}

-(void)passLenghtEqualsToSix:(NSString *)pass{
    [self.pasView.textField resignFirstResponder];
    ChangePayPassLastVC *vc=[[ChangePayPassLastVC alloc]init];
    vc.pass=pass;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)observationPassLength:(NSString *)pwd{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
