//
//  PayBaseCountOrTimeVC.m
//  BletcShop
//
//  Created by apple on 17/3/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PayBaseCountOrTimeVC.h"
#import "PayBaseClickCountVC.h"
#import "SingleModel.h"
@interface PayBaseCountOrTimeVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleArray;
    NSInteger selectedRow;
    UITableView *_tableView;
    SingleModel *model;
}
@end

@implementation PayBaseCountOrTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"发布广告";
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(goNextVC)];
    self.navigationItem.rightBarButtonItem=rightItem;
    titleArray=@[@"选择次数",@"选择时间"];
    selectedRow=0;
    model=[SingleModel sharedManager];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    if (indexPath.row==selectedRow) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    cell.textLabel.text=titleArray[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedRow=indexPath.row;
    [_tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    view.backgroundColor=RGB(240, 240, 240);
    UILabel *headLable=[[UILabel alloc]initWithFrame:CGRectMake(18, 0, SCREENWIDTH-18, 30)];
    headLable.font=[UIFont systemFontOfSize:12.0f];
    headLable.text=@"选择消费方式";
    [view addSubview:headLable];
    return view;
}
-(void)goNextVC{
    
    if (selectedRow==0) {
        //按点击量算
        model.baseOnCountsOrTime=@"click";
        PayBaseClickCountVC *VC=[[PayBaseClickCountVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (selectedRow==1){
        //按天数算
        model.baseOnCountsOrTime=@"time";
        PayBaseClickCountVC *VC=[[PayBaseClickCountVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
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
