//
//  ConvertRecordVC.m
//  BletcShop
//
//  Created by apple on 17/2/23.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ConvertRecordVC.h"
#import "UIImageView+WebCache.h"
@interface ConvertRecordVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *imageArr;
    NSArray *shopNameArr;
    NSArray *convertTimeArr;
    NSArray *pointCostArr;
    
    UITableView *_tableView;
}

@property(nonatomic,strong)NSArray *data_array;
@end

@implementation ConvertRecordVC
-(NSArray *)data_array{
    if (!_data_array) {
        _data_array = [NSArray array];
    }
    return _data_array;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"已兑换商品";
    self.view.backgroundColor=[UIColor whiteColor];
    imageArr=@[@"tempProducts_01.jpeg",@"tempProducts_02.jpg",@"tempProducts_04.jpg"];
    shopNameArr=@[@"爱国者Mini移动电源",@"懒人手机支架",@"日本印象保温杯"];
    convertTimeArr=@[@"兑换时间:2017-2-23 03:07:31",@"兑换时间:2017-2-22 04:25:21",@"兑换时间:2017-2-21 01:08:34"];
    pointCostArr=@[@"-500",@"-200",@"-300"];
    
     _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=100;
    [self.view addSubview:_tableView];
    
    [self getData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_array.count;
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
    UILabel *nameLab=[cell viewWithTag:200];
    UILabel *timeLab=[cell viewWithTag:300];
    UILabel *costLab=[cell viewWithTag:400];
    
    if (self.data_array.count != 0) {
        NSDictionary *dic = self.data_array[indexPath.row];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",POINT_GOODS,dic[@"image_url"]]]];
        
        nameLab.text=dic[@"name"];
        timeLab.text=dic[@"datetime"];
        costLab.text=[@"-" stringByAppendingString:dic[@"price"]];

    }

       return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}



-(void)getData{
    
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@Extra/mall/getExchange",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [paramer setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        [hub hideAnimated:YES];
        
        NSLog(@"result----%@",result);
        if (result) {
            self.data_array = (NSArray*)result;
            
            [_tableView reloadData];
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getExchange,error----%@",error);

        [hub hideAnimated:YES];
    }];

}
@end
