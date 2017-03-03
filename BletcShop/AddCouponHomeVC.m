//
//  AddCouponHomeVC.m
//  BletcShop
//
//  Created by apple on 17/2/20.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AddCouponHomeVC.h"
#import "AddCouponVC.h"
#import "ShaperView.h"
#import "CouponIntroduceVC.h"

#import "CouponCell.h"
@interface AddCouponHomeVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_dataArray;
}
@end

@implementation AddCouponHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(238, 238, 238);
    self.navigationItem.title=@"优惠券";
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addCoupon)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    NSDictionary * dic1 = @{@"shop":@"商消乐", @"money":@"30",@"limit":@"无限制",@"deadTime":@"有效期为:2017-2-20～2017-3-20",@"notice":@"代金券描述",@"image":@"5-01"};
    NSDictionary * dic2 = @{@"shop":@"尚艺轩", @"money":@"50",@"limit":@"满减",@"deadTime":@"有效期为:2017-2-25～2017-3-25",@"notice":@"代金券描述",@"image":@"6-01"};
    NSDictionary * dic3 = @{@"shop":@"绝味鸭脖", @"money":@"30",@"limit":@"满减",@"deadTime":@"有效期为:2017-2-28～2017-3-28",@"notice":@"代金券描述",@"image":@"4-011"};
    
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
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell) {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
//        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 5, SCREENWIDTH-20, 190*(SCREENWIDTH-20)/600.0-10)];
//        bgView.backgroundColor=[UIColor whiteColor];
//        bgView.layer.cornerRadius=5.0f;
//        bgView.clipsToBounds=YES;
//        [cell addSubview:bgView];
//        
//        UIImageView *_headImage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 40, 40)];
//        //_headImage.image=[UIImage imageNamed:@"5-01"];
//        _headImage.layer.cornerRadius=20;
//        _headImage.clipsToBounds=YES;
//        _headImage.tag=100;
//        [bgView addSubview:_headImage];
//        
//        UILabel *shopNameLable=[[UILabel alloc]initWithFrame:CGRectMake(70, 20, bgView.width-70, 20)];
//        //shopNameLable.text=@"森林雨火锅";
//        shopNameLable.font=[UIFont systemFontOfSize:15.0f];
//        shopNameLable.textColor=[UIColor grayColor];
//        shopNameLable.tag=200;
//        [bgView addSubview:shopNameLable];
//        
//        UILabel *couponMoney=[[UILabel alloc]initWithFrame:CGRectMake(70, 45, bgView.width-70, 30)];
//        //couponMoney.text=@"20元代金券";
//        couponMoney.font=[UIFont systemFontOfSize:20.0f];
//        couponMoney.tag=300;
//        [bgView addSubview:couponMoney];
//        
//        ShaperView *viewr=[[ShaperView alloc]initWithFrame:CGRectMake(5, _headImage.bottom+20, SCREENWIDTH-20, 1)];
//        ShaperView *viewt= [viewr drawDashLine:viewr lineLength:3 lineSpacing:3 lineColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f]];
//        [bgView addSubview:viewt];
//        
//        UILabel *deadTime=[[UILabel alloc]initWithFrame:CGRectMake(10, viewr.bottom, bgView.width-10, 20)];
//        //deadTime.text=@"有效期为:2017-2-25～2017-3-25";
//        deadTime.font=[UIFont systemFontOfSize:13.0f];
//        deadTime.textColor=[UIColor grayColor];
//        deadTime.tag=400;
//        [bgView addSubview:deadTime];
//        
//        cell.backgroundColor=RGB(238, 238, 238);
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    }
//    UIImageView *image=[cell viewWithTag:100];
//    image.image=[UIImage imageNamed:_dataArray[indexPath.row][@"image"]];
//    UILabel *lab1=[cell viewWithTag:200];
//    lab1.text=_dataArray[indexPath.row][@"shop"];
//    UILabel *lab2=[cell viewWithTag:300];
//    lab2.text=_dataArray[indexPath.row][@"money"];
//    UILabel *lab3=[cell viewWithTag:400];
//    lab3.text=_dataArray[indexPath.row][@"deadTime"];
//    return cell;
//    
//}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponCell *cell = [CouponCell couponCellWithTableView:tableView];
    
    if (_dataArray.count!=0) {
        cell.headImg.image=[UIImage imageNamed:_dataArray[indexPath.row][@"image"]];
        cell.shopNamelab.text=_dataArray[indexPath.row][@"shop"];
        cell.couponMoney.text=_dataArray[indexPath.row][@"money"];
        cell.deadTime.text=_dataArray[indexPath.row][@"deadTime"];
        cell.limitLab.text=_dataArray[indexPath.row][@"notice"];

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
//    return 190*(SCREENWIDTH-20)/600.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    CouponIntroduceVC *vc=[[CouponIntroduceVC alloc]init];
//    vc.infoDic=_dataArray[indexPath.row];
//    vc.index=0;
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addCoupon{
    AddCouponVC *couponVC=[[AddCouponVC alloc]init];
    [self.navigationController pushViewController:couponVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
