//
//  TimeLimitVipCardVC.m
//  BletcShop
//
//  Created by apple on 2017/6/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "TimeLimitVipCardVC.h"
#import "ChoiceCardPictureViewController.h"
#import "UIImageView+WebCache.h"
@interface TimeLimitVipCardVC ()<UITextFieldDelegate,ChoiceCardDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *topBgView;
@property (strong, nonatomic) IBOutlet UITextField *cardNameTF;
@property (strong, nonatomic) IBOutlet UITextField *cardOriginPrice;
@property (strong, nonatomic) IBOutlet UITextField *cardDiscountPrice;
@property (strong, nonatomic) IBOutlet UITextField *cardTimeLimit;
@property (strong, nonatomic) IBOutlet UIImageView *arrow;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *instrumentTextView;

@end

@implementation TimeLimitVipCardVC
- (IBAction)chooseCardImageBtnClick:(id)sender {
    ChoiceCardPictureViewController *pictureView = [[ChoiceCardPictureViewController alloc]init];
    pictureView.delegate = self;
    [self.navigationController pushViewController:pictureView animated:YES];
}
- (IBAction)sureBtnClick:(id)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationItem.title=@"发布体验卡";
    self.imageView.layer.borderWidth=1.0f;
    self.imageView.layer.borderColor=[RGB(234, 234, 234)CGColor];
    self.instrumentTextView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.instrumentTextView.layer.borderWidth=1.0f;
}
#pragma mark --隐藏键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark --textFeildDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==_cardTimeLimit) {
        return NO;
    }else{
        return YES;
    }
}
#pragma mark --textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
    }
    
    return YES;
}
#pragma mark --ChoiceCardDelegate
- (void)sendCardValue:(NSDictionary *)value
{
    self.choiceCard = [[NSDictionary alloc]initWithDictionary:value];
   
    for (UIView *view in self.imageView.subviews) {
        [view removeFromSuperview];
    }
    
    NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCECARD stringByAppendingString:self.choiceCard[@"image"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [self.imageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
    
    
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
