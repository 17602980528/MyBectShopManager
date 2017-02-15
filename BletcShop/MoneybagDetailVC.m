//
//  MoneybagDetailVC.m
//  BletcShop
//
//  Created by Bletc on 2017/1/18.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "MoneybagDetailVC.h"

@interface MoneybagDetailVC ()
{
    SDRefreshFooterView *_footRefresh;
    SDRefreshHeaderView *_headerRefresh;

}
@property(nonatomic,strong)NSMutableArray *data_A;
@end

@implementation MoneybagDetailVC
-(NSMutableArray *)data_A{
    if (!_data_A) {
        _data_A = [NSMutableArray array];
    }
    return _data_A;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"钱包明细";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 61;
    [self getDataWithMore:@""];
    
    _headerRefresh = [SDRefreshHeaderView refreshView];
    [_headerRefresh addToScrollView:self.tableView];
    _headerRefresh.isEffectedByNavigationController = NO;
    __block typeof(self) weakSelf = self;
    
    _headerRefresh.beginRefreshingOperation = ^{
        [weakSelf.data_A removeAllObjects];
        [weakSelf getDataWithMore:@""];
        
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data_A.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"myRedBag";
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *title_lab = [[UILabel alloc]initWithFrame:CGRectMake(17, 11, SCREENWIDTH*0.6, 16)];
        title_lab.textColor = RGB(51, 51, 51);
        title_lab.font = [UIFont systemFontOfSize:16];
        title_lab.tag = 900;
        [cell addSubview:title_lab];
        
        UILabel *detail_lab = [[UILabel alloc]initWithFrame:CGRectMake(18, 39, SCREENWIDTH*0.6, 12)];
        detail_lab.textColor = RGB(153,153,153);
        detail_lab.font = [UIFont systemFontOfSize:16];
        detail_lab.tag = 901;
        [cell addSubview:detail_lab];
        
        UILabel *money_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, SCREENWIDTH-23, 13)];
        money_lab.textColor = RGB(51,51,51);
        money_lab.textAlignment = NSTextAlignmentRight;
        money_lab.font = [UIFont systemFontOfSize:16];
        money_lab.tag = 902;
        [cell addSubview:money_lab];
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 60, SCREENWIDTH, 1)];
        line.backgroundColor = RGB(234, 234, 234);
        [cell addSubview:line];
        
    }
    
    UILabel *title_lab = (UILabel*)[cell viewWithTag:900];
    UILabel *detail_lab = (UILabel*)[cell viewWithTag:901];
    UILabel *money_lab = (UILabel*)[cell viewWithTag:902];
    
    
    if (self.data_A.count!=0) {
        NSDictionary *dic = self.data_A[indexPath.row];
        title_lab.text = [NSString getTheNoNullStr:dic[@"tip"] andRepalceStr:@"新用户注册"];
        detail_lab.text = [NSString getTheNoNullStr:dic[@"datetime"] andRepalceStr:@"12-12"];
        money_lab.text = [NSString stringWithFormat:@"%@元",[NSString getTheNoNullStr:dic[@"sum"] andRepalceStr:@"200.00"]];
    }
    
    
    
    return cell;
    
}

-(void)getDataWithMore:(NSString*)more{
    
    NSString *url =[NSString stringWithFormat:@"%@UserType/user/getBill",BASEURL];
    NSMutableDictionary *paramer =[NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [paramer setValue:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    
    //    NSLog(@"---%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [_headerRefresh endRefreshing];
        
        if (result) {

            
            NSArray *arr = (NSArray*)result;
            
            [self.data_A addObjectsFromArray:arr];
            
            [self.tableView reloadData];
            
        }
        
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error---%@",error);
        
//        [_footRefresh endRefreshing];
        [_headerRefresh endRefreshing];
    }];
    
}


@end
