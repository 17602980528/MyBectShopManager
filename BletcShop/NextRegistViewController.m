//
//  NextRegistViewController.m
//  BletcShop
//
//  Created by Bletc on 16/4/1.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NextRegistViewController.h"
#import "MoreInfoViewController.h"
#import "LastRegistViewController.h"
@interface NextRegistViewController ()

@end

@implementation NextRegistViewController
//点击空白结束编辑 收起键盘
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
//    [self.nibText resignFirstResponder];
//    [self.personText resignFirstResponder];
//    [self.addressText resignFirstResponder];
//    [self.shopNameText resignFirstResponder];
    [self.view endEditing:YES];
    
    
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

//然后根据具体的业务场景去写逻辑就可以了,比如
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //Tip:我们可以通过打印touch.view来看看具体点击的view是具体是什么名称,像点击UITableViewCell时响应的View则是UITableViewCellContentView.
    NSLog(@"%@",touch.view);
    if ([NSStringFromClass([touch.view class])    isEqualToString:@"UITableViewCellContentView"]) {
        //返回为NO则屏蔽手势事件
        return NO;
    }
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.ifOpen = NO;
    self.tradeArray = [[NSMutableArray alloc]initWithObjects:@"美容",@"美发",@"美甲",@"足疗按摩",@"皮革养护",@"汽车服务",@"洗衣",@"瑜伽舞蹈",@"瘦身纤体",@"宠物店",@"电影院",@"运动健身",@"零售连锁",@"餐饮食品",@"医药",@"游乐场",@"娱乐KTV",@"婚纱摄影",@"游泳馆",@"超市购物",@"甜点饮品",@"酒店",@"教育培训",@"商务会所",@"全部分类", nil];
    [self initRegistView];
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
    // Do any additional setup after loading the view.
}
-(void)backRegist
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)initRegistView
{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    navView.backgroundColor = NavBackGroundColor;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 18, 70, 44)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backRegist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
    [navView addSubview:btn];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-35, 18, 70, 44)];
    label.font=[UIFont systemFontOfSize:19.0f];
    label.text=@"注册";
    label.textAlignment=1;
    label.textColor=[UIColor whiteColor];
    [navView addSubview:label];
    UIView *landView = [[UIView alloc]initWithFrame:CGRectMake(0, (SCREENHEIGHT-300)/2, SCREENWIDTH, 240)];
    self.landView = landView;
    [self.view addSubview:landView];
    //昵称
    UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 10, 40)];
    redLabel.text = @"*";
    redLabel.textColor = [UIColor redColor];
    redLabel.font = [UIFont systemFontOfSize:15];
    
    [landView addSubview:redLabel];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 40)];
    nameLabel.text = @"昵称";
    nameLabel.font = [UIFont systemFontOfSize:15];
    
    [landView addSubview:nameLabel];
    UITextField *nibText = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, SCREENWIDTH-90, 40)];
    nibText.keyboardType =UIKeyboardTypeASCIICapable;
    nibText.placeholder = @"请设置您的昵称(不能为纯数字和包含特殊字符)";
    //nibText.secureTextEntry = YES;
    self.nibText = nibText;
    nibText.font = [UIFont systemFontOfSize:15];
    nibText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [landView addSubview:nibText];
//    UILabel *redLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, phoneText.bottom, 10, 40)];
//    redLabel1.text = @"*";
//    redLabel1.textColor = [UIColor redColor];
//    redLabel1.font = [UIFont systemFontOfSize:15];
//    [landView addSubview:redLabel1];
    //推荐人
    UILabel *redLabelper = [[UILabel alloc]initWithFrame:CGRectMake(10, nameLabel.bottom, 10, 40)];
    redLabelper.text = @"*";
    redLabelper.textColor = [UIColor redColor];
    redLabelper.font = [UIFont systemFontOfSize:15];
    [landView addSubview:redLabelper];
    UILabel *personLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, nibText.bottom, 70, 40)];
    personLabel.text = @"推荐人";
    personLabel.font = [UIFont systemFontOfSize:15];
    [landView addSubview:personLabel];
    UITextField *proText = [[UITextField alloc]initWithFrame:CGRectMake(90, nibText.bottom, SCREENWIDTH-90, 40)];
//    proText.secureTextEntry = YES;
    proText.text = @"";
    self.personText = proText;
    proText.delegate = self;
    proText.font = [UIFont systemFontOfSize:15];
    proText.placeholder = @"";
    proText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [landView addSubview:proText];
   
    
    //营业地址省市区
    UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, personLabel.bottom, 70, 40)];
    cityLabel.text = @"所在地区";
    cityLabel.font = [UIFont systemFontOfSize:15];
    [landView addSubview:cityLabel];
    
    UILabel *cityLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(90, proText.bottom, SCREENWIDTH-90, 40)];
    //addressText.secureTextEntry = YES;
    self.cityLabel =cityLabel1;
    cityLabel1.font = [UIFont systemFontOfSize:15];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (appdelegate.province==nil||[appdelegate.province isEqualToString:@"(null)"]) {
        appdelegate.province = @"";
    }if (appdelegate.city==nil||[appdelegate.city isEqualToString:@"(null)"]) {
        appdelegate.city = @"";
    }if (appdelegate.addressDistrite==nil||[appdelegate.addressDistrite isEqualToString:@"(null)"]) {
        appdelegate.addressDistrite = @"";
    }
    cityLabel1.text = [[NSString alloc] initWithFormat:@"%@%@%@",appdelegate.province,appdelegate.city,appdelegate.addressDistrite];
    [landView addSubview:cityLabel1];
    //营业地址
    //地址
    UILabel *redLabelAdd = [[UILabel alloc]initWithFrame:CGRectMake(10, cityLabel1.bottom, 10, 40)];
    redLabelAdd.text = @"*";
    redLabelAdd.textColor = [UIColor redColor];
    redLabelAdd.font = [UIFont systemFontOfSize:15];
    [landView addSubview:redLabelAdd];
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, cityLabel.bottom, 70, 40)];
    addressLabel.text = @"营业地址";
    addressLabel.font = [UIFont systemFontOfSize:15];
    [landView addSubview:addressLabel];

    UITextField *addressText = [[UITextField alloc]initWithFrame:CGRectMake(90, cityLabel1.bottom, SCREENWIDTH-90, 40)];
    //addressText.secureTextEntry = YES;
    self.addressText =addressText;
    addressText.font = [UIFont systemFontOfSize:15];
    addressText.placeholder = @"请输入您的具体营业地址";
    addressText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [landView addSubview:addressText];
    //店铺名称
    UILabel *redLabelName = [[UILabel alloc]initWithFrame:CGRectMake(10, addressLabel.bottom, 10, 40)];
    redLabelName.text = @"*";
    redLabelName.textColor = [UIColor redColor];
    redLabelName.font = [UIFont systemFontOfSize:15];
    [landView addSubview:redLabelName];
    //店铺名称
    UILabel *shopNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, addressLabel.bottom, 70, 40)];
    shopNameLabel.text = @"店铺名称";
    shopNameLabel.font = [UIFont systemFontOfSize:15];
    [landView addSubview:shopNameLabel];
    
    UITextField *shopNameText = [[UITextField alloc]initWithFrame:CGRectMake(90, addressText.bottom, SCREENWIDTH-90, 40)];
    //shopNameText.secureTextEntry = YES;
    self.shopNameText = shopNameText;
    shopNameText.font = [UIFont systemFontOfSize:15];
    shopNameText.placeholder = @"请输入您的店铺名称";
    shopNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [landView addSubview:shopNameText];
    UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(10+nameLabel.width+redLabel.width+1,  0,0.3, landView.height)];
    lines.backgroundColor = [UIColor grayColor];
    lines.alpha = 0.3;
    [landView addSubview:lines];
    //所属行业
    UILabel *redLabelTrade = [[UILabel alloc]initWithFrame:CGRectMake(10, shopNameLabel.bottom, 10, 40)];
    redLabelTrade.text = @"*";
    redLabelTrade.textColor = [UIColor redColor];
    redLabelTrade.font = [UIFont systemFontOfSize:15];
    [landView addSubview:redLabelTrade];
    //所属行业
    UILabel *tradeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, shopNameLabel.bottom, 70, 40)];
    tradeLabel.text = @"所属行业";
    tradeLabel.font = [UIFont systemFontOfSize:15];
    [landView addSubview:tradeLabel];
    
    UILabel *choiceTradeLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, shopNameLabel.bottom+5, 80, 30)];
    choiceTradeLabel.layer.borderWidth = 0.3;
    choiceTradeLabel.textAlignment = NSTextAlignmentCenter;
    self.choiceTradeLabel=choiceTradeLabel;
    if ([self.tradeString isEqualToString:@""]) {
    choiceTradeLabel.text = @"请选择";
    }
    else
        choiceTradeLabel.text = self.tradeString;
    
    NSLog(@"%@",choiceTradeLabel.text);
    choiceTradeLabel.font = [UIFont systemFontOfSize:13];
    [landView addSubview:choiceTradeLabel];
    UIButton *choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    choiceBtn.frame = CGRectMake(170, shopNameLabel.bottom+5, 20, 30);
    //    choseBtn.backgroundColor = [UIColor redColor];
    [choiceBtn setImage:[UIImage imageNamed:@"arraw_right"] forState:UIControlStateNormal];
    [choiceBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateSelected];
    [choiceBtn addTarget:self action:@selector(choiceTradeAction) forControlEvents:UIControlEventTouchUpInside];
    [landView addSubview:choiceBtn];
//    UIView *lines1 = [[UIView alloc]initWithFrame:CGRectMake(10+personLabel.width+1,0,  0.3, personLabel.height)];
//    lines1.backgroundColor = [UIColor grayColor];
//    lines1.alpha = 0.3;
//    [landView addSubview:lines1];
//    UIView *lines3 = [[UIView alloc]initWithFrame:CGRectMake(10+addressLabel.width+1,0,  0.3, addressLabel.height)];
//    lines3.backgroundColor = [UIColor grayColor];
//    lines3.alpha = 0.3;
//    [landView addSubview:lines3];
//    UIView *lines4 = [[UIView alloc]initWithFrame:CGRectMake(10+shopNameLabel.width+1,0,  0.3, shopNameLabel.height)];
//    lines4.backgroundColor = [UIColor grayColor];
//    lines4.alpha = 0.3;
//    [landView addSubview:lines4];

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, landView.width, 0.3)];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.3;
    [landView addSubview:line];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, nibText.bottom, landView.width, 0.3)];
    line1.backgroundColor = [UIColor grayColor];
    line1.alpha = 0.3;
    [landView addSubview:line1];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, proText.bottom, landView.width, 0.3)];
    line2.backgroundColor = [UIColor grayColor];
    line2.alpha = 0.3;
    [landView addSubview:line2];
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, addressText.bottom, landView.width, 0.3)];
    line3.backgroundColor = [UIColor grayColor];
    line3.alpha = 0.3;
    [landView addSubview:line3];
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, shopNameText.bottom, landView.width, 0.3)];
    line4.backgroundColor = [UIColor grayColor];
    line4.alpha = 0.3;
    [landView addSubview:line4];
    UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(0, tradeLabel.bottom, landView.width, 0.3)];
    line5.backgroundColor = [UIColor grayColor];
    line5.alpha = 0.3;
    [landView addSubview:line5];
    UIView *line6 = [[UIView alloc]initWithFrame:CGRectMake(0, cityLabel.bottom, landView.width, 0.3)];
    line6.backgroundColor = [UIColor grayColor];
    line6.alpha = 0.3;
    [landView addSubview:line6];
    UIButton *LandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    LandBtn.frame = CGRectMake(80, landView.bottom+10, SCREENWIDTH-160, 35);
    [LandBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [LandBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [LandBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [LandBtn setBackgroundColor:NavBackGroundColor];
    LandBtn.layer.cornerRadius = 10;
    [LandBtn addTarget:self action:@selector(moreInfoView) forControlEvents:UIControlEventTouchUpInside];
    LandBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:LandBtn];
    
    
    
}
- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 150)];
    self.demoView = demoView;
    demoView.frame=CGRectMake(0, 0, 290, 50);
    UILabel *numlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, demoView.width, 50)];
    numlabel.textAlignment = NSTextAlignmentCenter;
    numlabel.text = @"您通过在线用户推荐,入驻平台?";
    numlabel.font = [UIFont systemFontOfSize:16];
    [demoView addSubview:numlabel];
    return demoView;
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (alertView.tag==0&&buttonIndex==1) {
        self.personText.text = @"无人推荐";
        [alertView close];
    }
    else if (alertView.tag==0&&buttonIndex==0)
    {
        self.personText.text =@"";
        self.personText.placeholder = @"请输入您的推荐人";
            }
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
}

-(void)NewAddVipAction
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView]];
    
    // Modify the parameters

        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"是", @"否", nil]];

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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self NewAddVipAction];
    return YES;
}
-(void)choiceTradeAction
{
    if (self.ifOpen==NO) {
        UITableView *listTab = [[UITableView alloc]initWithFrame:CGRectMake(180, 220, SCREENWIDTH/3, SCREENHEIGHT/4) style:UITableViewStylePlain];
        listTab.dataSource = self;
        listTab.delegate = self;
        self.listTable = listTab;
        self.ifOpen = YES;
        //        listTab.alpha = 1;
        //    listTab.backgroundColor = [UIColor grayColor];
        [self.view addSubview:listTab];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tradeArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        //cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = [self.tradeArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.choiceTradeLabel.text = [self.tradeArray objectAtIndex:indexPath.row];;
    self.tradeString =[self.tradeArray objectAtIndex:indexPath.row];
    NSUserDefaults *trade_name = [NSUserDefaults standardUserDefaults];
    self.ifOpen = NO;
    [trade_name setObject:self.tradeString forKey:@"trade"];
    
    [trade_name synchronize];

    [self.listTable removeFromSuperview];
    [self.view reloadInputViews];
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string]; //定义一个NSScanner，扫描string
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
//是否包含特殊字符
-(BOOL)isIncludeSpecialCharact: (NSString *)str {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}
-(void)moreInfoView
{
//    LastRegistViewController *moreRegisVc = [[LastRegistViewController alloc]init];
//    moreRegisVc.phoneString = self.phoneString;
//    moreRegisVc.pswString = self.pswString;
//    moreRegisVc.nibNameString = self.nibText.text;
//    moreRegisVc.personString = self.personText.text;
//    moreRegisVc.addressString = self.addressText.text;
//    NSLog(@"propertyString%@",self.self.personText.text);
//    moreRegisVc.shopNameString = self.shopNameText.text;
//    moreRegisVc.tradeString = self.tradeString;
//    [self presentViewController:moreRegisVc animated:YES completion:nil];
    if ([self.nibText.text isEqualToString:@""]||[self.addressText.text isEqualToString:@""]||[self.shopNameText.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"信息填写不完整,请检查", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
    }else if ([self.nibText.text length]>32||[self isPureInt:self.nibText.text]||[self isIncludeSpecialCharact:self.nibText.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"昵称过长或包含特殊字符,请重新设置", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
    }
    else{
        LastRegistViewController *moreRegisVc = [[LastRegistViewController alloc]init];
        moreRegisVc.phoneString = self.phoneString;
        moreRegisVc.pswString = self.pswString;
        moreRegisVc.nibNameString = self.nibText.text;
        moreRegisVc.personString = self.personText.text;
        NSString *address = [[NSString alloc]initWithFormat:@"%@%@",self.cityLabel.text,self.addressText.text];
        moreRegisVc.addressString = address;
        NSLog(@"vvvvvvvvvvv%@",moreRegisVc.addressString);
        moreRegisVc.shopNameString = self.shopNameText.text;
        moreRegisVc.tradeString = self.tradeString;
        [self presentViewController:moreRegisVc animated:YES completion:nil];
    }
    //[self.navigationController pushViewController:moreRegisVc animated:YES];
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
