//
//  ConvertRecordVC.m
//  BletcShop
//
//  Created by apple on 17/2/23.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ConvertRecordVC.h"

@interface ConvertRecordVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *imageArr;
    NSArray *shopNameArr;
    NSArray *convertTimeArr;
    NSArray *pointCostArr;
}
@end

@implementation ConvertRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"已兑换商品";
    self.view.backgroundColor=[UIColor whiteColor];
    imageArr=@[@"tempProducts_01.jpeg",@"tempProducts_02.jpg",@"tempProducts_04.jpg"];
    shopNameArr=@[@"爱国者Mini移动电源",@"懒人手机支架",@"日本印象保温杯"];
    convertTimeArr=@[@"兑换时间:2017-2-23 03:07:31",@"兑换时间:2017-2-22 04:25:21",@"兑换时间:2017-2-21 01:08:34"];
    pointCostArr=@[@"-500",@"-200",@"-300"];
    
    UITableView *_tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=100;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        UIImageView *_shopImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
        _shopImageView.tag=100;
        //_shopImageView.image=[UIImage imageNamed:@"tempProducts_01.jpeg"];
        [cell addSubview:_shopImageView];
        
        UILabel *shopNameLable=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, SCREENWIDTH-100, 40)];
        shopNameLable.tag=200;
        //shopNameLable.text=@"爱国者Mini移动电源";
        shopNameLable.font=[UIFont systemFontOfSize:15.0f];
        [cell addSubview:shopNameLable];
        
        UILabel *exChangeTime=[[UILabel alloc]initWithFrame:CGRectMake(100, 50, SCREENWIDTH-100, 40)];
        exChangeTime.tag=300;
        //exChangeTime.text=@"兑换时间:2017-2-23 06:07:51";
        exChangeTime.font=[UIFont systemFontOfSize:13.0f];
        exChangeTime.textColor=[UIColor grayColor];
        [cell addSubview:exChangeTime];
        
        UILabel *costPoint=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-100, 35, 100, 30)];
        costPoint.textColor=[UIColor redColor];
        costPoint.tag=400;
        //costPoint.text=@"-500";
        costPoint.textAlignment=1;
        costPoint.font=[UIFont systemFontOfSize:13.0f];
        [cell addSubview:costPoint];
        
    }
    UIImageView *imageView=[cell viewWithTag:100];
    imageView.image=[UIImage imageNamed:imageArr[indexPath.row]];
    UILabel *nameLab=[cell viewWithTag:200];
    nameLab.text=shopNameArr[indexPath.row];
    UILabel *timeLab=[cell viewWithTag:300];
    timeLab.text=convertTimeArr[indexPath.row];
    UILabel *costLab=[cell viewWithTag:400];
    costLab.text=pointCostArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
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
