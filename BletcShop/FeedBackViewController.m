//
//  FeedBackViewController.m
//  BletcShop
//
//  Created by Bletc on 16/5/27.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "FeedBackViewController.h"
////#import "Toast+UIView.h"
//#import "MMProgressHUD.h"
@interface FeedBackViewController ()

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    self.title = @"意见反馈";
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    [self initFeedView];
    // Do any additional setup after loading the view.
}
//点击空白收起键盘X
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    
    [self.view endEditing:YES];
    
    
}
-(void)initFeedView
{
    self.view.backgroundColor = tableViewBackgroundColor;
    //反馈匡
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 30, SCREENWIDTH-40, SCREENHEIGHT/3-40)];
    _textView.delegate = self;
    //提示语
    _placeholder = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-60, 30)];
    _placeholder.font = [UIFont systemFontOfSize:13];
    _placeholder.textColor = [UIColor grayColor];
    _placeholder.text = @"请输入您的反馈意见,不超过200字";
    _placeholder.enabled = YES;
    _placeholder.backgroundColor = [UIColor clearColor];
    [self.textView addSubview:_placeholder];
    [self.view addSubview:self.textView];
    UIView *contactView = [[UIView alloc]initWithFrame:CGRectMake(20, SCREENHEIGHT/3+60-50, SCREENWIDTH-40, 60)];
    contactView.backgroundColor = [UIColor whiteColor];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 40)];
    lable.font = [UIFont systemFontOfSize:15];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.text = @"联系方式";
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(100, 10, 180, 40)];
    textField.delegate = self;
    textField.placeholder = @"QQ/手机号/邮箱";
    self.contactText = textField;
    textField.font = [UIFont systemFontOfSize:15];
    lable.backgroundColor = [UIColor whiteColor];
    textField.backgroundColor = [UIColor whiteColor];
    [contactView addSubview:lable];
    [contactView addSubview:textField];
    [self.view addSubview:contactView];
    UIButton *CreatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CreatBtn.frame = CGRectMake(50, SCREENHEIGHT/3+150-60, SCREENWIDTH-100, 40);
    [CreatBtn setTitle:@"提交" forState:UIControlStateNormal];
    [CreatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [CreatBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    CreatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [CreatBtn setBackgroundColor:[UIColor colorWithRed:82.0f/255.0f green:206.0f/255.0f blue:165.f/255.0f alpha:1.0f]];
    CreatBtn.layer.cornerRadius = 10;
    [CreatBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:CreatBtn];
}
-(void)submitAction
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/feedback/commit", BASEURL];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    if ([_textView.text isEqualToString:@""]) {
        
        
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"意见反馈不能为空", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        [hud hideAnimated:YES afterDelay:1.f];

        return;
    }else if (_contactText.text.length == 0){
        
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"联系方式不能为空", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        [hud hideAnimated:YES afterDelay:1.f];

        return;
    }else{
        
        [hud hideAnimated:YES];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:_textView.text forKey:@"content"];
        [params setObject:_contactText.text forKey:@"contact"];
        
        [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            
            NSLog(@"%@", result);
          
            
            if([result[@"result_code"] intValue]==1)
            {
                
                UIAlertController *altVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"意见反馈成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *goback = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    

                }];
                
                
                [altVC addAction:goback];
                [self presentViewController:altVC animated:YES completion:nil];


                
                
            }else if ([result[@"result_code"] intValue]==1062 ){
                
                UIAlertController *altVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"意见反馈重复!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *goback = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    
                }];
                [altVC addAction:goback];
                [self presentViewController:altVC animated:YES completion:nil];
                


                
            }
            
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@", error);
            
        }];

    }
 
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _placeholder.text = @"请输入您的反馈意见,不超过200字";
    }else{
        _placeholder.text = @"";
    }
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
