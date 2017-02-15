//
//  BankListViewController.m
//  BletcShop
//
//  Created by Bletc on 2016/11/14.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "BankListViewController.h"
#import "AddBankAccountVC.h"

@interface BankListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView*table_View;
    
    SDRefreshHeaderView *_refreshheader;

    
}
@property(nonatomic,strong)NSArray *bank_A;//

@end

@implementation BankListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self postGetAllBankCard];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择银行卡";
    self.view.backgroundColor= [UIColor whiteColor];
    table_View = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-self.tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
    table_View.dataSource = self;
    table_View.delegate = self;
    table_View.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.view addSubview: table_View];
    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:table_View];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block BankListViewController *blockSelf = self;
    _refreshheader.beginRefreshingOperation = ^{
        
        [blockSelf postGetAllBankCard];
    };
    
    
   
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 100, 37)];
    lable.textColor= RGB(51,51,51);
    lable.font = [UIFont systemFontOfSize:13];
    lable.text = @"到账银行";
    [view addSubview:lable];
    return view;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor=[UIColor whiteColor];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, SCREENWIDTH-100, 44)];
    lable.text = @"使用新卡提现";
    lable.textColor = RGB(51,51,51);
    lable.font= [UIFont systemFontOfSize:16];
    [view addSubview:lable];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-33-25, (45-25)/2, 25, 25)];
    
    [btn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
    
    [view addSubview:btn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, lable.bottom, SCREENWIDTH, 1)];
    line.backgroundColor = RGB(240, 240, 240);
    [view addSubview:line];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addBankCard)];
    [view addGestureRecognizer:tap];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 37;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 45;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bank_A.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor=[UIColor whiteColor];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, SCREENWIDTH-100, 44)];
    lable.text = @"建设银行储蓄卡(6608)";
    lable.textColor = RGB(51,51,51);
    lable.font= [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:lable];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-33-25, (45-25)/2, 25, 25)];
    
    [btn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
    
    [cell.contentView addSubview:btn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, lable.bottom, SCREENWIDTH, 1)];
    line.backgroundColor = RGB(240, 240, 240);
    [cell.contentView addSubview:line];
    
    
    
    if (self.bank_A.count>0) {
        NSDictionary *dic = self.bank_A[indexPath.row];
        
        NSString *number_s =dic[@"number"];
        number_s = [number_s substringFromIndex:number_s.length-4];
        
        
        lable.text = [NSString stringWithFormat:@"%@(%@)",dic[@"bank"],number_s];
        
        btn.selected = [dic[@"state"] isEqualToString:@"true"];
                
        
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"------------------------------");
    NSDictionary *dic = [self.bank_A objectAtIndex:indexPath.row];
    
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
            
            NSDictionary *dic = [self.bank_A objectAtIndex:indexPath.row];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
            [params setObject:dic[@"number"] forKey:@"number"];
            [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
                NSLog(@"-------%@",result);
                if ([result[@"result_code"] intValue]==1) {
                    [self getAllbankList:dic[@"state"]];
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


-(void)getAllbankList:(NSString*)state{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/bank/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result ==%@", result);
        
        self.bank_A = result;
        
        if ([state isEqualToString:@"true"] && self.bank_A.count>0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                
                [self tableView:table_View didSelectRowAtIndexPath:indexPath];
          
        }else{
            [table_View reloadData];
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];

}

-(void)addBankCard{
    NSLog(@"添加银行卡");
    AddBankAccountVC *VC = [[AddBankAccountVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

-(void)postGetAllBankCard
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/bank/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [_refreshheader endRefreshing];
        
        NSLog(@"%@", result);
        
        self.bank_A = result;
        [table_View reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
}


-(NSArray*)bank_A{
    if (!_bank_A) {
        _bank_A = [NSArray array];
    }
    return _bank_A;
}

@end
