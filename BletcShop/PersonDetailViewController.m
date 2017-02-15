//
//  PersonDetailViewController.m
//  BletcShop
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "PersonDetailViewController.h"

@interface PersonDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PersonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return self.titleArray.count;
    }
    return self.titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 12, SCREENWIDTH/2-10, 40)];
        label.textAlignment=NSTextAlignmentLeft;
        label.tag=100;
        [cell addSubview:label];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0, 12, SCREENWIDTH-10, 40)];
        label2.textAlignment=NSTextAlignmentRight;
        label2.tag=200;
        [cell addSubview:label2];
    }
    UILabel *lab=[cell viewWithTag:100];
    UILabel *lab2=[cell viewWithTag:200];
    if (indexPath.section==0) {
        lab.text=@"消费金额";
        NSString *money=[NSString stringWithFormat:@"￥  %@",self.totalMoney];
        lab2.text=money;
    }else{
        lab.text=self.titleArray[indexPath.row];
        lab2.text=self.array[indexPath.row];
    }
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80)];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/4, 0, SCREENWIDTH/2, 80)];
        label.font=[UIFont systemFontOfSize:30.0f];
        NSString *money=[NSString stringWithFormat:@"￥  %@",self.totalMoney];
        label.text=money;
        label.textAlignment=1;
        label.textColor=[UIColor orangeColor];
        [view addSubview:label];
        view.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0f];
        return view;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 80;
    }else{
        return 20;
    }
    return 80;
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
