//
//  DelayShopViewController.m
//  BletcShop
//
//  Created by Bletc on 16/5/6.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "DelayShopViewController.h"
#import "LZDButton.h"
@interface DelayShopViewController ()
{
    UIView *topBackView;
    UIView *noticeLine;


}
@property (nonatomic , strong) NSDictionary *deadLine_dic;// <#Description#>
@property (nonatomic , strong) NSDictionary *dead_dic;// <#Description#>

@end

@implementation DelayShopViewController

-(NSMutableArray *)sure_A{
    if (!_sure_A) {
        _sure_A = [NSMutableArray array];
    }
    return _sure_A;
}
-(NSMutableArray *)confuse_A{
    if (!_confuse_A) {
        _confuse_A = [NSMutableArray array];
    }
    return _confuse_A;
}
-(NSMutableArray *)wait_A{
    if (!_wait_A) {
        _wait_A = [NSMutableArray array];
    }
    return _wait_A;
}
-(NSMutableArray *)data_A{
    if (!_data_A) {
        _data_A = [NSMutableArray array];
    }
    return _data_A;
}

-(NSDictionary *)deadLine_dic{
    if (!_deadLine_dic) {
        _deadLine_dic = @{@"0.5":@"半年",@"1":@"一年",@"2":@"两年",@"3":@"三年",@"0":@"无限期"};
    }
    
    return _deadLine_dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"会员延期";
    self.selectTag=0;
    
    [self initCatergray];
    [self postRequestDelay];
    

    

}

//卡分类
-(void)initCatergray{
    NSArray *kindArray=@[@"待确认(0)",@"已确认(0)",@"已拒绝(0)"];
    topBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 49)];
    topBackView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topBackView];
    
    for (int i=0; i<kindArray.count; i++) {
        UIButton *Catergray=[UIButton buttonWithType:UIButtonTypeCustom];
        Catergray.frame=CGRectMake(1+i%kindArray.count*((SCREENWIDTH-5)/kindArray.count+1), 0, (SCREENWIDTH-5)/kindArray.count, 49);
        Catergray.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        [Catergray setTitle:kindArray[i] forState:UIControlStateNormal];
        [Catergray setTitleColor:RGB(51,51,51) forState:UIControlStateNormal];
        Catergray.tag=666+i;
        [topBackView addSubview:Catergray];
        [Catergray addTarget:self action:@selector(changeTitleColorAndRefreshCard:) forControlEvents:UIControlEventTouchUpInside];
        if (i!=kindArray.count-1) {
            if (i==0) {
                [Catergray setTitleColor:RGB(241,122,18) forState:UIControlStateNormal];
                noticeLine=[[UIView alloc]init];
                noticeLine.bounds=CGRectMake(0, 0, (SCREENWIDTH-105)/kindArray.count, 1);
                noticeLine.center=CGPointMake(Catergray.center.x, Catergray.center.y+24);
                noticeLine.backgroundColor=RGB(241,122,18);
                [topBackView addSubview:noticeLine];
            }
            UIView *catergrayView=[[UIView alloc]initWithFrame:CGRectMake(Catergray.frame.origin.x+(SCREENWIDTH-5)/kindArray.count,0,1,49)];
            catergrayView.backgroundColor=RGB(234, 234, 234);
            [topBackView addSubview:catergrayView];
        }
        
    }
    
    
    
    self.myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 49, SCREENWIDTH, SCREENHEIGHT-49-64) style:UITableViewStyleGrouped];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    [self.view addSubview:self.myTableView];

    
}

-(void)changeTitleColorAndRefreshCard:(UIButton *)sender{
    

    self.selectTag = sender.tag - 666;
    noticeLine.center=CGPointMake(sender.center.x, sender.center.y+24);
    for (int i=0; i<3; i++) {
        UIButton*button=(UIButton *)[topBackView viewWithTag:666+i];
        if (button.tag==sender.tag) {
            [button setTitleColor:RGB(241,122,18) forState:UIControlStateNormal];
        }else{
            [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        }
    }
    
    [self postRequestDelay];

}

-(void)postRequestDelay
{
    //获取未处理的
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/postpone/get",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setValue:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:@"null" forKey:@"state"];
   
    
//    NSLog(@"----%@===url==%@",params,url);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
//        NSLog(@"%@", result);
        NSArray *resuArr = result;

            [self.wait_A removeAllObjects];

       
        for (NSDictionary *dic in resuArr) {
            
                if ([dic[@"state"] isEqualToString:@"null"]) {
                    [self.wait_A addObject:dic];
                }

            

        }
        
     
        
        
        [self getfirstData];
    
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请求出错,请重新请求", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:4.f];
        
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    switch (self.selectTag) {
        case 0:
        {
            self.data_A=self.wait_A;
        }
            break;
        case 1:
        {
            self.data_A=self.sure_A;
        }
            break;
        case 2:
        {
            self.data_A=self.confuse_A;
        }
            break;
            
        default:
            break;
    }

    
    return self.data_A.count;
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 41+10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.selectTag ==0) {
        return 47;

    }else
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 41+10)];
    view.backgroundColor = [UIColor whiteColor];
    for (UIView*subview in view.subviews) {
        [subview removeFromSuperview];
    }
    
    UIView *line0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    line0.backgroundColor = RGB(239,238,244);
    [view addSubview:line0];

    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(12, line0.bottom, 75, 40)];
    lab.text = @"卡片编号:";
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = RGB(153,153,153);
    lab.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lab];
    
   
    UILabel *card_code_lab = [[UILabel alloc]initWithFrame:CGRectMake(102, line0.bottom, SCREENWIDTH-100, 40)];
    card_code_lab.text = @"卡片编号:";
    card_code_lab.font = [UIFont systemFontOfSize:15];
    card_code_lab.textColor = RGB(51,51,51);
    card_code_lab.textAlignment = NSTextAlignmentLeft;
    [view addSubview:card_code_lab];

    UILabel *state_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, line0.bottom, SCREENWIDTH-43, 40)];
    state_lab.font = [UIFont systemFontOfSize:12];
    state_lab.textColor = RGB(153,153,153);
    state_lab.textAlignment = NSTextAlignmentRight;
    [view addSubview:state_lab];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, state_lab.bottom, SCREENWIDTH, 1)];
    line.backgroundColor = RGB(246,246,246);
    [view addSubview:line];
    
    if (self.data_A.count!=0) {
        card_code_lab.text = self.data_A[section][@"card_code"];
        NSString *state_S =self.data_A[section][@"state"];
        
        if ([state_S isEqualToString:@"access"]) {
            state_lab.text = @"已同意";
        }
        if ([state_S isEqualToString:@"fail"]) {
            state_lab.text = @"已拒绝";
        }

    }
    
    
    return view;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (self.selectTag==0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 47)];
        view.backgroundColor = [UIColor whiteColor];
        for (UIView*subview in view.subviews) {
            [subview removeFromSuperview];
        }
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 0, SCREENWIDTH, 1)];
        line.backgroundColor = RGB(246,246,246);
        [view addSubview:line];
        
        
        for (int i = 0; i <2; i ++) {
            
            LZDButton *btn = [LZDButton creatLZDButton];
            btn.frame = CGRectMake(SCREENWIDTH-180 +i*(30+68), 9, 68, 27);
            btn.layer.cornerRadius = 3;
            btn.layer.borderColor = RGB(153,153,153).CGColor;
            btn.layer.borderWidth = 1;
            btn.layer.masksToBounds = YES;
            [view addSubview:btn];
            btn.section = section;
            btn.row = i;

            [btn addTarget:self action:@selector(disposeClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i==0) {
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitle:@"拒绝" forState:0];
                [btn setTitleColor:RGB(102,102,102) forState:0];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
            }
            if (i==1) {
                btn.backgroundColor = RGB(241,122,18);
                [btn setTitle:@"通过" forState:0];
                [btn setTitleColor:RGB(255,255,255) forState:0];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
            }
            
            
        }
        
        
        return view;

    }else{
        return nil;
}

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    // 定义唯一标识
    // 通过indexPath创建cell实例 每一个cell都是单独的
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *huiyuanLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 75, 30)];
        huiyuanLabel.text = @"卡片编号:";
        huiyuanLabel.font = [UIFont systemFontOfSize:15];
        huiyuanLabel.textColor = RGB(153,153,153);
        huiyuanLabel.tag = 900;
        huiyuanLabel.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:huiyuanLabel];
        
        UILabel *huiyuanText = [[UILabel alloc]initWithFrame:CGRectMake(102, 0, SCREENWIDTH-100, 30)];
        huiyuanText.text = @"洛天依";
        huiyuanText.textAlignment = NSTextAlignmentLeft;
        huiyuanText.font = [UIFont systemFontOfSize:15];
        huiyuanText.textColor = RGB(51,51,51);
        huiyuanText.tag = 901;
        [cell addSubview:huiyuanText];
        
    }
    
    if (self.data_A.count!=0) {
        NSDictionary *dic = self.data_A[indexPath.section];
        UILabel *huiyuanLabel = [cell viewWithTag:900];
        UILabel *huiyuanText = [cell viewWithTag:901];
        switch (indexPath.row) {
            case 0:
            {
                huiyuanLabel.text = @"会员名称:";
                huiyuanText.text = dic[@"nickname"];

                
            }
                break;
            case 1:
            {
                huiyuanLabel.text = @"卡片类型:";
                huiyuanText.text = dic[@"card_type"];

 
            }
                break;
            case 2:
            {
                huiyuanLabel.text = @"卡片级别:";
                huiyuanText.text = dic[@"card_level"];


            }
                break;
            case 3:
            {
                huiyuanLabel.text = @"延长期限:";
                huiyuanText.text = [self.deadLine_dic objectForKey:dic[@"postpone"]];


                
            }
                break;

                
            default:
                break;
        }
        
    }
    
    
  
    return cell;
}




//处理延期业务

-(void)disposeClick:(LZDButton*)sender{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/postpone/stateSet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:[[self.data_A objectAtIndex:sender.section] objectForKey:@"user"] forKey:@"uuid"];
    [params setObject:[[self.data_A objectAtIndex:sender.section] objectForKey:@"card_code"] forKey:@"card_code"];
    [params setObject:[[self.data_A objectAtIndex:sender.section] objectForKey:@"card_level"] forKey:@"card_level"];
    
    
    [params setObject:[[self.data_A objectAtIndex:sender.section] objectForKey:@"postpone"] forKey:@"postpone"];

    
    
    if (sender.row == 1) {
        [params setObject:@"access" forKey:@"state"];
    }else if (sender.row == 0) {
        [params setObject:@"fail" forKey:@"state"];
    }
    
    NSLog(@"----%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result stateSet===%@",result);
        if ([result[@"result_code"] intValue]==1)
        {
            
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"设置成功", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:1.f];
            [self postRequestDelay];

        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"设置失败,请重试", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            // Move to bottm center.
            //    hud.offset = CGPointMake(0.f, );
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:1.f];
        }
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请求出错,请重新请求", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:1.f];
        
    }];
    
}

-(void)getfirstData
{
    
    //获取已处理的
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/postpone/get",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    
        [params setObject:@"access" forKey:@"state"];
        
    
//    NSLog(@"----%@===url==%@",params,url);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
//        NSLog(@"%@", result);
        NSArray *resuArr = result;
        
       
            
            [self.sure_A removeAllObjects];
            [self.confuse_A removeAllObjects];
            
        
        for (NSDictionary *dic in resuArr) {
            
            
            if ([dic[@"state"] isEqualToString:@"access"]) {
                [self.sure_A addObject:dic];
            }
            
            if ([dic[@"state"] isEqualToString:@"fail"]) {
                [self.confuse_A addObject:dic];
                
            }
            
            
        }
        
        for (int i=0; i<3; i++) {
            UIButton*button=(UIButton *)[topBackView viewWithTag:666+i];
            NSString *title_S;
            if (i==0) {
                title_S = [NSString stringWithFormat:@"待确认(%lu)",(unsigned long)self.wait_A.count];
            }
            if (i==1) {
                title_S = [NSString stringWithFormat:@"已确认(%lu)",(unsigned long)self.sure_A.count];
            }
            
            if (i==2) {
                title_S = [NSString stringWithFormat:@"已拒绝(%lu)",(unsigned long)self.confuse_A.count];
            }
            
            
            [button setTitle:title_S forState:UIControlStateNormal];
            
            
            
        }
        
        
        
        [self.myTableView reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请求出错,请重新请求", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:4.f];
        
    }];
    
}

-(NSDictionary *)dead_dic{
    if (!_dead_dic) {
        _dead_dic = @{@"半年":@"0.5",@"一年":@"1",@"两年":@"2",@"三年":@"3",@"无限期":@"0"};
    }
    
    return _dead_dic;
}

@end
