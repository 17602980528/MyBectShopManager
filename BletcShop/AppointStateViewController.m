//
//  AppointStateViewController.m
//  BletcShop
//
//  Created by apple on 16/12/17.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "AppointStateViewController.h"

@interface AppointStateViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AppointStateViewController
{
    UITableView *_tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(240, 240, 240);
    self.navigationItem.title=@"我的预约";
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    self.data_A=[[NSMutableArray alloc]initWithCapacity:0];
    [self postRequestAppointMent];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data_A.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *huiyuanLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 75, 30)];
        huiyuanLabel.text = @"卡片编号:";
        huiyuanLabel.font = [UIFont systemFontOfSize:15];
        huiyuanLabel.textColor = RGB(153,153,153);
        huiyuanLabel.tag = 900;
        huiyuanLabel.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:huiyuanLabel];
        
        UILabel *huiyuanText = [[UILabel alloc]initWithFrame:CGRectMake(102, 0, SCREENWIDTH-100, 30)];
        huiyuanText.text = @"洛天依";
        huiyuanText.textAlignment = NSTextAlignmentLeft;
        huiyuanText.font = [UIFont systemFontOfSize:15];
        huiyuanText.textColor = RGB(51,51,51);
        huiyuanText.tag = 901;
        [cell addSubview:huiyuanText];
    }
    
    if (self.data_A.count!=0) {
        NSDictionary *dic = self.data_A[indexPath.section];
        UILabel *huiyuanLabel = [cell viewWithTag:900];
        UILabel *huiyuanText = [cell viewWithTag:901];
        switch (indexPath.row) {
            case 0:
            {
                huiyuanLabel.text = @"预约时间:";
                huiyuanText.text = dic[@"time"];
                
            }
                break;
            case 1:
            {
                huiyuanLabel.text = @"预约内容";
                huiyuanText.text = dic[@"content"];
                
            }
                break;
            case 2:
            {
                huiyuanLabel.text = @"申请日期:";
                huiyuanText.text = [NSString stringWithFormat:@"%@",dic[@"date"]];
                
                
            }
                break;
    
            default:
                break;
        }
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 41+10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 41+10)];
    view.backgroundColor = [UIColor whiteColor];
    for (UIView*subview in view.subviews) {
        [subview removeFromSuperview];
    }
    
    UIView *line0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    line0.backgroundColor = RGB(239,238,244);
    [view addSubview:line0];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(12, line0.bottom, 75, 40)];
    lab.text = @"处理状态:";
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = RGB(153,153,153);
    lab.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lab];
    
    
    UILabel *card_code_lab = [[UILabel alloc]initWithFrame:CGRectMake(102, line0.bottom, SCREENWIDTH-100, 40)];
    card_code_lab.text = @"";
    card_code_lab.font = [UIFont systemFontOfSize:15];
    card_code_lab.textColor = RGB(51,51,51);
    card_code_lab.textAlignment = NSTextAlignmentLeft;
    [view addSubview:card_code_lab];
    
    UILabel *state_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, line0.bottom, SCREENWIDTH-43, 40)];
    state_lab.font = [UIFont systemFontOfSize:12];
    state_lab.textColor = RGB(153,153,153);
    state_lab.textAlignment = NSTextAlignmentRight;
    [view addSubview:state_lab];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, state_lab.bottom, SCREENWIDTH, 1)];
    line.backgroundColor = RGB(246,246,246);
    [view addSubview:line];
    
    if (self.data_A.count!=0) {
//        card_code_lab.text = self.data_A[section][@"name"];
        NSString *state_S =self.data_A[section][@"state"];
        
        if ([state_S isEqualToString:@"access"]) {
            card_code_lab.text = @"已同意";
        }
        if ([state_S isEqualToString:@"fail"]) {
            card_code_lab.text = @"已拒绝";
        }
        if ([state_S isEqualToString:@"null"]) {
            card_code_lab.text = @"正在处理...";
        }
    }
    
    return view;
}
-(void)postRequestAppointMent
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/appoint/check",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"]  forKey:@"uuid"];
    [params setObject:self.dic[@"merchant"] forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"%@", result);
        NSArray *resuArr = result;
        for (int i=0;i<resuArr.count;i++) {
            
        [self.data_A addObject:resuArr[i]];

        }
        if (_tableView) {
            [_tableView reloadData];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请求出错,请重新请求", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
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
