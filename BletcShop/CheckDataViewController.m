//
//  CheckDataViewController.m
//  BletcShop
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "CheckDataViewController.h"
#import "CommenDataViewController.h"
#import "CashListViewController.h"
#import "UIButton+WebCache.h"

#import "JHChartHeader.h"

@interface CheckDataViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *title_array;
    NSArray *img_A;
}

@end

@implementation CheckDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
    
    self.navigationItem.title=@"数据统计";
    
     title_array=@[@"办卡",@"续卡",@"升级",@"消费",@"现金支付"];
     img_A = @[@"Ǯ",@"未消费",@"银行卡",@"续费",@"升级"];
    
    JHColumnChart *column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0, 0, kWeChatScreenWidth, SCREENHEIGHT/2)];
    
    column.valueArr = @[
                        @[@12],
                        @[@22],
                        @[@1],
                        @[@21],
                        @[@19],
                        
                        ];
    column.originSize = CGPointMake(30, 20);
    column.drawFromOriginX = 20;
    column.typeSpace = 20;
    column.isShowYLine = NO;
    column.columnWidth = 35;
    column.bgVewBackgoundColor = [UIColor whiteColor];
    column.drawTextColorForX_Y = [UIColor blackColor];
    column.colorForXYLine = [UIColor darkGrayColor];
    column.columnBGcolorsArr = @[[UIColor colorWithRed:72/256.0 green:200.0/256 blue:255.0/256 alpha:1],[UIColor greenColor],[UIColor orangeColor]];
    column.xShowInfoText = title_array;
    column.xDescTextFontSize = 9;
    [column showAnimation];
    [self.view addSubview:column];

    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10+SCREENHEIGHT/2, SCREENWIDTH, SCREENHEIGHT-(10+SCREENHEIGHT/2)) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"] ;
    [self.view addSubview:tableView];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return title_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 43, SCREENWIDTH, 1)];
        view.backgroundColor = RGB(234, 234, 234);
        [cell addSubview:view];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    cell.imageView.image = [UIImage imageNamed:img_A[indexPath.row]];
    cell.textLabel.text = title_array[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==4) {
        CashListViewController *VC=[[CashListViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];

    }else{
        CommenDataViewController *commenDataVC=[[CommenDataViewController alloc]init];
        commenDataVC.tag = indexPath.row+1;
        [self.navigationController pushViewController:commenDataVC animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
