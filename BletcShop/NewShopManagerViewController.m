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
    self.view.backgroundColor=RGB(240, 240, 240);
    self.navigationItem.title=@"店铺管理";
    [self initSubViews];
}
-(void)initSubViews{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToNext2:)];
    
     UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToNext:)];
    
    UIImageView *applyImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-50, 260, 100, 100)];
    applyImageView.userInteractionEnabled=YES;
    applyImageView.tag=1;
    applyImageView.image = [UIImage imageNamed:@"shop_list_n"];
    
    [self.view addSubview:applyImageView];
    
    [applyImageView addGestureRecognizer:tap];
    
    UILabel *applyLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 375, SCREENWIDTH, 17)];
    applyLable.text=@"店铺申请列表";
    applyLable.textAlignment=1;
    applyLable.font=[UIFont systemFontOfSize:18.0f];
    [self.view addSubview:applyLable];
    
    UIImageView *checkImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-50, 80, 100, 100)];
    checkImageView.userInteractionEnabled=YES;
    checkImageView.tag=2;
    checkImageView.image = [UIImage imageNamed:@"shop_management_n"];
    
    [self.view addSubview:checkImageView];
    
    [checkImageView addGestureRecognizer:tap2];
    
    UILabel *checkLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 195, SCREENWIDTH, 17)];
    checkLable.text=@"我管理的店铺";
    checkLable.textAlignment=1;
    checkLable.font=[UIFont systemFontOfSize:18.0f];
    [self.view addSubview:checkLable];
}
//申请店铺管理
-(void)goToNext:(UITapGestureRecognizer *)gesture{
    MineManagerViewController *mineVC=[[MineManagerViewController alloc]init];
    [self.navigationController pushViewController:mineVC animated:YES];
}
//查看店铺列表
-(void)goToNext2:(UITapGestureRecognizer *)gesture2{
    OtherApplyViewController *otherVC=[[OtherApplyViewController alloc]init];
    [self.navigationController pushViewController:otherVC animated:YES];
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
