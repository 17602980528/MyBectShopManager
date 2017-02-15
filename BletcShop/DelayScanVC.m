//
//  DelayScanVC.m
//  BletcShop
//
//  Created by Bletc on 2016/12/17.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "DelayScanVC.h"

@interface DelayScanVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSDictionary *deadLine_dic;// <#Description#>
@property (nonatomic , strong) UITableView *table_View;
@property (nonatomic , strong) NSMutableArray  *data_A;// 数据源数组

@end

@implementation DelayScanVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的延期";
    self.view.backgroundColor = [UIColor whiteColor];
    

    
    self.table_View =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    self.table_View.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table_View.delegate=self;
    self.table_View.dataSource=self;
    self.table_View.bounces = NO;
    [self.view addSubview:self.table_View];


    
    [self  postGetDate];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    
    return self.data_A.count;
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    lab.text = @"卡片编号:";
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = RGB(153,153,153);
    lab.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lab];
    
    
    UILabel *card_code_lab = [[UILabel alloc]initWithFrame:CGRectMake(102, line0.bottom, SCREENWIDTH-100, 40)];
    card_code_lab.text = @"卡片编号:";
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
        card_code_lab.text = self.data_A[section][@"card_code"];
        NSString *state_S =self.data_A[section][@"state"];
        
        if ([state_S isEqualToString:@"access"]) {
            state_lab.text = @"已同意";
        }
        if ([state_S isEqualToString:@"fail"]) {
            state_lab.text = @"已拒绝";
        }
        if ([state_S isEqualToString:@"null"]) {
            state_lab.text = @"处理中";
        }

    }
    
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    // 定义唯一标识
    // 通过indexPath创建cell实例 每一个cell都是单独的
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
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
                huiyuanLabel.text = @"卡片类型:";
                huiyuanText.text = dic[@"card_type"];
                
                
            }
                break;
            case 1:
            {
                huiyuanLabel.text = @"卡片级别:";
                huiyuanText.text = dic[@"card_level"];
                
                
            }
                break;
            case 2:
            {
                huiyuanLabel.text = @"延长期限:";
                huiyuanText.text = [self.deadLine_dic objectForKey:dic[@"postpone"]];
                
                
                
            }
                break;
                
            case 3:
            {
                huiyuanLabel.text = @"申请时间:";
                huiyuanText.text = dic[@"datetime"];
                
                
                
            }
                break;

            default:
                break;
        }
        
    }
    
    
    
    return cell;
}

-(void)postGetDate{
    NSString *url = [NSString stringWithFormat:@"%@UserType/postpone/check",BASEURL];
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
    [paramer setValue:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [paramer setValue:self.muid forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"===%@",result);
        
        self.data_A = result;
        [self.table_View reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

-(NSDictionary *)deadLine_dic{
    if (!_deadLine_dic) {
        _deadLine_dic = @{@"0.5":@"半年",@"1":@"一年",@"2":@"两年",@"3":@"三年",@"0":@"无限期"};
    }
    
    return _deadLine_dic;
}

-(NSMutableArray *)data_A{
    if (!_data_A) {
        _data_A = [NSMutableArray array];
    }
    return _data_A;
}

@end
