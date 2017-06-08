//
//  NewUserRegistVC.m
//  BletcShop
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NewUserRegistVC.h"
#import "NewUserAccessCodeVC.h"
@interface NewUserRegistVC ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;

@end

@implementation NewUserRegistVC
- (IBAction)accessCodeBtnClick:(id)sender {
    [_phoneTF resignFirstResponder];
    if (_phoneTF.text.length==11) {
        BOOL state = [NSString isMobileNum:_phoneTF.text];
        if (state) {
            //跳页面
            NewUserAccessCodeVC *vc=[[NewUserAccessCodeVC alloc]init];
            vc.phoneNum=_phoneTF.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码格式不对" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alertView show];
        }
    }else{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码长度不对" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"注册";
    _phoneTF.delegate=self;
    _phoneTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
}
-(void)fingerTapped:(UITapGestureRecognizer *)tap{
    [tap.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
