//
//  MyCashCouponViewController.m
//  BletcShop
//
//  Created by Bletc on 16/7/26.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MyCashCouponViewController.h"
#import "PointRuleViewController.h"
@interface MyCashCouponViewController ()

@end

@implementation MyCashCouponViewController
{
    __block MBProgressHUD *hud;
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
            [tempSelf initNoneActiveView];
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
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.rowHeight = 104;
    table.bounces = NO;
    self.couponTable = table;
    [self.view addSubview:table];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
    }
    NSDictionary *dic =[self.couponArray objectAtIndex:indexPath.row];
    
    UIImageView *couponImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, SCREENWIDTH-20, 110)];
    couponImageView.layer.cornerRadius = 10;
    couponImageView.layer.masksToBounds = YES;
    //couponImageView.image = [UIImage imageNamed:@"代金券-01.jpg"];
    [cell addSubview:couponImageView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.frame = CGRectMake(SCREENWIDTH/2-120, 10, 90, 60);
    moneyLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:50];
    moneyLabel.textColor = [UIColor whiteColor];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    NSRange pend = [dic[@"type"] rangeOfString:@"元"];
    //    NSString* Price =[[[self.couponArray objectAtIndex:indexPath.row] objectAtIndex:0] substringToIndex:pend.location];
    moneyLabel.text = [dic[@"type"] substringToIndex:pend.location];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-30, 50, 10, 10)];
    //imageView.image = [UIImage imageNamed:@"代金券-03"];
    [cell addSubview:imageView];
    
    [couponImageView addSubview:moneyLabel];
    
    //有效期
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.frame = CGRectMake(0, 80, SCREENWIDTH-80, 30);
    timeLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:15];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text = [[NSString alloc]initWithFormat:@"有效期至:%@",dic[@"deadline"]];
    [couponImageView addSubview:timeLabel];
    
    UIImageView *forgetImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-10-110*125/241, 5, 110*125/241, 110)];
    [cell addSubview:forgetImageView];
    if ([dic[@"type"] isEqualToString:@"100元"]) {
        couponImageView.image = [UIImage imageNamed:@"代金券-01"];
        imageView.image = [UIImage imageNamed:@"代金券-03"];
        forgetImageView.image=[UIImage imageNamed:@"代金券-02.png"];
    }else if ([dic[@"type"] isEqualToString:@"50元"]){
        couponImageView.image = [UIImage imageNamed:@"代金券-04"];
        imageView.image = [UIImage imageNamed:@"代金券-05"];
        forgetImageView.image=[UIImage imageNamed:@"代金券-06.png"];
    }else if ([dic[@"type"] isEqualToString:@"20元"]){
        couponImageView.image = [UIImage imageNamed:@"代金券-07"];
        imageView.image = [UIImage imageNamed:@"代金券-08"];
        forgetImageView.image=[UIImage imageNamed:@"代金券-09"];
    }else if ([dic[@"type"] isEqualToString:@"10元"]){
        couponImageView.image = [UIImage imageNamed:@"代金券-10"];
        imageView.image = [UIImage imageNamed:@"代金券-11"];
        forgetImageView.image=[UIImage imageNamed:@"代金券-12.png"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.useCoupon==100) {
        [self.delegate  sendValue:[self.couponArray objectAtIndex:indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        PointRuleViewController *PointRuleView = [[PointRuleViewController alloc]init];
        PointRuleView.type = 999;
        [self.navigationController pushViewController:PointRuleView animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
