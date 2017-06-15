//
//  AddPakageServiceVC.m
//  BletcShop
//
//  Created by apple on 2017/6/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AddPakageServiceVC.h"

@interface AddPakageServiceVC ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *productNameTF;
@property (strong, nonatomic) IBOutlet UITextField *oldPriceTF;
@property (strong, nonatomic) IBOutlet UITextField *discountPriceTF;

@end

@implementation AddPakageServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)confirmBtnClick:(id)sender {
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
