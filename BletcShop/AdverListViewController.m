//
//  AdverListViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/2/23.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AdverListViewController.h"
#import "CommenShowPublishAdvertInfosVC.h"
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
    return 141;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_selectTag==3) {
        return 50;
    }else{
        return 0.01;
    }
    return 0.01;
}



-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    view.backgroundColor = [UIColor whiteColor];
    for (UIView*subview in view.subviews) {
        [subview removeFromSuperview];
    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 0, SCREENWIDTH, 1)];
    line.backgroundColor = RGB(246,246,246);
    [view addSubview:line];
    if (_selectTag==3) {
        UIButton *deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame=CGRectMake(SCREENWIDTH-115-20-100, 10, 100, 30);
        deleteButton.backgroundColor=[UIColor whiteColor];
        [deleteButton setTitle:@"取消订单" forState:UIControlStateNormal];
        deleteButton.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        [deleteButton setTitleColor:NavBackGroundColor forState:UIControlStateNormal];
        deleteButton.layer.borderColor=[NavBackGroundColor CGColor];
        deleteButton.layer.borderWidth=0.8;
        deleteButton.layer.cornerRadius=5.0f;
        deleteButton.clipsToBounds=YES;
        deleteButton.tag=section;
        [view addSubview:deleteButton];
        [deleteButton addTarget:self action:@selector(deletePublish:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *payButton=[UIButton buttonWithType:UIButtonTypeCustom];
        payButton.frame=CGRectMake(SCREENWIDTH-115, 10, 100, 30);
        payButton.backgroundColor=NavBackGroundColor;
        payButton.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        [payButton setTitle:@"去支付" forState:UIControlStateNormal];
        [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        payButton.layer.cornerRadius=5.0f;
        payButton.clipsToBounds=YES;
        payButton.tag=section;
        [view addSubview:payButton];
        [payButton addTarget:self action:@selector(payForPublish:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return view;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 141)];
    view.backgroundColor=[UIColor whiteColor];
    
    UIView *grayView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    grayView.backgroundColor=RGB(240, 240, 240);
    [view addSubview:grayView];
    
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UILabel *shopNameLable=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREENWIDTH*2/3-15, 30)];
    shopNameLable.text=delegate.shopInfoDic[@"store"];
    
    shopNameLable.font=[UIFont systemFontOfSize:14.0f];
    shopNameLable.backgroundColor=[UIColor whiteColor];
    [view addSubview:shopNameLable];
    
    UILabel *dateTime=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH*2/3, 15, SCREENWIDTH*1/3, 20)];
    dateTime.text=self.data_A[section][@"datetime"];
    dateTime.textColor=RGB(102, 102, 102);
    dateTime.font=[UIFont systemFontOfSize:12.0f];
    [view addSubview:dateTime];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(12, 40,SCREENWIDTH-24, 1)];
    lineView.backgroundColor=RGB(234, 234, 234);
    [view addSubview:lineView];
    //广告图片
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(18, 50, 80, 80)];
    imageView.image=[UIImage imageNamed:@"icon3.png"];
    [view addSubview:imageView];
    //广告标题&描述
    NSString *descripString=self.data_A[section][@"info"];
    UILabel *advertDescription=[[UILabel alloc]init];
    advertDescription.numberOfLines=4;
    advertDescription.font=[UIFont systemFontOfSize:14.0f];
    advertDescription.text=descripString;
    advertDescription.lineBreakMode=NSLineBreakByTruncatingTail;
    advertDescription.frame=CGRectMake(98+10, 55, SCREENWIDTH-108-10, 20);
    [view addSubview:advertDescription];
    
    CGFloat height=[descripString boundingRectWithSize:CGSizeMake(SCREENWIDTH-108-10, 80) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : advertDescription.font} context:nil].size.height;
    CGRect frame = advertDescription.frame;
    frame.size.height = height;
    advertDescription.frame = frame;
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(12, 140,SCREENWIDTH-24, 1)];
    lineView2.backgroundColor=RGB(234, 234, 234);
    [view addSubview:lineView2];
    
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    // 定义唯一标识
    // 通过indexPath创建cell实例 每一个cell都是单独的:hpuvuq
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
                huiyuanLabel.text = @"广告类型:";
                huiyuanText.text = dic[@"datetime"];
                CGSize size = [UILabel getSizeWithLab:huiyuanLabel andMaxSize:CGSizeMake(1000, 1000)];
                
                CGRect frame = huiyuanText.frame;
                frame.origin.x = huiyuanLabel.frame.origin.x +size.width+10;
                huiyuanText.frame = frame;
                
                
            }
                break;
            case 1:
            {
                huiyuanLabel.text = @"活动类型:";
                huiyuanText.text =dic[@"datetime"];
                
                
            }
                break;
            case 2:
            {
                huiyuanLabel.text = @"广告位置:";
                huiyuanText.text = dic[@"position"];
                
                
            }
                break;
            case 3:
            {
                huiyuanLabel.text = @"收费方式:";
                huiyuanText.text = dic[@"pay_type"];
                
                
                
            }
                break;
            case 4:
            {
                huiyuanLabel.text = @"地区:";
                huiyuanText.text = dic[@"datetime"];
                
                
                
            }
                break;
                
                
            default:
                break;
        }
        
        
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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
//取消订单
-(void)deletePublish:(UIButton *)sender{
    
}
//去付款
-(void)payForPublish:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    CommenShowPublishAdvertInfosVC *vc=[[CommenShowPublishAdvertInfosVC alloc]init];
    vc.infoDic=self.data_A[sender.tag];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
