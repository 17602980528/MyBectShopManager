//
//  AdverListViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/2/23.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AdverListViewController.h"

@interface AdverListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *topBackView;
    UIView *noticeLine;
    NSArray *kindArray;
    NSArray *stateArray;
}
@property NSInteger selectTag;

@property (nonatomic,strong) UITableView *tabView;
@property (nonatomic , strong) NSMutableArray  *data_A;// 数据源数组
@property (nonatomic , strong) NSMutableArray *apply_A;// 已申请
@property (nonatomic , strong) NSMutableArray *wait_A;// 审核中
@property (nonatomic , strong) NSMutableArray *confuse_A;// 未通过
@property (nonatomic , strong) NSMutableArray *wait_pay;// 待支付
@property (nonatomic , strong) NSMutableArray *sure_A;// 已上线

@end

@implementation AdverListViewController

-(NSMutableArray *)apply_A{
    if (!_apply_A) {
        _apply_A = [NSMutableArray array];
    }
    return _apply_A;
}
-(NSMutableArray *)wait_A{
    if (!_wait_A) {
        _wait_A = [NSMutableArray array];
    }
    return _wait_A;
}
-(NSMutableArray *)confuse_A{
    if (!_confuse_A) {
        _confuse_A = [NSMutableArray array];
    }
    return _confuse_A;
}
-(NSMutableArray *)wait_pay{
    if (!_wait_pay) {
        _wait_pay = [NSMutableArray array];
    }
    return _wait_pay;
}
-(NSMutableArray *)sure_A{
    if (!_sure_A) {
        _sure_A = [NSMutableArray array];
    }
    return _sure_A;
}
-(NSMutableArray *)data_A{
    if (!_data_A) {
        _data_A = [NSMutableArray array];
    }
    return _data_A;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"广告列表";
    self.selectTag=0;

    [self initTopView];

}
-(void)initTopView{
    
    kindArray=@[@"已申请",@"审核中",@"未通过",@"待支付",@"已上线"];
    stateArray=@[@"COMMITTED",@"AUDITING",@"AUDIT_FAILURE",@"WAIT_FOR_PAY",@"ONLINE"];
    topBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    topBackView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topBackView];
    
    for (int i=0; i<kindArray.count; i++) {
        UIButton *Catergray=[UIButton buttonWithType:UIButtonTypeCustom];
        Catergray.frame=CGRectMake(1+i%kindArray.count*((SCREENWIDTH-6)/kindArray.count+1), 0, (SCREENWIDTH-5)/kindArray.count, 49);
        Catergray.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        [Catergray setTitle:kindArray[i] forState:UIControlStateNormal];
        [Catergray setTitleColor:RGB(51,51,51) forState:UIControlStateNormal];
        Catergray.tag=666+i;
        [topBackView addSubview:Catergray];
        [Catergray addTarget:self action:@selector(changeTitleColorAndRefreshCard:) forControlEvents:UIControlEventTouchUpInside];
        if (i!=kindArray.count-1) {
            if (i==0) {
                [Catergray setTitleColor:RGB(66,170,252) forState:UIControlStateNormal];
                noticeLine=[[UIView alloc]init];
                noticeLine.bounds=CGRectMake(0, 0, (SCREENWIDTH-105)/kindArray.count, 2);
                noticeLine.center=CGPointMake(Catergray.center.x, Catergray.center.y+24);
                noticeLine.backgroundColor=RGB(66,170,252);
                [topBackView addSubview:noticeLine];
            }
           
        }
        
    }
    
    self.tabView =[[UITableView alloc]initWithFrame:CGRectMake(0, topBackView.bottom, SCREENWIDTH, SCREENHEIGHT-topBackView.bottom-64) style:UITableViewStyleGrouped];
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabView.delegate=self;
    self.tabView.dataSource=self;
    [self.view addSubview:self.tabView];
    
    [self postRequestDataBaseState:stateArray[self.selectTag]];
}
-(void)changeTitleColorAndRefreshCard:(UIButton *)sender{
    
    
    self.selectTag = sender.tag - 666;
    noticeLine.center=CGPointMake(sender.center.x, sender.center.y+24);
    for (int i=0; i<kindArray.count; i++) {
        UIButton*button=(UIButton *)[topBackView viewWithTag:666+i];
        if (button.tag==sender.tag) {
            [button setTitleColor:RGB(66,170,252) forState:UIControlStateNormal];
        }else{
            [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        }
    }
    
    [self postRequestDataBaseState:stateArray[self.selectTag]];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.data_A.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
        return 36+9;
}



-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 36+9)];
        view.backgroundColor = [UIColor whiteColor];
        for (UIView*subview in view.subviews) {
            [subview removeFromSuperview];
        }
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 0, SCREENWIDTH, 1)];
        line.backgroundColor = RGB(246,246,246);
        [view addSubview:line];
        
    UILabel *huiyuanLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, line.bottom, 75, 35)];
    huiyuanLabel.text = @"地区:";
    huiyuanLabel.font = [UIFont systemFontOfSize:15];
    huiyuanLabel.textColor = RGB(102,102,102);
    huiyuanLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:huiyuanLabel];
    
    CGSize size = [UILabel getSizeWithLab:huiyuanLabel andMaxSize:CGSizeMake(1000, 1000)];
    
   
    
    UILabel *huiyuanText = [[UILabel alloc]initWithFrame:CGRectMake(huiyuanLabel.left +size.width+10, line.bottom, SCREENWIDTH-100, 35)];
    huiyuanText.text = @"西安市高新区富鱼路";
    huiyuanText.textAlignment = NSTextAlignmentLeft;
    huiyuanText.font = [UIFont systemFontOfSize:15];
    huiyuanText.textColor = RGB(51,51,51);
    [view addSubview:huiyuanText];
    
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, huiyuanLabel.bottom, SCREENWIDTH, view.height - huiyuanLabel.bottom)];
    line2.backgroundColor = RGB(246,246,246);
    [view addSubview:line2];
    
    
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
        huiyuanLabel.text = @"";
        huiyuanLabel.font = [UIFont systemFontOfSize:15];
        huiyuanLabel.textColor = RGB(153,153,153);
        huiyuanLabel.tag = 900;
        huiyuanLabel.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:huiyuanLabel];
        
        UILabel *huiyuanText = [[UILabel alloc]initWithFrame:CGRectMake(95, 0, SCREENWIDTH-100, 30)];
        huiyuanText.text = @"";
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
                huiyuanLabel.text = @"日期:";
                huiyuanText.text = dic[@"datetime"];
                CGSize size = [UILabel getSizeWithLab:huiyuanLabel andMaxSize:CGSizeMake(1000, 1000)];
                
                CGRect frame = huiyuanText.frame;
                frame.origin.x = huiyuanLabel.frame.origin.x +size.width+10;
                huiyuanText.frame = frame;
                
                
            }
                break;
            case 1:
            {
                huiyuanLabel.text = @"商家名称:";
                huiyuanText.text =dic[@"datetime"];
                
                
            }
                break;
            case 2:
            {
                huiyuanLabel.text = @"广告类型:";
                huiyuanText.text = dic[@"datetime"];
                
                
            }
                break;
            case 3:
            {
                huiyuanLabel.text = @"活动类型:";
                huiyuanText.text = dic[@"datetime"];
                
                
                
            }
                break;
            case 4:
            {
                huiyuanLabel.text = @"广告位置:";
                huiyuanText.text = dic[@"position"];
                
                
                
            }
                break;
                
                
            default:
                break;
        }
        
    
    }
    
    
    return cell;
}

-(void)postRequestDataBaseState:(NSString *)state{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/advertTop/getList",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:delegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:state forKey:@"state"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"result===%@",result);
        if (result) {
            self.data_A=result;
            [_tabView reloadData];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];

}
@end
