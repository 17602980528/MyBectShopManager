//
//  DefaultAddressVC.m
//  BletcShop
//
//  Created by Bletc on 2017/3/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "DefaultAddressVC.h"
#import "DefaultAddressCell.h"
#import "SelectAddressViewController.h"
@interface DefaultAddressVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table_View;
@property (nonatomic , strong) NSArray *data_A;// <#Description#>

@end

@implementation DefaultAddressVC

-(NSArray *)data_A{
    if (!_data_A) {
        _data_A = [NSArray array];
    }
    return _data_A;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self getdata];
}
-(void)addAddressClick{
    
    SelectAddressViewController *VC= [[SelectAddressViewController alloc]init];
    
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择收货地址";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addAddressClick)];
    
    self.table_View.estimatedRowHeight = 150;
    self.table_View.rowHeight = UITableViewAutomaticDimension;
    
}

-(void)getdata{
    NSString *url = [NSString stringWithFormat:@"%@Extra/mall/getAddList",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;

    [paramer setObject:app.userInfoDic[@"uuid"] forKey:@"uuid"];

    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"-result----%@",result);
        self.data_A = (NSArray *)result;
        [self.table_View reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"----error----%@",error);
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_A.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DefaultAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultAddressID"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DefaultAddressCell" owner:self options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.data_A.count !=0) {
        
        NSDictionary *dic = _data_A[indexPath.row];
        cell.nameLab.text = dic[@"name"];
        cell.phonelab.text = dic[@"phone"];
        cell.addresslab.text = dic[@"address"];

        if ([dic[@"state"] isEqualToString:@"usual"]) {
            cell.selctimg.image = [UIImage imageNamed:@"Unselected"];

        }else{
            cell.selctimg.image = [UIImage imageNamed:@"Selected"];

        }
       
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.data_A[indexPath.row];
    
    if ([dic[@"state"] isEqualToString:@"usual"]) {
        
        [self setDefaultAddressWithDic:dic];

    }
    
}
-(void)setDefaultAddressWithDic:(NSDictionary *)dic{
    
    
    NSString *url = [NSString stringWithFormat:@"%@Extra/mall/setDefaultAdd",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [paramer setObject:app.userInfoDic[@"uuid"] forKey:@"uuid"];
    [paramer setObject:dic[@"add_id"] forKey:@"add_id"];

    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"-result----%@",result);
        
        if ([result[@"result_code"] intValue]==1) {

            [self getdata];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"----error----%@",error);
    }];

    
}
@end
