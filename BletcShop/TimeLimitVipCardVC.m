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
#import "ValuePickerView.h"
@interface TimeLimitVipCardVC ()<UITextFieldDelegate,ChoiceCardDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *topBgView;
@property (strong, nonatomic) IBOutlet UITextField *cardNameTF;
@property (strong, nonatomic) IBOutlet UITextField *cardOriginPrice;
@property (strong, nonatomic) IBOutlet UITextField *cardDiscountPrice;
@property (strong, nonatomic) IBOutlet UITextField *cardTimeLimit;
@property (strong, nonatomic) IBOutlet UIImageView *arrow;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *instrumentTextView;
//选择的卡模板
@property (nonatomic,retain)NSDictionary *choiceCard;


@property(nonatomic,strong)NSArray*deadLine_A;//有效期
@property (nonatomic , strong) NSDictionary *deadLine_dic;// <#Description#>
@property (nonatomic , strong) NSDictionary *lineDead_dic;// <#Description#>

@property(nonatomic,strong)ValuePickerView *pickView;
@end

@implementation TimeLimitVipCardVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cardNameTF.superview.hidden = YES;
    _cardDiscountPrice.superview.hidden= YES;
    
    if (self.card_dic) {
        NSArray *cardTemp_A = [[NSUserDefaults standardUserDefaults]objectForKey:@"CARDIMGTEMP"];

        for (NSDictionary *tim_dic in cardTemp_A) {
            if ([tim_dic[@"color"] isEqualToString:_card_dic[@"template"]]) {
                self.choiceCard = tim_dic;
                
                NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCECARD stringByAppendingString:tim_dic[@"image"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                
                [self.imageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
                self.imageView.backgroundColor = [UIColor whiteColor];
                
                break ;
            }
        }
    }
    
    
    _cardOriginPrice.text = _card_dic[@"price"];
    _instrumentTextView.text = _card_dic[@"des"];
    _cardTimeLimit.text = self.lineDead_dic[_card_dic[@"indate"]];
    
    
    
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
        
        [_cardNameTF resignFirstResponder];
        [_cardOriginPrice resignFirstResponder];
        [_cardDiscountPrice resignFirstResponder];
        [_instrumentTextView resignFirstResponder];

        
        self.pickView.dataSource = self.deadLine_A;
        
        _pickView.valueDidSelect = ^(NSString *value) {
            textField.text = [[value componentsSeparatedByString:@"/"] firstObject];

        };
        [_pickView show];
        
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

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    CGRect textViewFrame = [textView convertRect:textView.frame toView:self.view];
    
    CGFloat h =SCREENHEIGHT-(textViewFrame.origin.y+textViewFrame.size.height+64);
    
    if (h<216) {

        [UIView animateWithDuration:0.3 animations:^{
            CGRect viewframe = self.view.frame;
            viewframe.origin.y  = h-216;
            
            self.view.frame = viewframe;
        }];
      
    
    }
   
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect viewframe = self.view.frame;
        viewframe.origin.y  = 64;
        
        self.view.frame = viewframe;
  
    }];
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

- (IBAction)chooseCardImageBtnClick:(id)sender {
    [_cardNameTF resignFirstResponder];
    [_cardOriginPrice resignFirstResponder];
    [_cardDiscountPrice resignFirstResponder];
    [_instrumentTextView resignFirstResponder];
    
    ChoiceCardPictureViewController *pictureView = [[ChoiceCardPictureViewController alloc]init];
    pictureView.delegate = self;
    [self.navigationController pushViewController:pictureView animated:YES];
}
- (IBAction)sureBtnClick:(id)sender {
    
    if (_cardOriginPrice.text.length==0) {
        [self showHint:@"请输入价格"];
    }else if (_cardTimeLimit.text.length==0)
    {
        [self showHint:@"请选择有效期"];
    }else if (_instrumentTextView.text.length==0){
        [self showHint:@"请填写会员说明"];
    }else if (!_choiceCard){
        [self showHint:@"请选择会员卡模板"];
    }else{
        
        [self postRequest];
    }
    
    
}

-(void)postRequest{
    
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/ExperienceCard/add",BASEURL];
    
   
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    
    [paramer setValue:app.shopInfoDic[@"muid"] forKey:@"muid"];
    [paramer setValue:self.choiceCard[@"color"] forKey:@"template"];
    [paramer setValue:_cardOriginPrice.text forKey:@"price"];
    [paramer setValue:_instrumentTextView.text forKey:@"des"];
    [paramer setValue:self.deadLine_dic[_cardTimeLimit.text] forKey:@"indate"];
    
    
    if ([self.navigationItem.title containsString:@"编辑"]) {
        url = [NSString stringWithFormat:@"%@MerchantType/ExperienceCard/mod",BASEURL];
        [paramer setValue:_card_dic[@"code"] forKey:@"code"];

    }
    NSLog(@"paramer=%@",paramer);
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result=%@",result);
        
        if ([result[@"result_code"] intValue]==0) {
            [self showHint:@"没有进行修改!"];
        }else
        
        if ([result[@"result_code"] intValue]==1) {
            
            NSString *ms = @"添加成功,是否继续添加?";
            
            if ([self.navigationItem.title containsString:@"编辑"]) {
                ms= @"修改成功!";
            }
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:ms message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                self.block();
                
                POP
            }];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.block();

                
            }];
            
            
            [alertVC addAction:cancleAction];
            
            if (![self.navigationItem.title containsString:@"编辑"]) {
                
                [alertVC addAction:sureAction];

            }

            
            [self presentViewController:alertVC animated:YES completion:nil];
            
        }else if([result[@"result_code"] intValue]==1062){
            
            [self showHint:@"请勿重复添加!"];

        }else{
            [self showHint:@"添加出错!"];

        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    
}

#pragma mark 懒加载
-(NSArray*)deadLine_A{
    if (!_deadLine_A) {
        _deadLine_A = @[@"半年",@"一年",@"两年",@"三年",@"无限期"];
    }
    return _deadLine_A;
}

-(NSDictionary *)lineDead_dic{
    if (!_lineDead_dic) {
        _lineDead_dic = @{@"0.5":@"半年",@"1":@"一年",@"2":@"两年",@"3":@"三年",@"0":@"无限期"};
    }
    
    return _lineDead_dic;
}
-(NSDictionary *)deadLine_dic{
    if (!_deadLine_dic) {
        _deadLine_dic = @{@"半年":@"0.5",@"一年":@"1",@"两年":@"2",@"三年":@"3",@"无限期":@"0"};
    }
    
    return _deadLine_dic;
}

-(ValuePickerView *)pickView{
    if (!_pickView) {
        _pickView = [[ValuePickerView alloc]init];
    }
    return _pickView;
}

@end
