//
//  AddBankAccountVC.m
//  BletcShop
//
//  Created by Bletc on 2016/11/11.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "AddBankAccountVC.h"
#import "ToolManager.h"
#import "MyMoneybagController.h"

@interface AddBankAccountVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField *bankNameTF;//开户行
    UITextField *bankAccountTF;//卡号

    UITextField *nameTF;//姓名
    UITextField *identifierTF;//身份证
    
    UITextField *phoneTF;//手机号

    


}

@property(nonatomic,strong)NSArray *array_TF;
@property(nonatomic,strong)NSArray *title_A;
@property(nonatomic,strong)NSArray *placeHodel_A;

@end

@implementation AddBankAccountVC

-(NSArray *)placeHodel_A{
    if (!_placeHodel_A) {
        _placeHodel_A = @[@[@"请输入开户行",@"请输入卡号"],@[@"请输入您的真实姓名",@"请输入您的证件号"],@[@"银行预留手机号"]];
    }
    return _placeHodel_A;
}
-(NSArray *)title_A{
    if (!_title_A) {
        _title_A = @[@[@"银行",@"卡号"],@[@"姓名",@"身份证"],@[@"手机号"]];
    }
    return _title_A;
}

-(void)backClick
{
    NSLog(@"---backClick----");
    
    if ([self.whoPush isEqualToString:@"GetMoneyViewController"]) {
        NSInteger index = 0;
        for (UIViewController *viewcontroller in self.navigationController.viewControllers) {
            if ([viewcontroller isKindOfClass:[MyMoneybagController class]]) {
                index= [self.navigationController.viewControllers indexOfObject:viewcontroller];
            }
        }
        [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];

    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"添加银行卡";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"leftArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    
    
    UITableView *table_view = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    table_view.rowHeight = 44;
    table_view.delegate = self;
    table_view.dataSource = self;
    table_view.bounces= NO;
    [self.view addSubview:table_view];
    
   }
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==self.title_A.count-1) {
        return 86;
    }else
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==self.title_A.count-1) {
        UIView *view = [UIView new];
        

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(12, 37, SCREENWIDTH-24, 49);
        [button setTitle:@"确定" forState:0];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.backgroundColor = NavBackGroundColor;
        [button addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        return view;
    }else
        return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.title_A.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.title_A[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
    }
    
    UILabel *title_lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 44)];
    title_lab.text = self.title_A[indexPath.section][indexPath.row];
    title_lab.textColor =RGB(51,51,51);
    title_lab.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:title_lab];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, SCREENWIDTH-90, 44)];
    textField.placeholder = self.placeHodel_A[indexPath.section][indexPath.row];
    textField.delegate = self;
    textField.textColor = [UIColor blackColor];
    textField.font = [UIFont systemFontOfSize:16];
    [textField setValue:RGB(153,153,153) forKeyPath:@"_placeholderLabel.textColor"];
     
     [textField setValue:[UIFont boldSystemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
      
      [cell.contentView addSubview:textField];
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            bankNameTF = textField;
        }
        if (indexPath.row==1) {
            bankAccountTF = textField;
        }

    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            nameTF = textField;
        }
        if (indexPath.row==1) {
            identifierTF = textField;
        }
        
    }

    if (indexPath.section==2) {
        if (indexPath.row==0) {
            phoneTF = textField;
        }
        
    }

    
    return cell;
}

-(void)sureClick{
    NSLog(@"确定");
    
    if (bankNameTF.text.length==0) {
        [self tishiSting:@"请输入开户行"];
        return;
    }
    
    if (bankAccountTF.text.length ==0) {
        [self tishiSting:@"请输入银行卡号"];
        return;

           }else{
               if (![NSString checkCardNo:bankAccountTF.text]) {
                   [self tishiSting:@"银行卡格式不正确"];

                   
                   return;
                   
               }

    }
    
    if (nameTF.text.length ==0) {
        [self tishiSting:@"请输入您的真实姓名"];
        
        return;
    }
    
    NSLog(@"====+%@",identifierTF.text);
    
    if (identifierTF.text.length==0) {
        [self tishiSting:@"请输入身份证号"];
        
        return;
    }else{
        
        if(![ToolManager validateIdentityCard:identifierTF.text]){
            [self tishiSting:@"身份证格式不正确"];
            
            return;
        }
       
    }
    
    if (phoneTF.text.length==0) {
        [self tishiSting:@"请输入手机号"];
        return;
    }else{
        if (![ToolManager validateMobile:phoneTF.text]){
            [self tishiSting:@"手机号码格式不正确"];
            return;
        }
    }
  
   
        [self postRequestAddCard];

}


-(void)postRequestAddCard
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/bank/add",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:nameTF.text forKey:@"name"];
    [params setObject:bankNameTF.text forKey:@"bank"];
    [params setObject:bankAccountTF.text forKey:@"number"];
    
    NSLog(@"------%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"result===%@",result);
        
        if ([result[@"result_code"] intValue]==1)
            
        {
            [self tishiSting:@"添加成功!"];
            [self setdefaultBank];
            
            
        }else if([result[@"result_code"] intValue]==1062)
        {
            [self tishiSting:@"添加重复!"];

           
        }else{
            [self tishiSting:@"添加失败!"];

        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}


-(void)setdefaultBank{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/bank/bind",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [params setObject:bankAccountTF.text forKey:@"number"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        
        if ([result[@"result_code"] intValue]==1) {
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)tishiSting:(NSString*)tishi{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = NSLocalizedString(tishi, @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:4.f];

    
}

@end
