//
//  PushAdverViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/2/23.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PushAdverViewController.h"

#import "AdvertisementHomeVC.h"
#import "AdverListViewController.h"
#import "AdverShowViewController.h"

@interface PushAdverViewController ()
@property (weak, nonatomic) IBOutlet UIButton *shuomingBtn;
@property (weak, nonatomic) IBOutlet UIButton *listBtn;
@property (weak, nonatomic) IBOutlet UIButton *pushBtn;

@end

@implementation PushAdverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"广告投放";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)pushAdverBtn:(UIButton *)sender {
    
    AdvertisementHomeVC *advertisementHomeVC=[[AdvertisementHomeVC alloc]init];
    [self.navigationController pushViewController:advertisementHomeVC animated:YES];
    
}
- (IBAction)adverListBtn:(id)sender {
    
    
    AdverListViewController *advertisementHomeVC=[[AdverListViewController alloc]init];
    [self.navigationController pushViewController:advertisementHomeVC animated:YES];
}
- (IBAction)adverconfuse:(UIButton *)sender {
    
    AdverShowViewController *advertisementHomeVC=[[AdverShowViewController alloc]init];
    [self.navigationController pushViewController:advertisementHomeVC animated:YES];
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
