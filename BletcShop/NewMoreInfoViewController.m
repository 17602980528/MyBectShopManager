//
//  NewMoreInfoViewController.m
//  BletcShop
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NewMoreInfoViewController.h"
#import "NewLastViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"

@interface NewMoreInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    NSArray *nameArray;
    CGFloat totalHeight;
    UITableView *_tableView;
    UITableView *_areaTableView;
    NSData *imageData;
    NSData *imageData2;
}
@end

@implementation NewMoreInfoViewController
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    
    NSLog(@"执行图片下载函数");
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    NSLog(@"yyyyy%lu",(unsigned long)data.length);
    result = [UIImage imageWithData:data];
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"店铺认证";
    self.state1=NO;
    self.state2=NO;
    self.state3=NO;
    self.state4=NO;
    self.state5=NO;
    self.state6=NO;
//    self.ifImageView1=NO;
//    self.ifImageView2=NO;
//    self.ifImageView3=NO;
//    self.ifImageView4=NO;
//    self.ifImageView5=NO;
//    self.ifImageView6=NO;
    [self initTopView];
    [self initTableView];
    self.indexTag=0;
}

-(void)initTopView{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    navView.backgroundColor = NavBackGroundColor;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 18, 70, 44)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backRegist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
    [navView addSubview:btn];
    //右边加一个保存按钮
    UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-70, 18,70, 44)];
    [btns setTitle:@"保存" forState:UIControlStateNormal];
    [btns addTarget:self action:@selector(saveBtnlick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
    [navView addSubview:btns];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-50, 18, 100, 44)];
    label.font=[UIFont systemFontOfSize:19.0f];
    label.text=@"店铺认证";
    label.textAlignment=1;
    label.textColor=[UIColor whiteColor];
    [navView addSubview:label];
    UIView *landView = [[UIView alloc]initWithFrame:CGRectMake(0, (SCREENHEIGHT-300)/2, SCREENWIDTH, 240)];
    self.landView = landView;
    [self.view addSubview:landView];
    NSArray *numArray=@[@"1",@"2",@"3"];
    NSArray *nameArrays=@[@"填写店主信息",@"填写店铺信息",@"注册完成"];
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
        label2.text=nameArrays[i];
        label2.font=[UIFont systemFontOfSize:12.0f];
        [backView addSubview:label2];
        if (i==1) {
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

//返回上一层
-(void)backRegist
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view endEditing:YES];
    [_tableView endEditing:YES];
}

-(void)initTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 108, SCREENWIDTH, SCREENHEIGHT-108)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    nameArray=@[@"当前地区",@"详细地址",@"单位名称",@"所属行业",@"营业执照",@"",@"法人照片",@"经营场地照片  ",@"营业地水电票",@""];
    UITapGestureRecognizer *tapClick=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAndHidden)];
    tapClick.delegate=self;
    [_tableView addGestureRecognizer:tapClick];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_areaTableView) {
        return self.tradeArray.count;
    }else{
        return 10;
    }
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_areaTableView) {
        
        UITableViewCell *cell2=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell2==nil) {
            cell2=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell2"];
            cell2.backgroundColor=[UIColor cyanColor];
            cell2.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell2.textLabel.text=self.tradeArray[indexPath.row];
        cell2.textLabel.font=[UIFont systemFontOfSize:13.0f];
        return cell2;
    }else{
        static NSString *cellIndentifier = @"cellIndentifier";
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row==0) {
            UILabel *xingLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
            xingLab.tag=99;
            xingLab.font=[UIFont systemFontOfSize:20.0f];
            xingLab.textColor=[UIColor redColor];
            xingLab.textAlignment=1;
            xingLab.text=@"*";
            [cell addSubview:xingLab];
            //名称
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 110, 50)];
            label.tag=100;
            label.font=[UIFont systemFontOfSize:15.0f];
            label.text=@"当前地区";
            [cell addSubview:label];
            //定位到的区域
            UILabel *areaLab=[[UILabel alloc]initWithFrame:CGRectMake(140, 5, SCREENWIDTH-140, 40)];
            areaLab.tag=300;
            areaLab.font=[UIFont systemFontOfSize:15.0f];
            areaLab.textColor=[UIColor grayColor];
            [cell addSubview:areaLab];
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            if (appdelegate.province==nil||[appdelegate.province isEqualToString:@"(null)"]) {
                appdelegate.province = @"";
            }if (appdelegate.city==nil||[appdelegate.city isEqualToString:@"(null)"]) {
                appdelegate.city = @"";
            }if (appdelegate.addressDistrite==nil||[appdelegate.addressDistrite isEqualToString:@"(null)"]) {
                appdelegate.addressDistrite = @"";
            }
            areaLab.text=[[NSString alloc] initWithFormat:@"%@%@%@",appdelegate.province,appdelegate.city,appdelegate.addressDistrite];
            self.locationLab=areaLab;
        }else if (indexPath.row==1){
            UILabel *xingLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
            xingLab.tag=99;
            xingLab.font=[UIFont systemFontOfSize:20.0f];
            xingLab.textColor=[UIColor redColor];
            xingLab.textAlignment=1;
            xingLab.text=@"*";
            [cell addSubview:xingLab];
            //名称
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 110, 50)];
            label.tag=100;
            label.font=[UIFont systemFontOfSize:15.0f];
            label.text=@"详细地址";
            [cell addSubview:label];
            //输入框
            UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(140, 5, SCREENWIDTH-140, 40)];
            textField.tag=331;

            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"seller_rr"]&&![[[NSUserDefaults standardUserDefaults]objectForKey:@"seller_rr"] isEqualToString:@""]) {
                textField.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"seller_rr"];
                self.detailAddressTF=textField;
            }else{
                if (![self.detailAddressTF.text isEqualToString:@""]) {
                    textField.text=self.detailAddressTF.text;
                }else{
                    textField.placeholder=@"单位地址";
                }
                self.detailAddressTF=textField;
            }
            
            textField.font=[UIFont systemFontOfSize:13.0f];
            [cell addSubview:textField];
            
            
        }else if (indexPath.row==2){
            UILabel *xingLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
            xingLab.tag=99;
            xingLab.font=[UIFont systemFontOfSize:20.0f];
            xingLab.textColor=[UIColor redColor];
            xingLab.textAlignment=1;
            xingLab.text=@"*";
            [cell addSubview:xingLab];
            //名称
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 110, 50)];
            label.tag=100;
            label.text=@"单位名称";
            label.font=[UIFont systemFontOfSize:15.0f];
            [cell addSubview:label];
            //输入框
            UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(140, 5, SCREENWIDTH-140, 40)];
            textField.tag=332;
            
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"sellerstore"]&&![[[NSUserDefaults standardUserDefaults]objectForKey:@"sellerstore"] isEqualToString:@""]) {
                textField.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"sellerstore"];
                self.agencyNameTF=textField;
            }else{
                if (![self.agencyNameTF.text isEqualToString:@""]) {
                    textField.text=self.agencyNameTF.text;
                }else{
                    textField.placeholder=@"单位名称";
                }
                self.agencyNameTF=textField;
            }
            
            textField.font=[UIFont systemFontOfSize:13.0f];
            [cell addSubview:textField];
            
        }else if (indexPath.row==3){
            UILabel *xingLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
            xingLab.tag=99;
            xingLab.font=[UIFont systemFontOfSize:20.0f];
            xingLab.textColor=[UIColor redColor];
            xingLab.textAlignment=1;
            xingLab.text=@"*";
            [cell addSubview:xingLab];
            //名称
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 110, 50)];
            label.tag=100;
            label.text=@"所属行业";
            label.font=[UIFont systemFontOfSize:15.0f];
            [cell addSubview:label];
            //所属行业选择
            UILabel *chooseLable=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, 100, 30)];
            chooseLable.tag=400;
            chooseLable.font=[UIFont systemFontOfSize:13.0f];
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"seller_trade"]&&![[[NSUserDefaults standardUserDefaults]objectForKey:@"seller_trade"]isEqualToString:@""]) {
                chooseLable.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"seller_trade"];
                self.kindLab=chooseLable;
            }else{
                if (![self.kindLab.text isEqualToString:@""]) {
                    chooseLable.text=self.kindLab.text;
                    NSLog(@"%@",self.kindLab.text);
                }else{
                    chooseLable.text=@"请选择";
                }
                self.kindLab=chooseLable;
            }
            
            chooseLable.layer.borderColor=[[UIColor grayColor]CGColor];
            chooseLable.layer.borderWidth=1;
            chooseLable.userInteractionEnabled=YES;
            [cell addSubview:chooseLable];
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapChooseClick:)];
            [chooseLable addGestureRecognizer:tap];
            UIImageView *zijieImage=[[UIImageView alloc]initWithFrame:CGRectMake(185, 15, 20, 20)];
            zijieImage.image=[UIImage imageNamed:@"zijie"];
            zijieImage.tag=10000;
            [cell addSubview:zijieImage];
        }else if (indexPath.row==4){
            UILabel *xingLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
            xingLab.tag=99;
            xingLab.font=[UIFont systemFontOfSize:20.0f];
            xingLab.textColor=[UIColor redColor];
            xingLab.textAlignment=1;
            xingLab.text=@"*";
            [cell addSubview:xingLab];
            //名称
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 110, 50)];
            label.tag=100;
            label.text=@"营业执照";
            label.font=[UIFont systemFontOfSize:15.0f];
            [cell addSubview:label];
            //营业执照下的有无
            UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame=CGRectMake(30, 50, 80, 25);
            btn1.backgroundColor=[UIColor redColor];
            btn1.tag=500;
            btn1.layer.cornerRadius=5.0f;
            btn1.titleLabel.font=[UIFont systemFontOfSize:15.0f];
            [btn1 setTitle:@"有" forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell addSubview:btn1];
            [btn1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
            self.haveBtn=btn1;
            self.haveBtn.selected=YES;
            //无
            UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
            btn2.frame=CGRectMake(30, 85, 80, 25);
            btn2.backgroundColor=[UIColor lightGrayColor];
            btn2.tag=600;
            btn2.layer.cornerRadius=5.0f;
            btn2.titleLabel.font=[UIFont systemFontOfSize:15.0f];
            [btn2 setTitle:@"无" forState:UIControlStateNormal];
            [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell addSubview:btn2];
            [btn2 addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
            self.noneBtn=btn2;
            UIImageView *headImageView1=[[UIImageView alloc]initWithFrame:CGRectMake(120, 20, (SCREENWIDTH-150)/2, ((SCREENWIDTH-150)/2)*116/176)];
            headImageView1.tag=700;
            headImageView1.userInteractionEnabled=YES;
            
            [cell addSubview:headImageView1];
            UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            [headImageView1 addGestureRecognizer:tapGesture1];
            self.imageView1=headImageView1;
            //设state判断是否已经运行过一次
            
            NSString *name = [[[NSString alloc]initWithFormat:@"http://101.201.100.191/VipCard/upload/MerchantImage/licenseImage/%@_%@.png",[[NSUserDefaults standardUserDefaults]objectForKey:@"sellerNickName"],self.phoneStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:name] placeholderImage:[UIImage imageNamed:@"mohu-09"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"------%@",image);
                if (image) {
                    self.ifImageView1=YES;
                }else{
                    self.ifImageView1=NO;
                }

            }];
            
//            if (self.state1==NO) {
//                NSString *name = [[[NSString alloc]initWithFormat:@"http://101.201.100.191/VipCard/upload/MerchantImage/licenseImage/%@_%@.png",[[NSUserDefaults standardUserDefaults]objectForKey:@"sellerNickName"],self.phoneStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                
//                UIImage *image= [self getImageFromURL:name];
//                if (image) {
//                    self.ifImageView1=YES;
//                    [self.imageView1 setImage:image];
//                }else{
//                    self.ifImageView1=NO;
//                }
//                self.state1=YES;
//            }
            
//            if (self.ifImageView1==NO) {
//                headImageView1.image=[UIImage imageNamed:@"mohu-09"];
//            }else{
//                headImageView1.image=self.imageView1.image;
//            }
            //照片下端红色文字
            UILabel *underLab=[[UILabel alloc]initWithFrame:CGRectMake(120, 20+((SCREENWIDTH-150)/2)*116/176, (SCREENWIDTH-150)/2, 40)];
            underLab.tag=900;
            underLab.text=@"营业执照照片";
            underLab.font=[UIFont systemFontOfSize:15.0f];
            underLab.textColor=[UIColor redColor];
            underLab.textAlignment=1;
            [cell addSubview:underLab];
            //无营业执照时的textfield
            UITextField *propertyText=[[UITextField alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 20, (SCREENWIDTH-150)/2, ((SCREENWIDTH-150)/2)*116/176)];
            propertyText.placeholder=@"关于营业执照情况说明";
            propertyText.tag=20000;
            propertyText.layer.borderWidth=1;
            propertyText.layer.borderColor=[[UIColor grayColor]CGColor];
            propertyText.font=[UIFont systemFontOfSize:13.0f];
            [cell addSubview:propertyText];
            if (![self.reasonTF.text isEqualToString:@""]) {
                propertyText.text=self.reasonTF.text;
            }else{
                propertyText.placeholder=@"营业执照情况说明";
            }
            self.reasonTF=propertyText;
            self.reasonTF.delegate=self;
            totalHeight=80+((SCREENWIDTH-150)/2)*116/176;
            
        }else if (indexPath.row==5){
            UILabel *xingLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
            xingLab.tag=99;
            xingLab.font=[UIFont systemFontOfSize:20.0f];
            xingLab.textColor=[UIColor redColor];
            xingLab.textAlignment=1;
            xingLab.text=@"*";
            [cell addSubview:xingLab];
            //营业执照下的有无
            UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame=CGRectMake(30, 20, 85, 25);
            btn1.backgroundColor=[UIColor redColor];
            btn1.tag=501;
            btn1.layer.cornerRadius=5.0f;
            btn1.titleLabel.font=[UIFont systemFontOfSize:15.0f];
            [btn1 setTitle:@"租赁合同" forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell addSubview:btn1];
            [btn1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
            self.agreeBtn1=btn1;
            //无
            UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
            btn2.frame=CGRectMake(30, 55, 85, 25);
            btn2.backgroundColor=[UIColor lightGrayColor];
            btn2.tag=601;
            btn2.layer.cornerRadius=5.0f;
            btn2.titleLabel.font=[UIFont systemFontOfSize:15.0f];
            [btn2 setTitle:@"房产证明" forState:UIControlStateNormal];
            [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell addSubview:btn2];
            [btn2 addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
            self.agreeBtn2=btn2;
            UIImageView *headImageView1=[[UIImageView alloc]initWithFrame:CGRectMake(120, 20, (SCREENWIDTH-150)/2, ((SCREENWIDTH-150)/2)*116/176)];
            headImageView1.tag=701;
            headImageView1.userInteractionEnabled=YES;
            
            [cell addSubview:headImageView1];
            UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            [headImageView1 addGestureRecognizer:tapGesture1];
            self.imageView2=headImageView1;
            
            
            NSString *name = [[[NSString alloc]initWithFormat:@"http://101.201.100.191/VipCard/upload/MerchantImage/tenancyImage/%@_%@_01.png",[[NSUserDefaults standardUserDefaults]objectForKey:@"sellerNickName"],self.phoneStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            
            [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:name] placeholderImage:[UIImage imageNamed:@"mohu-10"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"------%@",image);
                if (image) {
                    self.ifImageView2=YES;
                }else{
                    self.ifImageView2=NO;
                }
                
            }];

//            if (self.state2==NO) {
//                NSString *name = [[[NSString alloc]initWithFormat:@"http://101.201.100.191/VipCard/upload/MerchantImage/tenancyImage/%@_%@_01.png",[[NSUserDefaults standardUserDefaults]objectForKey:@"sellerNickName"],self.phoneStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                
//                UIImage *image= [self getImageFromURL:name];
//                if (image) {
//                    self.ifImageView2=YES;
//                    [self.imageView2 setImage:image];
//                }else{
//                    self.ifImageView2=NO;
//                }
//                self.state2=YES;
//            }
//            
//            if (self.ifImageView2==NO) {
//                headImageView1.image=[UIImage imageNamed:@"mohu-10"];
//            }else{
//                headImageView1.image=self.imageView2.image;
//            }
            
            //照片下端红色文字
            UILabel *underLab=[[UILabel alloc]initWithFrame:CGRectMake(120, 20+((SCREENWIDTH-150)/2)*116/176, (SCREENWIDTH-150)/2, 40)];
            underLab.tag=900;
            underLab.text=@"租赁合同首页";
            underLab.font=[UIFont systemFontOfSize:15.0f];
            underLab.textColor=[UIColor redColor];
            underLab.textAlignment=1;
            [cell addSubview:underLab];
            self.houseProvide1=underLab;
            UIImageView *headImageView2=[[UIImageView alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 20, (SCREENWIDTH-150)/2, ((SCREENWIDTH-150)/2)*116/176)];
            headImageView2.tag=800;
            headImageView2.userInteractionEnabled=YES;
            [cell addSubview:headImageView2];
            UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            [headImageView2 addGestureRecognizer:tapGesture2];
            self.imageView3=headImageView2;
            
            NSString *name2 = [[[NSString alloc]initWithFormat:@"http://101.201.100.191/VipCard/upload/MerchantImage/tenancyImage/%@_%@_02.png",[[NSUserDefaults standardUserDefaults]objectForKey:@"sellerNickName"],self.phoneStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            DebugLog(@"name2----%@",name2);
            
            [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:name2] placeholderImage:[UIImage imageNamed:@"mohu-11"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"------%@",imageURL);
                if (image) {
                    self.ifImageView3=YES;
                }else{
                    self.ifImageView3=NO;
                }
                
            }];
            
//            if (self.state3==NO) {
//                NSString *name2 = [[[NSString alloc]initWithFormat:@"http://101.201.100.191/VipCard/upload/MerchantImage/tenancyImage/%@_%@_02.png",[[NSUserDefaults standardUserDefaults]objectForKey:@"sellerNickName"],self.phoneStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                
//                UIImage *image2= [self getImageFromURL:name2];
//                if (image2) {
//                    self.ifImageView3=YES;
//                    [self.imageView3 setImage:image2];
//                }else{
//                    self.ifImageView3=NO;
//                }
//                self.state3=YES;
//            }
//            
//            if (self.ifImageView3==NO) {
//                headImageView2.image=[UIImage imageNamed:@"mohu-11"];
//
//            }else{
//                headImageView2.image=self.imageView3.image;
//            }
            
            UILabel *underRightLab=[[UILabel alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 20+((SCREENWIDTH-150)/2)*116/176, (SCREENWIDTH-150)/2, 40)];
            underRightLab.tag=1000;
            underRightLab.text=@"租赁合同尾页";
            underRightLab.font=[UIFont systemFontOfSize:15.0f];
            underRightLab.textAlignment=1;
            underRightLab.textColor=[UIColor redColor];
            [cell addSubview:underRightLab];
            self.houseProvide2=underRightLab;
            
        }else if (indexPath.row==6){
            UILabel *xingLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
            xingLab.tag=99;
            xingLab.font=[UIFont systemFontOfSize:20.0f];
            xingLab.textColor=[UIColor redColor];
            xingLab.textAlignment=1;
            xingLab.text=@"*";
            [cell addSubview:xingLab];
            //名称
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 110, 50)];
            label.tag=100;
            label.text=@"法人照片";
            label.font=[UIFont systemFontOfSize:15.0f];
            [cell addSubview:label];
            UIImageView *headImageView2=[[UIImageView alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 20, (SCREENWIDTH-150)/2, ((SCREENWIDTH-150)/2)*116/176)];
            headImageView2.tag=801;
            
            headImageView2.userInteractionEnabled=YES;
            [cell addSubview:headImageView2];
            UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            [headImageView2 addGestureRecognizer:tapGesture2];
            self.imageView4=headImageView2;
            
            NSString *name2 = [[[NSString alloc]initWithFormat:@"http://101.201.100.191/VipCard/upload/MerchantImage/lpImage/%@_%@.png",[[NSUserDefaults standardUserDefaults]objectForKey:@"sellerNickName"],self.phoneStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            [self.imageView4 sd_setImageWithURL:[NSURL URLWithString:name2] placeholderImage:[UIImage imageNamed:@"mohu-12"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"------%@",image);
                if (image) {
                    self.ifImageView4=YES;
                }else{
                    self.ifImageView4=NO;
                }
                
            }];

//            if (self.state4==NO) {
//                NSString *name2 = [[[NSString alloc]initWithFormat:@"http://101.201.100.191/VipCard/upload/MerchantImage/lpImage/%@_%@.png",[[NSUserDefaults standardUserDefaults]objectForKey:@"sellerNickName"],self.phoneStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                
//                UIImage *image2= [self getImageFromURL:name2];
//                if (image2) {
//                    self.ifImageView4=YES;
//                    [self.imageView4 setImage:image2];
//                }else{
//                    self.ifImageView4=NO;
//                }
//                self.state4=YES;
//            }
//            
//            if (self.ifImageView4==NO) {
//                headImageView2.image=[UIImage imageNamed:@"mohu-12"];
//            }else{
//                headImageView2.image=self.imageView4.image;
//            }

            UILabel *underRightLab=[[UILabel alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 20+((SCREENWIDTH-150)/2)*116/176, (SCREENWIDTH-150)/2, 40)];
            underRightLab.tag=1000;
            underRightLab.text=@"法人正面照片";
            underRightLab.font=[UIFont systemFontOfSize:15.0f];
            underRightLab.textAlignment=1;
            underRightLab.textColor=[UIColor redColor];
            [cell addSubview:underRightLab];
        }else if (indexPath.row==7){
            UILabel *xingLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
            xingLab.tag=99;
            xingLab.font=[UIFont systemFontOfSize:20.0f];
            xingLab.textColor=[UIColor redColor];
            xingLab.textAlignment=1;
            xingLab.text=@"*";
            [cell addSubview:xingLab];
            //名称
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 110, 50)];
            label.tag=100;
            label.text=@"经营场地图片";
            label.font=[UIFont systemFontOfSize:15.0f];
            [cell addSubview:label];
            UIImageView *headImageView2=[[UIImageView alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 20, (SCREENWIDTH-150)/2, ((SCREENWIDTH-150)/2)*116/176)];
            headImageView2.tag=802;
            
            headImageView2.userInteractionEnabled=YES;
            [cell addSubview:headImageView2];
            UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            [headImageView2 addGestureRecognizer:tapGesture2];
            self.imageView5=headImageView2;
            
            NSString *name2 = [[[NSString alloc]initWithFormat:@"http://101.201.100.191/VipCard/upload/MerchantImage/addImage/%@_%@.png",[[NSUserDefaults standardUserDefaults]objectForKey:@"sellerNickName"],self.phoneStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            [self.imageView5 sd_setImageWithURL:[NSURL URLWithString:name2] placeholderImage:[UIImage imageNamed:@"mohu-13"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (image) {
                    self.ifImageView5=YES;
                }else{
                    self.ifImageView5=NO;
                }
                
            }];

//            if (self.state5==NO) {
//                NSString *name2 = [[[NSString alloc]initWithFormat:@"http://101.201.100.191/VipCard/upload/MerchantImage/addImage/%@_%@.png",[[NSUserDefaults standardUserDefaults]objectForKey:@"sellerNickName"],self.phoneStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                
//                UIImage *image2= [self getImageFromURL:name2];
//                if (image2) {
//                    self.ifImageView5=YES;
//                    [self.imageView5 setImage:image2];
//                }else{
//                    self.ifImageView5=NO;
//                }
//                self.state5=YES;
//            }
//            
//            if (self.ifImageView5==NO) {
//                headImageView2.image=[UIImage imageNamed:@"mohu-13"];
//            }else{
//                headImageView2.image=self.imageView5.image;
//            }
            
            UILabel *underRightLab=[[UILabel alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 20+((SCREENWIDTH-150)/2)*116/176, (SCREENWIDTH-150)/2, 40)];
            underRightLab.tag=1000;
            underRightLab.text=@"经营场地照片";
            underRightLab.font=[UIFont systemFontOfSize:15.0f];
            underRightLab.textAlignment=1;
            underRightLab.textColor=[UIColor redColor];
            [cell addSubview:underRightLab];
        }else if (indexPath.row==8){
            UILabel *xingLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
            xingLab.tag=99;
            xingLab.font=[UIFont systemFontOfSize:20.0f];
            xingLab.textColor=[UIColor redColor];
            xingLab.textAlignment=1;
            xingLab.text=@"*";
            [cell addSubview:xingLab];
            //名称
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 110, 50)];
            label.tag=100;
            label.text=@"营业地水电票";
            label.font=[UIFont systemFontOfSize:15.0f];
            [cell addSubview:label];
            UIImageView *headImageView2=[[UIImageView alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 20, (SCREENWIDTH-150)/2, ((SCREENWIDTH-150)/2)*116/176)];
            headImageView2.tag=803;
            
            headImageView2.userInteractionEnabled=YES;
            [cell addSubview:headImageView2];
            UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            [headImageView2 addGestureRecognizer:tapGesture2];
            self.imageView6=headImageView2;
            
            NSString *name2 = [[[NSString alloc]initWithFormat:@"http://101.201.100.191/VipCard/upload/MerchantImage/wepImage/%@_%@.png",[[NSUserDefaults standardUserDefaults]objectForKey:@"sellerNickName"],self.phoneStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            [self.imageView6 sd_setImageWithURL:[NSURL URLWithString:name2] placeholderImage:[UIImage imageNamed:@"mohu-14"] options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"------%@",image);
                if (image) {
                    self.ifImageView6=YES;
                }else{
                    self.ifImageView6=NO;
                }
                
            }];

            
//            if (self.state6==NO) {
//                NSString *name2 = [[[NSString alloc]initWithFormat:@"http://101.201.100.191/VipCard/upload/MerchantImage/wepImage/%@_%@.png",[[NSUserDefaults standardUserDefaults]objectForKey:@"sellerNickName"],self.phoneStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                
//                UIImage *image2= [self getImageFromURL:name2];
//                if (image2) {
//                    self.ifImageView6=YES;
//                    [self.imageView6 setImage:image2];
//                }else{
//                    self.ifImageView6=NO;
//                }
//                self.state6=YES;
//            }
//            
//            if (self.ifImageView6==NO) {
//                headImageView2.image=[UIImage imageNamed:@"mohu-14"];
//            }else{
//                headImageView2.image=self.imageView6.image;
//            }
            
            UILabel *underRightLab=[[UILabel alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 20+((SCREENWIDTH-150)/2)*116/176, (SCREENWIDTH-150)/2, 40)];
            underRightLab.tag=1000;
            underRightLab.text=@"水电票据照片";
            underRightLab.font=[UIFont systemFontOfSize:15.0f];
            underRightLab.textAlignment=1;
            underRightLab.textColor=[UIColor redColor];
            [cell addSubview:underRightLab];
        }else if (indexPath.row==9){
            //最后一行，返回上一级，或者进入下一级页面
            UIButton *from=[UIButton buttonWithType:UIButtonTypeCustom];
            from.frame=CGRectMake(SCREENWIDTH/2-110, 5, 100, 40);
            from.backgroundColor=[UIColor whiteColor];
            [from setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [from setTitle:@"上一步" forState:UIControlStateNormal];
            from.layer.cornerRadius=8.0f;
            from.layer.borderColor=[[UIColor redColor]CGColor];
            from.layer.borderWidth=0.6;
            from.tag=1100;
            [from addTarget:self action:@selector(missSelf:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:from];
            
            UIButton *goNext=[UIButton buttonWithType:UIButtonTypeCustom];
            goNext.frame=CGRectMake(SCREENWIDTH/2+5, 5, 100, 40);
            goNext.backgroundColor=[UIColor redColor];
            [goNext setTitle:@"下一步" forState:UIControlStateNormal];
            [goNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            goNext.layer.cornerRadius=8.0f;
            goNext.layer.borderColor=[[UIColor redColor]CGColor];
            goNext.layer.borderWidth=0.6;
            goNext.tag=1200;
            [goNext addTarget:self action:@selector(goNext:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:goNext];

        }
        return cell;

    }
    return nil;
}
//区头高度设置为0.01
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_areaTableView) {
        return 40;
    }else{
    if(indexPath.row==4||indexPath.row==5){
        return totalHeight;
    }else if (indexPath.row==6||indexPath.row==7||indexPath.row==8){
        return totalHeight;
    }
        return 50;
    }
}
//you
-(void)btn1Click:(UIButton *)sender1{
    if (sender1==self.haveBtn) {
        [self.haveBtn setBackgroundColor:[UIColor redColor]];
        self.haveBtn.selected=YES;
        [self.noneBtn setBackgroundColor:[UIColor lightGrayColor]];
        self.noneBtn.selected=NO;
        self.reasonTF.text=@"";
        [self.reasonTF resignFirstResponder];
    }else if (sender1==self.agreeBtn1){
        [self.agreeBtn1 setBackgroundColor:[UIColor redColor]];
        self.agreeBtn1.selected=YES;
        [self.agreeBtn2 setBackgroundColor:[UIColor lightGrayColor]];
        self.agreeBtn2.selected=NO;
        self.houseProvide1.text=@"租赁合同首页";
        self.houseProvide2.text=@"租赁合同尾页";
    }
}
//wu
-(void)btn2Click:(UIButton *)sender2{
    if (sender2==self.noneBtn) {
        [self.haveBtn setBackgroundColor:[UIColor lightGrayColor]];
        self.haveBtn.selected=NO;
        [self.noneBtn setBackgroundColor:[UIColor redColor]];
        self.noneBtn.selected=YES;
    }else if (sender2==self.agreeBtn2){
        [self.agreeBtn1 setBackgroundColor:[UIColor lightGrayColor]];
        self.agreeBtn1.selected=NO;
        [self.agreeBtn2 setBackgroundColor:[UIColor redColor]];
        self.agreeBtn2.selected=YES;
        self.houseProvide1.text=@"房产证明首页";
        self.houseProvide2.text=@"房产证明尾页";
    }
}
//模态消失，返回上级界面
-(void)missSelf:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)saveRequest{
    //开始发起请求,请求成功，显示一下信息
    //地点问题
    NSLog(@"%@",self.kindLab.text);
    NSUserDefaults *use_name = [NSUserDefaults standardUserDefaults];
    [use_name setObject:self.locationLab.text forKey:@"selleraddress"];//商家地点
    [use_name setObject:self.detailAddressTF.text forKey:@"seller_rr"];//商家详细地点
    [use_name setObject:self.agencyNameTF.text forKey:@"sellerstore"];//单位名称
    [use_name setObject:self.kindLab.text forKey:@"seller_trade"];//行业
    //
    NSString *url =[[NSString alloc]initWithFormat:@"http://%@/VipCard/merchant_complete_02.php",SOCKETHOST ];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneStr forKey:@"phone"];
    NSString *newStr=[[NSString alloc]initWithFormat:@"%@%@",self.locationLab.text,self.detailAddressTF.text];
    NSLog(@"%@",newStr);
    [params setObject:newStr forKey:@"address"];//地点
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    float lat = appdelegate.userLocation.location.coordinate.latitude;
    NSString *latitude =[[NSString alloc]initWithFormat:@"%f",lat];
    [params setObject:latitude forKey:@"latitude"];
    float longti = appdelegate.userLocation.location.coordinate.longitude;
    NSString *longtitude =[[NSString alloc]initWithFormat:@"%f",longti];
    [params setObject:longtitude forKey:@"longtitude"];
    
    [use_name setObject:latitude forKey:@"seller_latitude"];
    [use_name setObject:longtitude forKey:@"seller_longtitude"];
    
    if (![self.agencyNameTF.text isEqualToString:@""]) {
        NSLog(@"%@",self.agencyNameTF.text);
        [params setObject:self.agencyNameTF.text forKey:@"store"];//机构名称
    }else{
        [params setObject:@"" forKey:@"store"];//机构名称
    }

    if (!self.kindLab.text) {
        [params setObject:@"不详" forKey:@"trade"];//行业
    }else{
        [params setObject:self.kindLab.text forKey:@"trade"];//行业
    }

    if (self.haveBtn.selected==YES){
        [params setObject:@"true" forKey:@"state"];
        [params setObject:@"null" forKey:@"explain"];
        [use_name setObject:@"null" forKey:@"seller_explain"];//合同
    }else{
        [params setObject:@"false" forKey:@"state"];
        [params setObject:self.reasonTF.text forKey:@"explain"];
        [use_name setObject:self.reasonTF.text forKey:@"seller_explain"];//合同
    }
    if (self.agreeBtn1.selected==YES) {
        [params setObject:@"租赁合同" forKey:@"house_contact"];
        [use_name setObject:@"租赁合同" forKey:@"seller_provide"];//营业
    }else{
        [params setObject:@"房产证明" forKey:@"house_contact"];
        [use_name setObject:@"房产证明" forKey:@"seller_provide"];//营业
    }
   [use_name synchronize];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"KKRequestDataService===%@", result);
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.frame = CGRectMake(0, 64, 375, 667);
        
                hud.mode = MBProgressHUDModeText;
        
                hud.label.text = NSLocalizedString(@"已保存成功", @"HUD message title");
                hud.label.font = [UIFont systemFontOfSize:13];
        
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                [hud hideAnimated:YES afterDelay:3.f];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
}

-(void)goNext:(UIButton *)sender{
    if (self.haveBtn.selected==YES) {
        if ([self.locationLab.text isEqualToString:@""]||[self.detailAddressTF.text isEqualToString:@""]||[self.agencyNameTF.text isEqualToString:@""]||[self.kindLab.text isEqualToString:@""]||self.ifImageView1==NO||self.ifImageView2==NO||self.ifImageView3==NO||self.ifImageView4==NO||self.ifImageView5==NO||self.ifImageView6==NO) {
            //MBProgressHUD *hud判断如果有一项没填就出提示
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"至少有一项信息填写不完成", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            // Move to bottm center.
            //    hud.offset = CGPointMake(0.f, );
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:4.f];
        }else{
            //有营业执照，不须说明情况，去下个界面，不给下个页面传入说明情况
            NewLastViewController *nextVC=[[NewLastViewController alloc]init];
            
            [self saveRequest];
            
            nextVC.phoneStr=self.phoneStr;
            nextVC.pswStr=self.pswStr;
            nextVC.nibNameString=self.nibNameString;
            nextVC.tuijianStr=self.tuijianStr;
            nextVC.nameStr=self.nameStr;
            nextVC.addressStr=self.addressStr;
            nextVC.identyStr=self.identyStr;
            nextVC.kaihuStr=self.kaihuStr;
            nextVC.zhanghaoStr=self.zhanghaoStr;
            nextVC.searchStr=self.searchStr;
            nextVC.areaStr=self.locationLab.text;
            nextVC.detailAddressStr=self.detailAddressTF.text;
            nextVC.agencyNameStr=self.agencyNameTF.text;
            nextVC.kindStr=self.kindLab.text;
            nextVC.reasonStr=@"null";
            nextVC.licenceString=@"有";
            if (self.agreeBtn1.selected==YES) {
                nextVC.propertyString=@"租赁合同";
            }else{
                nextVC.propertyString=@"房产证明";
            }
            //此处不再传情况说明字符串
            [self presentViewController:nextVC animated:YES completion:nil];
        }

    }else{
        if ([self.locationLab.text isEqualToString:@""]||[self.detailAddressTF.text isEqualToString:@""]||[self.agencyNameTF.text isEqualToString:@""]||[self.kindLab.text isEqualToString:@""]||[self.reasonTF.text isEqualToString:@""]||self.ifImageView2==NO||self.ifImageView3==NO||self.ifImageView4==NO||self.ifImageView5==NO||self.ifImageView6==NO) {
            //MBProgressHUD *hud判断如果有一项没填就出提示
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"至少有一项信息填写不完成", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            // Move to bottm center.
            //    hud.offset = CGPointMake(0.f, );
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:4.f];
        }else{
            //没有营业执照，给下个页面传入说明情况字段
            NewLastViewController *nextVC=[[NewLastViewController alloc]init];
            [self saveRequest];

            nextVC.phoneStr=self.phoneStr;
            nextVC.pswStr=self.pswStr;
            nextVC.nibNameString=self.nibNameString;
            nextVC.tuijianStr=self.tuijianStr;
            nextVC.nameStr=self.nameStr;
            nextVC.addressStr=self.addressStr;
            nextVC.identyStr=self.identyStr;
            nextVC.kaihuStr=self.kaihuStr;
            nextVC.zhanghaoStr=self.zhanghaoStr;
            nextVC.searchStr=self.searchStr;
            nextVC.areaStr=self.locationLab.text;
            nextVC.detailAddressStr=self.detailAddressTF.text;
            nextVC.agencyNameStr=self.agencyNameTF.text;
            nextVC.kindStr=self.kindLab.text;
            //此处需要传入具体－－营业执照情况说明字符串
            nextVC.reasonStr=self.reasonTF.text;
            nextVC.licenceString=@"无";
            if (self.agreeBtn1.selected==YES) {
                nextVC.propertyString=@"租赁合同";
            }else{
                nextVC.propertyString=@"房产证明";
            }
            [self presentViewController:nextVC animated:YES completion:nil];
        }

    }
}
-(void)tapChooseClick:(UITapGestureRecognizer *)tap{
    if (_areaTableView==nil) {
        _areaTableView=[[UITableView alloc]initWithFrame:CGRectMake(110, 190, 100, 200) style:UITableViewStylePlain];
        _areaTableView.delegate=self;
        _areaTableView.dataSource=self;
        [_tableView addSubview:_areaTableView];
        self.tradeArray = [[NSMutableArray alloc]initWithObjects:@"美容",@"美发",@"美甲",@"足疗按摩",@"皮革养护",@"汽车服务",@"洗衣",@"瑜伽舞蹈",@"瘦身纤体",@"宠物店",@"电影院",@"运动健身",@"零售连锁",@"餐饮食品",@"医药",@"游乐场",@"娱乐KTV",@"婚纱摄影",@"游泳馆",@"超市购物",@"甜点饮品",@"酒店",@"教育培训",@"商务会所",@"全部分类", nil];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_areaTableView) {
        _areaTableView.frame=CGRectMake(110, 64+190+44, 100, 0);
        [_areaTableView removeFromSuperview];
        _areaTableView=nil;
        self.kindLab.text=self.tradeArray[indexPath.row];
    }else
    {
        [_tableView endEditing:YES];
    }
}

-(void)tapClick:(UITapGestureRecognizer *)tap{

    UIImageView *imageViews=(UIImageView *)[tap view];
    if (imageViews==self.imageView1) {
        self.indexTag=1;
        if (self.haveBtn.selected) {
            //有营业执照
            [self.view endEditing:YES];
            UIActionSheet *sheet;
            // 判断是否支持相机
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                
            {
                sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
                
            }
            
            else {
                
                sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
                
            }
            
            sheet.tag = 255;
            
            [sheet showInView:self.view];
        }else{
            //上传失效,无营业执照，写原因
            
        }

    }else if (imageViews==self.imageView2){
        self.indexTag=2;
        //有营业执照，执行拍照或者从相册选择的逻辑
        [self.view endEditing:YES];
        UIActionSheet *sheet;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            
        {
            sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
            
        }
        
        else {
            
            sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
            
        }
        
        sheet.tag = 255;
        
        [sheet showInView:self.view];

    }else if (imageViews==self.imageView3){
        self.indexTag=3;
        //有营业执照，执行拍照或者从相册选择的逻辑
        [self.view endEditing:YES];
        UIActionSheet *sheet;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            
        {
            sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
            
        }
        
        else {
            
            sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
            
        }
        
        sheet.tag = 255;
        
        [sheet showInView:self.view];

    }else if (imageViews==self.imageView4){
        self.indexTag=4;
        //有营业执照，执行拍照或者从相册选择的逻辑
        [self.view endEditing:YES];
        UIActionSheet *sheet;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            
        {
            sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
            
        }
        
        else {
            
            sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
            
        }
        
        sheet.tag = 255;
        
        [sheet showInView:self.view];

    }else if (imageViews==self.imageView5){
        self.indexTag=5;
        //有营业执照，执行拍照或者从相册选择的逻辑
        [self.view endEditing:YES];
        UIActionSheet *sheet;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            
        {
            sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", nil];
            
        }
        
        else {
            
            sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
            
        }
        
        sheet.tag = 255;
        
        [sheet showInView:self.view];

    }else if (imageViews==self.imageView6){
        self.indexTag=6;
        //有营业执照，执行拍照或者从相册选择的逻辑
        [self.view endEditing:YES];
        UIActionSheet *sheet;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            
        {
            sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
            
        }
        
        else {
            
            sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
            
        }
        
        sheet.tag = 255;
        
        [sheet showInView:self.view];

    }
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}
//点击选取按钮触发事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 保存图片至本地，方法见下文
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    NSString *url =[[NSString alloc]initWithFormat:@"http://%@/VipCard/upload.php",SOCKETHOST ];
    //ASIFormDataRequest请求是post请求，可以查看其源码
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    //request.tag = 20;
    request.delegate = self;
    //AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *name = [[NSString alloc]initWithFormat:@"%@_%@",self.nibNameString,self.phoneStr];
    [request addPostValue:name forKey:@"name"];//商家用户名.png
    _isFullScreen = NO;
    if (_indexTag==1) {
        [self.imageView1 setImage:savedImage];
        [request addPostValue:@"license" forKey:@"type"];
        [request addFile:fullPath forKey:@"file1"];//如果有路径，上传文件
        //[request setData:data  withFileName:photoName andContentType:@"image/png" forKey:@"file1"];
        //               数据                文件名,随便起                 文件类型            设置key
        
        [request startAsynchronous];
        
    }else if(_indexTag==2)
    {
        NSString *name1 = [[NSString alloc]initWithFormat:@"%@_%@_01",self.nibNameString,self.phoneStr];
        
        [request addPostValue:name1 forKey:@"name"];//商家用户名.png
        [self.imageView2 setImage:savedImage];
        [request addPostValue:@"tenancy" forKey:@"type"];
        [request addFile:fullPath forKey:@"file1"];//如果有路径，上传文件
        //[request setData:data  withFileName:photoName andContentType:@"image/png" forKey:@"file1"];
        //               数据                文件名,随便起                 文件类型            设置key
        [request startAsynchronous];
    }else if(_indexTag==3)
    {
        NSString *name2 = [[NSString alloc]initWithFormat:@"%@_%@_02",self.nibNameString,self.phoneStr];
        [request addPostValue:name2 forKey:@"name"];//商家用户名.png
        [self.imageView3 setImage:savedImage];
        [request addPostValue:@"tenancy" forKey:@"type"];
        [request addFile:fullPath forKey:@"file1"];//如果有路径，上传文件
        [request startAsynchronous];
        
    }else if (_indexTag==4){
        [self.imageView4 setImage:savedImage];
        [request addPostValue:@"lp" forKey:@"type"];
        [request addFile:fullPath forKey:@"file1"];//如果有路径，上传文件
        [request startAsynchronous];
    }else if (_indexTag==5){
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [appdelegate.locService startUserLocationService];
        [self.imageView5 setImage:savedImage];
        [request addPostValue:@"add" forKey:@"type"];
        [request addFile:fullPath forKey:@"file1"];//如果有路径，上传文件
        //self.addressPhoto = fullPath;
        [request startAsynchronous];
    }else if (_indexTag==6){
        [self.imageView6 setImage:savedImage];
        [request addPostValue:@"wep" forKey:@"type"];
        [request addFile:fullPath forKey:@"file1"];//如果有路径，上传文件
        [request startAsynchronous];
    }
    
}

- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    imageData2=[NSData data];
    imageData = UIImageJPEGRepresentation(currentImage, 1.0);
    while ([imageData length]/1000>400) {
        if (imageData.length==imageData2.length) {
            break;
        }
        imageData2=imageData;
        UIImage *image=[[UIImage alloc]initWithData:imageData];
        imageData = UIImageJPEGRepresentation(image, 0.2);
    }
        NSLog(@"+++++++=++++=+++=+%lu",(unsigned long)imageData.length);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"图片太大,上传失败", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:4.f];
    NSLog(@"请求失败");
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    
    NSLog(@"%@", dic);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = NSLocalizedString(@"图片上传成功", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:4.f];
    if (self.indexTag==1)
    {
        self.ifImageView1=YES;
    }else if (self.indexTag==2)
    {
        self.ifImageView2=YES;
    }else if (self.indexTag==3)
    {
        self.ifImageView3=YES;
    }else if (self.indexTag==4){
        self.ifImageView4=YES;
    }else if (self.indexTag==5){
        self.ifImageView5=YES;
    }else if (self.indexTag==6){
        self.ifImageView6=YES;
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==self.reasonTF) {
        if (self.haveBtn.selected) {
            return NO;
        }
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)tapAndHidden{
    [_tableView endEditing:YES];
    [self.view endEditing:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //Tip:我们可以通过打印touch.view来看看具体点击的view是具体是什么名称,像点击UITableViewCell时响应的View则是UITableViewCellContentView.
    NSLog(@"%@",touch.view);
    if (gestureRecognizer.view == _tableView) {
        if ([NSStringFromClass([touch.view class])    isEqualToString:@"UITableViewCellContentView"]) {
            //返回为NO则屏蔽手势事件
            return NO;
        }
    }
    
    return YES;
}
-(void)saveBtnlick:(UIButton *)sender{
    [self saveRequest];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    DebugLog(@"--[[SDImageCache sharedImageCache] clearDisk]----");
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    
    [[[SDWebImageManager sharedManager]imageCache]clearDisk];
    [[[SDWebImageManager sharedManager]imageCache]clearMemory];

    
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
