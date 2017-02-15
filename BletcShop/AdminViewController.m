//
//  AdminViewController.m
//  BletcShop
//
//  Created by Bletc on 16/4/21.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "AdminViewController.h"

#import "AddAdminVC.h"

@interface AdminViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,AddAdminVCDelegate>
@property(nonatomic,weak)UIScrollView *listView;
@property(nonatomic,strong)NSArray *data;
@property(nonatomic,weak)UIView *listView1;
@property(nonatomic,strong)UITableView *tabView;
@property(nonatomic,weak)UIView *TopView;
@end

@implementation AdminViewController
{
    UIToolbar *toolView;
    
    UIView *back_View;//背景,权限
}
-(void)viewWillAppear:(BOOL)animated
{
    self.title = @"管理员设置";
}
-(NSDictionary *)edit_dic{
    if (!_edit_dic) {
        _edit_dic = [NSDictionary dictionary];
    }
    return _edit_dic;
}
-(void)reloadAPI{
    [self postRequest];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.ifOpenQX = NO;
    self.view.backgroundColor = RGB(240, 240, 240);
    
    UIButton *menuBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [menuBt addTarget:self action:@selector(addNewPerson) forControlEvents:UIControlEventTouchUpInside];
    [menuBt setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateNormal];
    [menuBt setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateHighlighted];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:menuBt];
    self.navigationItem.rightBarButtonItem = item;
    
    
    
    self.editTag = 0;
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    if([[appdelegate.shopInfoDic objectForKey:@"privi"] isEqualToString:@"register"])
    {
        self.array= @[@"经营者",@"店长",@"店员"];
    }else if([[appdelegate.shopInfoDic objectForKey:@"privi"] isEqualToString:@"operator"])
    {
        self.array= @[@"店长",@"店员"];
    }else if([[appdelegate.shopInfoDic objectForKey:@"privi"] isEqualToString:@"shopMg"])

    {
        self.array= @[@"店员"];
    }
    self.clerkString = [[NSString alloc]init];
    self.clerkString = @"";
    [self _initUI2];
    [self postRequest];
    
}

-(void)postRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/admin/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    AdminViewController *tempSelf=self;
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"postRequest==%@", result);
        tempSelf.data = result;
        if (_data.count>0) {
            if (tempSelf.tabView) {
                [_tabView reloadData];
            }
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    AdminViewController *tempSelf=self;
    tempSelf.edit_dic = [self.data objectAtIndex:indexPath.row];

    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        if([[appdelegate.shopInfoDic objectForKey:@"privi"] isEqualToString:tempSelf.edit_dic[@"privi"]] || ([[appdelegate.shopInfoDic objectForKey:@"privi"] isEqualToString:@"shopMg"] && [tempSelf.edit_dic[@"privi"] isEqualToString:@"operator"]) )
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有该权限!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alertView show];
            
        }else{
            
//            tempSelf.editTag=2;
//            [tempSelf NewAddVipAction];
            NSString *string=[[NSString alloc]initWithFormat:@"是否删除管理员:%@",self.edit_dic[@"account"]];
            
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alertView.tag=10000;
            alertView.delegate=self;
            [alertView show];
        }

        
    }];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

        if([[appdelegate.shopInfoDic objectForKey:@"privi"] isEqualToString:tempSelf.edit_dic[@"privi"]] || ([[appdelegate.shopInfoDic objectForKey:@"privi"] isEqualToString:@"shopMg"] && [tempSelf.edit_dic[@"privi"] isEqualToString:@"operator"]) )
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有该权限!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alertView show];
            
        }else{
            AddAdminVC *VC = [[AddAdminVC alloc]init];
            VC.delegate = self;
            
            VC.editTag=1;
            VC.edit_dic = [self.data objectAtIndex:indexPath.row];
            [tempSelf.navigationController pushViewController:VC animated:YES];

            
        }

        
       //        [tempSelf NewAddVipAction];
    }];
    editAction.backgroundColor = [UIColor grayColor];
    return @[deleteAction, editAction];
}


-(void)addNewPerson{
//    self.editTag = 0;
//    [self NewAddVipAction];
    
    AddAdminVC *VC = [[AddAdminVC alloc]init];
    VC.delegate = self;
    VC.editTag=0;

    [self.navigationController pushViewController:VC animated:YES];
}
-(void)NewAddVipAction
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    [alertView setContainerView:[self createDemoView]];
    
    [alertView setParentView:self.view];
    
    if (self.editTag==0) {
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确定", @"取消", nil]];
    }else if (self.editTag==1)
    {
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"修改", @"取消", nil]];
    }else if (self.editTag==2)
    {
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"删除", @"取消", nil]];
    }
    
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:YES];
    
    // And launch the dialog
    [alertView show];
    
    NSLog(@"=====%@",alertView);
    
    
}
-(void)postRequestAddAdmin
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/admin/add",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:self.nameText.text forKey:@"account"];
    [params setObject:self.passText.text forKey:@"passwd"];
    if (!self.boyBtn.selected&&self.girlBtn.selected) {
        [params setObject:@"女" forKey:@"sex"];
    }else if (self.boyBtn.selected&&!self.girlBtn.selected) {
        [params setObject:@"男" forKey:@"sex"];
    }
    
    if ([self.clerkLabel.text isEqualToString:@"经营者"]) {
        [params setObject:@"operator" forKey:@"privi"];
    }else if ([self.clerkLabel.text isEqualToString:@"店长"]) {
        [params setObject:@"shopMg" forKey:@"privi"];
    }else if ([self.clerkLabel.text isEqualToString:@"店员"]) {
        [params setObject:@"shopAs" forKey:@"privi"];
    }
    [params setObject:self.clerkLabel.text forKey:@"position"];
    
    [params setObject:self.phoneText.text forKey:@"phone"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"postRequestAddAdmin==%@", result);
        NSDictionary *result_dic = (NSDictionary*)result;
        
        
        if ([result_dic[@"result_code"]intValue]==1) {
            [self postRequest];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"添加成功", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:4.f];
            [self.TabSc reloadData];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //hud.frame = CGRectMake(0, 64, 375, 667);
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"添加出错,请重新添加", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            // Move to bottm center.
            //    hud.offset = CGPointMake(0.f, );
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:4.f];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"添加出错,请重新添加", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }];
    
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (alertView.tag==0&&buttonIndex==1) {
        [alertView close];
    }
    else if (alertView.tag==0&&buttonIndex==0)
    {
        if (self.editTag==0) {
            if([self.nameText.text isEqualToString:@""]||self.nameText.text==nil)
            {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写账号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                [alertView show];
            }else if([self.passText.text isEqualToString:@""]||self.nameText.text==nil)
            {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                [alertView show];
            }else if([self.phoneText.text isEqualToString:@""]||self.nameText.text==nil)
            {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写联系方式" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                [alertView show];
            }else
                [self postRequestAddAdmin];
        }else if (self.editTag==1){
            [self postRequestEditAdmin];
        }else if (self.editTag==2){
            
                [self postRequestDeleteAdmin];
            
        }
        
    }else if (alertView.tag==1&&buttonIndex==0){
        
    }
    NSLog(@"alertView.tag %d buttonIndex %d == editTag ==%ld", (int)buttonIndex, (int)[alertView tag],_editTag);
    [alertView close];
}

/**
 删除管理员
 */
-(void)postRequestDeleteAdmin
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/admin/del",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    
    [params setObject:self.edit_dic[@"account"] forKey:@"account"];
    
    NSLog(@"params==%@", params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);
        NSDictionary *resut_dic = (NSDictionary*)result;
        if ([resut_dic[@"result_code"] intValue]==1) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.font = [UIFont systemFontOfSize:13];
            
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:4.f];
            hud.label.text = NSLocalizedString(@"删除成功", @"HUD message title");
            [self postRequest];
            
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

/**
 编辑管理员信息
 */
-(void)postRequestEditAdmin
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/admin/mod",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:self.nameText.text forKey:@"account"];
    [params setObject:self.passText.text forKey:@"passwd"];
    if (!self.boyBtn.selected&&self.girlBtn.selected) {
        [params setObject:@"女" forKey:@"sex"];
    }else if (self.boyBtn.selected&&!self.girlBtn.selected) {
        [params setObject:@"男" forKey:@"sex"];
    }
    if ([self.clerkLabel.text isEqualToString:@"经营者"]) {
        [params setObject:@"operator" forKey:@"privi"];
    }else if ([self.clerkLabel.text isEqualToString:@"店长"]) {
        [params setObject:@"shopMg" forKey:@"privi"];
    }else if ([self.clerkLabel.text isEqualToString:@"店员"]) {
        [params setObject:@"shopAs" forKey:@"privi"];
    }
    [params setObject:self.clerkLabel.text forKey:@"position"];
    [params setObject:self.phoneText.text forKey:@"phone"];
    [params setObject:self.edit_dic[@"account"] forKey:@"eaccount"];
    
    NSLog(@"paremer==%@", params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);
        NSDictionary *result_dic = (NSDictionary*)result;
        if ([result_dic[@"result_code"] intValue]==1) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:3.f];
            hud.label.text = NSLocalizedString(@"修改成功", @"HUD message title");
            [self postRequest];
            
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

#pragma mark 创建一个填写账户密码的提示框

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 250)];
    self.demoView = demoView;
    if(self.editTag ==0){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 50)];
        label.text = @"管理员账号:";
        label.font = [UIFont systemFontOfSize:14];
        [demoView addSubview:label];
        UITextField *nameText = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, 160, 30)];
        nameText.delegate = self;
        nameText.layer.borderWidth = 0.3;
        nameText.backgroundColor = tableViewBackgroundColor;
        self.nameText = nameText;
        nameText.font = [UIFont systemFontOfSize:14];
        [demoView addSubview:nameText];
        
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
        line2.backgroundColor = [UIColor grayColor];
        line2.alpha = 0.3;
        [demoView addSubview:line2];
        
        //密码
        UILabel *phonelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 80, 50)];
        phonelabel.text = @"密码:";
        phonelabel.font = [UIFont systemFontOfSize:14];
        [demoView addSubview:phonelabel];
        UITextField *phoneText = [[UITextField alloc]initWithFrame:CGRectMake(90, 60, 160, 30)];
        phoneText.layer.borderWidth = 0.3;
        phoneText.backgroundColor = tableViewBackgroundColor;
        phoneText.delegate = self;
        self.passText = phoneText;
        phoneText.font = [UIFont systemFontOfSize:14];
        //        phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:phoneText];
        UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 0.3)];
        linePhone.backgroundColor = [UIColor grayColor];
        linePhone.alpha = 0.3;
        [demoView addSubview:linePhone];
        //权限
        UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 80, 50)];
        levelLabel.text = @"权限:";
        levelLabel.font = [UIFont systemFontOfSize:14];
        [demoView addSubview:levelLabel];
        
        
        UILabel *clerkLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 110, 80, 30)];
        clerkLabel.layer.borderWidth = 0.3;
        clerkLabel.textAlignment = NSTextAlignmentCenter;
        self.clerkLabel=clerkLabel;
        if ([self.clerkString isEqualToString:@""]) {
            clerkLabel.text = @"店员";
        }
        else
        {
            clerkLabel.text = self.clerkString;
        }
        NSLog(@"%@",clerkLabel.text);
        clerkLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:clerkLabel];
        UIButton *choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        choiceBtn.frame = CGRectMake(170, 110, 40, 30);
        [choiceBtn setImage:[UIImage imageNamed:@"arraw_right"] forState:UIControlStateNormal];
        [demoView addSubview:choiceBtn];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(90, 110, CGRectGetMaxY(choiceBtn.frame), 30);
        [button addTarget:self action:@selector(choseClerk) forControlEvents:UIControlEventTouchUpInside];
        [demoView addSubview:button];
        
        
        UIView *lineLevel = [[UIView alloc]initWithFrame:CGRectMake(0, 150, SCREENWIDTH, 0.3)];
        lineLevel.backgroundColor = [UIColor grayColor];
        lineLevel.alpha = 0.3;
        [demoView addSubview:lineLevel];
        //性别
        UILabel *sexlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 80, 50)];
        sexlabel.text = @"性别:";
        sexlabel.font = [UIFont systemFontOfSize:14];
        [demoView addSubview:sexlabel];
        //男
        UIButton *boyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        boyBtn.frame = CGRectMake(100, 165, 20, 20);
        //    choseBtn.backgroundColor = [UIColor redColor];
        [boyBtn setImage:[UIImage imageNamed:@"weigouxuan"] forState:UIControlStateNormal];
        [boyBtn setImage:[UIImage imageNamed:@"gouxuan@"] forState:UIControlStateSelected];
        [boyBtn addTarget:self action:@selector(boyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        self.boyBtn = boyBtn;
        [demoView addSubview:boyBtn];
        //
        UILabel *boylabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 160, 20, 30)];
        boylabel.text = @"男";
        boylabel.font = [UIFont systemFontOfSize:14];
        [demoView addSubview:boylabel];
        ////女
        UIButton *girlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        girlBtn.frame = CGRectMake(150, 165, 20, 20);
        //    choseBtn.backgroundColor = [UIColor redColor];
        [girlBtn setImage:[UIImage imageNamed:@"weigouxuan"] forState:UIControlStateNormal];
        [girlBtn setImage:[UIImage imageNamed:@"gouxuan@"] forState:UIControlStateSelected];
        [girlBtn addTarget:self action:@selector(girlBtnAction) forControlEvents:UIControlEventTouchUpInside];
        self.girlBtn = girlBtn;
        [demoView addSubview:girlBtn];
        //
        UILabel *girllabel = [[UILabel alloc]initWithFrame:CGRectMake(175, 160, 20, 30)];
        girllabel.text = @"女";
        girllabel.font = [UIFont systemFontOfSize:14];
        [demoView addSubview:girllabel];
        //联系方式
        UILabel *addresslabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, 80, 50)];
        addresslabel.text = @"联系方式:";
        addresslabel.font = [UIFont systemFontOfSize:14];
        [demoView addSubview:addresslabel];
        UITextField *addressText = [[UITextField alloc]initWithFrame:CGRectMake(90, 210, 160, 30)];
        addressText.layer.borderWidth = 0.3;
        addressText.backgroundColor = tableViewBackgroundColor;
        
        //        addressText.placeholder = @"";
        //        [addressText setInputAccessoryView:toolView];
        addressText.delegate =  self;
        self.phoneText = addressText;
        addressText.font = [UIFont systemFontOfSize:14];
        //        addressText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:addressText];
        UIView *lineAdd = [[UIView alloc]initWithFrame:CGRectMake(0, 200, SCREENWIDTH, 0.3)];
        lineAdd.backgroundColor = [UIColor grayColor];
        lineAdd.alpha = 0.3;
        [demoView addSubview:lineAdd];
        
        
        [self initchoseViews:clerkLabel andBack:demoView];
        
        
    }
    else if (self.editTag==1)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 50)];
        label.text = @"管理员账号:";
        label.font = [UIFont systemFontOfSize:14];
        [demoView addSubview:label];
        UITextField *nameText = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, 160, 30)];
        nameText.layer.borderWidth = 0.3;
        nameText.backgroundColor = tableViewBackgroundColor;
        nameText.text = self.edit_dic[@"account"];
        nameText.delegate = self;
        self.nameText = nameText;
        nameText.font = [UIFont systemFontOfSize:14];
        [demoView addSubview:nameText];
        
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
        line2.backgroundColor = [UIColor grayColor];
        line2.alpha = 0.3;
        [demoView addSubview:line2];
        
        //密码
        UILabel *phonelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 80, 50)];
        phonelabel.text = @"密码:";
        phonelabel.font = [UIFont systemFontOfSize:14];
        [demoView addSubview:phonelabel];
        UITextField *phoneText = [[UITextField alloc]initWithFrame:CGRectMake(90, 60, 160, 30)];
        phoneText.layer.borderWidth = 0.3;
        phoneText.backgroundColor = tableViewBackgroundColor;
        phoneText.text = self.edit_dic[@"passwd"];
        phoneText.delegate = self;
        //        [phoneText setInputAccessoryView:toolView];
        self.passText = phoneText;
        phoneText.font = [UIFont systemFontOfSize:14];
        //        phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:phoneText];
        UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 0.3)];
        linePhone.backgroundColor = [UIColor grayColor];
        linePhone.alpha = 0.3;
        [demoView addSubview:linePhone];
        //权限
        UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 80, 50)];
        levelLabel.text = @"权限:";
        levelLabel.font = [UIFont systemFontOfSize:14];
        [demoView addSubview:levelLabel];
        UILabel *clerkLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 110, 80, 30)];
        clerkLabel.layer.borderWidth = 0.3;
        clerkLabel.textAlignment = NSTextAlignmentCenter;
        self.clerkLabel=clerkLabel;
        clerkLabel.text = self.edit_dic[@"position"];        NSLog(@"%@",clerkLabel.text);
        clerkLabel.font = [UIFont systemFontOfSize:14];
        [demoView addSubview:clerkLabel];
        UIButton *choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        choiceBtn.frame = CGRectMake(170, 110, 40, 30);
        
        [choiceBtn setImage:[UIImage imageNamed:@"arraw_right"] forState:UIControlStateNormal];
        [choiceBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateSelected];
        //        [choiceBtn addTarget:self action:@selector(choiceAction) forControlEvents:UIControlEventTouchUpInside];
        //    self.boyBtn = boyBtn;
        [demoView addSubview:choiceBtn];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(90, 110, CGRectGetMaxY(choiceBtn.frame), 30);
        [button addTarget:self action:@selector(choseClerk) forControlEvents:UIControlEventTouchUpInside];
        [demoView addSubview:button];
        
        
        
        UIView *lineLevel = [[UIView alloc]initWithFrame:CGRectMake(0, 150, SCREENWIDTH, 0.3)];
        lineLevel.backgroundColor = [UIColor grayColor];
        lineLevel.alpha = 0.3;
        [demoView addSubview:lineLevel];
        //性别
        UILabel *sexlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 80, 50)];
        sexlabel.text = @"性别:";
        sexlabel.font = [UIFont systemFontOfSize:14];
        [demoView addSubview:sexlabel];
        //男
        UIButton *boyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        boyBtn.frame = CGRectMake(100, 165, 20, 20);
        //    choseBtn.backgroundColor = [UIColor redColor];
        
        [boyBtn addTarget:self action:@selector(boyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        self.boyBtn = boyBtn;
        [demoView addSubview:boyBtn];
        //
        UILabel *boylabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 160, 20, 30)];
        boylabel.text = @"男";
        boylabel.font = [UIFont systemFontOfSize:14];
        [demoView addSubview:boylabel];
        ////女
        UIButton *girlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        girlBtn.frame = CGRectMake(150, 165, 20, 20);
        //    choseBtn.backgroundColor = [UIColor redColor];
        
        [girlBtn addTarget:self action:@selector(girlBtnAction) forControlEvents:UIControlEventTouchUpInside];
        self.girlBtn = girlBtn;
        [demoView addSubview:girlBtn];
        //
        UILabel *girllabel = [[UILabel alloc]initWithFrame:CGRectMake(175, 160, 20, 30)];
        girllabel.text = @"女";
        girllabel.font = [UIFont systemFontOfSize:14];
        [demoView addSubview:girllabel];
        if ([self.edit_dic[@"sex"] isEqualToString:@"男"])
        {
            self.boyBtn.selected = YES;
        }else if ([self.edit_dic[@"sex"] isEqualToString:@"女"])
        {
            self.girlBtn.selected = YES;
        }
        [boyBtn setImage:[UIImage imageNamed:@"weigouxuan"] forState:UIControlStateNormal];
        [boyBtn setImage:[UIImage imageNamed:@"gouxuan@"] forState:UIControlStateSelected];
        [girlBtn setImage:[UIImage imageNamed:@"weigouxuan"] forState:UIControlStateNormal];
        [girlBtn setImage:[UIImage imageNamed:@"gouxuan@"] forState:UIControlStateSelected];
        //联系方式
        UILabel *addresslabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, 80, 50)];
        addresslabel.text = @"联系方式:";
        addresslabel.font = [UIFont systemFontOfSize:14];
        [demoView addSubview:addresslabel];
        UITextField *addressText = [[UITextField alloc]initWithFrame:CGRectMake(90, 210, 160, 30)];
        addressText.layer.borderWidth = 0.3;
        addressText.backgroundColor = tableViewBackgroundColor;
        addressText.text =self.edit_dic[@"phone"];
        addressText.delegate = self;
        //        [addressText setInputAccessoryView:toolView];
        self.phoneText = addressText;
        addressText.font = [UIFont systemFontOfSize:14];
        //        addressText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:addressText];
        UIView *lineAdd = [[UIView alloc]initWithFrame:CGRectMake(0, 200, SCREENWIDTH, 0.3)];
        
        lineAdd.backgroundColor = [UIColor grayColor];
        lineAdd.alpha = 0.3;
        [demoView addSubview:lineAdd];
        
        [self initchoseViews:clerkLabel andBack:demoView];
        
    }else if(self.editTag == 2)
    {
        demoView.frame=CGRectMake(0, 0, 290, 40);
        UILabel *numlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, demoView.width, 40)];
        numlabel.textAlignment = NSTextAlignmentCenter;
        numlabel.text = [[NSString alloc]initWithFormat:@"确定删除管理员:%@",self.edit_dic[@"account"]];
        numlabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:numlabel];
    }
    
    return demoView;
}

-(void)choseClerk{
    NSLog(@"======%d",_ifOpenQX);
    if (_ifOpenQX == NO) {
        back_View.hidden = NO;
        
        _ifOpenQX = YES;
    }
    else
    {
        back_View.hidden = YES;
        
        _ifOpenQX = NO;
    }
    
}
-(void)choiceAction:(UIButton*)button
{
    _ifOpenQX = !_ifOpenQX;
    back_View.hidden = YES;
    self.clerkLabel.text = self.array[button.tag];
    self.clerkString =self.array[button.tag];
    
    
}


-(void)boyBtnAction
{
    self.boyBtn.selected=YES;
    self.girlBtn.selected=NO;
    
}

-(void)girlBtnAction
{
    self.girlBtn.selected=YES;
    self.boyBtn.selected=NO;
    
}

-(void)initchoseViews:(UILabel *)clerklab andBack:(UIView*)back_V{
    back_View = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(clerklab.frame), CGRectGetMaxY(clerklab.frame), CGRectGetWidth(clerklab.frame), 100)];
    back_View.hidden = YES;

    [back_V addSubview:back_View];
    
    
    for (int i = 0; i <self.array.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button .frame = CGRectMake(0, i*40, CGRectGetWidth(clerklab.frame), 40);
        [button setTitle:_array[i] forState:UIControlStateNormal];
        button.backgroundColor =[UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.borderWidth = 0.3;
        button.tag = i;
        [button addTarget:self action:@selector(choiceAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [back_View addSubview:button];
        
        //重设背景frame
        if (i==_array.count-1) {
            back_View.frame =CGRectMake(CGRectGetMinX(clerklab.frame), CGRectGetMaxY(clerklab.frame), CGRectGetWidth(clerklab.frame), CGRectGetMaxY(button.frame));
        }
        
    }
}
-(void)_initUI2
{
    //列表的滑动视图
    
    _tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 , SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    _tabView.bounces = YES;
    _tabView.backgroundColor = RGB(240, 240, 240);
    [self.view addSubview:_tabView];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.backgroundColor = [UIColor whiteColor];
        UIImageView *headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 44, 44)];
        headImageView.layer.cornerRadius=22.0f;
        headImageView.clipsToBounds=YES;
        [cell addSubview:headImageView];
        headImageView.tag=500;
        
        UILabel *accountAccess=[[UILabel alloc]initWithFrame:CGRectMake(66, 10, SCREENWIDTH-64, 22)];
        accountAccess.tag=600;
        accountAccess.textColor=RGB(51, 51, 51);
        accountAccess.font=[UIFont systemFontOfSize:16.0f];
        [cell addSubview:accountAccess];
        
        UILabel *phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(66, 32,  SCREENWIDTH-64, 22)];
        phoneLabel.font=[UIFont systemFontOfSize:13.0f];
        phoneLabel.tag=700;
        phoneLabel.textColor=RGB(102, 102, 102);
        [cell addSubview:phoneLabel];
    }
    
    UIImageView *imgView=[cell viewWithTag:500];
    if ([[[self.data objectAtIndex:indexPath.row] objectForKey:@"sex"] isEqualToString:@"男"]) {
        imgView.image=[UIImage imageNamed:@"头像-6"];
    }else if ([[[self.data objectAtIndex:indexPath.row] objectForKey:@"sex"] isEqualToString:@"女"]){
        imgView.image=[UIImage imageNamed:@"头像-1"];
    }else{
        imgView.image=[UIImage imageNamed:@"头像"];
    }
    UILabel *topLabel=[cell viewWithTag:600];
    topLabel.text=[NSString stringWithFormat:@"%@(%@)",[[self.data objectAtIndex:indexPath.row] objectForKey:@"account"],[[self.data objectAtIndex:indexPath.row] objectForKey:@"position"]];
    UILabel *phone=[cell viewWithTag:700];
    phone.text=[[self.data objectAtIndex:indexPath.row] objectForKey:@"phone"];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)editBtnAction:(UIButton *)Btn
{
    self.editTag=1;
    self.edit_dic = [self.data objectAtIndex:Btn.tag];
    [self NewAddVipAction];
    
}
-(void)deleteBtnAction:(UIButton *)Btn
{
    self.editTag=2;
    self.edit_dic = [self.data objectAtIndex:Btn.tag];
    [self NewAddVipAction];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)dismissKeyBoard{
    
    [self.phoneText resignFirstResponder];
    [self.passText resignFirstResponder];
    [self.nameText resignFirstResponder];
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            [self postRequestDeleteAdmin];
        }
    }
}

@end
