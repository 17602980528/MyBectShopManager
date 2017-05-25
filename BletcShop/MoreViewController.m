//
//  MoreViewController.m
//  BletcShop
//
//  Created by wuzhengdong on 16/1/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreViewCell.h"

#import "FeedBackViewController.h"
#import "BackChooseStateViewController.h"
//#import "UMSocial.h"
#import <UMSocialCore/UMSocialCore.h>
#import "LZDConversationViewController.h"

#import "ShareViewController.h"

//#import "LZDCommonViewController.h"
#import "LZDBASEViewController.h"


#import "LZDContactViewController.h"

#import "SDImageCache.h"
#import "ContactSeverViewController.h"
#import "HotNewsVC.h"
@interface MoreViewController()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *data;
@property(nonatomic,weak)UITableView *setTable;

@end

@implementation MoreViewController
{
    float folderSize ;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"更多";
    
    folderSize =[[SDImageCache sharedImageCache] getSize]/1000.0/1000.0;

    [self _initTable];
    
    
}
-(NSArray *)data
{
    if (_data == nil) {
//        _data = @[@[@"联系共同会员",@"邀请好友使用"],@[@"退出",@"切换用户"],@[@"意见反馈"]];
        _data = @[@[@"切换用户"],@[@"清理缓存",@"意见反馈",@"联系客服",@"帮助中心"]];

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
    
    if (section ==0) {
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
       
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-100-50, 7, 100, 30)];
        label.tag=100;
        label.font=[UIFont systemFontOfSize:15.0f];
        label.textAlignment=1;
        [cell addSubview:label];
        cell.textLabel.font = [UIFont systemFontOfSize:15];

    }

    cell.data = self.data[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:cell.data];

    UILabel *lab=[cell viewWithTag:100];
    if (indexPath.section==1&&indexPath.row==0) {
        lab.text=[NSString stringWithFormat:@"%.2fM",folderSize];
    }else{
        lab.text=@"";
    }
    
    return cell;

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        if (indexPath.row ==0) {
         
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

            [appdelegate loginOutBletcShop];
            
            BackChooseStateViewController *backVC=[[BackChooseStateViewController alloc]init];
            [self presentViewController:backVC animated:YES completion:nil];
        }
        
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row==0) {
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];//可有可无
            folderSize=0;
            [tableView reloadData];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"清理缓存成功", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:2.f];
        }else if (indexPath.row==1){
            FeedBackViewController *feedBackView = [[FeedBackViewController alloc]init];
            [self.navigationController pushViewController:feedBackView animated:YES];
        }else if (indexPath.row==2){
            ContactSeverViewController *severVC=[[ContactSeverViewController alloc]init];
            [self.navigationController pushViewController:severVC animated:YES];
        }else{
            
            HotNewsVC *VC = [[HotNewsVC alloc]init];
            VC.title = @"帮助中心";
            VC.href = @"http://www.cnconsum.com/cnconsum/helpCenter/user";

            [self presentViewController:VC animated:YES completion:nil];
            
        }
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
