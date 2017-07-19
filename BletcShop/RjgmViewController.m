//
//  RjgmViewController.m
//  BletcShop
//
//  Created by Bletc on 16/4/20.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "RjgmViewController.h"
#import "RJGDetailVC.h"
#import "NewNextViewController.h"
#import "GetMoneyVC.h"

@interface RjgmViewController ()
{
    NSDictionary *data_dic;
}

@property(nonatomic,strong)UILabel *sum_Lab;
@property(nonatomic,strong)UILabel *insure_Lab;
@property(nonatomic,strong)UILabel *award_Lab;

@end

@implementation RjgmViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    topView.backgroundColor =NavBackGroundColor;
    [self.view addSubview:topView];
    
    UIImageView*backImg=[[UIImageView alloc]init];
    backImg.frame=CGRectMake(9, 30, 12, 20);
    backImg.image=[UIImage imageNamed:@"leftArrow"];
    [topView addSubview:backImg];
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, +20, SCREENWIDTH, 44)];
    label.text=@"资金提现";
    label.font=[UIFont systemFontOfSize:19];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    [topView addSubview:label];
    
    LZDButton*backTi=[LZDButton creatLZDButton];
    backTi.frame=CGRectMake(0, 20, SCREENWIDTH*0.2, 44);
    backTi.block = ^(LZDButton*btn){
        [self.navigationController popViewControllerAnimated:YES];

    };
    [topView addSubview:backTi];

    
    LZDButton *rightBtn = [LZDButton creatLZDButton];
    rightBtn.frame = CGRectMake(kWeChatScreenWidth-50, 20, 50, 44);
    
    [rightBtn setTitle:@"明细" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:rightBtn];
    
    rightBtn.block = ^(LZDButton *btn){
        NSLog(@"明细");

        RJGDetailVC *VC = [[RJGDetailVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    };

    
    [self creatSubViews];
    
    [self postRequestMoney];

    
}


-(void)postRequestMoney
{
    
    [self showHudInView:self.view hint:@"加载中..."];
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/sumGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    
    DebugLog(@"-url---%@-params--%@",url,params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        DebugLog(@"result===%@",result);
        [self hideHud];
        NSDictionary *dic = (NSDictionary*)result;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            data_dic = dic;
            [self initRjgmViewWithDic:dic];
            

        });
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}


-(void)creatSubViews{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 252-64)];
    backView.backgroundColor = NavBackGroundColor;
    [self.view addSubview:backView];
    
    UILabel *sum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 100-20, SCREENWIDTH, 44)];
    sum_Lab.textColor =[UIColor whiteColor];
    sum_Lab.font = [UIFont boldSystemFontOfSize:40];
    sum_Lab.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:sum_Lab];
    self.sum_Lab = sum_Lab;
    
    UILabel *title_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 69-20, SCREENWIDTH, 16)];
    title_lab.text = @"账户余额";
    title_lab.textColor = [UIColor whiteColor];
    title_lab.textAlignment = NSTextAlignmentCenter;
    
    title_lab.font =[UIFont systemFontOfSize:25];
    [backView addSubview:title_lab];
    NSArray *name_A  = @[@"保证金",@"奖励金额"];
    for (int i = 0; i <2; i ++) {
        UIView *View = [[UIView alloc]initWithFrame:CGRectMake(0, backView.bottom+i*48, SCREENWIDTH, 48)];
        [self.view addSubview:View];
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 18, 18)];
        imgV.layer.cornerRadius = 9;
        
        
        
        [View addSubview:imgV];
        UILabel * name_lab =[[UILabel alloc]initWithFrame:CGRectMake(imgV.right+10, 0, SCREENWIDTH, View.height)];
        name_lab.text = name_A[i];
        name_lab.textColor = [UIColor blackColor];
        name_lab.font =[UIFont systemFontOfSize:17];
        [View addSubview:name_lab];
        UILabel *count_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-10, View.height)];
        [View addSubview:count_lab];
        count_lab.textAlignment = NSTextAlignmentRight;
        count_lab.font = [UIFont systemFontOfSize:17];
        count_lab.textColor = NavBackGroundColor;
        if (i==0) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, View.height-1, SCREENWIDTH, 1)];
            line.backgroundColor =RGB(234, 234, 234);
            [View addSubview:line];
            imgV.image = [UIImage imageNamed:@"money_icon_pr_n"];
            self.insure_Lab = count_lab;
        }
        if (i==1) {

            imgV.image = [UIImage imageNamed:@"money_icon_bo_n"];
            
            self.award_Lab = count_lab;
        }
        
        
    }
    
    
    
//    LZDButton *rjgmBtn = [LZDButton creatLZDButton];
//    rjgmBtn.frame = CGRectMake(15, backView.bottom+150, SCREENWIDTH-30, 44);
//    [rjgmBtn setTitle:@"申请提现" forState:UIControlStateNormal];
//    
//    rjgmBtn.backgroundColor = NavBackGroundColor;
//    rjgmBtn.layer.cornerRadius = 5;
//    rjgmBtn.clipsToBounds = YES;
//    [self.view addSubview:rjgmBtn];
//    rjgmBtn.block = ^(LZDButton*btn){
//        
//        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//        
//        NSString *bankAccount = [NSString getTheNoNullStr:app.shopInfoDic[@"account"] andRepalceStr:@""];
//        NSString *bankName = [NSString getTheNoNullStr:app.shopInfoDic[@"name"] andRepalceStr:@""];
//        NSString *bankAddress = [NSString getTheNoNullStr:app.shopInfoDic[@"bank"] andRepalceStr:@""];
//        
//        NSLog(@"----%@--%@--%@==%@",bankAccount,bankName,bankAddress,data_dic);
//        if ( bankAccount.length!=19 || bankName.length==0 || bankAddress==0) {
//            
//            [self showTiShi:@"银行卡信息不完整，请填写" LeftBtn_s:@"取消" RightBtn_s:@"修改"];
//        }else{
//            
//            GetMoneyVC *VC = [[GetMoneyVC alloc]init];
//            VC.sum_string= data_dic[@"remain"];
//            VC.block = ^(){
//                [self postRequestMoney];
//            };
//            
//            [self.navigationController pushViewController:VC animated:YES];
//        }
//        
//        
//        
//        
//    };
    
    
    
}
-(void)initRjgmViewWithDic:(NSDictionary*)dic
{
        self.sum_Lab.text = dic[@"remain"];
       self.insure_Lab.text =[NSString getTheNoNullStr:dic[@"deposit"] andRepalceStr:@"0.00元"];
       self.award_Lab.text = [NSString getTheNoNullStr:dic[@"award"] andRepalceStr:@"0.00元"];
    
    
}

-(void)showTiShi:(NSString *)content LeftBtn_s:(NSString*)left RightBtn_s:(NSString*)right{
    
    
    UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:left otherButtonTitles:right, nil];
    
    altView.tag =9999;
    [altView show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==9999&&buttonIndex==1) {
        NewNextViewController *firstVC=[[NewNextViewController alloc]init];
        
        [self presentViewController:firstVC animated:YES completion:nil];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
