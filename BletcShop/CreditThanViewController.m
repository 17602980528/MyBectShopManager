//
//  CreditThanViewController.m
//  BletcShop
//
//  Created by Bletc on 16/6/17.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "CreditThanViewController.h"
#import "ValuePickerView.h"


@interface CreditThanViewController ()
@property (nonatomic, strong) ValuePickerView *pickerView;

@end

@implementation CreditThanViewController

-(NSDictionary *)data_dic{
    if (!_data_dic) {
        _data_dic = [NSDictionary dictionary];
    }
    return _data_dic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    self.title = @"授信额度";
    self.moneyArray = [[NSMutableArray alloc]init];
    self.moneyArray = [[NSMutableArray alloc]initWithObjects:@"10000",@"50000",@"200000",@"500000", nil];
    self.pickerView = [[ValuePickerView alloc]init];
    
    [self postCreditRequest];
}

-(void)postCreditRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/creditGet",BASEURL];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        self.data_dic = (NSDictionary*)result;
        [self initOderView];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    

}
-(void)postSubmitRequest
{


        NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/creditApp",BASEURL];

//    if ([self.allMoney floatValue]<[self.tixianLable.text floatValue])
//    {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        //            hud.frame = CGRectMake(0, 64, 375, 667);
//        // Set the annular determinate mode to show task progress.
//        hud.mode = MBProgressHUDModeText;
//        
//        hud.label.text = NSLocalizedString(@"余额不足,不能提现", @"HUD message title");
//        hud.label.font = [UIFont systemFontOfSize:13];
//        // Move to bottm center.
//        //    hud.offset = CGPointMake(0.f, );
//        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
//        [hud hideAnimated:YES afterDelay:4.f];
//
//    }else{
    
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid "];
        
        [params setObject:self.tixianLable.text forKey:@"credit_sum"];
    
        [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            NSLog(@"%@", result);
            NSDictionary *res_dic = (NSDictionary*)result;
            if ([res_dic[@"result_code"] intValue]==1)
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"提交成功,等待审核!", @"HUD message title");
                hud.label.font = [UIFont systemFontOfSize:13];
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                [hud hideAnimated:YES afterDelay:4.f];
//                [self.navigationController popViewControllerAnimated:YES];

            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"提交失败!", @"HUD message title");
                hud.label.font = [UIFont systemFontOfSize:13];
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                [hud hideAnimated:YES afterDelay:4.f];
                
            }
            
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@", error);
            
        }];
    
}
-(void)initOderView
{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 49+99)];
    myView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myView];
    self.myView = myView;
    UILabel *orderClassLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, 120, 49)];
    
    orderClassLabel.font = [UIFont systemFontOfSize:16];
    orderClassLabel.text = @"授信额度:";
    orderClassLabel.textColor = RGB(51, 51, 51);
    [myView addSubview:orderClassLabel];
    
    UILabel *orderClassLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-14, 49)];
    self.nowLable = orderClassLabel1;
    

    orderClassLabel1.font = [UIFont systemFontOfSize:16];
    orderClassLabel1.textColor = RGB(153, 153, 153);
    [orderClassLabel1 setTextAlignment:NSTextAlignmentRight];
    
    orderClassLabel1.text = [NSString getTheNoNullStr:self.data_dic[@"sum"] andRepalceStr:@"0.00元"];

    
    
    [myView addSubview:orderClassLabel1];
    
    //线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, orderClassLabel1.bottom, SCREENWIDTH, 10)];
    line.backgroundColor = RGB(240, 240, 240);
    [myView addSubview:line];
    //预约日期
    UILabel *orderDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, line.bottom, 120, 45)];
    orderDateLabel.font = [UIFont systemFontOfSize:16];
    orderDateLabel.textColor = RGB(51, 51, 51);
    orderDateLabel.text = @"剩余额度:";
    [myView addSubview:orderDateLabel];
    UILabel *orderDateLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, line.bottom, SCREENWIDTH-14, 45)];
    self.shengyuLable = orderDateLabel1;
    orderDateLabel1.font = [UIFont systemFontOfSize:16];
    orderDateLabel1.textColor = RGB(153, 153, 153);
    [orderDateLabel1 setTextAlignment:NSTextAlignmentRight];
    orderDateLabel1.text = [NSString stringWithFormat:@"%@元",self.data_dic[@"remain"]];

    
    [myView addSubview:orderDateLabel1];
//        //线

    //预约时间Time
    UILabel *orderTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, orderDateLabel1.bottom, 120, 45)];
    orderTimeLabel.font = [UIFont systemFontOfSize:16];
    orderTimeLabel.textColor = RGB(51, 51, 51);
    orderTimeLabel.text = @"我要提额:";
    [myView addSubview:orderTimeLabel];

    
    UILabel *orderTimeLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, orderDateLabel1.bottom, SCREENWIDTH-53, 45)];
    orderTimeLabel1.text= self.moneyArray[0];

    self.tixianLable = orderTimeLabel1;
    orderTimeLabel1.font = [UIFont systemFontOfSize:16];
    orderTimeLabel1.textColor = RGB(153, 153, 153);
    [orderTimeLabel1 setTextAlignment:NSTextAlignmentRight];
    
    
//    orderTimeLabel1.layer.borderWidth = 1;
    
    [myView addSubview:orderTimeLabel1];
    
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-40, orderDateLabel1.bottom+14, 7.5, 14)];
    imgV.image =[UIImage imageNamed:@"arraw_right"];
    [myView addSubview:imgV];
    
    UIButton *CreatBtnTime = [UIButton buttonWithType:UIButtonTypeCustom];
    CreatBtnTime.frame = CGRectMake(SCREENWIDTH-100, orderDateLabel1.bottom, 100, 45);
    
    [CreatBtnTime addTarget:self action:@selector(choiceOrderTime) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:CreatBtnTime];
//    //线

    CGRect frame = myView.frame;
    frame.size.height =orderTimeLabel1.bottom;
    myView.frame = frame;
    
    UIButton *CreatBtnOK = [UIButton buttonWithType:UIButtonTypeCustom];
    CreatBtnOK.frame = CGRectMake(12, myView.bottom+52, SCREENWIDTH-24, 50);
    [CreatBtnOK setTitle:@"提交申请" forState:UIControlStateNormal];
    [CreatBtnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [CreatBtnOK setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    CreatBtnOK.titleLabel.font = [UIFont systemFontOfSize:18];
    [CreatBtnOK setBackgroundColor:NavBackGroundColor];
    CreatBtnOK.layer.cornerRadius = 5;
    [CreatBtnOK addTarget:self action:@selector(submitActionOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:CreatBtnOK];
    
}
-(void)submitActionOrder
{
    [self postSubmitRequest];
}
-(void)choiceOrderTime
{
    if (self.moneyArray.count>0) {
        
        self.pickerView.dataSource = self.moneyArray;
        [self.pickerView show];
        
        __weak typeof(self) weakSelf = self;
        
        self.pickerView.valueDidSelect = ^(NSString * value){
           weakSelf.tixianLable.text = [[value componentsSeparatedByString:@"/"] firstObject];
            
        };
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"暂无可提升额度", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:4.f];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
