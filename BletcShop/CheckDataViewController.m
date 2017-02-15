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
//    for (int i=0; i<array.count; i++) {
//        int X= i %5;
//        int Y = i/5;
//        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(10+X*(SCREENWIDTH-20)/5, 10+Y*((SCREENWIDTH-20)/5+10), (SCREENWIDTH-20)/5, (SCREENWIDTH-20)/5);
//        button.tag=i+1;
//        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:button];
//        
//        [button setBackgroundImage:[UIImage imageNamed:@"LLL"] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"bbbLL"] forState:UIControlStateHighlighted];
//
//        UIImageView *imgV = [[UIImageView alloc]init];
//        imgV.center = CGPointMake(button.width/2, button.width/2-10);
//        imgV.bounds = CGRectMake(0, 0, button.width/3, button.width/3);
//        imgV.image = [UIImage imageNamed:img_A[i]];
//        [button addSubview:imgV];
//        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imgV.bottom, button.width, 20)];
//        lab.text =array[i];
//        lab.font =[UIFont systemFontOfSize:12];
//        lab.textAlignment= NSTextAlignmentCenter;
//        lab.textColor = [UIColor colorWithHexString:@"#333333"];
//        [button addSubview:lab];
//        
//    }
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, SCREENHEIGHT-64-10) style:UITableViewStylePlain];
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


//-(void)btnClick:(UIButton *)sender{
//    
//    if (sender.tag ==5) {
//        CashListViewController *VC=[[CashListViewController alloc]init];
//        [self.navigationController pushViewController:VC animated:YES];
//
//    }else{
//        CommenDataViewController *commenDataVC=[[CommenDataViewController alloc]init];
//        commenDataVC.tag = sender.tag;
//        [self.navigationController pushViewController:commenDataVC animated:YES];
//    }
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
