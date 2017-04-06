//
//  CashListViewController.m
//  BletcShop
//
//  Created by Bletc on 16/9/19.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "CashListViewController.h"
#import "CashListCell.h"

@interface CashListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSArray *data_array;
@end

@implementation CashListViewController

-(NSArray*)data_array{
    if (!_data_array) {
        _data_array = [NSArray array];
    }
    return _data_array;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    self.navigationItem.title = @"现金支付明细";
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    tableView.delegate =self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor = RGB(240, 240, 240);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self postRequestMoney];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    
    
    CashListCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CashListCell" owner:self options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.data_array.count!=0) {
        
        NSDictionary *dic = self.data_array[indexPath.row];
//        cell.name_lab.text = [NSString stringWithFormat:@"客户类型:%@",dic[@"name"]];
        cell.cardNum.text = [NSString stringWithFormat:@"单号:%@",dic[@"ordernum"]];
        cell.time_lab.text = [NSString stringWithFormat:@"时间:%@",dic[@"datetime"]];
        cell.cash_lab.text = [NSString stringWithFormat:@"%@元",dic[@"sum"]];
    }
    
    return cell;

}

-(void)postRequestMoney
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/cashGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"merchant"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        self.data_array = [result copy];
        
        DebugLog(@"result===%@",self.data_array);

        [self.tableView reloadData];
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
