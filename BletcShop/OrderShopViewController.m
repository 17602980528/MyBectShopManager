//
//  OrderShopViewController.m
//  BletcShop
//
//  Created by Bletc on 16/5/6.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "OrderShopViewController.h"

@interface OrderShopViewController ()

@end

@implementation OrderShopViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self postRequestDelay];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"预约处理";

    self.waitArray = [[NSMutableArray alloc]init];
    self.overArray = [[NSMutableArray alloc]init];
    self.selectRow = 0;
    self.selectTag=0;
    [self _initUI];

}
-(void)_initUI
{
    NSArray *array=@[@"待处理",@"已处理"];
    UISegmentedControl *segmentControl=[[UISegmentedControl alloc]initWithItems:array];
    segmentControl.segmentedControlStyle=UISegmentedControlStyleBordered;
    //设置位置 大小
    segmentControl.frame=CGRectMake(0, 10, SCREENWIDTH, 70);
    //默认选择
    segmentControl.selectedSegmentIndex=0;
    //设置背景色
    segmentControl.backgroundColor = [UIColor grayColor];
    segmentControl.tintColor=[UIColor colorWithRed:82.0f/255.0f green:206.0f/255.0f blue:165.f/255.0f alpha:1.0f];;
    self.segmentControl = segmentControl;
    
    [self.segmentControl addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmentControl];
    self.myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 90, SCREENWIDTH, SCREENHEIGHT-90-64)];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    [self.view addSubview:self.myTableView];
    //    UIButton  *oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    oneBtn.frame = CGRectMake(0, 5, self.view.width/2, 80);
    //    oneBtn.backgroundColor = [UIColor orangeColor];
    //    [oneBtn setTitle:@"已管理店铺" forState:UIControlStateNormal];
    //    [BjSc addSubview:oneBtn];
    //
    //    UIButton *twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    twoBtn.frame = CGRectMake(self.view.width/2, 5, self.view.width/2, 80);
    //    twoBtn.backgroundColor = [UIColor colorWithRed:82.0f/255.0f green:206.0f/255.0f blue:165.f/255.0f alpha:1.0f];
    //    [twoBtn setTitle:@"申请管理店铺" forState:UIControlStateNormal];
    //    [BjSc addSubview:twoBtn];
    
}
-(void)postRequestDelay
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/appoint/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"]  forKey:@"muid"];
    if (self.segmentControl.selectedSegmentIndex==0) {
        [params setObject:@"null" forKey:@"state"];
    }else if (self.segmentControl.selectedSegmentIndex==1) {
        [params setObject:@"access" forKey:@"state"];
    }
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        NSArray *resuArr = result;
       
        if (self.segmentControl.selectedSegmentIndex==0) {
            self.waitArray = [resuArr copy];
        }else if (self.segmentControl.selectedSegmentIndex==1) {
            self.overArray = [resuArr copy];
        }
        [self.myTableView reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请求出错,请重新请求", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)valueChange:(id)sender
{
    [self postRequestDelay];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.waitArray.count;
    if (self.segmentControl.selectedSegmentIndex ==0 ){
        return self.waitArray.count;
    }
    else if(self.segmentControl.selectedSegmentIndex ==1)
    {
        return self.overArray.count;
    }
    else
        return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    // 定义唯一标识
    // 通过indexPath创建cell实例 每一个cell都是单独的
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    NSMutableArray *muta_array;
    
    if (self.segmentControl.selectedSegmentIndex ==0) {
        muta_array =self.waitArray;
        
        
    }else if (self.segmentControl.selectedSegmentIndex ==1) {
      

        muta_array = self.overArray;
    
    }
    
    UILabel *huiyuanLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 40, 30)];
    huiyuanLabel.text = @"时间:";
    huiyuanLabel.font = [UIFont systemFontOfSize:12];
    huiyuanLabel.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:huiyuanLabel];
    
    UILabel *huiyuanText = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, SCREENWIDTH/2-60, 30)];
    NSString *time = [[NSString alloc]initWithFormat:@"%@ %@",[[muta_array objectAtIndex:indexPath.row] objectForKey:@"date"],[[muta_array objectAtIndex:indexPath.row] objectForKey:@"time"]];
    huiyuanText.text = time;;
    huiyuanText.textAlignment = NSTextAlignmentLeft;
    huiyuanText.font = [UIFont systemFontOfSize:11];
    [cell addSubview:huiyuanText];
    UILabel *cardNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+20, 5, 40, 30)];
    cardNumLabel.text = @"预约:";
    cardNumLabel.textAlignment = NSTextAlignmentLeft;
    cardNumLabel.font = [UIFont systemFontOfSize:12];
    [cell addSubview:cardNumLabel];
    UILabel *cardNumText = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+60, 5, SCREENWIDTH/2-100, 30)];
    cardNumText.textAlignment = NSTextAlignmentLeft;
    cardNumText.text = [[muta_array objectAtIndex:indexPath.row] objectForKey:@"content"];
    cardNumText.font = [UIFont systemFontOfSize:12];
    [cell addSubview:cardNumText];
    UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 45, 40, 30)];
    levelLabel.text = @"会员:";
    levelLabel.font = [UIFont systemFontOfSize:12];
    levelLabel.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:levelLabel];
    
    UILabel *levelText = [[UILabel alloc]initWithFrame:CGRectMake(60, 45, SCREENWIDTH/2-100, 30)];
    levelText.text = [[muta_array objectAtIndex:indexPath.row] objectForKey:@"name"];
    levelText.textAlignment = NSTextAlignmentLeft;
    levelText.font = [UIFont systemFontOfSize:12];
    [cell addSubview:levelText];
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+20, 45, 40, 30)];
    typeLabel.text = @"手机:";
    typeLabel.textAlignment = NSTextAlignmentLeft;
    typeLabel.font = [UIFont systemFontOfSize:12];
    [cell addSubview:typeLabel];
    UILabel *typeText = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+60, 45, SCREENWIDTH/2-100, 30)];
    typeText.textAlignment = NSTextAlignmentLeft;
    typeText.text = [[muta_array objectAtIndex:indexPath.row] objectForKey:@"phone"];
    typeText.font = [UIFont systemFontOfSize:12];
    [cell addSubview:typeText];

    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 79, SCREENWIDTH, 1)];
    lineview.backgroundColor = [UIColor grayColor];
    [cell addSubview:lineview];
    return cell;
}
-(void)selectAction
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    alertView.backgroundColor = [UIColor whiteColor];
    self.alertView = alertView;
    [alertView setContainerView:[self createDemoView]];
    
    if (self.segmentControl.selectedSegmentIndex ==0) {
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"通过申请", @"驳回申请",@"返回", nil]];
    }
    else{
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"返回",nil]];
    }
    [alertView setDelegate:self];
    
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    [alertView show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (self.segmentControl.selectedSegmentIndex==0) {
        if (alertView.tag==0&&buttonIndex==0) {
            self.selectTag = 1;
            [self postRequestAccess];
        }else if (alertView.tag==0&&buttonIndex==1) {
            self.selectTag = 2;
            [self postRequestAccess];
        }
        
    }
    
    [alertView close];
}
-(void)postRequestAccess
{

    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/appoint/stateSet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[[self.waitArray objectAtIndex:self.selectRow] objectForKey:@"merchant"] forKey:@"muid"];
    [params setObject:[[self.waitArray objectAtIndex:self.selectRow] objectForKey:@"user"] forKey:@"uuid"];
    [params setObject:[[self.waitArray objectAtIndex:self.selectRow] objectForKey:@"date"] forKey:@"date"];
    [params setObject:[[self.waitArray objectAtIndex:self.selectRow] objectForKey:@"time"] forKey:@"time"];
    if (self.selectTag == 1) {
        [params setObject:@"access" forKey:@"state"];
    }else if (self.selectTag == 2) {
        [params setObject:@"fail" forKey:@"state"];
    }
    
       [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        if ([result[@"result_code"] intValue]==1)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"设置成功", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            // Move to bottm center.
            //    hud.offset = CGPointMake(0.f, );
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:3.f];
            [self postRequestDelay];
            [self.myTableView reloadData];
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
            [hud hideAnimated:YES afterDelay:3.f];
        }
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"添加出错,请重新添加", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }];
    
}

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] init];
    demoView.backgroundColor = [UIColor whiteColor];
    if(self.segmentControl.selectedSegmentIndex==0)
    {
        demoView.frame = CGRectMake(0, 0, 280, 250);
    }
    else
        demoView.frame = CGRectMake(0, 0, 280, 290);
    self.demoView = demoView;
    //上线日期
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, demoView.width-60, 40)];
    titleLabel.text = @"预约申请处理";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    //titleLabel.font = [UIFont systemFontOfSize:14];
    [demoView addSubview:titleLabel];
    UIView *lineTitle = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
    lineTitle.backgroundColor = [UIColor grayColor];
    lineTitle.alpha = 0.3;
    [demoView addSubview:lineTitle];
    NSString *huiyuan = [[NSString alloc]initWithFormat:@"会员: "];
    NSString *twoString =[[NSString alloc]init];
    if (self.segmentControl.selectedSegmentIndex==0) {
        twoString = [huiyuan stringByAppendingString:[[self.waitArray objectAtIndex:self.selectRow] objectForKey:@"name"]];
    }else if (self.segmentControl.selectedSegmentIndex==1) {
        twoString = [huiyuan stringByAppendingString:[[self.overArray objectAtIndex:self.selectRow] objectForKey:@"name"]];
    }
    //会员
    UILabel *vipLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 55, demoView.width-60, 30)];
    vipLabel.text = twoString;
    vipLabel.textAlignment = NSTextAlignmentCenter;
    //vipLabel.font = [UIFont boldSystemFontOfSize:15];
    vipLabel.font = [UIFont systemFontOfSize:15];
    [demoView addSubview:vipLabel];
    UIView *lineVip = [[UIView alloc]initWithFrame:CGRectMake(0, 90, SCREENWIDTH, 0.3)];
    lineVip.backgroundColor = [UIColor grayColor];
    lineVip.alpha = 0.3;
    [demoView addSubview:lineVip];
    //卡片编号
    NSString *cardNum = [[NSString alloc]initWithFormat:@"手机号: "];
    NSString *threeString =[[NSString alloc]init];
    if (self.segmentControl.selectedSegmentIndex==0) {
        threeString = [cardNum stringByAppendingString:[[self.waitArray objectAtIndex:self.selectRow] objectForKey:@"phone"]];
    }else if (self.segmentControl.selectedSegmentIndex==1) {
        threeString = [cardNum stringByAppendingString:[[self.overArray objectAtIndex:self.selectRow] objectForKey:@"phone"]];
    
    }
    //
    UILabel *cardNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 95, demoView.width-60, 30)];
    cardNumLabel.text = threeString;
    cardNumLabel.textAlignment = NSTextAlignmentCenter;
    //vipLabel.font = [UIFont boldSystemFontOfSize:15];
    cardNumLabel.font = [UIFont systemFontOfSize:15];
    [demoView addSubview:cardNumLabel];
    UIView *lineNum = [[UIView alloc]initWithFrame:CGRectMake(0, 130, SCREENWIDTH, 0.3)];
    lineNum.backgroundColor = [UIColor grayColor];
    lineNum.alpha = 0.3;
    [demoView addSubview:lineNum];
    //卡片级别
    NSString *cardLevel = [[NSString alloc]initWithFormat:@"日期: "];
    NSString *fourString =[[NSString alloc]init];
    if (self.segmentControl.selectedSegmentIndex==0) {
        fourString = [cardLevel stringByAppendingString:[[self.waitArray objectAtIndex:self.selectRow] objectForKey:@"date"]];
    }else if (self.segmentControl.selectedSegmentIndex==1) {
        fourString = [cardLevel stringByAppendingString:[[self.overArray objectAtIndex:self.selectRow] objectForKey:@"date"]];
    }
    //卡片级别
    UILabel *cardLevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 135, demoView.width-60, 30)];
    cardLevelLabel.text = fourString;
    cardLevelLabel.textAlignment = NSTextAlignmentCenter;
    //vipLabel.font = [UIFont boldSystemFontOfSize:15];
    cardLevelLabel.font = [UIFont systemFontOfSize:15];
    [demoView addSubview:cardLevelLabel];
    UIView *lineLevel = [[UIView alloc]initWithFrame:CGRectMake(0, 170, SCREENWIDTH, 0.3)];
    lineLevel.backgroundColor = [UIColor grayColor];
    lineLevel.alpha = 0.3;
    [demoView addSubview:lineLevel];
    //卡片类型
    NSString *cardType = [[NSString alloc]initWithFormat:@"时间: "];
    NSString *fiveString =[[NSString alloc]init];
    if (self.segmentControl.selectedSegmentIndex==0) {
        fiveString = [cardType stringByAppendingString:[[self.waitArray objectAtIndex:self.selectRow] objectForKey:@"time"]];
    }else if (self.segmentControl.selectedSegmentIndex==1) {
        fiveString = [cardType stringByAppendingString:[[self.overArray objectAtIndex:self.selectRow] objectForKey:@"time"]];
    }
    //
    UILabel *cardTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 175, demoView.width-60, 30)];
    cardTypeLabel.text = fiveString;
    cardTypeLabel.textAlignment = NSTextAlignmentCenter;
    //vipLabel.font = [UIFont boldSystemFontOfSize:15];
    cardTypeLabel.font = [UIFont systemFontOfSize:15];
    [demoView addSubview:cardTypeLabel];
    UIView *lineType = [[UIView alloc]initWithFrame:CGRectMake(0, 210, SCREENWIDTH, 0.3)];
    lineType.backgroundColor = [UIColor grayColor];
    lineType.alpha = 0.3;
    [demoView addSubview:lineType];
    //开始日期
    NSString *startDate = [[NSString alloc]initWithFormat:@"预约内容: "];
    NSString *sixString =[[NSString alloc]init];
    if (self.segmentControl.selectedSegmentIndex==0) {
        sixString = [startDate stringByAppendingString:[[self.waitArray objectAtIndex:self.selectRow] objectForKey:@"content"]];
    }else if (self.segmentControl.selectedSegmentIndex==1) {
        sixString = [startDate stringByAppendingString:[[self.overArray objectAtIndex:self.selectRow]objectForKey:@"content"]];
    }
    //
    UILabel *startDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 215, demoView.width-60, 30)];
    startDateLabel.text = sixString;
    startDateLabel.textAlignment = NSTextAlignmentCenter;
    startDateLabel.font = [UIFont systemFontOfSize:15];
    [demoView addSubview:startDateLabel];
    UIView *linestartDate = [[UIView alloc]initWithFrame:CGRectMake(0, 250, SCREENWIDTH, 0.3)];
    linestartDate.backgroundColor = [UIColor grayColor];
    linestartDate.alpha = 0.3;
    [demoView addSubview:linestartDate];
//    //结束日期
//    NSString *endDate = [[NSString alloc]initWithFormat:@"结束日期: "];
//    NSString *sevenString =[[NSString alloc]init];
//    if (self.segmentControl.selectedSegmentIndex==0) {
//        sevenString = [endDate stringByAppendingString:[[self.waitArray objectAtIndex:self.selectRow] objectAtIndex:6]];
//    }else if (self.segmentControl.selectedSegmentIndex==1) {
//        sevenString = [endDate stringByAppendingString:[[self.overArray objectAtIndex:self.selectRow] objectAtIndex:6]];
//    }
//    //
//    UILabel *endDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 255, demoView.width-60, 30)];
//    endDateLabel.text = sevenString;
//    endDateLabel.textAlignment = NSTextAlignmentCenter;
//    //vipLabel.font = [UIFont boldSystemFontOfSize:15];
//    endDateLabel.font = [UIFont systemFontOfSize:15];
//    [demoView addSubview:endDateLabel];
    if (self.segmentControl.selectedSegmentIndex ==1) {
        UIView *lineendDate = [[UIView alloc]initWithFrame:CGRectMake(0, 250, SCREENWIDTH, 0.3)];
        lineendDate.backgroundColor = [UIColor grayColor];
        lineendDate.alpha = 0.3;
        [demoView addSubview:lineendDate];
        //审批状态
        NSString *stateString = [[NSString alloc]initWithFormat:@"审批状态: "];
        NSString *eightString =[[NSString alloc]init];
        NSString *String =[[NSString alloc]init];
        if ([[[self.overArray objectAtIndex:self.selectRow] objectForKey:@"state"] isEqualToString:@"access"])
        {
            String = @"已通过";
        }else if ([[[self.overArray objectAtIndex:self.selectRow] objectForKey:@"state"] isEqualToString:@"fail"])
        {
            String = @"被驳回";
        }
        eightString = [stateString stringByAppendingString:String];
        //
        UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 255, demoView.width-60, 30)];
        stateLabel.text = eightString;
        stateLabel.textAlignment = NSTextAlignmentCenter;
        //vipLabel.font = [UIFont boldSystemFontOfSize:15];
        stateLabel.font = [UIFont systemFontOfSize:15];
        stateLabel.textColor = [UIColor greenColor];
        [demoView addSubview:stateLabel];
        
    }
    
    //
    //        UIView *lineLevel = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
    //        lineLevel.backgroundColor = [UIColor grayColor];
    //        lineLevel.alpha = 0.3;
    //        [demoView addSubview:lineLevel];
    //        UIView *lineLevel22 = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 0.3)];
    //        lineLevel22.backgroundColor = [UIColor grayColor];
    //        lineLevel22.alpha = 0.3;
    //        [demoView addSubview:lineLevel22];
    //        //在线时间
    //        UILabel *zaixianLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 160, 50, 30)];
    //        zaixianLabel.text = @"在线时间";
    //        zaixianLabel.font = [UIFont systemFontOfSize:10];
    //        [demoView addSubview:zaixianLabel];
    //
    //        UIView *lineLevel33 = [[UIView alloc]initWithFrame:CGRectMake(0, 150, SCREENWIDTH, 0.3)];
    //        lineLevel33.backgroundColor = [UIColor grayColor];
    //        lineLevel33.alpha = 0.3;
    //        [demoView addSubview:lineLevel33];
    //        UIView *lineLevel11 = [[UIView alloc]initWithFrame:CGRectMake(0, 200, SCREENWIDTH, 0.3)];
    //        lineLevel11.backgroundColor = [UIColor grayColor];
    //        lineLevel11.alpha = 0.3;
    //        [demoView addSubview:lineLevel11];
    //        UILabel *imageLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 210, 50, 30)];
    //        imageLabel.text = @"内容";
    //        imageLabel.font = [UIFont systemFontOfSize:10];
    //        [demoView addSubview:imageLabel];
    
    
    return demoView;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectRow = indexPath.row;
    [self selectAction];
    
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
