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
#import "CouponCell.h"
#import "UIImageView+WebCache.h"
@interface MyCashCouponViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyCashCouponViewController
{
    __block MBProgressHUD *hud;
    UITableView *_tableView;
    NSArray *_dataArray;
}

-(NSMutableArray *)couponArray{
    if (!_couponArray) {
        _couponArray = [NSMutableArray array];
    }
    return _couponArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self postRequestCashCoupon];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的代金券";

    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"#######%@",self.couponArray);
    
    [self _inittable];

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
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/coupon/userGet",BASEURL];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    NSLog(@"params---%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        [hud hideAnimated:YES];
        
        DebugLog(@"result---%@",result);
        if ([result count]==0) {
            
          [self initNoneActiveView];

        }else{
            NSArray *arr = (NSArray*)result;
            [self.couponArray removeAllObjects];
            for (NSDictionary *dic in arr) {
               
                    [self.couponArray addObject:dic];
            }
            
        }
        
        [_tableView reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hideAnimated:YES afterDelay:3.f];
        NSLog(@"%@", error);
    }];
    
}
//创建TableView
-(void)_inittable
{

    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.couponArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponCell *cell = [CouponCell couponCellWithTableView:tableView];
    
    if (self.couponArray.count!=0) {
        NSDictionary *dic = self.couponArray[indexPath.row];
        
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,dic[@"image_url"]]]];
        cell.shopNamelab.text=dic[@"store"];
        cell.couponMoney.text=dic[@"pri_condition"];
        cell.deadTime.text= [NSString stringWithFormat:@"%@~%@",dic[@"date_start"],dic[@"date_end"]];
        cell.limitLab.text=dic[@"content"];
        
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150+11;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponIntroduceVC *vc=[[CouponIntroduceVC alloc]init];
    vc.infoDic=_couponArray[indexPath.row];
    vc.index=0;
    [self.navigationController pushViewController:vc animated:YES];
}


-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"===删除==");
        
    }];
    action.backgroundColor = [UIColor redColor];
    return @[action];
    
}

-(void)deleteCouponWithDic:(NSDictionary*)dic{
    NSString *url = [NSString stringWithFormat:@"%@",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
@end
