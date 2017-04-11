//
//  MineManagerViewController.m
//  BletcShop
//
//  Created by apple on 16/12/16.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MineManagerViewController.h"
#import "MerchantDetailViewController.h"
#import "ShopManagerDataReportVC.h"
@interface MineManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *data_A;
@property (nonatomic,strong)UITextField *phoneText;

@end

@implementation MineManagerViewController
{
    UITableView *_tableView;
}

-(void)ScanClcik{
    
   
    ShopManagerDataReportVC *VC=[[ShopManagerDataReportVC alloc]init];
    VC.data_A = self.data_A;
    
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"我管理的店铺";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"查看" style:UIBarButtonItemStylePlain target:self action:@selector(ScanClcik)];

    self.view.backgroundColor=[UIColor whiteColor];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    [self initBottomView];
    [self postRequest];
    
}
-(void)initBottomView{
    UIView *bottomView= [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-49-64, SCREENWIDTH, 49)];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    applyButton.frame=CGRectMake(0, 0, SCREENWIDTH, 49);
    applyButton.backgroundColor=NavBackGroundColor;
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyButton setTitle:@"申请店铺管理" forState:UIControlStateNormal];
    applyButton.titleLabel.font=[UIFont systemFontOfSize:16.0f];
    [bottomView addSubview:applyButton];
    
    [applyButton addTarget:self action:@selector(addManagerShop) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)addManagerShop{
       
    UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"输入店铺注册手机号:" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    altView.alertViewStyle = UIAlertViewStylePlainTextInput;
    altView.tag = 999;
    [altView show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==999&&buttonIndex==0) {
        
        self.phoneText = [alertView textFieldAtIndex:0];
        [self postRequestAddShop];
        
    }
    
}
#pragma mark ---申请管理店铺
-(void)postRequestAddShop
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/store/app",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:self.phoneText.text forKey:@"store"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        DebugLog(@"params=%@==%@",params,result);
        
        if ([result[@"result_code"] intValue]==1) {
            [self postRequest];
            
            [self tishi:@"申请成功"];
            
        }
        else if([result[@"result_code"] intValue]==1062)
        {
            [self tishi:@"已申请"];
            
        }else{
            [self tishi:@"申请错误"];
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        [self tishi:@"添加出错,请重新添加"];
        
        
        
    }];
    
}
#pragma mark ---获取已管理店铺列表
-(void)postRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/store/manageGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        DebugLog(@"result==%@",result);
        
        self.data_A = [result copy];
        if (_tableView) {
            [_tableView reloadData];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
#pragma mark ---tableView 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_A.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //商铺名
        UILabel *shopNameLable=[[UILabel alloc]initWithFrame:CGRectMake(14, 17, SCREENWIDTH-120-14, 16)];
        shopNameLable.font=[UIFont systemFontOfSize:16.0f];
        shopNameLable.tag=100;
        [cell addSubview:shopNameLable];
        //商铺电话号码
        UILabel *phoneLable=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-110, 17, 100, 16)];
        phoneLable.textAlignment=1;
        phoneLable.font=[UIFont systemFontOfSize:13.0f];
        phoneLable.tag=200;
        [cell addSubview:phoneLable];
        //商户户名
        UILabel *shopAccountLable=[[UILabel alloc]initWithFrame:CGRectMake(14, 55, SCREENWIDTH-14, 13)];
        shopAccountLable.textColor=[UIColor grayColor];
        shopAccountLable.font=[UIFont systemFontOfSize:13.0f];
        shopAccountLable.tag=300;
        [cell addSubview:shopAccountLable];
        //商户地点
        UILabel *shopAddressLable=[[UILabel alloc]initWithFrame:CGRectMake(14, 80, SCREENWIDTH-14, 13)];
        shopAddressLable.textColor=[UIColor grayColor];
        shopAddressLable.font=[UIFont systemFontOfSize:13.0f];
        shopAddressLable.tag=400;
        [cell addSubview:shopAddressLable];
        
    }
    
    UILabel *shopNameLabel=[cell viewWithTag:100];
    shopNameLabel.text=self.data_A[indexPath.row][@"store"];
    
    UILabel *shopPhoneLabel=[cell viewWithTag:200];
    shopPhoneLabel.text=self.data_A[indexPath.row][@"phone"];
    
    UILabel *shopAccountLabel=[cell viewWithTag:300];
    shopAccountLabel.text=self.data_A[indexPath.row][@"name"];
    
    UILabel *shopAddressLable=[cell viewWithTag:400];
    shopAddressLable.text=self.data_A[indexPath.row][@"address"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(void)tishi:(NSString*)tishi{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = NSLocalizedString(tishi, @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:3.f];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MerchantDetailViewController *detailVC=[[MerchantDetailViewController alloc]init];
    detailVC.array=self.data_A;
    detailVC.index=indexPath.row;
    [self.navigationController pushViewController:detailVC animated:YES];

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
