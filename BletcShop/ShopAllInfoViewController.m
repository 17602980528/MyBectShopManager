//
//  ShopAllInfoViewController.m
//  BletcShop
//
//  Created by Bletc on 16/6/24.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShopAllInfoViewController.h"
#import "PictureDetailViewController.h"
@interface ShopAllInfoViewController ()
@property(nonatomic,weak)UITextView *text1;
@property(nonatomic,weak)UITextField *tf1;
@property(nonatomic,weak)UITextField *tf2;
@property(nonatomic,weak)UITextView *text3;
@property(nonatomic,weak)UITextView *text4;
@property(nonatomic,weak)UITextView *text5;
@end

@implementation ShopAllInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"商家介绍";
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick)];
    self.navigationItem.rightBarButtonItem=item;
    [self postRequestGetInfo];
    [self initLayout];
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditingTextView)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // Do any additional setup after loading the view.
}
-(void)postRequestGetInfo
{

    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/Info/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"postRequestGetInfo%@", result);
        self.data = result;
        if (self.data.count>0) {
            self.text1.text=self.data[0][@"intro"];
            self.text3.text=self.data[0][@"service"];
            self.text4.text=self.data[0][@"notice"];
            self.text5.text=self.data[0][@"tip"];
            NSString *string=self.data[0][@"time"];
            NSArray *array=[string componentsSeparatedByString:@"-"];
            
            if (array.count>1) {
                self.tf1.text=array[0];
                self.tf2.text=array[1];
            }
            
        }
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
//上传商户信息
-(void)postRequestSetInfo{
    NSString *urlStr=[[NSString alloc]initWithFormat:@"%@MerchantType/Info/mod",BASEURL];
    NSMutableDictionary *userInfos=[NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    //NSLog(@"###########%@", appdelegate.shopUserInfoArray);
    [userInfos setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    
    NSString *newStr=[NSString stringWithFormat:@"%@-%@",self.tf1.text,self.tf2.text];
    [userInfos setObject:self.text1.text forKey:@"intro"];
    [userInfos setObject: newStr forKey:@"time"];
    [userInfos setObject:self.text3.text forKey:@"service"];
    [userInfos setObject:self.text4.text forKey:@"notice"];
    [userInfos setObject:self.text5.text forKey:@"tip"];
    [KKRequestDataService requestWithURL:urlStr params:userInfos httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"postRequestGetInfo%@", result);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"图片太大,上传失败", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:2.f];
        if ([[NSString stringWithFormat:@"%@",result[@"result_code"]] isEqualToString:@"1"]) {
            hud.label.text = NSLocalizedString(@"上传成功", @"HUD message title");
        }else{
            hud.label.text = NSLocalizedString(@"上传失败", @"HUD message title");
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)initLayout{
    UIView *grayView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 15)];
    grayView.backgroundColor=[UIColor lightGrayColor];
    grayView.alpha=0.5;
    [self.view addSubview:grayView];
    
    UIView *merchantIntroduceView=[[UIView alloc]initWithFrame:CGRectMake(0, 15, SCREENWIDTH, (SCREENHEIGHT-64-40)/5)];
    //merchantIntroduceView.backgroundColor=[UIColor redColor];
    [self.view addSubview:merchantIntroduceView];
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(20, merchantIntroduceView.height/2-10, 80, 20)];
    label1.text=@"商家简介:";
    [merchantIntroduceView addSubview:label1];
    
    UITextView *textView1=[[UITextView alloc]initWithFrame:CGRectMake(120, 5, SCREENWIDTH-120-10, merchantIntroduceView.height-10)];
    textView1.layer.borderWidth=1.0f;
    textView1.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    [merchantIntroduceView addSubview:textView1];
    self.text1=textView1;
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(20, merchantIntroduceView.height-1, SCREENWIDTH-40, 1)];
    line1.backgroundColor=[UIColor grayColor];
    line1.alpha=0.3;
    [merchantIntroduceView addSubview:line1];
    
    UIView *timeView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(merchantIntroduceView.frame), SCREENWIDTH, 40)];
    //timeView.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:timeView];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(20, timeView.height/2-10, 80, 20)];
    label2.text=@"营业时间:";
    [timeView addSubview:label2];
    
    UITextField *textField1=[[UITextField alloc]initWithFrame:CGRectMake(120, 5, textView1.width/2-15, 30)];
    textField1.layer.borderWidth=1.0f;
    textField1.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    textField1.placeholder=@"时:分";
    textField1.borderStyle=UITextBorderStyleLine;
    [timeView addSubview:textField1];
    self.tf1=textField1;
    
    UILabel *labelTo=[[UILabel alloc]initWithFrame:CGRectMake(textField1.right, 5, 30, 30)];
    labelTo.text=@"至";
    labelTo.textAlignment=1;
    [timeView addSubview:labelTo];
    
    UITextField *textfield2=[[UITextField alloc]initWithFrame:CGRectMake(labelTo.right, 5, textView1.width/2-15, 30)];
    textfield2.layer.borderWidth=1.0f;
    textfield2.layer.borderColor=[[UIColor grayColor]CGColor];
    textfield2.placeholder=@"时:分";
    textfield2.borderStyle=UITextBorderStyleLine;
    [timeView addSubview:textfield2];
    self.tf2=textfield2;
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(20, timeView.height-1, SCREENWIDTH-40, 1)];
    line2.backgroundColor=[UIColor grayColor];
    line2.alpha=0.3;
    [timeView addSubview:line2];
    
    UIView *serviceView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(timeView.frame), SCREENWIDTH, (SCREENHEIGHT-64-40)/5)];
    //serviceView.backgroundColor=[UIColor cyanColor];
    [self.view addSubview:serviceView];
    
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(20, serviceView.height/2-10, 80, 20)];
    label3.textAlignment=1;
    label3.text=@"门店服务:";
    [serviceView addSubview:label3];
    
    UITextView *textView3=[[UITextView alloc]initWithFrame:CGRectMake(120, 5, SCREENWIDTH-120-10, serviceView.height-10)];
    textView3.layer.borderWidth=1.0f;
    textView3.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    [serviceView addSubview:textView3];
    self.text3=textView3;
    
    UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(20, serviceView.height-1, SCREENWIDTH-40, 1)];
    line3.backgroundColor=[UIColor grayColor];
    line3.alpha=0.3;
    [serviceView addSubview:line3];
    
    UIView *payNoticeView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(serviceView.frame), SCREENWIDTH, (SCREENHEIGHT-64-40)/5)];
    //payNoticeView.backgroundColor=[UIColor orangeColor];
    [self.view addSubview:payNoticeView];
    
    UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(20, payNoticeView.height/2-10, 80, 20)];
    label4.textAlignment=1;
    label4.text=@"购买须知:";
    [payNoticeView addSubview:label4];
    
    UITextView *textView4=[[UITextView alloc]initWithFrame:CGRectMake(120, 5, SCREENWIDTH-120-10, payNoticeView.height-10)];
    textView4.layer.borderWidth=1.0f;
    textView4.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    [payNoticeView addSubview:textView4];
    self.text4=textView4;
    
    UIView *line4=[[UIView alloc]initWithFrame:CGRectMake(20, payNoticeView.height-1, SCREENWIDTH-40, 1)];
    line4.backgroundColor=[UIColor grayColor];
    line4.alpha=0.3;
    [payNoticeView addSubview:line4];
    
    UIView *noticeView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(payNoticeView.frame), SCREENWIDTH, (SCREENHEIGHT-64-40)/5)];
    //noticeView.backgroundColor=[UIColor purpleColor];
    [self.view addSubview:noticeView];
    
    UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(20, noticeView.height/2-10, 80, 20)];
    label5.textAlignment=1;
    label5.text=@"温馨提示:";
    [noticeView addSubview:label5];
    
    UITextView *textView5=[[UITextView alloc]initWithFrame:CGRectMake(120, 5, SCREENWIDTH-120-10, noticeView.height-10)];
    textView5.layer.borderWidth=1.0f;
    textView5.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    [noticeView addSubview:textView5];
    self.text5=textView5;
    
    UIView *line5=[[UIView alloc]initWithFrame:CGRectMake(20, noticeView.height-1, SCREENWIDTH-40, 1)];
    line5.backgroundColor=[UIColor grayColor];
    line5.alpha=0.3;
    [noticeView addSubview:line5];
    
    UIView *detaiView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(noticeView.frame), SCREENWIDTH, SCREENHEIGHT-CGRectGetMaxY(noticeView.frame))];
    //detaiView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:detaiView];
    
    UILabel *label6=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 80, 20)];
    label6.text=@"图文详情:";
    label6.textAlignment=1;
    [detaiView addSubview:label6];
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame=CGRectMake(SCREENWIDTH-100, 20, 70, 30);
    settingBtn.titleLabel.font=[UIFont systemFontOfSize:13.0f];
    [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
    settingBtn.backgroundColor=NavBackGroundColor;
    [settingBtn addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    settingBtn.layer.cornerRadius=5;
    settingBtn.clipsToBounds=YES;
    [detaiView addSubview:settingBtn];
}
//顶端rightbtn
-(void)btnClick{
    [self postRequestSetInfo];
    
}
//下端设置btn
-(void)setClick{
    PictureDetailViewController *picVC = [[PictureDetailViewController alloc]init];
    [self.navigationController pushViewController:picVC animated:YES ];
}

-(void)endEditingTextView{
    [self.view endEditing:YES];
}

@end
