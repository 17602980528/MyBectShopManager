//
//  ChargeToAccountVC.m
//  BletcShop
//
//  Created by Bletc on 16/9/19.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ChargeToAccountVC.h"

@interface ChargeToAccountVC ()<UITextFieldDelegate>
{
    UITextField *textFiled;
    UISegmentedControl *_segment;
}
@end

@implementation ChargeToAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"现金入账";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSubViews];

}
-(void)initSubViews{
    
//    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, SCREENWIDTH, 40)];
//    lab.text = @"客户类型:";
//    lab.textColor =[UIColor blackColor];
//    lab.font =[UIFont systemFontOfSize:15];
//    [self.view addSubview:lab];
//     _segment = [[UISegmentedControl alloc]initWithItems:@[@"散客",@"会员"]];
//    _segment.frame = CGRectMake(100, 42, SCREENWIDTH-150, 36);
//    _segment.selectedSegmentIndex= 0;
//    _segment.tintColor = NavBackGroundColor;
//
//    [self.view addSubview:_segment];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, SCREENWIDTH, 40)];
    lab1.text = @"支付金额:";
    lab1.textColor =[UIColor blackColor];
    lab1.font =[UIFont systemFontOfSize:15];
    [self.view addSubview:lab1];
    
    textFiled = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, SCREENWIDTH-150, 40)];
    textFiled.placeholder = @"输入金额";
    textFiled.font = [UIFont systemFontOfSize:15];
    textFiled.borderStyle = UITextBorderStyleRoundedRect;
    textFiled.delegate = self;
    textFiled.textColor = [UIColor blackColor];
    textFiled.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.view addSubview:textFiled];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREENWIDTH*0.15, textFiled.bottom+100, SCREENWIDTH*0.7, 44);
    [button setTitle:@"提交" forState:0];
    button.backgroundColor = NavBackGroundColor;
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}

-(void)buttonClick{
    
    if ([textFiled.text floatValue]<=0.0) {
        [self showHint:@"金额不能小于零"];
    }else{
        
    
    [textFiled resignFirstResponder];
//    [self showHudInView:self.view hint:@"提交中..."];
    
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/merchant/cashPay",BASEURL];
        
    
    NSMutableDictionary *paramaer = [NSMutableDictionary dictionary];
    
//    NSString *name = [_segment titleForSegmentAtIndex:_segment.selectedSegmentIndex];
        
    [paramaer setValue:textFiled.text forKey:@"sum"];
    [paramaer setValue:app.shopInfoDic[@"muid"] forKey:@"merchant"];
//    [paramaer setValue:name forKey:@"name"];

        NSDateFormatter* matter = [[NSDateFormatter alloc]init];
        [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* date  = [NSDate date];
        NSString *NowDate = [matter stringFromDate:date];
        [paramaer setObject:NowDate forKey:@"datetime "];
    
    [KKRequestDataService requestWithURL:url params:paramaer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
//        [self hideHud];
        DebugLog(@"result====%@",result);
        
        if ([result[@"result_code"] integerValue]==1) {
            textFiled.text = @"";
            
         UIAlertView *altView =   [[UIAlertView alloc]initWithTitle:@"提示" message:@"提交成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            
            [altView show];
            
//            [self showHint:@"提交成功"];
        }else{
//            [self showHint:@"提交失败"];
            
              UIAlertView *altView =   [[UIAlertView alloc]initWithTitle:@"提示" message:@"提交失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [altView show];


        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        DebugLog(@"error====%@",error.description);

    }];

    
    }
  
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
