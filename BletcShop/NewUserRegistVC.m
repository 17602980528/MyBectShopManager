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
#ifdef DEBUG
    //跳页面
    NewUserAccessCodeVC *vc=[[NewUserAccessCodeVC alloc]init];
    vc.phoneNum=_phoneTF.text;
    [self.navigationController pushViewController:vc animated:YES];
#else
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

#endif
   
}

-(void)fingerTapped:(UITapGestureRecognizer *)tap{
    [tap.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)setTextFieldLeftImageView:(UITextField *)textField leftImageName:(NSString *)imageName
{
    // 设置左边图片
    UIImageView *leftView     = [[UIImageView alloc] init];
    leftView.image            = [UIImage imageNamed:imageName];
    leftView.bounds = CGRectMake(0, 0, 30, 30);
    //    leftView.height = 30;
    //    leftView.width = 30;
    
    // 设置leftView的内容居中
    leftView.contentMode      = UIViewContentModeCenter;
    textField.leftView        = leftView;
    
    // 设置左边的view永远显示
    textField.leftViewMode    = UITextFieldViewModeAlways;
    
    // 设置右边永远显示清除按钮
    textField.clearButtonMode = UITextFieldViewModeAlways;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"填写手机号";
    _phoneTF.delegate=self;
    _phoneTF.returnKeyType=UIReturnKeyDone;
    _phoneTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self setTextFieldLeftImageView:_phoneTF leftImageName:@"手机"];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
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
