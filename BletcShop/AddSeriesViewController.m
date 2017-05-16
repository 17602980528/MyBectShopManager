//
//  AddSeriesViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/5/16.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AddSeriesViewController.h"

@interface AddSeriesViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation AddSeriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加系列";
    self.textField.layer.borderColor = RGB(226,102,102).CGColor;
    _textField.layer.borderWidth = 1;
    
    
    
}
- (IBAction)btnClick:(UIButton *)sender {
    if (![self.textField.text isEqualToString:@""]) {
        if ([_delegate respondsToSelector:@selector(addCardCodeAndTypes: type: muid:)]) {
            AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [_delegate addCardCodeAndTypes: self.textField.text type:_cardTypes muid:delegate.shopInfoDic[@"muid"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

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
