//
//  UpgradeViewController.m
//  BletcShop
//
//  Created by Bletc on 16/4/13.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "UpgradeViewController.h"
#import "CardManagerViewController.h"
#import "OrderInfomaViewController.h"//订单详情
@interface UpgradeViewController ()

@end

@implementation UpgradeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.cha = 0.0;
    self.title = @"我要升级";
    self.pickArray = [[NSMutableArray alloc]init];
    self.otherArray = [[NSMutableArray alloc]init];
    [self.pickArray addObject:@"请选择"];
    _ifCard = NO;
    NSLog(@"%@",self.resultArray);
    
    if (self.resultArray.count>0) {
        for (int i=0; i<self.resultArray.count; i++) {
            if ([self.card_dic[@"card_level"] isEqualToString:[self.resultArray objectAtIndex:i][@"level"]]) {
                
                self.cardNow_dic = [self.resultArray objectAtIndex:i];
            }
        }
    }
    NSString *price = [[NSString alloc]init];
    if (![self.cardNow_dic[@"price"] isEqualToString:@""]) {
        
        price = self.cardNow_dic[@"price"];
        
        NSLog(@"price:%@",price);
    }
    
    for (int i=0; i<self.resultArray.count; i++) {
        
       
        NSString* price1 = [self.resultArray objectAtIndex:i][@"price"];
        if ([price1 floatValue]>[price floatValue]) {
            [self.pickArray addObject:[[self.resultArray objectAtIndex:i] objectForKey:@"level"]];
            [self.otherArray addObject:[self.resultArray objectAtIndex:i]];
            
        }
        NSLog(@"price1:%@",price1);
    }
    if (self.pickArray.count==1)
    {
        if([[UIDevice currentDevice].systemVersion floatValue]>=8.0)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的卡已是最高级别!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self.navigationController popViewControllerAnimated:YES];
                // 回调在block里面
                // to do..
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"您的卡已是最高级别！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }

    }
    self.cardType = self.card_dic[@"card_level"];
    self.adviceString = [[NSString alloc]initWithFormat:@"您当前卡级别为%@,请选择将要升级的卡",self.cardType ];
    NSLog(@"%@",self.pickArray);
    //self.pickArray = @[@"金卡",@"白金卡",@"钻卡"];
    [self _inittable];

}
-(void)_inittable
{
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.rowHeight = 104;
    table.bounces = NO;
    table.tag = 1001;
    self.myTable = table;
    [self.view addSubview:table];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1001) {
        return 60;
    }
    else
        return 30;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag==1001) {
        return 20;
    }else
        return 0.01;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    // 定义唯一标识
    // 通过indexPath创建cell实例 每一个cell都是单独的
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (tableView.tag==1001) {
        if (indexPath.row==0) {
            UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 70, 30)];
            moneyLabel.font = [UIFont systemFontOfSize:13];
            moneyLabel.text = @"卡片升级:";
            [cell addSubview:moneyLabel];
            UILabel *cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 70, 20)];
            self.cardLable = cardLabel;
            cardLabel.font = [UIFont systemFontOfSize:13];
            [cardLabel setTextAlignment:NSTextAlignmentCenter];
          
                cardLabel.text = self.cardType;
            
            cardLabel.layer.borderWidth = 1;
            
            [cell addSubview:cardLabel];
            UIButton *CreatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            CreatBtn.frame = CGRectMake(170, 20, 20, 20);
            [CreatBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
            [CreatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [CreatBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            CreatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [CreatBtn setBackgroundColor:[UIColor grayColor]];
            
            [CreatBtn addTarget:self action:@selector(choiceCard) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:CreatBtn];
            UITextView *aView = [[UITextView alloc]initWithFrame:CGRectMake(200, 5, SCREENWIDTH-220, 50)];
            self.adviceText = aView;
            aView.editable = NO;
            aView.text = self.adviceString;
            [cell addSubview:aView];
            
        }
        else if(indexPath.row ==1)
        {
            UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 70, 30)];
            moneyLabel.font = [UIFont systemFontOfSize:13];
            moneyLabel.text = @"充值金额:";
            [cell addSubview:moneyLabel];
            UILabel *moneyText = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, SCREENWIDTH-130, 30)];
//            moneyText.placeholder = @"0";
//            moneyText.delegate = self;
//            moneyText.keyboardType=UIKeyboardTypeNumberPad;
            moneyText.backgroundColor = tableViewBackgroundColor;
            moneyText.layer.borderWidth=1;
            self.moneyText = moneyText;
            moneyText.text =[[NSString alloc]initWithFormat:@"%.2f",self.cha];
            [cell addSubview:moneyText];
            
        }else if (indexPath.row==2)
        {
            UIButton *CreatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            CreatBtn.frame = CGRectMake(80, 10, SCREENWIDTH-160, 40);
            [CreatBtn setTitle:@"确定" forState:UIControlStateNormal];
            [CreatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [CreatBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            CreatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [CreatBtn setBackgroundColor:[UIColor colorWithRed:82.0f/255.0f green:206.0f/255.0f blue:165.f/255.0f alpha:1.0f]];
            CreatBtn.layer.cornerRadius = 10;
            [CreatBtn addTarget:self action:@selector(creatAction) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:CreatBtn];
        }
        UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SCREENWIDTH, 1)];
        viewLine.backgroundColor = [UIColor grayColor];
        viewLine.alpha = 0.3;
        [cell addSubview:viewLine];

    }
        return cell;
}
-(void)creatAction
{
    if ([self.moneyText.text floatValue]<self.cha)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"充值金额不够!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        
        [self postCardIfRequest];

        
    }
}
//此会员卡是否被办理过
-(void)postCardIfRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/stateGet",BASEURL];

    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:self.card_dic[@"merchant"] forKey:@"muid"];
    [params setObject:self.card_dic[@"card_code"] forKey:@"cardCode"];
    [params setObject:self.cardType forKey:@"cardLevel"];
    [params setObject:self.card_dic[@"card_type"] forKey:@"cardType"];
  
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"%@",result);
        
        DebugLog(@"self.adviceString==%@\nself.cha===%f",self.adviceString,self.cha);
        
        if ([result[@"result_code"] isEqualToString:@"false"])
        {
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            appdelegate.payCardType = self.cardType;
            appdelegate.moneyText = self.moneyText.text;

            
            
            if ([self.adviceString isEqualToString:@"您的余额足够,可直接升级"]&&!(self.cha<0)) {
                [self postRequestUpgradeNoMoney];
            }
            else if([self.card_dic[@"card_type"] isEqualToString:self.cardType]){
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                
                hud.label.text = NSLocalizedString(@"您要升级的卡已存在,不能升级", @"HUD message title");
                hud.label.font = [UIFont systemFontOfSize:13];
                [hud hideAnimated:YES afterDelay:3.f];
                
            }else{
                [self choicePayType];

            }

            
        }else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"您要升级的卡已存在,不能升级", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            [hud hideAnimated:YES afterDelay:3.f];
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
    
}
-(void)postRequestUpgradeNoMoney
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/setLevel",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.cardInfo_dic[@"user"] forKey:@"uuid"];
    [params setObject:appdelegate.payCardType forKey:@"new_level"];
    

    [params setObject:appdelegate.cardInfo_dic[@"merchant"] forKey:@"muid"];
    [params setObject:appdelegate.cardInfo_dic[@"card_code"] forKey:@"cardCode"];
    [params setObject:appdelegate.cardInfo_dic[@"card_level"] forKey:@"cardLevel"];
    [params setObject:appdelegate.moneyText forKey:@"sum"];
    
//    NSDateFormatter* matter = [[NSDateFormatter alloc]init];
//    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate* date  = [NSDate date];
//    NSString *NowDate = [matter stringFromDate:date];
//    [params setObject:NowDate forKey:@"dateTime"];
   

    
    DebugLog(@"------%@",params);
    
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        UIViewController *view =[appdelegate getCurrentRootViewController];
        NSLog(@"%@", result);

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if ([result[@"result_code"] intValue]==1) {
            hud.label.text = NSLocalizedString(@"升级成功", @"HUD message title");
            
            hud.label.font = [UIFont boldSystemFontOfSize:14];
            //    [hud setColor:[UIColor blackColor]];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            hud.userInteractionEnabled = YES;
            
            [hud hideAnimated:YES afterDelay:4.f];
            
            
            
            
            {
                NSMutableDictionary  *card_dic = [NSMutableDictionary dictionaryWithDictionary:appdelegate.cardInfo_dic];
                
                [card_dic setValue:self.cardType forKey:@"card_level"];
                appdelegate.cardInfo_dic =  card_dic;
                
            }
            
            
            
        }else
        {
            hud.label.text = NSLocalizedString(@"请求失败 请重试", @"HUD message title");
            
            hud.label.font = [UIFont systemFontOfSize:13];
            //    [hud setColor:[UIColor blackColor]];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            hud.userInteractionEnabled = YES;
            
            [hud hideAnimated:YES afterDelay:2.f];
            
            
        }
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] animated:YES];
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
//订单信息
-(void)choicePayType
{
    OrderInfomaViewController *orderInfoView = [[OrderInfomaViewController alloc]init];
    orderInfoView.moneyString = self.moneyText.text;
    orderInfoView.orderInfoType=4;
    [self.navigationController pushViewController:orderInfoView animated:YES];
}

-(void)choiceCard
{
    if (_ifCard == NO) {
        UIPickerView* pickerView = [ [ UIPickerView alloc] initWithFrame:CGRectMake(80,self.myTable.bottom-130,SCREENWIDTH-160,130)];
        
        pickerView.delegate = self;
        pickerView.dataSource =  self;
        self.cardTypePickerView = pickerView;
        [self.myTable addSubview:pickerView];
        _ifCard = YES;
    }
    else
    {
        _ifCard = NO;
        [self.cardTypePickerView removeFromSuperview];
    }
    
    
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(row ==0)
    {
        //pickerView.userInteractionEnabled = NO;
    }else
    {
        NSLog(@"string:%@",self.otherArray);
        self.cardType = self.pickArray[row];
        NSString *price = [[NSString alloc]init];
        for (int i=0; i<self.otherArray.count; i++)
        {
            if ([self.cardType isEqualToString:[[self.otherArray objectAtIndex:i] objectForKey:@"level"]]) {
                
             //要升级的卡  需要的金额
                price = [[self.otherArray objectAtIndex:i] objectForKey:@"price"];
                
                NSLog(@"string:%@",price);
                break;
            }
        }
       //当前卡的余额
        
        NSString *priceMy = self.card_dic[@"card_remain"];;
        
        NSLog(@"string:%@",priceMy);
        
//        NSInteger totle = [cstring integerValue] +[self.moneyText.text integerValue];
        if ([priceMy floatValue]>=[price floatValue]) {
            self.adviceString = @"您的余额足够,可直接升级";
            self.cha = 0.00;
        }else if ([priceMy floatValue]<[price floatValue]) {
            self.cha =[price floatValue]-[priceMy floatValue];
            NSString *chaStr = [[NSString alloc]initWithFormat:@"您需要充值%.2f便可升级",self.cha];
            self.adviceString = chaStr ;
        }

        self.cardLable.text =@"";
        
        [self.myTable reloadData];
        _ifCard = NO;
        [self.cardTypePickerView removeFromSuperview];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
