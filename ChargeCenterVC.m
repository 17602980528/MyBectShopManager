//
//  ChargeCenterVC.m
//  BletcShop
//
//  Created by Bletc on 16/9/29.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ChargeCenterVC.h"
#import "ChargeToAccountVC.h"
#import "LZDCashViewController.h"
#import "LZDCountsViewController.h"
#import "MJXAViewController.h"


#import "ReveiveMoneyQRInfoVC.h"


@interface ChargeCenterVC ()
{
    NSArray *arr;
}
@end

@implementation ChargeCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"结算中心";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
    
    
    for (int i = 0; i <2; i ++) {
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(15, 15+i*((SCREENHEIGHT-64-49-45)/2+15), SCREENWIDTH-30, (SCREENHEIGHT-64-49-45)/2);
        button1.backgroundColor = [UIColor whiteColor];
        
        button1.tag = i;
        [button1 addTarget:self action:@selector(choseClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button1];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.center = CGPointMake(button1.center.x, button1.center.y-30);
        btn.userInteractionEnabled = NO;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.bounds = CGRectMake(0, 0, SCREENWIDTH*0.25, SCREENWIDTH*0.25);
        btn.layer.cornerRadius = btn.width/2;
        btn.layer.masksToBounds = YES;
        [self.view addSubview:btn];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, btn.bottom+20, SCREENWIDTH, 20)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = RGB(51, 51, 51);
        lab.font = [UIFont boldSystemFontOfSize:18];
        [self.view addSubview:lab];

 
        if (i==0) {
            [btn setTitle:@"收" forState:0];
            btn.backgroundColor = RGB(277, 196, 0);
            lab.text = @"我要收款";
            
            
        }else{
            [btn setTitle:@"入" forState:0];
            btn.backgroundColor = RGB(0, 185, 25);
            lab.text = @"现金入账";

        }
    }
    
    

    
    
    
    
    
//    arr = @[@"金额结算",@"现金结算",@"明细结算",@"按次结算"];
//    
//    
//    for (int i =0; i <arr.count; i ++) {
//        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        CGFloat hh =(165-49)*SCREENWIDTH/375;
//        
//        button.frame = CGRectMake(SCREENWIDTH/2-85-23 +i%2*(85+46), hh+i/2*(111+32), 85, 111);
//        NSLog(@"=====%f",button.frame.origin.x);
//        button.tag = i;
//        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:button];
//        
//        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, button.width, button.width)];
//        imgV.layer.cornerRadius = imgV.width/2;
//        imgV.layer.masksToBounds = YES;
//        imgV.backgroundColor=[UIColor whiteColor];
//        imgV.image = [UIImage imageNamed:arr[i]];
//        [button addSubview:imgV];
//        
//        UILabel *lable= [[UILabel alloc]initWithFrame:CGRectMake(0, imgV.bottom+12, imgV.width, 14)];
//        lable.text = arr[i];
//        lable.textColor = RGB(51,51,51);
//        lable.textAlignment = NSTextAlignmentCenter;
//        lable.font = [UIFont systemFontOfSize:15];
//        [button addSubview:lable];
//    }
//    
    
    
    
//    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, SCREENHEIGHT-64-10) style:UITableViewStylePlain];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    tableView.bounces = NO;
//    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    tableView.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"] ;
//    [self.view addSubview:tableView];

    
}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return arr.count;
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *identifier = @"cellID";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 43, SCREENWIDTH, 1)];
//        view.backgroundColor = RGB(234, 234, 234);
//        [cell addSubview:view];
//        cell.textLabel.font = [UIFont systemFontOfSize:15];
//    }
//    cell.imageView.image = [UIImage imageNamed:arr[indexPath.row]];
//    cell.textLabel.text = arr[indexPath.row];
//    
//    return cell;
//}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSString *stateStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"wangyongle"];
//    
//    
//#ifdef DEBUG
//    stateStr = @"login_access";
//    
//    
//#else
//    
//    
//#endif
//    
//    
//    
//    if ([stateStr isEqualToString:@"incomplete"]) {
//        //去完善信息界面
//        [self showTiShi:@"信息不完善,是否去完善?" LeftBtn_s:@"取消" RightBtn_s:@"确定"];
//        
//        
//        
//    }else if ([stateStr isEqualToString:@"user_not_auth"]){
//        
//        [self showTiShi:@"用户尚未审核，我们将在三个工作日，完成审核" LeftBtn_s:@"取消" RightBtn_s:@"修改"];
//        
//        //            [self use_examine];
//    }else if ([stateStr isEqualToString:@"user_auth_fail"]){
//        
//        [self showTiShi:@"审核未通过，请重新修改" LeftBtn_s:@"取消" RightBtn_s:@"修改"];
//        
//        
//        
//    }else if ([stateStr isEqualToString:@"login_access"]){
//        
//
//    
//    switch (indexPath.row) {
//        case 0:
//            //明细结算
//        {
//            MJXAViewController *mingxiVC=[[MJXAViewController alloc]init];
//            [self.navigationController pushViewController:mingxiVC animated:YES];
//        }
//            break;
//        case 1:
//            //金额结算
//        {
//            LZDCashViewController *VC = [[LZDCashViewController alloc]init];
//            [self.navigationController pushViewController:VC animated:YES];
//        }
//            break;
//        case 2:
//            //现金结算
//        {
//            ChargeToAccountVC *VC = [[ChargeToAccountVC alloc]init];
//            [self.navigationController pushViewController:VC animated:YES];
//
//        }
//            
//            break;
//        case 3:
//            //按次结算
//            
//        {
//            
//            LZDCountsViewController *VC = [[LZDCountsViewController alloc]init];
//            [self.navigationController pushViewController:VC animated:YES];
//        }
//            break;
//
//        default:
//            break;
//    }
//        
//    }
//
//    
//}


-(void)choseClick:(UIButton*)sender{
    
    NSString *stateStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"wangyongle"];
    
   
    
    
#ifdef DEBUG
    stateStr = @"login_access";
    
    
#else
    
    
#endif
    
    
    
    if ([stateStr isEqualToString:@"incomplete"]) {
        //去完善信息界面
        [self showTiShi:@"信息不完善,是否去完善?" LeftBtn_s:@"取消" RightBtn_s:@"确定"];
        
        
        
    }else if ([stateStr isEqualToString:@"user_not_auth"]){
        
        [self showTiShi:@"用户尚未审核，我们将在三个工作日，完成审核" LeftBtn_s:@"取消" RightBtn_s:@"修改"];
        
        //            [self use_examine];
    }else if ([stateStr isEqualToString:@"user_auth_fail"]){
        
        [self showTiShi:@"审核未通过，请重新修改" LeftBtn_s:@"取消" RightBtn_s:@"修改"];
        
        
        
    }else if ([stateStr isEqualToString:@"login_access"]){
        
        
        
        switch (sender.tag) {
                
            case 0:
                //收款二维码
            {
                ReveiveMoneyQRInfoVC *VC = [[ReveiveMoneyQRInfoVC alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
               
            }
                break;
            case 1:
                //现金结算
            {
                ChargeToAccountVC *VC = [[ChargeToAccountVC alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
                
            }
                break;
                
                
                
            default:
                break;
        }
        
    }
    
    
}
//-(void)buttonClick:(UIButton*)sender{
//    
//    NSString *stateStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"wangyongle"];
//    
//    
//#ifdef DEBUG
//    stateStr = @"login_access";
//    
//    
//#else
//    
//    
//#endif
//    
//    
//    
//    if ([stateStr isEqualToString:@"incomplete"]) {
//        //去完善信息界面
//        [self showTiShi:@"信息不完善,是否去完善?" LeftBtn_s:@"取消" RightBtn_s:@"确定"];
//        
//        
//        
//    }else if ([stateStr isEqualToString:@"user_not_auth"]){
//        
//        [self showTiShi:@"用户尚未审核，我们将在三个工作日，完成审核" LeftBtn_s:@"取消" RightBtn_s:@"修改"];
//        
//        //            [self use_examine];
//    }else if ([stateStr isEqualToString:@"user_auth_fail"]){
//        
//        [self showTiShi:@"审核未通过，请重新修改" LeftBtn_s:@"取消" RightBtn_s:@"修改"];
//        
//        
//        
//    }else if ([stateStr isEqualToString:@"login_access"]){
//        
//        
//        
//        switch (sender.tag) {
//           
//            case 0:
//                //金额结算
//            {
//                LZDCashViewController *VC = [[LZDCashViewController alloc]init];
//                [self.navigationController pushViewController:VC animated:YES];
//            }
//                break;
//            case 1:
//                //现金结算
//            {
//                ChargeToAccountVC *VC = [[ChargeToAccountVC alloc]init];
//                [self.navigationController pushViewController:VC animated:YES];
//                
//            }
//                break;
//
//            case 2:
//                //明细结算
//            {
//                MJXAViewController *mingxiVC=[[MJXAViewController alloc]init];
//                [self.navigationController pushViewController:mingxiVC animated:YES];
//            }
//                break;
//                
//            case 3:
//                //按次结算
//                
//            {
//                
//                LZDCountsViewController *VC = [[LZDCountsViewController alloc]init];
//                [self.navigationController pushViewController:VC animated:YES];
//            }
//                break;
//                
//            default:
//                break;
//        }
//        
//    }
//    
//    
//}

-(void)showTiShi:(NSString *)content LeftBtn_s:(NSString*)left RightBtn_s:(NSString*)right{
    
    
    UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:left otherButtonTitles:right, nil];
    
    altView.tag =9999;
    [altView show];
    
}


@end
