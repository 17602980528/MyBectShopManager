//
//  MainTabBarController.m
//  BletcShop
//
//  Created by wuzhengdong on 16/1/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavigationController.h"
#import "MoreViewController.h"
#import "MineViewController.h"
#import "ShoppingViewController.h"
#import "FirstViewController.h"

#import "HomeViewController.h"
#import "CardMarketViewController.h"


@interface MainTabBarController ()


@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.tabBar.translucent = NO;
    [self addchildVc];
    
}

//添加子控制器
-(void)addchildVc
{
    //    UIEdgeInsets Insets=UIEdgeInsetsMake(-10, 0, 10, 0);
    
    HomeViewController *firstVc = [[HomeViewController alloc]init];
    
    
    //    FirstViewController *firstVc = [[FirstViewController alloc]init];
    [self addOneChindVC:firstVc title:@"首页" imageName:@"mine_home_n" selectedImageName:@"mine_home_s"];
    
    ShoppingViewController *shopVC = [[ShoppingViewController alloc]init];
    [self addOneChindVC:shopVC title:@"周边" imageName:@"mine_side_n" selectedImageName:@"mine_side_s"];
    
    
    CardMarketViewController *cardmarketVC= [[CardMarketViewController alloc]init];
    
    
    [self addOneChindVC:cardmarketVC title:@"卡市" imageName:@"mine_card_n" selectedImageName:@"mine_card_s"];
    //    cardmarketVC.tabBarItem.imageInsets=Insets;
    
    MineViewController *mineVC = [[MineViewController alloc]init];
    [self addOneChindVC:mineVC title:@"我的" imageName:@"mine_my_n" selectedImageName:@"mine_my_s"];
    
    MoreViewController *moreVC = [[MoreViewController alloc]init];
    [self addOneChindVC:moreVC title:@"更多" imageName:@"mine_more_n" selectedImageName:@"mine_more_s"];
    
    //self.viewControllers = @[firstVc,shopVC,mineVC,moreVC];
}
//添加自控制器的方法
-(void)addOneChindVC:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    //设置标题
    childVC.tabBarItem.title = title;
    
    //设置图片
    UIImage *normalImg = [UIImage imageNamed:imageName];
    childVC.tabBarItem.image = normalImg;
    
    
    //设置tabBarItem普通状态下的文字颜色
    NSMutableDictionary *textAttr = [NSMutableDictionary dictionary];
        textAttr[NSForegroundColorAttributeName] = [UIColor grayColor];
    textAttr[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [childVC.tabBarItem setTitleTextAttributes:textAttr forState:UIControlStateNormal];
    
    //设置tabBarItem选中状态下的文字颜色
    NSMutableDictionary *selectedAttr = [NSMutableDictionary dictionary];
    selectedAttr[NSForegroundColorAttributeName] = NavBackGroundColor;
    selectedAttr[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [childVC.tabBarItem setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    
    //设置选中状态下的图片
    UIImage *selectedImg = [UIImage imageNamed:selectedImageName];
    UIImage *normal_Img = [UIImage imageNamed:imageName];

        selectedImg = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    normal_Img = [normal_Img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    childVC.tabBarItem.selectedImage = selectedImg;
    childVC.tabBarItem.image = normal_Img;
    
//    添加导航
    BaseNavigationController *BaseNav = [[BaseNavigationController alloc]initWithRootViewController:childVC];
    [self addChildViewController:BaseNav];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose      of any resources that can be recreated.
}



@end
