//
//  MyRedBagVC.m
//  BletcShop
//
//  Created by Bletc on 2016/12/15.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MyRedBagVC.h"
#import "UIImageView+WebCache.h"
#import "SDRefreshView.h"
#import "BonusCashViewController.h"
@interface MyRedBagVC ()<UITableViewDelegate,UITableViewDataSource,BonusCashViewControllerDelegate>
{
    UITableView *_tableView;
    SDRefreshFooterView *_footRefresh;
    SDRefreshHeaderView *_headerRefresh;
    int currentIndex;//请求页码
    UILabel *allMoney_lab;
    
    
}

@property(nonatomic,strong)NSMutableArray *data_A;
@end

@implementation MyRedBagVC
-(NSMutableArray *)data_A{
    if (!_data_A) {
        _data_A = [NSMutableArray array];
        
    }
    return _data_A;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    currentIndex=1;
    
    self.navigationItem.title = @"我的红包";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:@"提现" style:UIBarButtonItemStylePlain target:self action:@selector(withdrawCash)];
    self.navigationItem.rightBarButtonItem=item;
    [self creatTopView];
    
}
-(void)bunosSuccess{
    [self getDataWithMore:@""];
}
//去提现页面
-(void)withdrawCash{
    if ([allMoney_lab.text floatValue]<100) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"红包金额满100方可提现", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:1.f];
    }else{
        BonusCashViewController *bonusCashVC=[[BonusCashViewController alloc]init];
        int lastMoney=[allMoney_lab.text floatValue]/100;
        bonusCashVC.delegate=self;
        bonusCashVC.moneyString=[NSString stringWithFormat:@"%d",lastMoney*100];
        [self.navigationController pushViewController:bonusCashVC animated:YES];
    }
}
-(void)creatTopView{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 225)];
    topView.backgroundColor = RGB(240, 240, 240);
    [self.view addSubview:topView];
    
    
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-91)/2, 28, 91, 91)];
    headImage.clipsToBounds=YES;
    headImage.layer.cornerRadius= headImage.width/2;
    headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    headImage.layer.borderWidth = 2;
    headImage.contentMode = UIViewContentModeScaleAspectFill;
    [topView addSubview:headImage];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString *str = [[[NSString alloc]initWithFormat:@"%@%@",HEADIMAGE,[appdelegate.userInfoDic objectForKey:@"headimage"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [headImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"头像.png"] options:SDWebImageRetryFailed];
    
    
    allMoney_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, headImage.bottom+38, SCREENWIDTH, 29)];
    allMoney_lab.text = @"";
    allMoney_lab.textColor = RGB(227,45,45);
    allMoney_lab.textAlignment= NSTextAlignmentCenter;
    allMoney_lab.font = [UIFont systemFontOfSize:36];
    [topView addSubview:allMoney_lab];
    
    
    [self initTableView];
    
}
-(void)initTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 225, SCREENWIDTH, SCREENHEIGHT-64-225) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 61;
    _tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _headerRefresh = [SDRefreshHeaderView refreshView];
    [_headerRefresh addToScrollView:_tableView isEffectedByNavigationController:NO];
    
    __block typeof(self) weakSelf = self;
    _headerRefresh.beginRefreshingOperation = ^{
        [weakSelf.data_A removeAllObjects];
        [weakSelf getDataWithMore:@""];
        
    };
    
    
    _footRefresh = [SDRefreshFooterView refreshView];
    [_footRefresh addToScrollView:_tableView];
    
    _footRefresh.beginRefreshingOperation = ^{
        
        [weakSelf getDataWithMore:@"more"];
        
    };
    
    
    [self getDataWithMore:@""];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_A.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        money_lab.text = [NSString getTheNoNullStr:dic[@"sum"] andRepalceStr:@"200.00"];
    }
    
    
    
    return cell;
    
}

-(void)getDataWithMore:(NSString*)more{
    
    NSString *url =[NSString stringWithFormat:@"%@UserType/user/getRedPacket",BASEURL];
    NSMutableDictionary *paramer =[NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [paramer setValue:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    if ([more isEqualToString:@"more"]) {
        [paramer setValue:[NSString stringWithFormat:@"%d",++currentIndex] forKey:@"page"];
        
    }else{
        [self.data_A removeAllObjects];
        currentIndex = 1;
        [paramer setValue:@"1" forKey:@"page"];
        
    }
    
       NSLog(@"---%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        [_footRefresh endRefreshing];
        [_headerRefresh endRefreshing];
        
        NSLog(@"=====%@",result);
        if (result) {
            allMoney_lab.text = [NSString getTheNoNullStr:[NSString stringWithFormat:@"%@元",result[@"sum"]] andRepalceStr:@"0.00元"];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:allMoney_lab.text];
            [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} range:NSMakeRange(allMoney_lab.text.length-1, 1)];
            allMoney_lab.attributedText = attr;
            
            NSArray *arr = result[@"record"];
            
            [self.data_A addObjectsFromArray:arr];
            
            [_tableView reloadData];
        }
        
        
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error---%@",error);
        
        [_footRefresh endRefreshing];
        [_headerRefresh endRefreshing];
    }];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
