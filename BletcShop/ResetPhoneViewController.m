//
//  ResetPhoneViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/2/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ResetPhoneViewController.h"
#import "ResetPhoneNextVC.h"

@interface ResetPhoneViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@end

@implementation ResetPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更换手机号";

    
   
}
- (IBAction)nextBtn:(UIButton *)sender {
    
    [self.phoneTF resignFirstResponder];
    
    if ([ToolManager validateMobile:self.phoneTF.text]) {
        ResetPhoneNextVC *VC = [[ResetPhoneNextVC alloc]init];
        VC.phone = self.phoneTF.text;
        [self.navigationController pushViewController:VC animated:YES];

    }else{
        
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];

        
    }
    
    
    
    
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
