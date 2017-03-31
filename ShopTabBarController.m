//
//  ShopTabBarController.m
//  BletcShop
//
//  Created by Yuan on 16/1/28.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShopTabBarController.h"
#import "BaseNavigationController.h"
#import "ShopVipController.h"

#import "ShopMoreViewController.h"
#import "BusinessViewController.h"
#import "MyProtuctsController.h"
#import "ChargeCenterVC.h"

@interface ShopTabBarController ()

@end

@implementation ShopTabBarController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addchildVc];
    
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

   // NSLog(@"tgtgtgtgtg%@",appdelegate.shopInfoDic);
    
    if ([appdelegate.shopInfoDic[@"privi"]  isEqualToString:@"shopAs"]) {
        self.selectedIndex = 2;
        
        
    }else
    {
        self.selectedIndex = 3;
    }
    
    NSString *selectedIndex = [[NSUserDefaults standardUserDefaults]valueForKey:@"shopselectedIndex"];
    NSLog(@"dismiss==viewWillAppear=%@",selectedIndex);
    if (selectedIndex.length!=0) {
        self.selectedIndex = [selectedIndex integerValue];


    }
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"shopselectedIndex"];

}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
    NSUserDefaults *dianpu = [NSUserDefaults standardUserDefaults];
    NSString *select =[NSString stringWithFormat:@"%ld",self.selectedIndex];
    
    [dianpu setValue:select forKey:@"shopselectedIndex"];
    
    [dianpu synchronize];

    
    NSLog(@"selectindex =viewWillDisappear==%ld",self.selectedIndex);



}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
}

//添加自控制器
-(void)addchildVc
{
    
    ShopVipController *oneVc = [[ShopVipController alloc]init];
    oneVc.shopEnter = self.shopEnter;
    NSLog(@"oneVc.shopEnter%d",self.shopEnter);
    [self addOneChindVC:oneVc title:@"我的会员" imageName:@"bu_vip_icon_n" selectedImageName:@"bu_vip_icon_s"];
//    oneVc.infoArray = self.array;
//    NSLog(@"self.infoArray = %@",self.array);
    MyProtuctsController *twoVC = [[MyProtuctsController alloc]init];
    [self addOneChindVC:twoVC title:@"我的商品" imageName:@"bu_shop_icon_n" selectedImageName:@"bu_shop_icon_s"];
    

    
//    ClosingController *threeVc = [[ClosingController alloc]init];
    ChargeCenterVC *threeVc = [[ChargeCenterVC alloc]init];

    [self addOneChindVC:threeVc title:@"结算中心" imageName:@"bu_set_icon_n" selectedImageName:@"bu_set_icon_s"];
    
    BusinessViewController *fourVC = [[BusinessViewController alloc]init];
    [self addOneChindVC:fourVC title:@"业务中心" imageName:@"bu_bu_icon_n" selectedImageName:@"bu_bu_icon_s"];
    ShopMoreViewController *fiveVC = [[ShopMoreViewController alloc]init];
    [self addOneChindVC:fiveVC title:@"更多" imageName:@"bu_more_icon_n" selectedImageName:@"bu_more_icon_s"];
    
    
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
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

        if ([appdelegate.shopInfoDic[@"privi"]  isEqualToString:@"shopAs"]) {

            if ([childVC.tabBarItem.title isEqualToString:@"结算中心"]||[childVC.tabBarItem.title isEqualToString:@"更多"]) {
                childVC.tabBarItem.enabled = YES;
            }else
                childVC.tabBarItem.enabled = NO;
        }
//    if ([childVC.tabBarItem.title isEqualToString:@"我的会员"]) {
//        childVC.tabBarItem.enabled = NO;
//    }
    //设置选中状态下的图片
    UIImage *selectedImg = [UIImage imageNamed:selectedImageName];
    if (iOS7) {
        selectedImg = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVC.tabBarItem.selectedImage = selectedImg;
    
    //    添加导航
    BaseNavigationController *BaseNav = [[BaseNavigationController alloc]initWithRootViewController:childVC];
    [self addChildViewController:BaseNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

