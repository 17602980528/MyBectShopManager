//
//  LZDAddSeriseListVC.m
//  BletcShop
//
//  Created by Bletc on 2017/6/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "LZDAddSeriseListVC.h"

@interface LZDAddSeriseListVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *text_Field;
@end

@implementation LZDAddSeriseListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创建系列";
    _text_Field.borderStyle = UITextBorderStyleNone;

}
- (IBAction)sureBtnClick:(id)sender {
    
    if (_text_Field.text.length==0) {
        [self showHint:@"请输入系列名称"];
    }else{
        [self postAddSeriseRequest];
    }
  }


-(void)postAddSeriseRequest{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/card/addSeries",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [params setObject:app.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:_cardTypeName forKey:@"type"];
    [params setObject:_text_Field.text forKey:@"name"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        if ([result[@"result_code"]integerValue]==1) {

            [self showHint:@"添加成功"];
            self.block();
            POP

        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
