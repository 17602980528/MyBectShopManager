//
//  SuccessController.m
//  BletcShop
//
//  Created by Yuan on 16/2/24.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "SuccessController.h"
#import "UserProtocolViewController.h"
#import "LandingController.h"
#import "PointRuleViewController.h"
#import "ToolManager.h"
@interface SuccessController ()<UITextFieldDelegate>
@property(nonatomic,weak)UIButton *OkBtn;
@property(nonatomic,weak)UITextField *nameText;
@property(nonatomic,weak)UITextField *Reftext;

@property(nonatomic,weak)UITextField *nameRealText;
@property(nonatomic,weak)UITextField *idCardtext;
@property(nonatomic,weak)UILabel *cityLabel1;
@property(nonatomic,weak)UITextField *addressText;
@end

@implementation SuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"完善信息";
    self.witchView = 0;
    //    打开触摸添加单击手势
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    NSLog(@"%@",_phoneNum);
    [self _initUI];
}
-(void)_initUI
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, SCREENWIDTH, 300)];
    //    topView.backgroundColor = [UIColor grayColor];`
    [self.view addSubview:topView];
    
    UIImageView *xingView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 8, 8)];
    xingView.image = [UIImage imageNamed:@"xing"];
    [topView addSubview:xingView];
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(xingView.right+5, 0, 40, 50)];
    //    nameLab.backgroundColor = [UIColor redColor];
    nameLab.text = @"昵称";
    
    nameLab.font = [UIFont systemFontOfSize:15];
    [topView addSubview:nameLab];
    UIView *Fen1 = [[UIView alloc]initWithFrame:CGRectMake(nameLab.width, 15, 1, nameLab.height-30)];
    Fen1.backgroundColor = [UIColor grayColor];
    Fen1.alpha = 0.3;
    [nameLab addSubview:Fen1];
    UITextField *nameText = [[UITextField alloc]initWithFrame:CGRectMake(nameLab.right+10, 0, topView.width-xingView.width-nameLab.width-35, 50)];
    nameText.delegate = self;
    //nameText.secureTextEntry = YES;
    nameText.font = [UIFont systemFontOfSize:15];
    nameText.placeholder = @"请设置您的昵称(不能为纯数字和包含特殊字符)";
    //    nameText.backgroundColor = [UIColor redColor];
    nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameText = nameText;
    [topView addSubview:nameText];
//    //推荐人
//    UIImageView *xingView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, nameLab.bottom+20, 8, 8)];
//    xingView1.image = [UIImage imageNamed:@"xing"];
//    [topView addSubview:xingView1];
//    UILabel *RefLab = [[UILabel alloc]initWithFrame:CGRectMake(xingView1.right+5, nameLab.bottom, 55, 50)];
//    RefLab.text = @"推荐人";
//    RefLab.font = [UIFont systemFontOfSize:15];
//    [topView addSubview:RefLab];
//    UIView *fen2 = [[UIView alloc]initWithFrame:CGRectMake(RefLab.right, nameLab.bottom+15, 1, RefLab.height-30)];
//    fen2.backgroundColor = [UIColor grayColor];
//    fen2.alpha = 0.3;
//    [topView addSubview:fen2];
//    UITextField *RefText = [[UITextField alloc]initWithFrame:CGRectMake(RefLab.right+10, nameText.bottom, topView.width-xingView1.width-RefLab.width-35, 50)];
//    //RefText.placeholder = @"推荐人用户名/手机号码";
//    RefText.font = [UIFont systemFontOfSize:15];
//    RefText.clearButtonMode = UITextFieldViewModeWhileEditing;
//    RefText.delegate = self;
//    self.Reftext = RefText;
//    [topView addSubview:RefText];
    //姓名
    UIImageView *xingView2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, nameLab.bottom+20, 8, 8)];
    xingView2.image = [UIImage imageNamed:@"xing"];
    [topView addSubview:xingView2];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(xingView2.right+5, nameLab.bottom, 65, 50)];
    nameLabel.text = @"真实姓名";
    nameLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:nameLabel];
    UIView *fen3 = [[UIView alloc]initWithFrame:CGRectMake(nameLabel.right, nameLab.bottom+15, 1, nameLab.height-30)];
    fen3.backgroundColor = [UIColor grayColor];
    fen3.alpha = 0.3;
    [topView addSubview:fen3];
    UITextField *nameRealText = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right+10, nameLab.bottom, topView.width-xingView2.width-nameLab.width-35, 50)];
    nameRealText.delegate = self;
    nameRealText.font = [UIFont systemFontOfSize:15];
    nameRealText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.nameRealText = nameRealText;
    [topView addSubview:nameRealText];
    //身份证
    UIImageView *xingView3 = [[UIImageView alloc]initWithFrame:CGRectMake(10, nameLabel.bottom+20, 8, 8)];
    xingView3.image = [UIImage imageNamed:@"xing"];
    [topView addSubview:xingView3];
    UILabel *idCardLabel = [[UILabel alloc]initWithFrame:CGRectMake(xingView2.right+5, nameRealText.bottom, 55, 50)];
    idCardLabel.text = @"身份证";
    idCardLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:idCardLabel];
    UIView *fen4 = [[UIView alloc]initWithFrame:CGRectMake(idCardLabel.right, nameLabel.bottom+15, 1, nameLab.height-30)];
    fen4.backgroundColor = [UIColor grayColor];
    fen4.alpha = 0.3;
    [topView addSubview:fen4];
    UITextField *idCardText = [[UITextField alloc]initWithFrame:CGRectMake(idCardLabel.right+10, nameRealText.bottom, topView.width-xingView2.width-nameLab.width-35, 50)];
    idCardText.delegate = self;
    //RefText.placeholder = @"推荐人用户名/手机号码";
    idCardText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    idCardText.font = [UIFont systemFontOfSize:15];
    idCardText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.idCardtext = idCardText;
    [topView addSubview:idCardText];
    //省市区
    UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, idCardText.bottom, 65, 50)];
    cityLabel.text = @"所在区域";
    cityLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:cityLabel];
    
    UIView *fen5 = [[UIView alloc]initWithFrame:CGRectMake(cityLabel.right, idCardLabel.bottom+15, 1, nameLab.height-30)];
    fen5.backgroundColor = [UIColor grayColor];
    fen5.alpha = 0.3;
    [topView addSubview:fen5];
    UILabel *cityLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(cityLabel.right+10, idCardText.bottom, topView.width-xingView2.width-cityLabel.width-35, 50)];
    cityLabel1.text = @"";
    cityLabel1.font = [UIFont systemFontOfSize:15];
    cityLabel1.userInteractionEnabled = YES;
    UIGestureRecognizer *tapGestureDate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceCity)];
    [cityLabel1 addGestureRecognizer:tapGestureDate];

    
    self.cityLabel1 = cityLabel1;
    [topView addSubview:cityLabel1];
    //具体地址
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, cityLabel1.bottom, 65, 50)];
    addressLabel.text = @"具体地址";
    addressLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:addressLabel];
    UIView *fen6 = [[UIView alloc]initWithFrame:CGRectMake(addressLabel.right, cityLabel.bottom+15, 1, nameLab.height-30)];
    fen6.backgroundColor = [UIColor grayColor];
    fen6.alpha = 0.3;
    [topView addSubview:fen6];
    UITextField *addressText = [[UITextField alloc]initWithFrame:CGRectMake(nameLab.right+10, cityLabel1.bottom, topView.width-xingView2.width-nameLab.width-35, 50)];
    addressText.delegate = self;
    addressText.text = @"";
    addressText.font = [UIFont systemFontOfSize:15];
    addressText.clearButtonMode = UITextFieldViewModeWhileEditing;
    //addressText.keyboardType = UIKeyboardTypeASCIICapable;
    
    
    self.addressText = addressText;
    [topView addSubview:addressText];
    //
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, topView.width, 0.3)];
    line1.backgroundColor = [UIColor grayColor];
    line1.alpha = 0.3;
    [topView addSubview:line1];
//    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, nameLab.bottom,topView.width, 0.3)];
//    line2.backgroundColor = [UIColor grayColor];
//    line2.alpha = 0.3;
//    [topView addSubview:line2];
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, nameLab.bottom, topView.width, 0.3)];
    line3.backgroundColor = [UIColor grayColor];
    line3.alpha = 0.3;
    [topView addSubview:line3];
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, nameLabel.bottom, topView.width, 0.3)];
    line4.backgroundColor = [UIColor grayColor];
    line4.alpha = 0.3;
    [topView addSubview:line4];
    UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(0, idCardText.bottom, topView.width, 0.3)];
    line5.backgroundColor = [UIColor grayColor];
    line5.alpha = 0.3;
    [topView addSubview:line5];
    UIView *line6 = [[UIView alloc]initWithFrame:CGRectMake(0, cityLabel.bottom, topView.width, 0.3)];
    line6.backgroundColor = [UIColor grayColor];
    line6.alpha = 0.3;
    [topView addSubview:line6];
    
    UIView *line7 = [[UIView alloc]initWithFrame:CGRectMake(0, addressLabel.bottom,topView.width, 0.3)];
    line7.backgroundColor = [UIColor grayColor];
    line7.alpha = 0.3;
    [topView addSubview:line7];
    
    UIButton *OkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    OkBtn.frame = CGRectMake(30, topView.bottom+20, SCREENWIDTH-60, 35);
    OkBtn.backgroundColor = NavBackGroundColor;
    OkBtn.layer.cornerRadius = 10;
    [OkBtn setTitle:@"立即完成" forState:UIControlStateNormal];
    [OkBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [OkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //OkBtn.enabled = YES;
    [OkBtn addTarget:self action:@selector(OkBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.OkBtn = OkBtn;
    [self.view addSubview:OkBtn];
    
    UIButton *ChoseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ChoseBtn.frame = CGRectMake(30, OkBtn.bottom+15, 15, 15);

    [ChoseBtn setImage:[UIImage imageNamed:@"xuan"] forState:UIControlStateNormal];
    [ChoseBtn setImage:[UIImage imageNamed:@"xuan1"] forState:UIControlStateSelected];
    ChoseBtn.selected = YES;

    [ChoseBtn addTarget:self action:@selector(ChoseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //    ChoseBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:ChoseBtn];
    
    UILabel *agreeLabe = [[UILabel alloc]initWithFrame:CGRectMake(ChoseBtn.right+1, OkBtn.bottom+15, 105, 15)];
    agreeLabe.text = @"我已阅读并同意商消乐";
    agreeLabe.textColor = [UIColor grayColor];
    agreeLabe.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:agreeLabe];
    UIButton *xieyiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xieyiBtn.frame = CGRectMake(agreeLabe.right, OkBtn.bottom+15, 85, 15);
    [xieyiBtn setTitle:@"《用户使用协议》" forState:UIControlStateNormal];
    [xieyiBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [xieyiBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    xieyiBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [xieyiBtn addTarget:self action:@selector(lookXieYiView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xieyiBtn];
    
}
-(void)lookXieYiView
{

    
    PointRuleViewController *PointRuleView = [[PointRuleViewController alloc]init];
    PointRuleView.type = 888;
    [self.navigationController pushViewController:PointRuleView animated:YES];

}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.toolbarCancelDone.hidden = YES;
    picker.hidden = YES;

    
   
    return YES;
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



-(void)ChoseAction:(UIButton *)btn
{
    btn.selected =! btn.selected;
    NSLog(@"勾选");
    if (btn.selected == YES) {
        self.OkBtn.enabled = YES;
        self.OkBtn.backgroundColor =  NavBackGroundColor;
    }else if(btn.selected == NO)
    {
        self.OkBtn.enabled = NO;
        self.OkBtn.backgroundColor = [UIColor grayColor];
    }
    
}

-(void)OkBtnAction
{
    if([self.nameText.text isEqualToString:@""]||[self.Reftext.text isEqualToString:@""]||[self.nameRealText.text isEqualToString:@""]||[self.idCardtext.text isEqualToString:@""])
    {
        
        [self textExample:@"请完整您的资料"];

    }else if([self isPureInt:self.nameText.text]||[self isIncludeSpecialCharact:self.nameText.text]||self.nameText.text.length>32)
    {
        
        [self textExample:@"昵称过长或包含特殊字符,请重新设置"];

    }else if(![ToolManager validateIdentityCard:self.idCardtext.text])
    {
        [self textExample:@"身份证格式不对,请重新输入"];
    }else{
        
        [self postRequest];
    }
}

//注册请求
-(void)postRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/complete",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneNum forKey:@"phone"];
    [params setObject:self.nameText.text forKey:@"nickname"];
    [params setObject:self.nameRealText.text forKey:@"name"];
    [params setObject:self.idCardtext.text forKey:@"id"];
    
    NSString *addressInfo = [[NSString alloc]initWithFormat:@"%@%@",self.cityLabel1.text,self.addressText.text];
    
    if ([addressInfo isEqualToString:@""]) {
        [params setObject:@"未设置" forKey:@"address"];
    }else
        [params setObject:addressInfo forKey:@"address"];
    
    NSLog(@"--%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        if ([result[@"result_code"] intValue]==1) {
            NSLog(@"成功");
            
  
            
            
            [self textExample:@"注册成功,请登录"];
            [self performSelector:@selector(popVC) withObject:nil afterDelay:2];
            
           
            
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
    }];
    
}
-(void)popVC{
    NSLog(@"===%@",self.navigationController.viewControllers);
    
    UIViewController *viewCtl = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:viewCtl animated:YES];
}
-(void)loadingView
{
    LandingController *landingView = [[LandingController alloc]init];
    [self.navigationController pushViewController:landingView animated:YES];
}
//-(void)postRequestLanding
//{
//    
//    //NSString *url = @"http://192.168.0.117/VipCard/user_login.php";
//    NSString *url =[[NSString alloc]initWithFormat:@"http://%@/VipCard/user_login.php",SOCKETHOST ];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:self.phoneNum forKey:@"user"];
//    [params setObject:self.passWord forKey:@"passwd"];
//    
//    //    if ([self isPureInt:self.userText.text] == YES) {
//    //        [params setObject:@"phone" forKey:@"sign"];
//    //    }else
//    //    {
//    //        [params setObject:@"nickname" forKey:@"sign"];
//    //    }
//    
//    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
//        
//        NSLog(@"%@", result);
//        if ([[result objectAtIndex:0]  isEqualToString: @"login_access"]) {
//            NSLog(@"成功");
//            [self landingSuc];
//            NSMutableArray *UserArr = [result objectAtIndex:1];//result[1];
//            NSString *UseName = [UserArr objectAtIndex:0];
//            NSUserDefaults *use_name = [NSUserDefaults standardUserDefaults];
//            
//            NSLog(@"%@",UserArr);
//            //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            
//            [use_name setObject:[UserArr objectAtIndex:1] forKey:@"userID"];
//            [use_name setObject:[UserArr objectAtIndex:2] forKey:@"userToken"];
//            NSLog(@"%@",[UserArr objectAtIndex:1]);
//            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//            appdelegate.userInfoArray = UserArr;
//            appdelegate.IsLogin = YES;
//            [appdelegate socketConnectHost];
//            
//            [use_name setValue:UseName forKey:@"usename"];
//            [use_name synchronize];
//            [self.navigationController popViewControllerAnimated:YES];
//            
//        }
//        //        else if ([[result objectAtIndex:0] isEqualToString:@"passwd_wrong"])
//        //        {
//        //            [self passwd_wrong];
//        //        }else
//        //        {
//        //            [self use_notfound];
//        //        }
//    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //[self noIntenet];
//        NSLog(@"%@", error);
//    }];
//    
//}
//登录成功提示
- (void)landingSuc
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"登录成功", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:2.f];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    
    [self.view endEditing:YES];
    [self.nameText resignFirstResponder];
    [self.nameRealText resignFirstResponder];
    [self.Reftext resignFirstResponder];
    [self.idCardtext resignFirstResponder];
    [self.addressText resignFirstResponder];
    
    
}

-(void)choiceCity
{
    [self.nameText resignFirstResponder];
    [self.nameRealText resignFirstResponder];
    [self.Reftext resignFirstResponder];
    [self.idCardtext resignFirstResponder];
    [self.addressText resignFirstResponder];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"areaAll" ofType:@"plist"];
    areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    province = [[NSArray alloc] initWithArray: provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    
    NSString *selectedCity = [city objectAtIndex: 0];
    district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    
    
    if (picker==nil) {
        picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, SCREENHEIGHT-64-160, SCREENWIDTH, 146)];
    }
    
    picker.backgroundColor = tableViewBackgroundColor;
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    [picker selectRow: 0 inComponent: 0 animated: YES];
    [self.view addSubview: picker];
    if (self.toolbarCancelDone==nil) {
        self.toolbarCancelDone = [[UIToolbar alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-200-64, SCREENWIDTH, 40)];
    }
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREENWIDTH-60, 0, 60, 40);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    //[okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [okBtn addTarget:self action:@selector(actionDone) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbarCancelDone addSubview:okBtn];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 60, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbarCancelDone addSubview:cancelBtn];
    
    [self.view addSubview:self.toolbarCancelDone];
    selectedProvince = [province objectAtIndex: 0];
    picker.hidden = NO;
    self.toolbarCancelDone.hidden = NO;
//    button = [UIButton buttonWithType: 100];
//    [button setTitle: @"测试PickerView效果" forState: UIControlStateNormal];
//    [button setFrame: CGRectMake(160-button.bounds.size.width/2, 320, button.bounds.size.width, button.bounds.size.height)];
//    [button setTintColor: [UIColor grayColor]];
//    [button addTarget: self action: @selector(buttobClicked:) forControlEvents: UIControlEventTouchUpInside];
//    [self.view addSubview: button];
}
- (void)actionCancel
{
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         picker.hidden = YES;
                         self.toolbarCancelDone.hidden = YES;
                         
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
}

- (void)actionDone
{

            self.cityLabel1.text = [NSString stringWithFormat:@"%@%@%@",[province objectAtIndex:[picker selectedRowInComponent:0]],[city objectAtIndex:[picker selectedRowInComponent:1]],[district objectAtIndex:[picker selectedRowInComponent:2]]];

    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         picker.hidden = YES;
                         self.toolbarCancelDone.hidden = YES;
                         
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    
    
}
#pragma mark- Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province count];
    }
    else if (component == CITY_COMPONENT) {
        return [city count];
    }
    else {
        return [district count];
    }
}


#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province objectAtIndex: row];
    }
    else if (component == CITY_COMPONENT) {
        return [city objectAtIndex: row];
    }
    else {
        return [district objectAtIndex: row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        selectedProvince = [province objectAtIndex: row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", (long)row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        
        city = [[NSArray alloc] initWithArray: array];
        
        
        NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [city objectAtIndex: 0]]];
        [picker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [picker reloadComponent: CITY_COMPONENT];
        [picker reloadComponent: DISTRICT_COMPONENT];
        
    }
    else if (component == CITY_COMPONENT) {
        NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[province indexOfObject: selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        [picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [picker reloadComponent: DISTRICT_COMPONENT];
    }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return 80;
    }
    else if (component == CITY_COMPONENT) {
        return 100;
    }
    else {
        return 115;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [province objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [city objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [district objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
}


//提示遮罩
- (void)textExample:(NSString *)tishi {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(tishi, @"HUD message title");
    
    hud.label.font = [UIFont systemFontOfSize:13];
    [hud hideAnimated:YES afterDelay:1];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
