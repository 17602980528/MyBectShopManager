//
//  BindBankCardViewController.m
//  BletcShop
//
//  Created by Bletc on 16/6/17.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "BindBankCardViewController.h"

@interface BindBankCardViewController ()

@end

@implementation BindBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.cardArray = @[@[]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"绑定银行卡";
    UIButton *menuBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [menuBt addTarget:self action:@selector(addBindCard) forControlEvents:UIControlEventTouchUpInside];
    [menuBt setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateNormal];
    [menuBt setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateHighlighted];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:menuBt];
    self.navigationItem.rightBarButtonItem = item;
    
    [self postGetAllBankCard];
    // Do any additional setup after loading the view.
}
-(void)_inittable
{
    for (UIView*view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.rowHeight = 104;
    table.bounces = NO;
    self.Cardtable = table;
    [self.view addSubview:table];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.cardArray.count>0) {
        return self.cardArray.count;
    }else
        return 0;
    
    //return self.cardmoneyArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UILabel *jibieLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 200, 30)];
   

    jibieLabel.backgroundColor = [UIColor clearColor];
    jibieLabel.textAlignment = NSTextAlignmentLeft;
    jibieLabel.font = [UIFont systemFontOfSize:12];
    [cell addSubview:jibieLabel];
    UILabel *cardNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 50, 100, 30)];
  
    cardNameLabel.backgroundColor = [UIColor clearColor];
    cardNameLabel.textAlignment = NSTextAlignmentLeft;
    cardNameLabel.font = [UIFont systemFontOfSize:12];
    [cell addSubview:cardNameLabel];
    UILabel *timesLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-100, 50, 70, 30)];
    
     timesLabel.backgroundColor = [UIColor clearColor];
    timesLabel.textAlignment = NSTextAlignmentRight;
    timesLabel.font = [UIFont systemFontOfSize:12];
    [cell addSubview:timesLabel];
    
    

    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 90, SCREENWIDTH, 1)];
    viewLine.backgroundColor = [UIColor grayColor];
    viewLine.alpha = 0.3;
    [cell addSubview:viewLine];
    
    
    if (self.cardArray.count>0) {
        NSDictionary *dic = self.cardArray[indexPath.row];
        
        jibieLabel.text = dic[@"number"];;
        cardNameLabel.text = dic[@"bank"];;

            timesLabel.textColor = ButtonGreenColor;
            if ([dic[@"state"] isEqualToString:@"true"]) {
                timesLabel.text =@"已绑定";
            }else
            {
                timesLabel.text = @"";
            }
        

        
    }
    return cell;
    
}
-(void)NewAddVipAction
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView]];
    
    // Modify the parameters
    
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"增加", @"取消", nil]];
    
    
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
}
- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 150)];
    self.demoView = demoView;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 50)];
    label.text = @"姓名:";
    label.font = [UIFont systemFontOfSize:13];
    [demoView addSubview:label];
    UITextField *nameText = [[UITextField alloc]initWithFrame:CGRectMake(70, 10, 160, 30)];
    nameText.layer.borderWidth = 0.3;
    //nameText.backgroundColor = tableViewBackgroundColor;
    nameText.placeholder = @"";
    self.nameText = nameText;
    nameText.font = [UIFont systemFontOfSize:13];
    nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [demoView addSubview:nameText];
    
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 290, 0.3)];
    line2.backgroundColor = [UIColor grayColor];
    line2.alpha = 0.3;
    [demoView addSubview:line2];
    
    //密码
    UILabel *phonelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 60, 50)];
    phonelabel.text = @"开户行:";
    phonelabel.font = [UIFont systemFontOfSize:13];
    [demoView addSubview:phonelabel];
    UITextField *openBankText = [[UITextField alloc]initWithFrame:CGRectMake(70, 60, 160, 30)];
    openBankText.layer.borderWidth = 0.3;
    //openBankText.backgroundColor = tableViewBackgroundColor;
    openBankText.placeholder = @"";
    self.openBankText = openBankText;
    openBankText.font = [UIFont systemFontOfSize:13];
    openBankText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [demoView addSubview:openBankText];
    UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 290, 0.3)];
    linePhone.backgroundColor = [UIColor grayColor];
    linePhone.alpha = 0.3;
    [demoView addSubview:linePhone];
    //权限
    UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 60, 50)];
    levelLabel.text = @"银行卡号:";
    levelLabel.font = [UIFont systemFontOfSize:13];
    [demoView addSubview:levelLabel];
    UITextField *cardNumText = [[UITextField alloc]initWithFrame:CGRectMake(70, 110, 160, 30)];
    cardNumText.layer.borderWidth = 0.3;
    cardNumText.textAlignment = NSTextAlignmentCenter;
    self.cardNumText=cardNumText;
    
    NSLog(@"%@",cardNumText.text);
    cardNumText.font = [UIFont systemFontOfSize:13];
    [demoView addSubview:cardNumText];
    return demoView;
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (alertView.tag==0&&buttonIndex==1) {
        [alertView close];
    }
    else if (alertView.tag==0&&buttonIndex==0)
    {
        
        if (self.cardNumText.text.length!=19) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"银行卡格式不正确", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:4.f];
            
        }else{
            [self postRequestAddCard];

        }
        
        
    }
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
}
-(void)postRequestAddCard
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/bank/add",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:self.nameText.text forKey:@"name"];
    [params setObject:self.openBankText.text forKey:@"bank"];
    [params setObject:self.cardNumText.text forKey:@"number"];
  
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        if ([result[@"result_code"] intValue]==1)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"添加成功", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:4.f];
            [self postGetAllBankCard];
        }else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                       hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"添加失败", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:4.f];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];

}
-(void)postGetAllBankCard
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/bank/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        NSArray *arr = [result copy];
        self.cardArray = [arr copy];
        [self _inittable];
                
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
}
-(void)addBindCard
{
    [self NewAddVipAction];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.cardArray objectAtIndex:indexPath.row];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/bank/bind",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [params setObject:dic[@"number"] forKey:@"number"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        
        if ([result[@"result_code"] intValue]==1) {
            [self postGetAllBankCard];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];

}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        NSLog(@"===UITableViewCellEditingStyle");
        
        
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该银行卡?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/bank/delete",BASEURL];
            
            NSDictionary *dic = [self.cardArray objectAtIndex:indexPath.row];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
            [params setObject:dic[@"number"] forKey:@"number"];
            [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
                
                if ([result[@"result_code"] intValue]==1) {
                    [self postGetAllBankCard];
                }
                
            } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"%@", error);
                
            }];
            
            
        }];
        
        [alertVC addAction:cancel];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        
        
        
        
        
        
    }
}


@end
