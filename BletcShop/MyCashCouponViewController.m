//
//  MyCashCouponViewController.m
//  BletcShop
//
//  Created by Bletc on 16/7/26.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MyCashCouponViewController.h"
#import "ShaperView.h"
#import "CouponIntroduceVC.h"
@interface MyCashCouponViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyCashCouponViewController
{
    __block MBProgressHUD *hud;
    UITableView *_tableView;
    NSArray *_dataArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.title = @"我的代金券";
    self.couponArray = [[NSMutableArray alloc]init];
    
    [self postRequestCashCoupon];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"#######%@",self.couponArray);
}
//无活动显示无活动
-(void)initNoneActiveView{
    self.view.backgroundColor=RGB(240, 240, 240);
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-92, 63, 184, 117)];
    imageView.image=[UIImage imageNamed:@"CC588055F2B4764AA006CD2B6ACDD25C.jpg"];
    [self.view addSubview:imageView];
    
    UILabel *noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+46, SCREENWIDTH, 30)];
    noticeLabel.font=[UIFont systemFontOfSize:15.0f];
    noticeLabel.textColor=RGB(153, 153, 153);
    noticeLabel.textAlignment=NSTextAlignmentCenter;
    noticeLabel.text=@"没有可用的代金券哦";
    [self.view addSubview:noticeLabel];
}
-(void)postRequestCashCoupon
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/voucherGet",BASEURL];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    __block MyCashCouponViewController *tempSelf=self;
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        [hud hideAnimated:YES];
        
        DebugLog(@"result---%@",result);
        if ([result count]==0) {
            //            [tempSelf initNoneActiveView];
            [tempSelf _inittable];
        }else{
            NSArray *arr = (NSArray*)result;
            for (NSDictionary *dic in arr) {
                NSString *count = dic[@"num"];
                for (int i = 0; i < [count intValue]; i ++) {
                    [self.couponArray addObject:dic];
                }
            }
            [tempSelf _inittable];
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hideAnimated:YES afterDelay:3.f];
        NSLog(@"%@", error);
    }];
    
}
//创建TableView
-(void)_inittable
{
    //    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    //    table.delegate = self;
    //    table.dataSource = self;
    //    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    table.showsVerticalScrollIndicator = NO;
    //    table.rowHeight = 104;
    //    table.bounces = NO;
    //    self.couponTable = table;
    //    [self.view addSubview:table];
    NSDictionary * dic1 = @{@"shop":@"商消乐", @"money":@"30元代金券",@"limit":@"无限制",@"deadTime":@"有效期为:2017-2-20～2017-3-20",@"notice":@"代金券描述",@"image":@"5-01"};
    NSDictionary * dic2 = @{@"shop":@"尚艺轩", @"money":@"50元代金券",@"limit":@"满减",@"deadTime":@"有效期为:2017-2-25～2017-3-25",@"notice":@"代金券描述",@"image":@"6-01"};
    NSDictionary * dic3 = @{@"shop":@"绝味鸭脖", @"money":@"30元代金券",@"limit":@"满减",@"deadTime":@"有效期为:2017-2-28～2017-3-28",@"notice":@"代金券描述",@"image":@"4-011"};
    
    _dataArray=@[dic1,dic2,dic3];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 5, SCREENWIDTH-20, 190*(SCREENWIDTH-20)/600.0-10)];
        bgView.backgroundColor=[UIColor whiteColor];
        bgView.layer.cornerRadius=5.0f;
        bgView.clipsToBounds=YES;
        [cell addSubview:bgView];
        
        UIImageView *_headImage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 40, 40)];
        //_headImage.image=[UIImage imageNamed:@"5-01"];
        _headImage.layer.cornerRadius=20;
        _headImage.clipsToBounds=YES;
        _headImage.tag=100;
        [bgView addSubview:_headImage];
        
        UILabel *shopNameLable=[[UILabel alloc]initWithFrame:CGRectMake(70, 20, bgView.width-70, 20)];
        //shopNameLable.text=@"森林雨火锅";
        shopNameLable.font=[UIFont systemFontOfSize:15.0f];
        shopNameLable.textColor=[UIColor grayColor];
        shopNameLable.tag=200;
        [bgView addSubview:shopNameLable];
        
        UILabel *couponMoney=[[UILabel alloc]initWithFrame:CGRectMake(70, 45, bgView.width-70, 30)];
        //couponMoney.text=@"20元代金券";
        couponMoney.font=[UIFont systemFontOfSize:20.0f];
        couponMoney.tag=300;
        [bgView addSubview:couponMoney];
        
        ShaperView *viewr=[[ShaperView alloc]initWithFrame:CGRectMake(5, _headImage.bottom+20, SCREENWIDTH-20, 1)];
        ShaperView *viewt= [viewr drawDashLine:viewr lineLength:3 lineSpacing:3 lineColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f]];
        [bgView addSubview:viewt];
        
        UILabel *deadTime=[[UILabel alloc]initWithFrame:CGRectMake(10, viewr.bottom, bgView.width-10, 20)];
        //deadTime.text=@"有效期为:2017-2-25～2017-3-25";
        deadTime.font=[UIFont systemFontOfSize:13.0f];
        deadTime.textColor=[UIColor grayColor];
        deadTime.tag=400;
        [bgView addSubview:deadTime];
        
        cell.backgroundColor=RGB(238, 238, 238);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    UIImageView *image=[cell viewWithTag:100];
    image.image=[UIImage imageNamed:_dataArray[indexPath.row][@"image"]];
    UILabel *lab1=[cell viewWithTag:200];
    lab1.text=_dataArray[indexPath.row][@"shop"];
    UILabel *lab2=[cell viewWithTag:300];
    lab2.text=_dataArray[indexPath.row][@"money"];
    UILabel *lab3=[cell viewWithTag:400];
    lab3.text=_dataArray[indexPath.row][@"deadTime"];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190*(SCREENWIDTH-20)/600.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponIntroduceVC *vc=[[CouponIntroduceVC alloc]init];
    vc.infoDic=_dataArray[indexPath.row];
    vc.index=0;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.couponArray.count;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 120;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 20;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    static NSString *cellIndentifier = @"cellIndentifier";
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
//    }
//    NSDictionary *dic =[self.couponArray objectAtIndex:indexPath.row];
//
//    UIImageView *couponImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, SCREENWIDTH-20, 110)];
//    couponImageView.layer.cornerRadius = 10;
//    couponImageView.layer.masksToBounds = YES;
//    //couponImageView.image = [UIImage imageNamed:@"代金券-01.jpg"];
//    [cell addSubview:couponImageView];
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    UILabel *moneyLabel = [[UILabel alloc]init];
//    moneyLabel.frame = CGRectMake(SCREENWIDTH/2-120, 10, 90, 60);
//    moneyLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:50];
//    moneyLabel.textColor = [UIColor whiteColor];
//    moneyLabel.textAlignment = NSTextAlignmentCenter;
//    NSRange pend = [dic[@"type"] rangeOfString:@"元"];
//    //    NSString* Price =[[[self.couponArray objectAtIndex:indexPath.row] objectAtIndex:0] substringToIndex:pend.location];
//    moneyLabel.text = [dic[@"type"] substringToIndex:pend.location];
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-30, 50, 10, 10)];
//    //imageView.image = [UIImage imageNamed:@"代金券-03"];
//    [cell addSubview:imageView];
//
//    [couponImageView addSubview:moneyLabel];
//
//    //有效期
//    UILabel *timeLabel = [[UILabel alloc]init];
//    timeLabel.frame = CGRectMake(0, 80, SCREENWIDTH-80, 30);
//    timeLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:15];
//    timeLabel.textColor = [UIColor whiteColor];
//    timeLabel.textAlignment = NSTextAlignmentCenter;
//    timeLabel.text = [[NSString alloc]initWithFormat:@"有效期至:%@",dic[@"deadline"]];
//    [couponImageView addSubview:timeLabel];
//
//    UIImageView *forgetImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-10-110*125/241, 5, 110*125/241, 110)];
//    [cell addSubview:forgetImageView];
//    if ([dic[@"type"] isEqualToString:@"100元"]) {
//        couponImageView.image = [UIImage imageNamed:@"代金券-01"];
//        imageView.image = [UIImage imageNamed:@"代金券-03"];
//        forgetImageView.image=[UIImage imageNamed:@"代金券-02.png"];
//    }else if ([dic[@"type"] isEqualToString:@"50元"]){
//        couponImageView.image = [UIImage imageNamed:@"代金券-04"];
//        imageView.image = [UIImage imageNamed:@"代金券-05"];
//        forgetImageView.image=[UIImage imageNamed:@"代金券-06.png"];
//    }else if ([dic[@"type"] isEqualToString:@"20元"]){
//        couponImageView.image = [UIImage imageNamed:@"代金券-07"];
//        imageView.image = [UIImage imageNamed:@"代金券-08"];
//        forgetImageView.image=[UIImage imageNamed:@"代金券-09"];
//    }else if ([dic[@"type"] isEqualToString:@"10元"]){
//        couponImageView.image = [UIImage imageNamed:@"代金券-10"];
//        imageView.image = [UIImage imageNamed:@"代金券-11"];
//        forgetImageView.image=[UIImage imageNamed:@"代金券-12.png"];
//    }
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.useCoupon==100) {
//        [self.delegate  sendValue:[self.couponArray objectAtIndex:indexPath.row]];
//        [self.navigationController popViewControllerAnimated:YES];
//    }else
//    {
//        PointRuleViewController *PointRuleView = [[PointRuleViewController alloc]init];
//        PointRuleView.type = 999;
//        [self.navigationController pushViewController:PointRuleView animated:YES];
//    }
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
