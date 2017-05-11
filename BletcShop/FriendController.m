//
//  FriendController.m
//  BletcShop
//
//  Created by Yuan on 16/1/26.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "FriendController.h"
@interface FriendController ()
{
    UIView *lineView;
    UIButton *button1;
    UIButton *button2;
    NSMutableArray *_array;
    UITableView *_tableView;
    UIScrollView *backGroudScrollView;
    //jie xiao
    UITableView *_tableView2;
    NSMutableArray *_array2;
}
@end

@implementation FriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的推荐";
    
    self.view.backgroundColor = RGB(240, 240, 240);
    
    _array=[[NSMutableArray alloc]initWithCapacity:0];
    _array2=[[NSMutableArray alloc]initWithCapacity:0];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    button1=[UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame=CGRectMake(0, 0, SCREENWIDTH/2, 50);
    [button1 setTitle:@"已推荐商户(0)" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:15];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button1];
    
    button2=[UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame=CGRectMake(SCREENWIDTH/2, 0, SCREENWIDTH/2, 50);
    [button2 setTitle:@"已推荐用户(0)" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:15];

    [button2 addTarget:self action:@selector(btnClick2:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button2];
    
    lineView=[[UIView alloc]init];
    lineView.bounds=CGRectMake(0, 48, SCREENWIDTH/4, 2);
    lineView.center=CGPointMake(button1.center.x, 49);
    lineView.backgroundColor=[UIColor redColor];
    [view addSubview:lineView];
    
    backGroudScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, SCREENHEIGHT-64-50)];
    backGroudScrollView.bounces=NO;
    backGroudScrollView.showsHorizontalScrollIndicator=NO;
    backGroudScrollView.delegate=self;
    backGroudScrollView.pagingEnabled=YES;
    backGroudScrollView.contentSize=CGSizeMake(SCREENWIDTH*2, SCREENHEIGHT-64-50);
    [self.view addSubview:backGroudScrollView];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-50) style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [backGroudScrollView addSubview:_tableView];
    //已揭晓名单的表
    _tableView2=[[UITableView alloc]initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT-64-50) style:UITableViewStyleGrouped];
    _tableView2.dataSource=self;
    _tableView2.delegate=self;
    [backGroudScrollView addSubview:_tableView2];
    
    [self postRequest];
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


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_tableView) {
        return _array.count;
    }else if (tableView==_tableView2){
        return _array2.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    //用户
    if(tableView==_tableView2)
    {
        UILabel *yonghuLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(18, 15-2, SCREENWIDTH-18, 15+4)];
        if (_array2.count>0) {
            yonghuLabel1.text = [NSString getTheNoNullStr:[[_array2 objectAtIndex:indexPath.row] objectForKey:@"name"] andRepalceStr:@"未知"];
        }
        yonghuLabel1.backgroundColor = [UIColor clearColor];
        yonghuLabel1.textAlignment = NSTextAlignmentLeft;
        yonghuLabel1.font = [UIFont systemFontOfSize:15];
        [cell addSubview:yonghuLabel1];
        //储值额
        UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 46, SCREENWIDTH/2-18, 15)];
        moneyLabel.text = @"收入总额:";
        moneyLabel.textColor=[UIColor grayColor];
        moneyLabel.backgroundColor = [UIColor clearColor];
        moneyLabel.textAlignment = NSTextAlignmentLeft;
        moneyLabel.font = [UIFont systemFontOfSize:13];
        [cell addSubview:moneyLabel];
        
        if (_array2.count>0) {
            moneyLabel.text = [NSString stringWithFormat:@"收入总额 %@",[[_array2 objectAtIndex:indexPath.row] objectForKey:@"sum"]];
        }
        //提成
        UILabel *tichengLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+10, 46, SCREENWIDTH/2-10, 15)];
        tichengLabel.text = @"推荐奖励:";
        tichengLabel.textColor=[UIColor grayColor];
        tichengLabel.backgroundColor = [UIColor clearColor];
        tichengLabel.textAlignment = NSTextAlignmentLeft;
        tichengLabel.font = [UIFont systemFontOfSize:13];
        [cell addSubview:tichengLabel];
        if (_array2.count>0) {
            tichengLabel.text = [NSString stringWithFormat:@"推荐奖励 %@",[[_array2 objectAtIndex:indexPath.row] objectForKey:@"income"]];
        }
        
    }else if(tableView==_tableView)
    {
        //商户
        UILabel *yonghuLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 15-2, SCREENWIDTH-18, 15+4)];
        yonghuLabel.text = @"";
        yonghuLabel.backgroundColor = [UIColor clearColor];
        yonghuLabel.textAlignment = NSTextAlignmentLeft;
        yonghuLabel.font = [UIFont systemFontOfSize:15];
        [cell addSubview:yonghuLabel];
        
               //储值额
        UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 46, SCREENWIDTH/2-18, 15)];
        moneyLabel.text = @"营业总额:";
        moneyLabel.textColor=[UIColor grayColor];
        moneyLabel.backgroundColor = [UIColor clearColor];
        moneyLabel.textAlignment = NSTextAlignmentLeft;
        moneyLabel.font = [UIFont systemFontOfSize:13];
        [cell addSubview:moneyLabel];
        
        
        //提成
        UILabel *tichengLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+10, 46, SCREENWIDTH/2-10, 15)];
        tichengLabel.text = @"推荐奖励:";
        tichengLabel.textColor=[UIColor grayColor];
        tichengLabel.backgroundColor = [UIColor clearColor];
        tichengLabel.textAlignment = NSTextAlignmentLeft;
        tichengLabel.font = [UIFont systemFontOfSize:12];
        [cell addSubview:tichengLabel];
        
        //审核状态
        UILabel *statelab = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+10, 15-2, SCREENWIDTH/2-10, 15)];
        statelab.textColor=[UIColor purpleColor];
        statelab.font = [UIFont systemFontOfSize:13];
        [cell addSubview:statelab];

        
        if (_array.count>0) {
            
            yonghuLabel.text = [NSString getTheNoNullStr:[[_array objectAtIndex:indexPath.row] objectForKey:@"name"] andRepalceStr:@"未知"];

            moneyLabel.text = [NSString stringWithFormat:@"营业总额 %@",[[_array objectAtIndex:indexPath.row] objectForKey:@"sum"]];

            tichengLabel.text = [NSString stringWithFormat:@"推荐奖励 %@",[[_array objectAtIndex:indexPath.row] objectForKey:@"income"]];
            
            NSString *state_s = [NSString getTheNoNullStr:[[_array objectAtIndex:indexPath.row] objectForKey:@"state"] andRepalceStr:@""];
            
            if ([state_s isEqualToString:@"ONLINE"]) {
                
                statelab.text = @"已上线!";
                
                
            }else if ([state_s isEqualToString:@"Auditing"]){
                
                statelab.text = @"审核中!";

            }else if ([state_s isEqualToString:@"Fail"]){
                statelab.text = @"审核失败!";

            }else{
                statelab.text = @"";
 
            }

        }
        
    }
    
    return cell;
}

-(void)postRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/referrer/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        NSArray *array = (NSArray*)result;
        if (array.count>0)
        {
            for (int i=0; i<array.count; i++) {
                if ([[[array objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"u"]) {
                    [_array2 addObject:[array objectAtIndex:i]];
                    [button2 setTitle:[NSString stringWithFormat:@"已推荐用户(%lu)",(unsigned long)_array2.count] forState:UIControlStateNormal];
                }else if([[[array objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"m"]) {
                    [_array addObject:[array objectAtIndex:i]];
                    [button1 setTitle:[NSString stringWithFormat:@"已推荐商户(%lu)",(unsigned long)_array.count] forState:UIControlStateNormal];
                }
            }
            
        }
        if (_tableView) {
            [_tableView reloadData];
        }
        if (_tableView2) {
            [_tableView2 reloadData];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
