//
//  AdvertisementHomeVC.m
//  BletcShop
//
//  Created by apple on 17/2/21.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AdvertisementHomeVC.h"
#import "SurroundingAreaVC.h"
#import "PublishAdvertSecondVC.h"
#import "OffLineNoticeVC.h"
#import "ArcForRandomAdvertVC.h"
#import "SingleModel.h"
@interface AdvertisementHomeVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *adverKindArr;
    NSInteger selectedRow;
    SingleModel *model;
}
@end

@implementation AdvertisementHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(240, 240, 240);
    self.navigationItem.title=@"广告推送";
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(goNextVC)];
    self.navigationItem.rightBarButtonItem=rightItem;
    model=[SingleModel sharedManager];
    adverKindArr=@[@"欢迎页广告",@"顶部轮播活动页面",@"活动区广告",@"周边广告",@"随机广告",@"弹出页广告"];
    selectedRow=0;
    
    UITableView *_tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text=adverKindArr[indexPath.row];
    if (indexPath.row==selectedRow) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedRow=indexPath.row;
    [tableView reloadData];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    view.backgroundColor=RGB(240, 240, 240);//[UIColor whiteColor];
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    lab.text=@"  选择广告投放类型";
    [view addSubview:lab];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)goNextVC{
    model.advertIndex=selectedRow;
    if (selectedRow==0||selectedRow==4||selectedRow==5) {
        //
        OffLineNoticeVC *vc=[[OffLineNoticeVC alloc]init];
        vc.title=adverKindArr[selectedRow];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (selectedRow==3){
        SurroundingAreaVC *publishAdvertSecondVC=[[SurroundingAreaVC alloc]init];
         publishAdvertSecondVC.title=adverKindArr[selectedRow];
        [self.navigationController pushViewController:publishAdvertSecondVC animated:YES];
    }else{
        PublishAdvertSecondVC *publishAdvertSecondVC=[[PublishAdvertSecondVC alloc]init];
        publishAdvertSecondVC.title=adverKindArr[selectedRow];
        [self.navigationController pushViewController:publishAdvertSecondVC animated:YES];
    }
    
}

@end
