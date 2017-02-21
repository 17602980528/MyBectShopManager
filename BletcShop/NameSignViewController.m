//
//  NameSignViewController.m
//  BletcShop
//
//  Created by apple on 16/11/16.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NameSignViewController.h"

@interface NameSignViewController ()

@end

@implementation NameSignViewController
{
    UITextView *textView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(243, 243, 243);
    self.navigationItem.title=@"个性签名";
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveContent)];
    self.navigationItem.rightBarButtonItem = item2;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 135)];
    
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    NSString *sign=[NSString getTheNoNullStr:[df objectForKey:@"specialSign"] andRepalceStr:@""];
    textView.text = sign;
    

    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-62, 135, 49, 13)];
    label.font=[UIFont systemFontOfSize:13.0f];
    label.textAlignment=NSTextAlignmentLeft;
    label.textColor=RGB(153, 153, 153);
    label.text=@"限30字";    
    [view addSubview:label];
    [view addSubview:textView];
}
-(void)saveContent{
    NSString *string=[NSString getTheNoNullStr:textView.text andRepalceStr:@"1"];
    if (string.length<=30) {
        NSNotification * notice = [NSNotification notificationWithName:@"signNotice" object:nil userInfo:@{@"1":textView.text}];
        [[NSNotificationCenter defaultCenter]postNotification:notice];
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:textView.text forKey:@"specialSign"];
        [defaults synchronize];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"保存成功", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        [textView resignFirstResponder];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"字数不能大于100", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        [textView resignFirstResponder];
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
