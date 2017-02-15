//
//  GoShopViewController.m
//  BletcShop
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "GoShopViewController.h"
#import "UIImageView+WebCache.h"
@interface GoShopViewController ()
{
    UIImageView *scoreImageView;
    UIImageView *yueImageView;
    UILabel *guizeLabel;
    UILabel *yueLab;
    NSString *type;
    NSString *yue;
}
@end

@implementation GoShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"订单详情";
    self.allPoint=@"0";
    type=@"1";
    [self initView];
    [self postRequestPoints];
}

-(void)initView{
    //调试乐点支付
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
    //topView.backgroundColor=[UIColor redColor];
    [self.view addSubview:topView];
    //顶端图片
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 30, 140, 140)];
    //imageView.backgroundColor=[UIColor yellowColor];
    [topView addSubview:imageView];
    NSURL * nurl1=[[NSURL alloc] initWithString:[[DUOBAOIMAGE stringByAppendingString:_imageName]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [imageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
    //第一行，商品名称
    UILabel *scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(170, 30,SCREENWIDTH-180 ,60)];
    scoreLabel.text=_shopName;
    //scoreLabel.backgroundColor=[UIColor orangeColor];
    scoreLabel.numberOfLines=0;
    scoreLabel.font=[UIFont systemFontOfSize:15.0f];
    [topView addSubview:scoreLabel];
    //本次购买次数
    UILabel *yueLabel=[[UILabel alloc]initWithFrame:CGRectMake(170, 110, SCREENWIDTH-180, 60)];
    yueLabel.text=[[NSString alloc]initWithFormat:@"本次共购买了%ld次",(long)_counts ];
    yueLabel.numberOfLines=0;
    yueLabel.font=[UIFont systemFontOfSize:15.0f];
    //yueLabel.backgroundColor=[UIColor cyanColor];
    [topView addSubview:yueLabel];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(10, 220, SCREENWIDTH-20, 1)];
    lineView1.backgroundColor=[UIColor grayColor];
    lineView1.alpha=0.3;
    [self.view addSubview:lineView1];
    //乐点支付
    scoreImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 231, 40, 40)];
    //scoreImageView.backgroundColor=[UIColor redColor];
    scoreImageView.userInteractionEnabled=YES;
    scoreImageView.image=[UIImage imageNamed:@"select_true"];
    [self.view addSubview:scoreImageView];
    
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1:)];
    [scoreImageView addGestureRecognizer:tap1];
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(70, 231, 120, 40)];
    label1.text=@"乐点支付";
    [self.view addSubview:label1];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(10, 281, SCREENWIDTH-20, 1)];
    lineView2.backgroundColor=[UIColor grayColor];
    lineView2.alpha=0.3;
    [self.view addSubview:lineView2];
    //余额支付
    yueImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 292, 40, 40)];
    //yueImageView.backgroundColor=[UIColor redColor];
    yueImageView.userInteractionEnabled=YES;
    yueImageView.image=[UIImage imageNamed:@"select_false"];
    [self.view addSubview:yueImageView];
    
    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2:)];
    [yueImageView addGestureRecognizer:tap2];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(70, 292, 120, 40)];
    label2.text=@"余额支付";
    [self.view addSubview:label2];
    
    UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(10, 342, SCREENWIDTH-20, 1)];
    lineView3.backgroundColor=[UIColor grayColor];
    lineView3.alpha=0.3;
    [self.view addSubview:lineView3];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=NavBackGroundColor;
    button.frame=CGRectMake(0, SCREENHEIGHT-64-50, SCREENWIDTH, 50);
    [button setTitle:@"确认支付" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(Click1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    guizeLabel=[[UILabel alloc]initWithFrame:CGRectMake(180, 231, SCREENWIDTH-200-10, 40)];
    //guizeLabel.text=[[NSString alloc]initWithFormat:@"本次需%d乐点",_counts*10];
    guizeLabel.hidden=NO;
    guizeLabel.textColor=[UIColor grayColor];
    [self.view addSubview:guizeLabel];
    
    yueLab=[[UILabel alloc]initWithFrame:CGRectMake(180, 292, SCREENWIDTH-200-10, 40)];
    yueLab.text=[[NSString alloc]initWithFormat:@"共计%ld元",(long)_counts];
    yueLab.hidden=YES;
    yueLab.textColor=[UIColor grayColor];
    [self.view addSubview:yueLab];
}
//乐点选中样式
-(void)tap1:(UITapGestureRecognizer *)tapOne{
    if (_counts*10>[self.allPoint integerValue]) {
        guizeLabel.text=@"乐点不足";
    }else{
        guizeLabel.text=[[NSString alloc]initWithFormat:@"本次需%ld乐点",_counts*10];
    }
    type=@"1";
    yueImageView.image=[UIImage imageNamed:@"select_false"];
    scoreImageView.image=[UIImage imageNamed:@"select_true"];
    guizeLabel.hidden=NO;
    yueLab.hidden=YES;
    
}
//余额选中样式
-(void)tap2:(UITapGestureRecognizer *)tapTow{
    type=@"2";
    scoreImageView.image=[UIImage imageNamed:@"select_false"];
    yueImageView.image=[UIImage imageNamed:@"select_true"];
    guizeLabel.hidden=YES;
    yueLab.hidden=NO;
}
//乐点支付
-(void)Click1{
    if ([type isEqualToString:@"1"]) {
        if (_counts*10>[self.allPoint integerValue]) {
            //乐点不足，不会去支付
        }else{
            //乐点充足，调起支付接口
            [self postRequest];
        }

    }else{
        //余额支付
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        NSString *str=[appdelegate.userInfoArray objectAtIndex:8];
        NSArray *array=[str componentsSeparatedByString:@"元"];
        NSLog(@"%@",array);
        if (_counts*1.0<[[array objectAtIndex:0]doubleValue]) {
            //余额充足，可支付
            [self postRequest];
        }else{
            //余额不足
            yueLab.text=@"余额不足";
            yueLab.hidden=NO;
        }
    }
    
}
//获取用户乐点的方法



-(void)postRequestPoints
{
    //请求乐点数
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountGet",BASEURL];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:@"integral" forKey:@"type"];
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);
        self.allPoint = result[@"integral"];
        NSLog(@"%@", self.allPoint);
        
        if (_counts*10>[self.allPoint integerValue]) {
            guizeLabel.text=@"乐点不足";
        }else{
            guizeLabel.text=[[NSString alloc]initWithFormat:@"本次需%ld乐点",_counts*10];
        }


        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
//调起乐点支付
-(void)postRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"http://101.201.100.191/VipCard/award_take_part.php"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:_issue forKey:@"issue"];
    [params setObject:[appdelegate.userInfoArray objectAtIndex:1] forKey:@"phone"];
    [params setObject:[appdelegate.userInfoArray objectAtIndex:0] forKey:@"nickname"];
    [params setObject:[[NSString alloc]initWithFormat:@"%ld",(long)_counts] forKey:@"time"];
    if ([type isEqualToString:@"1"]) {
        [params setObject:@"1" forKey:@"pay_type"];
    }else if([type isEqualToString:@"2"]){
        [params setObject:@"2" forKey:@"pay_type"];
    }

    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         if ([result[0] isEqualToString:@"1"]) {
             //支付成功，执行相应逻辑,弹出提示框，返回上一界面
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.frame = CGRectMake(0, 64, 375, 667);
             // Set the annular determinate mode to show task progress.
             hud.mode = MBProgressHUDModeText;
             hud.label.text = NSLocalizedString(@"购买成功", @"HUD message title");
             hud.label.font = [UIFont systemFontOfSize:13];
             // Move to bottm center.
             //    hud.offset = CGPointMake(0.f, );
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             [hud hideAnimated:YES afterDelay:3.f];
             //提示成功之后，返回上一个界面
             [self performSelector:@selector(backToFirst) withObject:nil afterDelay:3.0f];
             
         }else if([result[0] isEqualToString:@"nomore"]){
             //提示剩余人数不足，无法购买，或者重新去购买
             NSLog(@"%@",result[1]);
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.frame = CGRectMake(0, 64, 375, 667);
             // Set the annular determinate mode to show task progress.
             hud.mode = MBProgressHUDModeText;
             hud.label.font = [UIFont systemFontOfSize:13];
             // Move to bottm center.
             //    hud.offset = CGPointMake(0.f, );
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             [hud hideAnimated:YES afterDelay:3.f];
             //提示成功之后，返回上一个界面
             [self performSelector:@selector(backToFirst) withObject:nil afterDelay:3.0f];
             NSString *numStr=[[NSString alloc]initWithFormat:@"%@",result[1]];
             if ([numStr isEqualToString:@"0"]) {
                 hud.label.text = NSLocalizedString(@"活动已结束", @"HUD message title");
             }else{
                 hud.label.text = [[NSString alloc]initWithFormat:@"剩余%@人次",result[1]];//NSLocalizedString(@"剩余%@人次", result[1]);
             }
             
         }else if([result[0] isEqualToString:@"finish"]){
             NSLog(@"%@",result);
             if ([_delegate respondsToSelector:@selector(awardResult:)]) {
                 [_delegate awardResult:result[1]];
             }
             //支付成功，执行相应逻辑,弹出提示框，返回上一界面
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.frame = CGRectMake(0, 64, 375, 667);
             // Set the annular determinate mode to show task progress.
             hud.mode = MBProgressHUDModeText;
             hud.label.text = NSLocalizedString(@"购买成功", @"HUD message title");
             hud.label.font = [UIFont systemFontOfSize:13];
             // Move to bottm center.
             //    hud.offset = CGPointMake(0.f, );
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             [hud hideAnimated:YES afterDelay:3.f];
             //提示成功之后，返回上一个界面
             [self performSelector:@selector(backToFirst) withObject:nil afterDelay:3.0f];

         }
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    
}
-(void)backToFirst{
    [self.navigationController popViewControllerAnimated:YES];
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
