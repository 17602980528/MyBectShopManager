//
//  EndOrBeginningViewController.m
//  BletcShop
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "EndOrBeginningViewController.h"
#import "UIImageView+WebCache.h"
@interface EndOrBeginningViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIView *lineView;
    UIButton *button1;
    UIButton *button2;
    NSMutableArray *array;
    UITableView *_tableView;
    UIScrollView *backGroudScrollView;
    //jie xiao
    UITableView *_tableView2;
    NSMutableArray *array2;
}
@end

@implementation EndOrBeginningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"抽奖记录";
    array=[[NSMutableArray alloc]initWithCapacity:0];
    array2=[[NSMutableArray alloc]initWithCapacity:0];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    view.backgroundColor=[[UIColor alloc]initWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:view];
    
    button1=[UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame=CGRectMake(0, 0, SCREENWIDTH/2, 50);
    [button1 setTitle:@"进行中" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button1];
    
    button2=[UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame=CGRectMake(SCREENWIDTH/2, 0, SCREENWIDTH/2, 50);
    [button2 setTitle:@"已揭晓" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(btnClick2:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button2];
    
    lineView=[[UIView alloc]init];
    lineView.bounds=CGRectMake(0, 48, SCREENWIDTH/2, 2);
    lineView.center=CGPointMake(button1.center.x, 49);
    lineView.backgroundColor=[UIColor redColor];
    [view addSubview:lineView];
    
    backGroudScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, SCREENHEIGHT-64-50)];
    backGroudScrollView.bounces=NO;
    backGroudScrollView.showsHorizontalScrollIndicator=NO;
    backGroudScrollView.delegate=self;
    backGroudScrollView.pagingEnabled=YES;
    backGroudScrollView.contentSize=CGSizeMake(SCREENWIDTH*2, SCREENHEIGHT-64-50);
    backGroudScrollView.backgroundColor=[UIColor cyanColor];
    [self.view addSubview:backGroudScrollView];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-50) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [backGroudScrollView addSubview:_tableView];
    //已揭晓名单的表
    _tableView2=[[UITableView alloc]initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT-64-50) style:UITableViewStyleGrouped];
    _tableView2.dataSource=self;
    _tableView2.delegate=self;
    _tableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView2.backgroundColor=[UIColor whiteColor];
    [backGroudScrollView addSubview:_tableView2];
    
    [self postRequest];
    [self postResultRequest];
}
-(void)btnClick1:(UIButton *)sender{
    lineView.center=CGPointMake(button1.center.x, 49);
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3f animations:^{
        backGroudScrollView.contentOffset=CGPointMake(0, 0);
    }];
}
-(void)btnClick2:(UIButton *)sender{
    lineView.center=CGPointMake(button2.center.x, 49);
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3f animations:^{
        backGroudScrollView.contentOffset=CGPointMake(SCREENWIDTH, 0);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_tableView) {
        return array.count;
    }else if(tableView==_tableView2){
        return array2.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableView) {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            //图像
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
            imageView.tag=100;
            [cell addSubview:imageView];
            //期号
            UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(120, 10, SCREENWIDTH-120, 30)];
            label1.tag=200;
            label1.font=[UIFont systemFontOfSize:15.0f];
            //label1.backgroundColor=[UIColor yellowColor];
            [cell addSubview:label1];
            //揭晓进度
            UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(120, 45, SCREENWIDTH-120, 30)];
            label2.tag=300;
            label2.font=[UIFont systemFontOfSize:15.0f];
            //label2.backgroundColor=[UIColor yellowColor];
            [cell addSubview:label2];
            //总需－－剩余
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(120, 80, SCREENWIDTH-120, 30)];
            label3.tag=400;
            label3.font=[UIFont systemFontOfSize:15.0f];
            //label3.backgroundColor=[UIColor yellowColor];
            [cell addSubview:label3];
            //参与次数
            UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(10, 120, SCREENWIDTH/2-60, 30)];
            label4.tag=500;
            label4.font=[UIFont systemFontOfSize:15.0f];
            //label4.backgroundColor=[UIColor yellowColor];
            [cell addSubview:label4];
            //参与时期
            UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-60, 120, SCREENWIDTH/2+60, 30)];
            label5.tag=600;
            label5.font=[UIFont systemFontOfSize:13.0f];
            //label5.backgroundColor=[UIColor cyanColor];
            [cell addSubview:label5];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UIImageView *imgView=[cell viewWithTag:100];
        UILabel *lab1=[cell viewWithTag:200];
        UILabel *lab2=[cell viewWithTag:300];
        UILabel *lab3=[cell viewWithTag:400];
        UILabel *lab4=[cell viewWithTag:500];
        UILabel *lab5=[cell viewWithTag:600];
        if (array.count>0) {
            NSURL * nurl1=[[NSURL alloc] initWithString:[[DUOBAOIMAGE stringByAppendingString:array[indexPath.row][1]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
            ;
            
            float totalPerson = [array[indexPath.row][4] floatValue];
            float lastPerson = [array[indexPath.row][5] floatValue];
            CGFloat scale =(totalPerson-lastPerson)/totalPerson*100;
            NSString *progressStr=[[NSString alloc]initWithFormat:@"%.2f%%",scale];
            lab1.text=[[NSString alloc]initWithFormat:@"期号:%@",array[indexPath.row][3]];
            lab2.text=[[NSString alloc]initWithFormat:@"揭晓进度:%@",progressStr ];
            lab3.text=[[NSString alloc]initWithFormat:@"总需%@人次    剩余%@",array[indexPath.row][4],array[indexPath.row][5]];
            lab4.text=[[NSString alloc]initWithFormat:@"参与%@次",array[indexPath.row][6]];
            lab5.text=[[NSString alloc]initWithFormat:@"参与时间%@",array[indexPath.row][7]];
        }
        
        return cell;

    }else if (tableView==_tableView2){
        UITableViewCell *cell2=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell2==nil) {
            cell2=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell2"];
            UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(5, 10, SCREENWIDTH-10, 260)];
            backgroundView.backgroundColor=[[UIColor alloc]initWithRed:195/255.0 green:248/255.0 blue:253/255.0 alpha:1.0f];
            backgroundView.layer.cornerRadius=8.0f;
            backgroundView.clipsToBounds=YES;
            backgroundView.tag=888;
            [cell2 addSubview:backgroundView];
            //布局揭晓界面
            UIImageView *imageVeiw=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
            //imageVeiw.backgroundColor=[UIColor redColor];
            imageVeiw.tag=700;
            [backgroundView addSubview:imageVeiw];
            cell2.selectionStyle=UITableViewCellSelectionStyleNone;
            //期号
            UILabel *label11=[[UILabel alloc]initWithFrame:CGRectMake(120, 10, SCREENWIDTH-120-10, 30)];
            label11.tag=800;
            label11.font=[UIFont systemFontOfSize:15.0f];
            //label11.backgroundColor=[UIColor yellowColor];
            [backgroundView addSubview:label11];
            //揭晓时间
            UILabel *label12=[[UILabel alloc]initWithFrame:CGRectMake(120, 45, SCREENWIDTH-120-10, 30)];
            label12.tag=900;
            label12.font=[UIFont systemFontOfSize:15.0f];
            //label12.backgroundColor=[UIColor yellowColor];
            [backgroundView addSubview:label12];
            //参与次数
            UILabel *label13=[[UILabel alloc]initWithFrame:CGRectMake(5, 120, SCREENWIDTH/2-60-10, 30)];
            label13.tag=1000;
            label13.font=[UIFont systemFontOfSize:15.0f];
            //label13.backgroundColor=[UIColor yellowColor];
            [backgroundView addSubview:label13];
            //参与时期
            UILabel *label14=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-60, 120, SCREENWIDTH/2+60-10, 30)];
            label14.tag=1100;
            label14.font=[UIFont systemFontOfSize:13.0f];
            //label14.backgroundColor=[UIColor cyanColor];
            [backgroundView addSubview:label14];
            //后140，中奖者名单
            UIImageView *imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(10, 160, 50, 50)];
            imageView2.tag=2000;
            //imageView2.backgroundColor=[UIColor blueColor];
            [backgroundView addSubview:imageView2];
            //中奖图标
            UIImageView *tubiaoImage=[[UIImageView alloc]initWithFrame:CGRectMake(backgroundView.width-60, 160, 50, 50)];
            tubiaoImage.image=[UIImage imageNamed:@"award_ac"];
            [backgroundView addSubview:tubiaoImage];
            //中奖人昵称
            UILabel *label21=[[UILabel alloc]initWithFrame:CGRectMake(70, 160, SCREENWIDTH-70-10, 20)];
            //label21.backgroundColor=[UIColor yellowColor];
            label21.font=[UIFont systemFontOfSize:15.0f];
            label21.tag=1200;
            [backgroundView addSubview:label21];
            //揭晓时间
            UILabel *label22=[[UILabel alloc]initWithFrame:CGRectMake(70, 185, SCREENWIDTH-70-10, 20)];
            //label22.backgroundColor=[UIColor yellowColor];
            label22.font=[UIFont systemFontOfSize:15.0f];
            label22.tag=1300;
            [backgroundView addSubview:label22];
            //获奖者参与次数
            UILabel *label23=[[UILabel alloc]initWithFrame:CGRectMake(70, 210, SCREENWIDTH-70-10, 20)];
            //label23.backgroundColor=[UIColor yellowColor];
            label23.font=[UIFont systemFontOfSize:15.0f];
            label23.tag=1400;
            [backgroundView addSubview:label23];
            //获奖者参与抽奖时间
            UILabel *label24=[[UILabel alloc]initWithFrame:CGRectMake(70, 235, SCREENWIDTH-70-10, 20)];
            //label24.backgroundColor=[UIColor yellowColor];
            label24.font=[UIFont systemFontOfSize:15.0f];
            label24.tag=1500;
            [backgroundView addSubview:label24];
        }
        UIView *groundView=[cell2 viewWithTag:888];
        UIImageView *imgView=[groundView viewWithTag:700];
        UILabel *lab11=[groundView viewWithTag:800];
        UILabel *lab12=[groundView viewWithTag:900];
        UILabel *lab13=[groundView viewWithTag:1000];
        UILabel *lab14=[groundView viewWithTag:1100];
        UIImageView *imgView2=[groundView viewWithTag:2000];
        UILabel *lab21=[groundView viewWithTag:1200];
        UILabel *lab22=[groundView viewWithTag:1300];
        UILabel *lab23=[groundView viewWithTag:1400];
        UILabel *lab24=[groundView viewWithTag:1500];
        if (array2.count>0) {
            NSURL * nurl1=[[NSURL alloc] initWithString:[[DUOBAOIMAGE stringByAppendingString:array2[indexPath.row][1]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
            ;
            lab11.text=[[NSString alloc]initWithFormat:@"第%@期",array2[indexPath.row][3]];
            lab12.text=[[NSString alloc]initWithFormat:@"揭晓时间:%@",array2[indexPath.row][8]];
            lab13.text=[[NSString alloc]initWithFormat:@"参与人次:%@",array2[indexPath.row][6]];
            lab14.text=[[NSString alloc]initWithFormat:@"抽奖时间:%@",array2[indexPath.row][7]];
            
            NSURL * nurl2=[[NSURL alloc] initWithString:[[HEADIMAGE stringByAppendingString:array2[indexPath.row][9][4]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [imgView2 sd_setImageWithURL:nurl2 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
            lab21.text=array2[indexPath.row][9][1];
            lab22.text=[[NSString alloc]initWithFormat:@"幸运号码:%@",array2[indexPath.row][9][0]];
            lab23.text=[[NSString alloc]initWithFormat:@"参与次数:%@",array2[indexPath.row][9][3]];
            lab24.text=[[NSString alloc]initWithFormat:@"抽奖时间:%@",array2[indexPath.row][9][2]];
            
        }
        return cell2;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableView) {
        return 160;
    }else if (tableView==_tableView2){
        return 280;
    }
    return 160;
}
-(void)postRequest{
    NSString *url =[[NSString alloc]initWithFormat:@"http://101.201.100.191/VipCard/award_record_query.php"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.userInfoArray objectAtIndex:1] forKey:@"phone"];
    [params setObject:@"running" forKey:@"state"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray * result) {
        NSLog(@"%@",result);
        if (result.count>0) {
            for (int i=0; i<result.count; i++) {
                [array addObject:result[i]];
            }
            if (_tableView) {
                [_tableView reloadData];
            }
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];

}
//活动背景scrollview调用代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==backGroudScrollView) {
        if (scrollView.contentOffset.x==SCREENWIDTH) {
            lineView.center=CGPointMake(button2.center.x, 49);
            [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else if (scrollView.contentOffset.x==0){
            lineView.center=CGPointMake(button1.center.x, 49);
            [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

-(void)postResultRequest{
    NSString *url =[[NSString alloc]initWithFormat:@"http://101.201.100.191/VipCard/award_record_query.php"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.userInfoArray objectAtIndex:1] forKey:@"phone"];
    [params setObject:@"end" forKey:@"state"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray * result) {
        NSLog(@"%@",result);
        if (result.count>0) {
            for (int i=0; i<result.count; i++) {
                [array2 addObject:result[i]];
            }
            if (_tableView2) {
                [_tableView2 reloadData];
            }
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
