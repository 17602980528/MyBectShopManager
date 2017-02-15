//
//  ShopMoreViewController.m
//  BletcShop
//
//  Created by Yuan on 16/1/28.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShopMoreViewController.h"
#import "MoreViewCell.h"
#import "CreditThanViewController.h"
#import "FeedBackViewController.h"
#import "ShopUserInfoViewController.h"
#import "BackChooseStateViewController.h"
#import "NewNextViewController.h"
@interface ShopMoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *data;
@property(nonatomic,weak)UITableView *setTable;
@end

@implementation ShopMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"更多";
    [self _initTable];
    
}
-(NSArray *)data
{
    if (_data == nil) {
        

        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        NSString *bankAccount = [NSString getTheNoNullStr:app.shopInfoDic[@"account"] andRepalceStr:@""];
        NSString *bankName = [NSString getTheNoNullStr:app.shopInfoDic[@"name"] andRepalceStr:@""];
        NSString *bankAddress = [NSString getTheNoNullStr:app.shopInfoDic[@"bank"] andRepalceStr:@""];
        

        NSString *log_success = [[NSUserDefaults standardUserDefaults]objectForKey:@"wangyongle"];

        
        if ([log_success isEqualToString:@"login_access"] && bankAccount.length==19 && bankName.length!=0 && bankAddress!=0) {
            
            

            _data = @[@[@"我的账户"],@[@"退出",@"切换账号"],@[@"意见反馈"]];
            
        }else{
            _data = @[@[@"我的账户",@"认证信息"],@[@"退出",@"切换账号"],@[@"意见反馈"]];
            
        }
    }
    return _data;
}
-(void)_initTable
{
    UITableView *setTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStyleGrouped];
    setTable.delegate = self;
    setTable.dataSource = self;
    setTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    setTable.showsVerticalScrollIndicator = NO;
    setTable.bounces = NO;
    self.setTable = setTable;
    [self.view addSubview:setTable];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 4;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else
    return 4;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.data[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    MoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[MoreViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.data = self.data[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {

        NewNextViewController *VC = [[NewNextViewController alloc]init];
        [self presentViewController:VC animated:YES completion:nil];
        
    }if (indexPath.section ==1) {
        if (indexPath.row==0) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出应用?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
            
            [alert show];
        }else if (indexPath.row==1){
            
          
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            

            [appdelegate loginOutBletcShop];
      
            BackChooseStateViewController *backVC=[[BackChooseStateViewController alloc]init];
            [self presentViewController:backVC animated:YES completion:nil];
            
        }
    }else if (indexPath.section == 0 && indexPath.row == 0)
    {

        ShopUserInfoViewController *creditView = [[ShopUserInfoViewController alloc]init];
        [self.navigationController pushViewController:creditView animated:YES];
    }

    
    else if (indexPath.section == 2 && indexPath.row == 0)
    {
        FeedBackViewController *feedBackView = [[FeedBackViewController alloc]init];
        [self.navigationController pushViewController:feedBackView animated:YES];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if(buttonIndex ==0){
        
        
        [self exitApplication ];
        
    }
    
}

- (void)exitApplication
{
    
  
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.socketCutBy=1;
    [app cutOffSocket];
    UIWindow *window = app.window;
    
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    //exit(0);
    
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
