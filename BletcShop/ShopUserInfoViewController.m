//
//  ShopUserInfoViewController.m
//  BletcShop
//
//  Created by Bletc on 16/6/23.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShopUserInfoViewController.h"
#import "PointRuleViewController.h"

#import "NewChangePsWordViewController.h"

#import "ResetPhoneViewController.h"
@interface ShopUserInfoViewController ()

@end

@implementation ShopUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"个人信息";
    [self _initTable];
}
-(void)_initTable
{
    UITableView *mytable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    mytable.backgroundColor = [UIColor clearColor];
    mytable.dataSource = self;
    mytable.delegate = self;
    mytable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mytable.showsVerticalScrollIndicator = NO;
    mytable.bounces = NO;
    self.Mytable = mytable;
    mytable.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:mytable];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
            return 70;
    }
    else
        return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 7;
    }
    else
        return 1;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 0.01;
    }
    else
        return SCREENHEIGHT-40-80-60-70*7;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    view.backgroundColor = tableViewBackgroundColor;
    return view;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    view.backgroundColor = tableViewBackgroundColor;
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    // 通过indexPath创建cell实例 每一个cell都是单独的
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        NSArray *labelStringArray =@[@"昵称",@"店铺名",@"手机号",@"修改密码",@"地址",@"保证金",@"入驻协议"];
        UILabel *nameLabel = [[UILabel alloc]init];
        
            nameLabel.frame = CGRectMake(10, 0, 100, 70);
        
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.tag = 1000;
        nameLabel.text = [labelStringArray objectAtIndex:indexPath.row];
        [cell addSubview:nameLabel];
            UILabel *descripLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, SCREENWIDTH-150, 70)];
            descripLabel.backgroundColor = [UIColor clearColor];
            descripLabel.text = @"";
            descripLabel.textAlignment = NSTextAlignmentRight;
            descripLabel.font = [UIFont systemFontOfSize:16];
            descripLabel.tag = 1000;
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
            if (indexPath.row==0) {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                descripLabel.text = appdelegate.shopInfoDic[@"bname"];
            }else if (indexPath.row==1) {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                descripLabel.text = appdelegate.shopInfoDic[@"store"];
            }else if (indexPath.row==2) {
//                [cell setAccessoryType:UITableViewCellAccessoryNone];
                descripLabel.text = appdelegate.shopInfoDic[@"phone"];
            }else if (indexPath.row==3) {
                
                    descripLabel.text = @"";
            }else if (indexPath.row==4) {
                if (!appdelegate.shopInfoDic[@"address"]) {
                    descripLabel.text =@"未设置";
                }else
                    descripLabel.text = appdelegate.shopInfoDic[@"address"];
            }else if (indexPath.row==5) {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                if ([appdelegate.shopInfoDic[@"remain"] floatValue]==0.0) {
                    descripLabel.text =@"0.00";
                }else
                    descripLabel.text = appdelegate.shopInfoDic[@"remain"];
            }
            else if(indexPath.row==6){
                descripLabel.text=@"协议详情";
            }
            else
                descripLabel.text =@"未设置";
            
            
            [cell addSubview:descripLabel];
        
    }
    else
    {
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        //        UIButton *chosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [chosBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        chosBtn.frame = CGRectMake(0, 0, SCREENWIDTH, 60);
        //        [chosBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        //        chosBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        ////        [chosBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
        ////        [chosBtn addTarget:self action:@selector(chosBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //        [cell addSubview:chosBtn];
        
        
    }
    //    if (indexPath.row==0) {
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
    viewLine.backgroundColor = [UIColor grayColor];
    viewLine.alpha = 0.3;
    [cell addSubview:viewLine];
    //    }
    //    else{
    //        UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, cell.height, SCREENWIDTH, 1)];
    //        viewLine.backgroundColor = [UIColor grayColor];
    //        viewLine.alpha = 0.3;
    //        [cell addSubview:viewLine];
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        if (indexPath.row==2) {
            
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            if (![[appdelegate.shopInfoDic objectForKey:@"privi"] isEqualToString:@"register"]) {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有修改权限!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                [alertView show];
                
                NSLog(@"tgtgtgtgtg");
            }else
            {
                ResetPhoneViewController *VC = [[ResetPhoneViewController alloc]init];
                
                [self.navigationController pushViewController:VC animated:YES];

            }

            
        }else
        
        if (indexPath.row==3) {
            
                AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                    if (![[appdelegate.shopInfoDic objectForKey:@"privi"] isEqualToString:@"register"]) {
                        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有修改权限!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                        [alertView show];
            
                        NSLog(@"tgtgtgtgtg");
                    }else
                    {
                        NewChangePsWordViewController *passVC=[[NewChangePsWordViewController alloc]init];
                        passVC.type_login = @"shop";
                        [self.navigationController pushViewController:passVC animated:YES];
                    }

            
           

//            self.selectRow =3;
//            [self NewAddAction];
        }else if (indexPath.row==6){
            PointRuleViewController *PointRuleView = [[PointRuleViewController alloc]init];
            PointRuleView.type = 8888;
            [self.navigationController pushViewController:PointRuleView animated:YES];
        }
        else if (indexPath.row==4) {
            
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            if (![[appdelegate.shopInfoDic objectForKey:@"privi"] isEqualToString:@"register"]) {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有修改权限!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                [alertView show];
                
                NSLog(@"tgtgtgtgtg");
            }else
            {
                self.selectRow =4;
                [self NewAddAction];
            }

            
        }
        
    }else {
//        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//        appdelegate.shopIsLogin = NO;
//        [self.navigationController popViewControllerAnimated:YES];
        //进入选择界面
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否确认退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
        
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
       
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [appdelegate loginOutBletcShop];
      
        [appdelegate _initChose];
    }else{
        //
    }
}

-(void)NewAddAction
{
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    self.alertView = alertView;
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView]];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确定", @"取消", nil]];
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
    UIView *demoView = [[UIView alloc] init ];
    demoView.frame =CGRectMake(0, 0, 290, 80);
    if(self.selectRow==4)
    {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 40)];
        label.text = @"修改地址";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:label];
        UITextField *nameText = [[UITextField alloc]initWithFrame:CGRectMake(30, 45, 230, 30)];
        self.addressText = nameText;
        nameText.placeholder = @" ";
        nameText.textAlignment = NSTextAlignmentCenter;
        nameText.layer.borderWidth = 0.5;
        nameText.font = [UIFont systemFontOfSize:11];
        nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:nameText];
        
    }
    else if(self.selectRow==3)
    {
        demoView.frame =CGRectMake(0, 0, 290, 160);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 40)];
        label.text = @"修改密码";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:label];
        //原密码
        UILabel *oldlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 50, 30)];
        oldlabel.text = @"原密码";
        oldlabel.textAlignment = NSTextAlignmentCenter;
        oldlabel.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:oldlabel];
        
        UITextField *nameText = [[UITextField alloc]initWithFrame:CGRectMake(70, 45, 200, 30)];
        nameText.keyboardType = UIKeyboardTypeASCIICapable;
        //nameText.placeholder = @"原密码";
        self.oldPswText = nameText;
        nameText.delegate = self;
        nameText.tag = 2002;
        //nameText.placeholder = @" ";
        nameText.textAlignment = NSTextAlignmentLeft;
        nameText.layer.borderWidth = 0.5;
        nameText.font = [UIFont systemFontOfSize:11];
        nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:nameText];
        //新密码
        UILabel *newlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 85, 50, 30)];
        newlabel.text = @"新密码";
        newlabel.textAlignment = NSTextAlignmentCenter;
        newlabel.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:newlabel];
        UITextField *pswText = [[UITextField alloc]initWithFrame:CGRectMake(70, 85, 200, 30)];
        pswText.keyboardType = UIKeyboardTypeASCIICapable;
        //pswText.placeholder = @"新密码";
        self.pswText = pswText;
        pswText.delegate = self;
        pswText.tag = 2002;
        //pswText.placeholder = @" ";
        pswText.textAlignment = NSTextAlignmentLeft;
        pswText.layer.borderWidth = 0.5;
        pswText.font = [UIFont systemFontOfSize:11];
        pswText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:pswText];
        //重复密码
        UILabel *newlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 125, 60, 30)];
        newlabel1.text = @"确认密码";
        newlabel1.textAlignment = NSTextAlignmentCenter;
        newlabel1.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:newlabel1];
        UITextField *pswdText = [[UITextField alloc]initWithFrame:CGRectMake(70, 125, 200, 30)];
        pswdText.keyboardType = UIKeyboardTypeASCIICapable;
        //pswdText.placeholder = @"重复密码";
        self.pswdText = pswdText;
        pswdText.delegate = self;
        pswdText.tag = 2002;
        //pswdText.placeholder = @" ";
        pswdText.textAlignment = NSTextAlignmentLeft;
        pswdText.layer.borderWidth = 0.5;
        pswdText.font = [UIFont systemFontOfSize:11];
        pswdText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:pswdText];
        
        
    }
    return demoView;
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    if (alertView.tag==0&&buttonIndex==0) {
        if (self.selectRow==3) {

            
            if (![self.pswText.text isEqualToString:self.pswdText.text])
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"请重新输入密码", @"HUD message title");
                
                hud.label.font = [UIFont systemFontOfSize:13];
                //    [hud setColor:[UIColor blackColor]];
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                hud.userInteractionEnabled = YES;
                
                [hud hideAnimated:YES afterDelay:2.f];
            }else if ([self.oldPswText.text isEqualToString:self.pswdText.text])
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"新密码和原密码相同,请重新输入", @"HUD message title");
                
                hud.label.font = [UIFont systemFontOfSize:13];
                //    [hud setColor:[UIColor blackColor]];
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                hud.userInteractionEnabled = YES;
                
                [hud hideAnimated:YES afterDelay:2.f];
            }else
            {
                [self postChangePsw];
            }
        }
        else if(self.selectRow==4)
        {
            [self postRequestAddress];
        }
    }
    else
        [alertView close];
}

//修改密码
-(void)postChangePsw
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/accountSet",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    [params setObject:@"passwd" forKey:@"type"];
    [params setObject:self.oldPswText.text forKey:@"pwd_old"];
    [params setObject:self.pswdText.text forKey:@"pwd_new"];
    
    NSLog(@"paramer===%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {

         if ([result[@"result_code"] intValue]==1) {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.label.text = NSLocalizedString(@"密码修改成功", @"HUD message title");
             
             hud.label.font = [UIFont systemFontOfSize:13];
             //    [hud setColor:[UIColor blackColor]];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             hud.userInteractionEnabled = YES;
             
             [hud hideAnimated:YES afterDelay:2.f];
             AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
             NSMutableDictionary *mutab_dic =appdelegate.shopInfoDic;
             
             


             NSLog(@"self.pswText.text==%@",self.pswText.text);
             
             [mutab_dic setValue:self.pswText.text forKey:@"passwd"];
             appdelegate.shopInfoDic = mutab_dic;

             

         }else
         {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.label.text = NSLocalizedString(result[@"result_code"], @"HUD message title");
             
             hud.label.font = [UIFont systemFontOfSize:13];
             //    [hud setColor:[UIColor blackColor]];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             hud.userInteractionEnabled = YES;
             
             [hud hideAnimated:YES afterDelay:2.f];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@", error);
         
     }];
    
    
}
-(void)postRequestAddress
{

    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/accountSet",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];


    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];

    [params setObject:@"address" forKey:@"type"];
    [params setObject:self.addressText.text forKey:@"para"];
    NSLog(@"%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         
         NSLog(@"%@", result);

         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
         hud.mode = MBProgressHUDModeText;
         if ([result[@"result_code"] intValue]==1) {
             hud.label.text = NSLocalizedString(@"修改成功", @"HUD message title");
             
             hud.label.font = [UIFont systemFontOfSize:13];
             //    [hud setColor:[UIColor blackColor]];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             hud.userInteractionEnabled = YES;
             
             [hud hideAnimated:YES afterDelay:2.f];
             
             AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
             NSMutableDictionary *mutab_dic =appdelegate.shopInfoDic;
             
             
             
             
             NSLog(@"self.pswText.text==%@",self.pswText.text);
             
             [mutab_dic setValue:self.addressText.text forKey:@"address"];
             appdelegate.shopInfoDic = mutab_dic;

             
             [self.Mytable reloadData];
         }else
         {
             hud.label.text = NSLocalizedString(@"请求失败 请重试", @"HUD message title");
             
             hud.label.font = [UIFont systemFontOfSize:13];
             //    [hud setColor:[UIColor blackColor]];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             hud.userInteractionEnabled = YES;
             
             [hud hideAnimated:YES afterDelay:2.f];
             
             
         }
         
         
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@", error);
         
     }];
    
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
