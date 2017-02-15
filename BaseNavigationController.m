//
//  BaseNavigationController.m
//  BletcShop
//
//  Created by wuzhengdong on 16/1/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//修改info以后 用来修改电池条样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //去掉PUSH后的back文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}

+(void)initialize
{
    [self setUpNavigationBarTheme];
}


+(void)setUpNavigationBarTheme{
    //设置导航栏主题
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIColor *bgColor = NavBackGroundColor;
    [navBar setBarTintColor:bgColor];
    navBar.translucent = NO;
    
    //设置标题文字颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    
    [navBar setTitleTextAttributes:attrs];
    [navBar setTintColor:[UIColor whiteColor]];
    
    
}
//push以后拦截Tabbar
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
