//
//  NewLastViewController.m
//  BletcShop
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NewLastViewController.h"
#import "XieYiViewController.h"
#import "PointRuleViewController.h"
#import "ShopLandController.h"
#import "ToolManager.h"

@interface NewLastViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>
@end

@interface NewLastViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UIButton *tipButton;
    UITableView *_tableView;
    
    NSMutableDictionary *shopInfoDic;

}
@end

@implementation NewLastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"店铺认证";
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    NSDictionary*dic =[[NSUserDefaults standardUserDefaults]objectForKey:app.shopInfoDic[@"muid"]];
    
    shopInfoDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    NSLog(@"----------------------%@",shopInfoDic);
    
    [self initTopView];
    [self initTableView];
}
-(void)initTopView{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    navView.backgroundColor = NavBackGroundColor;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 18, 70, 44)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backRegist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
    [navView addSubview:btn];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 18, SCREENWIDTH, 44)];
    label.font=[UIFont systemFontOfSize:19.0f];
    label.text=@"预付保险认证";
    label.textAlignment=1;
    label.textColor=[UIColor whiteColor];
    [navView addSubview:label];
    UIView *landView = [[UIView alloc]initWithFrame:CGRectMake(0, (SCREENHEIGHT-300)/2, SCREENWIDTH, 240)];
    self.landView = landView;
    [self.view addSubview:landView];
    NSArray *numArray=@[@"1",@"2",@"3"];
    NSArray *nameArray=@[@"填写店主信息",@"填写店铺信息",@"注册完成"];
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(-1, 64, SCREENWIDTH+2, 44)];
    topView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    topView.layer.borderWidth=1;
    [self.view addSubview:topView];
    for (int i=0; i<3; i++) {
        UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(i%3*SCREENWIDTH/3, 0, SCREENWIDTH/3, 44)];
        backView.backgroundColor=[UIColor whiteColor];
        [topView addSubview:backView];
        
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, 20, 20)];
        label1.layer.cornerRadius=10;
        label1.clipsToBounds=YES;
        label1.text=numArray[i];
        label1.textColor=[UIColor whiteColor];
        label1.textAlignment=1;
        [backView addSubview:label1];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(30, 10, SCREENWIDTH/3-30, 20)];
        //label2.backgroundColor=[UIColor redColor];
        label2.text=nameArray[i];
        label2.font=[UIFont systemFontOfSize:12.0f];
        [backView addSubview:label2];
        if (i==2) {
            label2.textColor=[UIColor redColor];
            label1.backgroundColor=[UIColor redColor];
            UIView *slidView=[[UIView alloc]initWithFrame:CGRectMake(0, 36, SCREENWIDTH/3, 8)];
            slidView.backgroundColor=[UIColor redColor];
            [backView addSubview:slidView];
        }else{
            label2.textColor=[UIColor grayColor];
            label1.backgroundColor=[UIColor grayColor];
        }
    }
    
}
-(void)backRegist{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 108, SCREENWIDTH, SCREENHEIGHT-108)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    UITapGestureRecognizer *tapClick=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAndHidden)];
    [_tableView addGestureRecognizer:tapClick];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        UILabel *xingLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
        xingLab.tag=99;
        xingLab.font=[UIFont systemFontOfSize:20.0f];
        xingLab.textColor=[UIColor redColor];
        xingLab.textAlignment=1;
        xingLab.text=@"*";
        [cell addSubview:xingLab];
        //紧急联系人
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, SCREENWIDTH-30, 50)];
        label.tag=100;
        label.numberOfLines=0;
        label.font=[UIFont systemFontOfSize:15.0f];
        [cell addSubview:label];
        //姓名
        UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 50 , 50)];
        nameLab.tag=200;
        nameLab.font=[UIFont systemFontOfSize:15.0f];
        [cell addSubview:nameLab];
        UITextField *nameTF=[[UITextField alloc]initWithFrame:CGRectMake(80, 5, 90, 40)];
        nameTF.tag=300;
        nameTF.font=[UIFont systemFontOfSize:15.0f];
        nameTF.placeholder=@"请输入姓名";
        [cell addSubview:nameTF];
        //手机
        UILabel *phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(170, 0, 50, 50)];
        phoneLab.tag=400;
        phoneLab.font=[UIFont systemFontOfSize:15.0f];
        [cell addSubview:phoneLab];
        UITextField *phoneTF=[[UITextField alloc]initWithFrame:CGRectMake(220, 5, SCREENWIDTH-220, 40)];
        phoneTF.delegate=self;
        phoneTF.tag=500;
        phoneTF.font=[UIFont systemFontOfSize:15.0f];
        phoneTF.placeholder=@"请输入手机号";
        [cell addSubview:phoneTF];
        //上一步
        UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame=CGRectMake(SCREENWIDTH/2-110, 70, 100, 40);
        backBtn.tag=600;
        [cell addSubview:backBtn];
        backBtn.layer.cornerRadius=8.0f;
        backBtn.layer.borderColor=[[UIColor redColor]CGColor];
        backBtn.backgroundColor=[UIColor whiteColor];
        backBtn.layer.borderWidth=0.6;
        [backBtn setTitle:@"上一步" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backPrevious:) forControlEvents:UIControlEventTouchUpInside];
        //下一步
        UIButton *goNextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        goNextBtn.frame=CGRectMake(SCREENWIDTH/2+10, 70, 100, 40);
        goNextBtn.tag=700;
        [cell addSubview:goNextBtn];
        goNextBtn.layer.cornerRadius=8.0f;
        //goNextBtn.layer.borderColor=[[UIColor redColor]CGColor];
        goNextBtn.backgroundColor=[UIColor redColor];
        //goNextBtn.layer.borderWidth=0.6;
        [goNextBtn setTitle:@"立即认证" forState:UIControlStateNormal];
        [goNextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [goNextBtn addTarget:self action:@selector(goRegister:) forControlEvents:UIControlEventTouchUpInside];
        //复选框
        UIButton *chooseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        chooseBtn.tag=800;
        chooseBtn.frame=CGRectMake(50, 120, 20, 20);
        [chooseBtn setImage:[UIImage imageNamed:@"xuan"] forState:UIControlStateNormal];
        [chooseBtn setImage:[UIImage imageNamed:@"xuan1"] forState:UIControlStateSelected];
        chooseBtn.selected = YES;
        [chooseBtn addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:chooseBtn];
        //我已阅读。。。《》
        UILabel *readLable=[[UILabel alloc]initWithFrame:CGRectMake(75, 120, 135, 20)];
        readLable.font=[UIFont systemFontOfSize:13.0f];
        readLable.tag=900;
        readLable.textColor=[UIColor grayColor];
        readLable.text=@"我已阅读并同意商消乐";
        [cell addSubview:readLable];
        //协议名
        UILabel *agreeLable=[[UILabel alloc]initWithFrame:CGRectMake(205, 120, SCREENWIDTH-205, 20)];
        agreeLable.font=[UIFont systemFontOfSize:13.0f];
        agreeLable.tag=1000;
        agreeLable.textColor=[UIColor blueColor];
        agreeLable.text=@"《商户入驻协议》";
        [cell addSubview:agreeLable];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    UILabel *xing=[cell viewWithTag:99];
    UILabel *nickLab=[cell viewWithTag:100];
    UILabel *name=[cell viewWithTag:200];
    UITextField *nametf=[cell viewWithTag:300];
    UILabel *phone=[cell viewWithTag:400];
    UITextField *phonetf=[cell viewWithTag:500];
    UIButton *backBtn=[cell viewWithTag:600];
    UIButton *nextBtn=[cell viewWithTag:700];
    UIButton *chooseButton=[cell viewWithTag:800];
    UILabel *readLab=[cell viewWithTag:900];
    UILabel *agreeLab=[cell viewWithTag:1000];
    if (indexPath.row==0||indexPath.row==2||indexPath.row==4||indexPath.row==6) {
        xing.hidden=YES;
        nickLab.hidden=NO;
        name.hidden=YES;
        nametf.hidden=YES;
        phone.hidden=YES;
        phonetf.hidden=YES;
        backBtn.hidden=YES;
        nextBtn.hidden=YES;
        chooseButton.hidden=YES;
        readLab.hidden=YES;
        agreeLab.hidden=YES;
        if (indexPath.row==0) {
            nickLab.text=@"紧急联系人（直系亲属）";
        }else if (indexPath.row==2){
            nickLab.text=@"紧急联系人（直系亲属）";
        }else if (indexPath.row==4){
            nickLab.text=@"紧急联系人（其他联系人）";
        }else if (indexPath.row==6){
            nickLab.text=@"备注：授权贵公司在联系不到本人的情况下可联络本人紧急联系人";
            nickLab.font=[UIFont systemFontOfSize:13.0f];
            nickLab.textColor=[UIColor grayColor];
            backBtn.hidden=NO;
            nextBtn.hidden=NO;
            chooseButton.hidden=NO;
            tipButton=chooseButton;
            readLab.hidden=NO;
            agreeLab.hidden=NO;
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = agreeLab.frame;
            [button addTarget:self action:@selector(gotoWebview) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
            
//            UIGestureRecognizer *recognizer=[[UIGestureRecognizer alloc]initWithTarget:self action:@selector(gotoWebview)];
//            [agreeLab addGestureRecognizer:recognizer];
        }
    }else{
        xing.hidden=YES;
        nickLab.hidden=YES;
        nametf.hidden=NO;
        name.hidden=NO;
        name.text=@"姓名:";
        phone.hidden=NO;
        phone.text=@"手机:";
        phonetf.hidden=NO;
        phonetf.keyboardType=UIKeyboardTypeNumberPad;
        backBtn.hidden=YES;
        nextBtn.hidden=YES;
        chooseButton.hidden=YES;
        readLab.hidden=YES;
        agreeLab.hidden=YES;
        if (indexPath.row==1) {
            self.tf1=nametf;
            self.tf1.text=shopInfoDic[@"frel_name"];
            self.tf2=phonetf;
            self.tf2.text=shopInfoDic[@"frel_phone"];
        }
        if (indexPath.row==3) {
            self.tf3=nametf;
            self.tf3.text=shopInfoDic[@"srel_name"];
            self.tf4=phonetf;
            self.tf4.text=shopInfoDic[@"srel_phone"];
        }
        if (indexPath.row==5) {
            self.tf5=nametf;
            self.tf5.text=shopInfoDic[@"trel_name"];
            self.tf6=phonetf;
            self.tf6.text=shopInfoDic[@"trel_phone"];

        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==6) {
        return 200;
    }else{
        return 50;
    }
    return 50;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//返回上级页面
-(void)backPrevious:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view endEditing:YES];
}
//立即注册
-(void)goRegister:(UIButton *)sender{
    //加判断，信息完整则显示提交成功，等待审核－－－否则就提示信息不完整
    if (tipButton.selected==NO) {
        //MBProgressHUD *hud判断如果有一项没填就出提示
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"至少有一项信息填写不完成", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:4.f];
    }else{
        //此处已得到用户所有资料，可上传服务器
        if (self.tf2.text.length!=0 || self.tf4.text.length!=0||self.tf6.text.length!=0) {
            if ([ToolManager validateMobile:self.tf2.text] ||[ToolManager validateMobile:self.tf4.text] || [ToolManager validateMobile:self.tf6.text]) {
                [self saveInfomation];

                
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.frame = CGRectMake(0, 64, 375, 667);
                // Set the annular determinate mode to show task progress.
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"手机号码格式不对", @"HUD message title");
                hud.label.font = [UIFont systemFontOfSize:13];
                // Move to bottm center.
                //    hud.offset = CGPointMake(0.f, );
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                [hud hideAnimated:YES afterDelay:3.f];
            }
            
        }else{
            
            [self saveInfomation];

        }
        
        
    }
    
}

-(void)saveInfo{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [shopInfoDic setValue:self.tf1.text forKey:@"frel_name"];//联系人1
    [shopInfoDic setValue:self.tf2.text forKey:@"frel_phone"];//联系人1电话号
    [shopInfoDic setValue:self.tf3.text forKey:@"srel_name"];//联系人2
    [shopInfoDic setValue:self.tf4.text forKey:@"srel_phone"];//联系人2电话号
    [shopInfoDic setValue:self.tf5.text forKey:@"trel_name"];//联系人3
    [shopInfoDic setValue:self.tf6.text forKey:@"trel_phone"];//联系人3电话号
    
    [userDefault setObject:shopInfoDic forKey:shopInfoDic[@"muid"]];
    [userDefault synchronize];
    
    
}

//接口3
-(void)saveInfomation{
    
    [self saveInfo];
    
 
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/complete_03",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneStr forKey:@"phone"];
    [params setObject:self.tf1.text forKey:@"frel_name"];
    [params setObject:self.tf2.text forKey:@"frel_phone"];
    [params setObject:self.tf3.text forKey:@"srel_name"];
    [params setObject:self.tf4.text forKey:@"srel_phone"];
    [params setObject:self.tf5.text forKey:@"trel_name"];
    [params setObject:self.tf6.text forKey:@"trel_phone"];
   
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSDictionary *res_dic = (NSDictionary *)result;
        if ([res_dic[@"result_code"] integerValue]==1||[res_dic[@"result_code"] integerValue]==0) {
            
            UIAlertView *altView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您已认证成功是否重新登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [altView show];
        }
        
        NSLog(@"%@", result);
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];

    
}
//选择协议
-(void)chooseClick:(UIButton *)sender{

        sender.selected= !sender.selected;

}
//查看协议
-(void)gotoWebview{
    
    XieYiViewController *PointRuleView = [[XieYiViewController alloc]init];
    PointRuleView.type = 8888;
    
    
    [self presentViewController:PointRuleView animated:YES completion:nil];

}

-(void)tapAndHidden{
    [_tableView endEditing:YES];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    UIView *view = textField.superview;
    
    while (![view isKindOfClass:[UITableViewCell class]]) {
        
        view = [view superview];
        
    }
    
    UITableViewCell *cell = (UITableViewCell*)view;
    
    CGRect rect = [cell convertRect:cell.frame toView:self.view];
    
    if (rect.origin.y + rect.size.height>=SCREENHEIGHT-260) {
        
        //_tableView.contentInset = UIEdgeInsetsMake(0, 0, 216, 0);
        _tableView.frame=CGRectMake(0, 108, SCREENWIDTH, SCREENHEIGHT-108-260);
        
        [_tableView scrollToRowAtIndexPath:[_tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        
    }
    
    return YES;
}
//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    _tableView.frame =CGRectMake(0, 108, SCREENWIDTH, SCREENHEIGHT-108);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
        
        for (UIView *view in self.view.subviews) {
            [view removeFromSuperview];
        }
         ShopLandController *shopvc = [[ShopLandController alloc]init];
        
        AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        appdelegate.window.rootViewController = shopvc;

    }
}


@end
