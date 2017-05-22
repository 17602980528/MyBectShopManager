//
//  MyProtuctsController.m
//  BletcShop
//
//  Created by Yuan on 16/1/28.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MyProtuctsController.h"
#import "NewProductTableViewCell.h"
#import "NewNextViewController.h"
#import "UIImageView+WebCache.h"
#import "AddproductVC.h"

@interface MyProtuctsController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,AddProductDelegate>
{
    SDRefreshHeaderView *headerRefresh;
}
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)UITableView *tabView;
@end


@implementation MyProtuctsController

-(void)reloadTheAPI{
    [self postRequest];
    NSLog(@"reloadTheAPI");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.editDic = [[NSMutableDictionary alloc]init];
    self.editTag = 0;

    [self _initUI];
    [self postRequest];
}

-(NSArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
        
    }return _data;
}

//商品数据
-(void)postRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/commodity/get",BASEURL];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    
    MyProtuctsController *tempSelf=self;
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [headerRefresh endRefreshing];
        NSLog(@"<<<<<<%@", result);
        tempSelf.data = [NSMutableArray arrayWithArray:result];
        [tempSelf.tabView reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [headerRefresh endRefreshing];

        NSLog(@"%@", error);
        
    }];
    
}
//视图控件
-(void)_initUI
{
    //    底层的视图
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    topView.backgroundColor = NavBackGroundColor;
    [self.view addSubview:topView];
    //    标题
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2 - 50, 20, 100, 44)];
    titleLab.text = @"我的产品";
    titleLab.textAlignment  = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:18];
    [topView addSubview:titleLab];
    
    //新增按钮
    UIButton *NewAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    NewAdd.frame = CGRectMake(SCREENWIDTH-40, 20+(topView.height-20-25)/2, 25, 25);
    //    [NewAdd setTitle:@"新增产品" forState:UIControlStateNormal];
    [NewAdd setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateNormal];
    [NewAdd setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateHighlighted];
    
    //    NewAdd.backgroundColor = [UIColor redColor];
    //    NewAdd.layer.cornerRadius = 10;
    [NewAdd addTarget:self action:@selector(addProAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:NewAdd];
    
    self.tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-49) style:UITableViewStyleGrouped];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    _tabView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tabView];
    
    
    headerRefresh = [SDRefreshHeaderView refreshView];
    [headerRefresh addToScrollView:_tabView];
    headerRefresh.isEffectedByNavigationController = NO;
    __block typeof(self)blockSelf = self;
    headerRefresh.beginRefreshingOperation = ^{
        [blockSelf postRequest];
    };
    
}


-(void)addProAction:(UIButton *)Btn
{
//    NSString *stateStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"wangyongle"];
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
//    if ([stateStr isEqualToString:@"incomplete"]) {
//        //去完善信息界面
//        
//        [self showTiShi:@"信息不完善,是否去完善?" LeftBtn_s:@"取消" RightBtn_s:@"确定"];
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
//    }else if ([stateStr isEqualToString:@"user_auth_fail"]){
//        //正在审核中
//        UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"正在审核中" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [altView show];
//        
//    }else if ([stateStr isEqualToString:@"login_access"]){
//        
        AddproductVC *VC = [[AddproductVC alloc]init];
        VC.editTag = 0;
        
        VC.delegate = self;
        [self.navigationController pushViewController:VC animated:YES];
//        self.editTag=0;
//        [self NewAddAction];

//    }
}
//审核
- (void)use_examine
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"用户尚未审核，我们将在三个工作日，完成审核", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:3.f];
    
}
//审核
- (void)use_examine_fail
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"审核未通过，请重新注册", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:3.f];
    
}

-(void)NewAddAction
{
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView]];
    
    // Modify the parameters
    if (self.editTag==0) {
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确定", @"取消", nil]];
    }else if (self.editTag==1)
    {
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"修改", @"取消", nil]];
    }else if (self.editTag==2)
    {
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"删除", @"取消", nil]];
    }
    
    
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    if (alertView.tag ==0&&buttonIndex==0) {
        if (self.editTag==0) {
            [self textCantBeNull2];
        }else if (self.editTag==1){
            [self postRequestEditProduct];
        }else if (self.editTag==2){
            [self postRequestDeleteProduct];
        }
        
    }
    else
        [alertView close];
}
-(void)postRequestDeleteProduct
{
    //NSString *url = @"http://192.168.0.117/VipCard/commodity_delete.php";
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/commodity/del",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    
    [params setObject:[self.editDic objectForKey:@"number"] forKey:@"code"];
    
    NSLog(@"%@", appdelegate.shopUserInfoArray);
    NSLog(@"%@", params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        NSDictionary *dic = result;
        if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"result_code"]] isEqualToString:@"1"]) {
            //[self.alertView close];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            hud.label.font = [UIFont systemFontOfSize:13];
            // Move to bottm center.
            //    hud.offset = CGPointMake(0.f, );
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:3.f];
            hud.label.text = NSLocalizedString(@"删除成功", @"HUD message title");
            [self postRequest];
            
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
-(void)postRequestEditProduct
{
    //NSString *url = @"http://192.168.0.117/VipCard/commodity_modify.php";
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/commodity/mod",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    [params setObject:self.proPriceText.text forKey:@"price"];
    [params setObject:self.proNumText.text forKey:@"remain"];
    [params setObject:self.proNameText.text forKey:@"name"];
    [params setObject:self.proCodeText.text forKey:@"code"];
    [params setObject:[self.editDic objectForKey:@"number"] forKey:@"ecode"];
    
    NSLog(@"%@", appdelegate.shopUserInfoArray);
    NSLog(@"%@", params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        NSDictionary *dic = result;
        if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"result_code"]] isEqualToString:@"1"]) {
            //[self.alertView close];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            hud.label.font = [UIFont systemFontOfSize:13];
            // Move to bottm center.
            //    hud.offset = CGPointMake(0.f, );
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:3.f];
            hud.label.text = NSLocalizedString(@"修改商品成功", @"HUD message title");
            [self postRequest];
            
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
-(void)textCantBeNull2
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:3.f];
    if ([self.proCodeText.text isEqualToString:@""]) {
        hud.label.text = NSLocalizedString(@"请填写商品编号", @"HUD message title");
    }
    else if ([self.proNameText.text isEqualToString:@""])
    {
        hud.label.text = NSLocalizedString(@"请填写商品名称", @"HUD message title");
    }
    else if ([self.proNumText.text isEqualToString:@""])
    {
        hud.label.text = NSLocalizedString(@"请填写商品数量", @"HUD message title");
    }else if ([self.proPriceText.text isEqualToString:@""])
    {
        hud.label.text = NSLocalizedString(@"请填写商品价格", @"HUD message title");
    }else
    {
        [self postRequestAddVipCard];
    }
    
}

-(void)postRequestAddVipCard
{
    //NSString *url = @"http://192.168.0.117/VipCard/commodity_add.php";
    NSString *url =[[NSString alloc]initWithFormat:@"%@/MerchantType/commodity/add",BASEURL ];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    [params setObject:self.proPriceText.text forKey:@"price"];
    [params setObject:self.proNumText.text forKey:@"remain"];
    [params setObject:self.proNameText.text forKey:@"name"];
    [params setObject:self.proCodeText.text forKey:@"code"];
    NSLog(@"%@", appdelegate.shopUserInfoArray);
    NSLog(@"%@", params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        NSDictionary *dic = result;
        if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"result_code"]] isEqualToString:@"1"]) {
            //[self.alertView close];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            hud.label.font = [UIFont systemFontOfSize:13];
            // Move to bottm center.
            //    hud.offset = CGPointMake(0.f, );
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:3.f];
            hud.label.text = NSLocalizedString(@"添加商品成功", @"HUD message title");
            [self postRequest];
            
        }else if([[NSString stringWithFormat:@"%@",[dic objectForKey:@"result_code"]] isEqualToString:@"1062"]){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            hud.label.font = [UIFont systemFontOfSize:13];
            // Move to bottm center.
            //    hud.offset = CGPointMake(0.f, );
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:3.f];
            hud.label.text = NSLocalizedString(@"已添加该商品,请勿重复添加", @"HUD message title");
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}


- (UIView *)createDemoView
{
    //商品编号
    UIView *demoView = [[UIView alloc] init ];
    demoView.frame=CGRectMake(0, 0, SCREENWIDTH-40, 160);
    if (self.editTag==0) {
        UILabel *numlabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 40)];
        numlabel.text = @"商品编号:";
        numlabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:numlabel];
        UITextField *numText = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, 200, 40)];
        self.proCodeText = numText;
        numText.placeholder = @" ";
        numText.font = [UIFont systemFontOfSize:13];
        numText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:numText];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH-40, 0.3)];
        line2.backgroundColor = [UIColor grayColor];
        line2.alpha = 0.3;
        [demoView addSubview:line2];
        
        //商品名称
        UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, 80, 40)];
        namelabel.text = @"商品名称:";
        namelabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:namelabel];
        UITextField *nameText = [[UITextField alloc]initWithFrame:CGRectMake(90, 40, 200, 40)];
        self.proNameText = nameText;
        nameText.placeholder = @" ";
        nameText.font = [UIFont systemFontOfSize:13];
        nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:nameText];
        UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 80, SCREENWIDTH-40, 0.3)];
        linePhone.backgroundColor = [UIColor grayColor];
        linePhone.alpha = 0.3;
        [demoView addSubview:linePhone];
        //商品库存
        UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 80, 80, 40)];
        levelLabel.text = @"商品库存:";
        levelLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:levelLabel];
        UITextField *cucunText = [[UITextField alloc]initWithFrame:CGRectMake(90, 80, 200, 40)];
        self.proNumText = cucunText;
        cucunText.placeholder = @" ";
        cucunText.font = [UIFont systemFontOfSize:13];
        cucunText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:cucunText];
        UIView *lineLevel = [[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREENWIDTH-40, 0.3)];
        lineLevel.backgroundColor = [UIColor grayColor];
        lineLevel.alpha = 0.3;
        [demoView addSubview:lineLevel];
        //价格
        UILabel *pricelabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 120, 80, 40)];
        pricelabel.text = @"价格:";
        
        pricelabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:pricelabel];
        UITextField *priceText = [[UITextField alloc]initWithFrame:CGRectMake(90, 120, 200, 40)];
        self.proPriceText =priceText;
        priceText.placeholder = @" ";
        priceText.font = [UIFont systemFontOfSize:13];
        priceText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:priceText];
        UIView *lineAdd = [[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREENWIDTH-40, 0.3)];
        lineAdd.backgroundColor = [UIColor grayColor];
        lineAdd.alpha = 0.3;
        [demoView addSubview:lineAdd];
    }
    else if (self.editTag==1)
    {
        UILabel *numlabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 40)];
        numlabel.text = @"商品编号:";
        numlabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:numlabel];
        UITextField *numText = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, 200, 40)];
        self.proCodeText = numText;
        numText.text =[self.editDic objectForKey:@"number"];
        numText.font = [UIFont systemFontOfSize:13];
        numText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:numText];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH-40, 0.3)];
        line2.backgroundColor = [UIColor grayColor];
        line2.alpha = 0.3;
        [demoView addSubview:line2];
        
        //商品名称
        UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, 80, 40)];
        namelabel.text = @"商品名称:";
        namelabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:namelabel];
        UITextField *nameText = [[UITextField alloc]initWithFrame:CGRectMake(90, 40, 200, 40)];
        self.proNameText = nameText;
        nameText.text =[self.editDic objectForKey:@"name"];
        nameText.font = [UIFont systemFontOfSize:13];
        nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:nameText];
        UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 80, SCREENWIDTH-40, 0.3)];
        linePhone.backgroundColor = [UIColor grayColor];
        linePhone.alpha = 0.3;
        [demoView addSubview:linePhone];
        //商品库存
        UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 80, 80, 40)];
        levelLabel.text = @"商品库存:";
        levelLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:levelLabel];
        UITextField *cucunText = [[UITextField alloc]initWithFrame:CGRectMake(90, 80, 200, 40)];
        self.proNumText = cucunText;
        cucunText.text =[self.editDic objectForKey:@"remain"];
        cucunText.font = [UIFont systemFontOfSize:13];
        cucunText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:cucunText];
        UIView *lineLevel = [[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREENWIDTH-40, 0.3)];
        lineLevel.backgroundColor = [UIColor grayColor];
        lineLevel.alpha = 0.3;
        [demoView addSubview:lineLevel];
        //价格
        UILabel *pricelabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 120, 80, 30)];
        pricelabel.text = @"价格:";
        
        pricelabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:pricelabel];
        UITextField *priceText = [[UITextField alloc]initWithFrame:CGRectMake(90, 120, 200, 40)];
        self.proPriceText =priceText;
        priceText.text = [self.editDic objectForKey:@"price"];
        priceText.font = [UIFont systemFontOfSize:13];
        priceText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:priceText];
        UIView *lineAdd = [[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREENWIDTH-40, 0.3)];
        lineAdd.backgroundColor = [UIColor grayColor];
        lineAdd.alpha = 0.3;
        [demoView addSubview:lineAdd];
    }else if(self.editTag == 2)
    {
        demoView.frame=CGRectMake(0, 0, 290, 40);
        UILabel *numlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, demoView.width, 40)];
        numlabel.textAlignment = NSTextAlignmentCenter;
        numlabel.text = [[NSString alloc]initWithFormat:@"确定删除商品:%@",[self.editDic objectForKey:@"name"]];
        numlabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:numlabel];
    }
    return demoView;
}

//商品列表的代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    NewProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[NewProductTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    if (self.data.count>0) {
        NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCE_PRODUCT stringByAppendingString:self.data[indexPath.row][@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        
        cell.pruductName.text =[NSString stringWithFormat:@"%@",[[self.data objectAtIndex:indexPath.row] objectForKey:@"name"]] ;
        cell.pruductCode.text = [NSString stringWithFormat:@"%@",[[self.data objectAtIndex:indexPath.row] objectForKey:@"number"]];
        cell.pruductPrice.text = [NSString stringWithFormat:@"￥%@",[[self.data objectAtIndex:indexPath.row] objectForKey:@"price"]];
        cell.pruductRemain.text = [NSString stringWithFormat:@"库存 %@",[NSString getTheNoNullStr:[[self.data objectAtIndex:indexPath.row] objectForKey:@"remain"] andRepalceStr:@"----"]];
        [cell.headImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
    }
    
    return cell;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyProtuctsController *tempSelf=self;
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        tempSelf.editTag=2;

        tempSelf.editDic = [self.data objectAtIndex:indexPath.row];
        [tempSelf NewAddAction];
    }];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        self.editTag=1;
        self.editDic = [self.data objectAtIndex:indexPath.row];
        
        AddproductVC *VC = [[AddproductVC alloc]init];
        VC.editTag = 1;
        VC.delegate = tempSelf;
        VC.product_dic = [self.data objectAtIndex:indexPath.row];
        
        
        [self.navigationController pushViewController:VC animated:YES];

    }];
    editAction.backgroundColor = [UIColor grayColor];
    return @[deleteAction, editAction];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==9999&&buttonIndex==1) {
        NewNextViewController *firstVC=[[NewNextViewController alloc]init];
        
        [self presentViewController:firstVC animated:YES completion:nil];
    }
}
-(void)showTiShi:(NSString *)content LeftBtn_s:(NSString*)left RightBtn_s:(NSString*)right{
    
    
    UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:left otherButtonTitles:right, nil];
    
    altView.tag =9999;
    [altView show];
    
}
@end
