//
//  PointAllGetAndCostsVC.m
//  BletcShop
//
//  Created by apple on 17/2/23.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PointAllGetAndCostsVC.h"

@interface PointAllGetAndCostsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataArray;
    UITableView *_tableView;
}
@end

@implementation PointAllGetAndCostsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"积分明细";
    self.view.backgroundColor=[UIColor whiteColor];
    
    _dataArray=[[NSArray alloc]init];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=64;
    [self.view addSubview:_tableView];
    [self postRequestPonitDetails];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        UILabel *shopNameLable=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREENWIDTH-20, 20)];
        shopNameLable.tag=100;
        shopNameLable.text=@"推荐新用户奖励";
        shopNameLable.font=[UIFont systemFontOfSize:15.0f];
        [cell addSubview:shopNameLable];
        
        UILabel *exChangeTime=[[UILabel alloc]initWithFrame:CGRectMake(20, 30, SCREENWIDTH-20, 20)];
        exChangeTime.text=@"2017-2-23 06:07:51";
        exChangeTime.font=[UIFont systemFontOfSize:13.0f];
        exChangeTime.tag=200;
        exChangeTime.textColor=[UIColor grayColor];
        [cell addSubview:exChangeTime];
        
        UILabel *costPoint=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-100, 17, 100, 30)];
        costPoint.textColor=[UIColor redColor];
        costPoint.text=@"+10";
        costPoint.textAlignment=1;
        costPoint.font=[UIFont systemFontOfSize:13.0f];
        costPoint.tag=300;
        [cell addSubview:costPoint];
        
    }
    UILabel *lab1=[cell viewWithTag:100];
    UILabel *lab2=[cell viewWithTag:200];
    UILabel *lab3=[cell viewWithTag:300];
    lab1.text=_dataArray[indexPath.row][@"content"];
    lab2.text=_dataArray[indexPath.row][@"datetime"];
    lab3.text=[NSString stringWithFormat:@"-%@",_dataArray[indexPath.row][@"sum"]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)postRequestPonitDetails{
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/mall/getConsume",BASEURL ];
    AppDelegate *del=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:del.userInfoDic[@"uuid"] forKey:@"uuid"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);
        if (result) {
            _dataArray=result;
            [_tableView reloadData];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];

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
