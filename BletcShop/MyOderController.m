//
//  MyOderController.m
//  BletcShop
//
//  Created by Yuan on 16/1/26.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MyOderController.h"
#import "MyOrderDetailVC.h"

@interface MyOderController ()

@end

@implementation MyOderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的消费";
    self.orderArray = [[NSMutableArray alloc]init];
    [self postRequstOrderInfo];
    // Do any additional setup after loading the view.
}
//获取消费记录
-(void)postRequstOrderInfo
{

    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/cnGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result%@", result);
         NSArray *arr = [result copy];
         self.orderArray = [arr copy];
         [self initTableView];

         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    
}

-(void)initTableView
{
    self.myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    [self.view addSubview:self.myTableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.waitArray.count;
    
    return self.orderArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;
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
    UILabel *contentlab = [[UILabel alloc]initWithFrame:CGRectMake(23, 10, SCREENWIDTH-100, 16)];
    contentlab.text = [[[self.orderArray objectAtIndex:indexPath.row] objectForKey:@"content"]componentsSeparatedByString:PAY_USCS][0];
    contentlab.textColor = RGB(51,51,51);
    contentlab.textAlignment = NSTextAlignmentLeft;
    contentlab.font = [UIFont systemFontOfSize:17];
    [cell addSubview:contentlab];
    
    UILabel *stateLab = [[UILabel alloc]initWithFrame:CGRectMake(23, contentlab.bottom+15, 100, 14)];
    stateLab.text = @"支付成功";
    stateLab.textColor = RGB(102,102,102);
    stateLab.textAlignment = NSTextAlignmentLeft;
    stateLab.font = [UIFont systemFontOfSize:15];
    stateLab.tag = 1000;
    [cell addSubview:stateLab];
    
    
    UILabel *timelab = [[UILabel alloc]initWithFrame:CGRectMake(23, stateLab.bottom+11, SCREENWIDTH-110, 12)];
    

    timelab.text = [[self.orderArray objectAtIndex:indexPath.row] objectForKey:@"datetime"];
    timelab.textColor = RGB(153,153,153);
    
    timelab.textAlignment = NSTextAlignmentLeft;
    timelab.font = [UIFont systemFontOfSize:15];
    [cell addSubview:timelab];
    
    
    UILabel *dateLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(95, 12, SCREENWIDTH-95-23, 18)];

    dateLabel1.textColor = RGB(51,51,51);
    dateLabel1.textAlignment = NSTextAlignmentRight;
    dateLabel1.font = [UIFont systemFontOfSize:23];
    [cell addSubview:dateLabel1];
    
    NSString *string = [[[[self.orderArray objectAtIndex:indexPath.row] objectForKey:@"content"] componentsSeparatedByString:PAY_USCS] lastObject];

    if ([[string substringToIndex:4] isEqualToString:@"结算次数"]||[[string substringToIndex:4] isEqualToString:@"消费次数"]) {
        
        NSArray *arr = [NSArray array];
        arr= [string componentsSeparatedByString:PAY_UORC];
        for (NSString *stri in arr) {
            
            NSString *price = [[stri componentsSeparatedByString:PAY_NP]lastObject];
          price =  [[price componentsSeparatedByString:@"次"]firstObject];
            string = [NSString stringWithFormat:@"%d次",[string intValue]+[price intValue]];
            
        }
        
    }else{
        
        NSArray *arr = [NSArray array];

        arr= [string componentsSeparatedByString:PAY_UORC];
        for (NSString *stri in arr) {
            NSString *price = [[stri componentsSeparatedByString:PAY_NP]lastObject];
            price =  [[price componentsSeparatedByString:@"元"]firstObject];

            string = [NSString stringWithFormat:@"%.2f元",[string floatValue]+[price floatValue]];
            
        }

    }
    
    
    dateLabel1.text = string;


    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 87-1, SCREENWIDTH, 1)];
    lineview.backgroundColor = RGB(234,234,234);
    [cell addSubview:lineview];
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:
    (NSIndexPath *)indexPath{
    
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        self.selectRow = indexPath.row;
        [self postRequstOrderDelete];

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *pay_tp;

    
    NSString *string = [[[[self.orderArray objectAtIndex:indexPath.row] objectForKey:@"content"] componentsSeparatedByString:PAY_USCS] lastObject];
    
    if ([[string substringToIndex:4] isEqualToString:@"结算次数"]||[[string substringToIndex:4] isEqualToString:@"消费次数"]) {
        pay_tp = @"计次数量";
        NSArray *arr = [NSArray array];
        arr= [string componentsSeparatedByString:PAY_UORC];
        for (NSString *stri in arr) {
            
            NSString *price = [[stri componentsSeparatedByString:PAY_NP]lastObject];
            price =  [[price componentsSeparatedByString:@"次"]firstObject];
            string = [NSString stringWithFormat:@"%d次",[string intValue]+[price intValue]];
        
            
        }
        
    }else{
        pay_tp = @"付款金额";

        NSArray *arr = [NSArray array];
        
        arr= [string componentsSeparatedByString:PAY_UORC];
        for (NSString *stri in arr) {
            NSString *price = [[stri componentsSeparatedByString:PAY_NP]lastObject];
            price =  [[price componentsSeparatedByString:@"元"]firstObject];
            
            string = [NSString stringWithFormat:@"%.2f元",[string floatValue]+[price floatValue]];
            
        }
        
    }

    MyOrderDetailVC *VC  = [[MyOrderDetailVC alloc]init];
    VC.order_dic = [self.orderArray objectAtIndex:indexPath.row];
    VC.allPay = string;
    VC.pay_type_s = pay_tp;
    
    [self.navigationController pushViewController:VC animated:YES];
    
//    self.selectRow = indexPath.row;
//    [self NewAlertView];
    
    
    
}
-(void)NewAlertView
{

    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];

    alertView.parentView = self.view;

    [alertView setContainerView:[self createDemoView]];
    

    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"删除", @"取消", nil]];
    [alertView setDelegate:self];
    

    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {

        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    

    [alertView show];
}


- (UIView *)createDemoView
{
    NSArray *infoArray = [NSArray array];
    
       NSDictionary *dic = [self.orderArray objectAtIndex:self.selectRow];
    
    NSLog(@"dic--_%@",dic);
    UIView *demoView = [[UIView alloc] init];
    if([dic[@"content"] rangeOfString:PAY_UORC].location !=NSNotFound)//_roaldSearchText
    {
        NSString *string = [[dic[@"content"] componentsSeparatedByString:PAY_USCS] lastObject];
        
        
        infoArray=[string componentsSeparatedByString:PAY_UORC];//根据su拆分成多个字符串
    }
    else
    {
        if([dic[@"content"] rangeOfString:PAY_NP].location !=NSNotFound)
        {
            //            self.payMoney = 0.0;
            demoView.frame =CGRectMake(0, 0, SCREENWIDTH, 200);
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
            
            label.text = @"订单支付凭证";
            //self.payShopName = [[infoArrayOr objectAtIndex:1] substringToIndex:range.location];
            //label.text = @"修改昵称";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:13];
            [demoView addSubview:label];
            UILabel *labelShop = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 80, 40)];
            labelShop.text = @"商家:";
            labelShop.textAlignment = NSTextAlignmentLeft;
            labelShop.font = [UIFont boldSystemFontOfSize:13];
            [demoView addSubview:labelShop];
            UILabel *shopNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, SCREENWIDTH-120, 40)];

            shopNameLabel.text = [dic[@"content"] componentsSeparatedByString:PAY_USCS][0];

            shopNameLabel.textAlignment = NSTextAlignmentRight;
            shopNameLabel.font = [UIFont boldSystemFontOfSize:13];
            [demoView addSubview:shopNameLabel];
            
            UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 80, 40)];
            label1.textAlignment = NSTextAlignmentLeft;
            label1.font = [UIFont boldSystemFontOfSize:13];
            
            [demoView addSubview:label1];
          
            NSString *shop_str = [[dic[@"content"]componentsSeparatedByString:PAY_USCS]lastObject];
            
            
            UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 80, SCREENWIDTH-120, 40)];
            priceLabel.textAlignment = NSTextAlignmentRight;
            priceLabel.font = [UIFont boldSystemFontOfSize:13];
            [demoView addSubview:priceLabel];

            //NSRange end = [[infoArray objectAtIndex:i] rangeOfString:@"s"];
            priceLabel.text = [[shop_str componentsSeparatedByString:PAY_NP] lastObject];
            
            label1.text = [[shop_str componentsSeparatedByString:PAY_NP] firstObject];

            //NSRange pend = [priceLabel.text rangeOfString:@"元"];
           // NSString *priceAll =[priceLabel.text substringToIndex:pend.location];
            //self.payMoney = [priceAll floatValue];
            //NSLog(@"WWWWWWWWWW%@",priceAll);
            //日期时间
            UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, 80, 40)];
            labelTime.text = @"时间:";
            labelTime.textAlignment = NSTextAlignmentLeft;
            labelTime.font = [UIFont boldSystemFontOfSize:13];
            [demoView addSubview:labelTime];
            UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 120, SCREENWIDTH-120, 40)];
            
            timeLabel.text = dic[@"datetime"] ;
            //self.payShopName = [[infoArrayOr objectAtIndex:1] substringToIndex:range.location];
            //label.text = @"修改昵称";
            timeLabel.textAlignment = NSTextAlignmentRight;
            timeLabel.font = [UIFont boldSystemFontOfSize:13];
            [demoView addSubview:timeLabel];
            //状态
            UILabel *labelState = [[UILabel alloc]initWithFrame:CGRectMake(20, 160, 80, 40)];
            labelState.text = @"状态:";
            labelState.textAlignment = NSTextAlignmentLeft;
            labelState.font = [UIFont boldSystemFontOfSize:13];
            [demoView addSubview:labelState];
            UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 160, SCREENWIDTH-120, 40)];
            
            stateLabel.text = @"已完成" ;
            stateLabel.textColor = [UIColor greenColor];
            //self.payShopName = [[infoArrayOr objectAtIndex:1] substringToIndex:range.location];
            //label.text = @"修改昵称";
            stateLabel.textAlignment = NSTextAlignmentRight;
            stateLabel.font = [UIFont boldSystemFontOfSize:13];
            [demoView addSubview:stateLabel];
            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 0.3)];
            line1.backgroundColor = [UIColor grayColor];
            line1.alpha = 0.3;
            [demoView addSubview:line1];
            UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 80, SCREENWIDTH, 0.3)];
            line2.backgroundColor = [UIColor grayColor];
            line2.alpha = 0.3;
            [demoView addSubview:line2];
            UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREENWIDTH, 0.3)];
            line3.backgroundColor = [UIColor grayColor];
            line3.alpha = 0.3;
            [demoView addSubview:line3];
            UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 160, SCREENWIDTH, 0.3)];
            line4.backgroundColor = [UIColor grayColor];
            line4.alpha = 0.3;
            [demoView addSubview:line4];
        }
    }
    
    if (infoArray.count>0) {
        //self.payMoney = 0.0;
        demoView.frame =CGRectMake(0, 0, SCREENWIDTH, 40*(infoArray.count+4));
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
        
        label.text = @"订单支付凭证";
        //self.payShopName = [[infoArrayOr objectAtIndex:1] substringToIndex:range.location];
        //label.text = @"修改昵称";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:label];
        UILabel *labelShop = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 80, 40)];
        labelShop.text = @"商家:";
        labelShop.textAlignment = NSTextAlignmentLeft;
        labelShop.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:labelShop];
        UILabel *shopNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, SCREENWIDTH-120, 40)];

        shopNameLabel.text = [[dic[@"content"]componentsSeparatedByString:PAY_USCS]firstObject];

        //label.text = @"修改昵称";
        shopNameLabel.textAlignment = NSTextAlignmentRight;
        shopNameLabel.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:shopNameLabel];
        //NSString *allPrice = [[NSString alloc]init];
        
        for(int i=0; i<infoArray.count; i++) {
            //获取每个数组里的项目和价格-(项目sm价格)
            
            {
                NSString *string = infoArray[i];//项目sm价格
                
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 40*(i+2), 80, 40)];

                label.text = [[string componentsSeparatedByString:PAY_NP] firstObject];
                label.textAlignment = NSTextAlignmentLeft;
                label.font = [UIFont boldSystemFontOfSize:13];
                [demoView addSubview:label];
                UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 40*(i+2), SCREENWIDTH-120, 40)];
                priceLabel.textAlignment = NSTextAlignmentRight;
                priceLabel.font = [UIFont boldSystemFontOfSize:13];
                [demoView addSubview:priceLabel];


                priceLabel.text = [[string componentsSeparatedByString:PAY_NP] lastObject];

                
                UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40*(i+2),SCREENWIDTH, 0.3)];
                line1.backgroundColor = [UIColor grayColor];
                line1.alpha = 0.3;
                [demoView addSubview:line1];
            }
            //self.payMoney = self.payMoney+=[allPrice floatValue];
            
        }
        //日期时间
        UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(20, 40*(infoArray.count+2), 80, 40)];
        labelTime.text = @"时间:";
        labelTime.textAlignment = NSTextAlignmentLeft;
        labelTime.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:labelTime];
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 40*(infoArray.count+2), SCREENWIDTH-120, 40)];
        
        timeLabel.text = dic[@"datetime"] ;
        //label.text = @"修改昵称";
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:timeLabel];
        //状态
        UILabel *labelState = [[UILabel alloc]initWithFrame:CGRectMake(20, 40*(infoArray.count+3), 80, 40)];
        labelState.text = @"状态:";
        labelState.textAlignment = NSTextAlignmentLeft;
        labelState.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:labelState];
        UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 40*(infoArray.count+3), SCREENWIDTH-120, 40)];
        
        stateLabel.text = @"已完成" ;
        stateLabel.textColor = [UIColor greenColor];
        //self.payShopName = [[infoArrayOr objectAtIndex:1] substringToIndex:range.location];
        //label.text = @"修改昵称";
        stateLabel.textAlignment = NSTextAlignmentRight;
        stateLabel.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:stateLabel];
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 40*(infoArray.count+2), SCREENWIDTH, 0.3)];
        line3.backgroundColor = [UIColor grayColor];
        line3.alpha = 0.3;
        [demoView addSubview:line3];
        UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 40*(infoArray.count+3), SCREENWIDTH, 0.3)];
        line4.backgroundColor = [UIColor grayColor];
        line4.alpha = 0.3;
        [demoView addSubview:line4];
        
    }
    //NSLog(@"zzzzzzzzzzzzzzzzz%f",self.payMoney);
    return demoView;
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (alertView.tag==0&&buttonIndex==1) {
        [alertView close];
    }
    else if (alertView.tag==0&&buttonIndex==0)
    {
        [alertView close];
        [self postRequstOrderDelete];
        
    }
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
}
-(void)postRequstOrderDelete
{

    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/cnDel",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:[[self.orderArray objectAtIndex:self.selectRow] objectForKey:@"datetime"] forKey:@"datetime"];

    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result%@", result);
         if ([result[@"result_code"] intValue]==1) {
             [self postRequstOrderInfo];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
