//
//  NewShopManagerViewController.m
//  BletcShop
//
//  Created by apple on 16/12/16.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NewShopManagerViewController.h"
#import "OtherApplyViewController.h"//shenqingliebiao
#import "MineManagerViewController.h"//woguanlide

@interface NewShopManagerViewController ()

@end

@implementation NewShopManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor=RGB(240, 240, 240);
    self.navigationItem.title=@"店铺管理";
    
    
    
//    [self initSubViews];
}


//我管理的店铺
-(IBAction)goToNext:(UITapGestureRecognizer *)gesture{
    MineManagerViewController *mineVC=[[MineManagerViewController alloc]init];
    [self.navigationController pushViewController:mineVC animated:YES];
}
//查看申请列表
-(IBAction)goToNext2:(UITapGestureRecognizer *)gesture2{
    OtherApplyViewController *otherVC=[[OtherApplyViewController alloc]init];
    [self.navigationController pushViewController:otherVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
