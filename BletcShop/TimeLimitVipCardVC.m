//
//  TimeLimitVipCardVC.m
//  BletcShop
//
//  Created by apple on 2017/6/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "TimeLimitVipCardVC.h"

@interface TimeLimitVipCardVC ()
@property (strong, nonatomic) IBOutlet UIView *topBgView;
@property (strong, nonatomic) IBOutlet UITextField *cardNameTF;
@property (strong, nonatomic) IBOutlet UITextField *cardOriginPrice;
@property (strong, nonatomic) IBOutlet UITextField *cardDiscountPrice;
@property (strong, nonatomic) IBOutlet UITextField *cardTimeLimit;
@property (strong, nonatomic) IBOutlet UIImageView *arrow;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation TimeLimitVipCardVC
- (IBAction)chooseCardImageBtnClick:(id)sender {
}
- (IBAction)sureBtnClick:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
