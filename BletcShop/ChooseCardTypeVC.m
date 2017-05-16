//
//  ChooseCardTypeVC.m
//  BletcShop
//
//  Created by apple on 2017/5/16.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ChooseCardTypeVC.h"

@interface ChooseCardTypeVC ()
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIImageView *topImageView;
@property (strong, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (strong, nonatomic) IBOutlet UIButton *topButton;
@property (strong, nonatomic) IBOutlet UIButton *bottomButton;
@property (nonatomic,copy)NSString *selectResult;
@end

@implementation ChooseCardTypeVC
- (IBAction)moneyClick:(UIButton *)sender {
    _topView.backgroundColor=RGB(226, 102, 102);
    _bottomView.backgroundColor=RGB(117, 91, 91);
    _topImageView.image=[UIImage imageNamed:@"quan1"];
    _bottomImageView.image=[UIImage imageNamed:@"quan2"];
    [sender setTitleColor:RGB(226, 102, 102) forState:UIControlStateNormal];
     [_bottomButton setTitleColor:RGB(117, 91, 91) forState:UIControlStateNormal];
     _selectResult=@"储值卡";
}
- (IBAction)countClick:(UIButton *)sender {
    _topView.backgroundColor=RGB(117, 91, 91);
    _bottomView.backgroundColor=RGB(226, 102, 102);
    _topImageView.image=[UIImage imageNamed:@"quan2"];
    _bottomImageView.image=[UIImage imageNamed:@"quan1"];
     [_topButton setTitleColor: RGB(117, 91, 91) forState:UIControlStateNormal];
    [sender setTitleColor:RGB(226, 102, 102) forState:UIControlStateNormal];
    _selectResult=@"计次卡";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectResult=@"储值卡";
}
- (IBAction)gotoNextVC:(id)sender {
    
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
