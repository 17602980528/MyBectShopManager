//
//  NewMiddleViewController.m
//  BletcShop
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NewMiddleViewController.h"
#import "NewLastViewController.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"

#import "JFAreaDataManager.h"
#import "ValuePickerView.h"

@interface NewMiddleViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    NSArray *nameArray;
    CGFloat totalHeight;
    UIScrollView *_scrollView;
    UITableView *_areaTableView;
    NSData *imageData;
    NSData *imageData2;
    
    NSMutableDictionary *shopInfoDic;
    
    NSMutableArray *array;//保存所有图片
    
    
    NSMutableArray *eare_data;
    ValuePickerView *pickView;

}
@property(nonatomic,strong)NSArray *streetArray;
@end

@implementation NewMiddleViewController
-(NSMutableArray *)tradeArray{
    if (!_tradeArray) {
        _tradeArray = [[NSMutableArray alloc]initWithObjects:@"美容",@"美发",@"美甲",@"足疗按摩",@"皮革养护",@"汽车服务",@"洗衣",@"瑜伽舞蹈",@"瘦身纤体",@"宠物店",@"电影院",@"运动健身",@"零售连锁",@"餐饮食品",@"医药",@"游乐场",@"娱乐KTV",@"婚纱摄影",@"游泳馆",@"超市购物",@"甜点饮品",@"酒店",@"教育培训",@"商务会所", nil];
    }
    return _tradeArray;
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"店铺认证";
    
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSDictionary *dic =[[NSUserDefaults standardUserDefaults]objectForKey:app.shopInfoDic[@"muid"]];
    
    shopInfoDic = [[NSMutableDictionary alloc]initWithDictionary:dic];

    DebugLog(@"shopInfoDic==%@",shopInfoDic);
    
    
    __block typeof(self)  bloskSelf = self;
    
    NSLog(@"-app.city-----%@",app.city);

    [[JFAreaDataManager shareManager] currentCityDic:app.city currentCityDic:^(NSDictionary *dic) {
        
        
        NSLog(@"-dic-----%@",dic);
        [[JFAreaDataManager shareManager]areaData:dic[@"code"] areaData:^(NSMutableArray *areaData) {
            
            
            NSLog(@"-areaData-----%@",areaData);
            
            for (NSDictionary *dic in areaData) {
                NSString *name = dic[@"name"];
                
                
                if ([name isEqualToString:app.addressDistrite] || [name containsString:app.addressDistrite] || [app.addressDistrite containsString:name]) {
                    
                    
                    NSString *url = [NSString stringWithFormat:@"%@Extra/address/getStreet",BASEURL];;
                    
                    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
                    [parame setValue:dic[@"code"] forKey:@"district_id"];
                    
                    NSLog(@"url====+%@=====%@",url,parame);
                    [KKRequestDataService requestWithURL:url params:parame httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
                        
                        NSLog(@"-areaData-----%@",areaData);
                        
                        eare_data = [NSMutableArray arrayWithArray:result];
                        
                        NSMutableArray *arr = [NSMutableArray array];
                        for (NSDictionary *dic_eare in result) {
                            [arr addObject:dic_eare[@"name"]];
                            
                        }
                        self.streetArray=[[NSArray alloc]initWithArray:arr];
                        pickView= [[ValuePickerView alloc]init];
                        
                        NSLog(@"--------------%@",arr);
                        pickView.dataSource = arr;
                        pickView.valueDidSelect = ^(NSString *value) {
                            
                            
                            bloskSelf.detailAddressTF.text =  [[value componentsSeparatedByString:@"/"] firstObject];
                            
                        };
                        
                    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                    }];
                    
                    
                    
                    
                    
                    
                    break;
                    
                    
                }
            }
            
        }];
    }];
    
    
    
    totalHeight=80+((SCREENWIDTH-150)/2)*116/176;
    [self initTopView];
    [self initScrollView];
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
    btns.tag = 999;
    [self.view addSubview:navView];
    [navView addSubview:btns];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 18, SCREENWIDTH, 44)];
    label.font=[UIFont systemFontOfSize:19.0f];
    label.text=@"预付保险认证";
    label.textAlignment=1;
    label.textColor=[UIColor whiteColor];
    [navView addSubview:label];
    
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
    [_scrollView endEditing:YES];
}
-(void)saveBtnlick:(UIButton *)sender{
    [self saveRequest:sender.tag];
}

-(void)saveInfo{
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [shopInfoDic setValue:self.detailAddressTF.text forKey:@"address"];
    [shopInfoDic setValue:self.agencyNameTF.text forKey:@"store"];
    [shopInfoDic setValue:self.kindLab.text forKey:@"trade"];
    [shopInfoDic setValue:_adddetailnewAddressTF.text forKey:@"full_add"];
    [shopInfoDic setValue:_company_nameTF.text forKey:@"company_name"];
    [shopInfoDic setValue:_company_styleTF.text forKey:@"company_nature"];
    if (self.haveBtn.selected==YES){
        [shopInfoDic setValue:@"null" forKey:@"explain_lic"];
    }else{
        [shopInfoDic setValue:self.reasonTF.text forKey:@"explain_lic"];
    }
    
    if (self.agreeBtn1.selected==YES) {
        [shopInfoDic setValue:@"租赁合同" forKey:@"house_contact"];
    }else{
        [shopInfoDic setValue:@"房产证明" forKey:@"house_contact"];
    }


    [shopInfoDic setValue:self.reasonTF.text forKey:@"explain_lic"];

    [shopInfoDic setValue:self.store_textf.text forKey:@"store_number"];

    NSLog(@"--saveInfo----%@",shopInfoDic);
    
    [userDefault setObject:shopInfoDic forKey:shopInfoDic[@"muid"]];
    [userDefault synchronize];
    
    
}
-(void)saveRequest:(NSInteger)tag{
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    //开始发起请求,请求成功，显示一下信息
    //地点问题
    NSLog(@"%@",self.kindLab.text);
    
    
    [self saveInfo];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/complete_02",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:shopInfoDic[@"muid"] forKey:@"muid"];

    [params setObject:self.phoneStr forKey:@"phone"];
    NSString *newStr=[[NSString alloc]initWithFormat:@"%@%@",self.locationLab.text,self.detailAddressTF.text];
    NSLog(@"%@",newStr);
    [params setObject:newStr forKey:@"address"];//地点
    
    float lat = appdelegate.userLocation.location.coordinate.latitude;
    NSString *latitude =[[NSString alloc]initWithFormat:@"%f",lat];
    [params setObject:latitude forKey:@"latitude"];
    float longti = appdelegate.userLocation.location.coordinate.longitude;
    NSString *longtitude =[[NSString alloc]initWithFormat:@"%f",longti];
    [params setObject:longtitude forKey:@"longtitude"];
    
    if (![_adddetailnewAddressTF.text isEqualToString:@""]) {
         [params setObject:_adddetailnewAddressTF.text forKey:@"full_add"];
    }else{
         [params setObject:@"" forKey:@"full_add"];
    }
    if (![_company_nameTF.text isEqualToString:@""]) {
        [params setObject:_company_nameTF.text forKey:@"company_name"];
    }else{
        [params setObject:@"" forKey:@"company_name"];
    }
    if (![_company_styleTF.text isEqualToString:@""]) {
        [params setObject:_company_styleTF.text forKey:@"company_nature"];
    }else{
        [params setObject:@"" forKey:@"company_nature"];
    }
    
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

        [params setObject:@"null" forKey:@"explain_lic"];
    }else{

        [params setObject:self.reasonTF.text forKey:@"explain_lic"];
        
    }
    if (self.agreeBtn1.selected==YES) {
        [params setObject:@"租赁合同" forKey:@"house_contact"];
    }else{
        [params setObject:@"房产证明" forKey:@"house_contact"];
    }
    
    NSString *imgUrl = [[NSString alloc]initWithFormat:@"%@.png",shopInfoDic[@"muid"]];
    
    [params setObject:imgUrl forKey:@"image_url"];

    
    if (![self.store_textf.text isEqualToString:@""]) {

        [params setObject:self.store_textf.text forKey:@"store_number"];//联系方式
    }else{
        [params setObject:@"" forKey:@"store_number"];
    }


    DebugLog(@"url==%@ parame ==%@",url,params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@" KKRequestDataService ==%@", result);
        
        if (tag==999) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"已保存成功", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            
            [hud hideAnimated:YES afterDelay:3.f];
            
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
}

-(void)initScrollView{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 108, SCREENWIDTH, SCREENHEIGHT-108)];
    _scrollView.contentSize=CGSizeMake(SCREENWIDTH, 60+200+totalHeight*5+50);
    _scrollView.showsVerticalScrollIndicator=NO;

    [self.view addSubview:_scrollView];
    
    UITapGestureRecognizer *tapClick=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAndHidden)];
    tapClick.delegate=self;
    [_scrollView addGestureRecognizer:tapClick];
    
    
    //1hang--------
    UILabel *xingLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    xingLab.font=[UIFont systemFontOfSize:20.0f];
    xingLab.textColor=[UIColor redColor];
    xingLab.text=@"*";
    xingLab.textAlignment=1;
    [_scrollView addSubview:xingLab];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(10, 50, SCREENWIDTH-20, 0.3)];
    lineView1.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineView1];
    //名称
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 5, 110, 40)];
    label.font=[UIFont systemFontOfSize:15.0f];
    label.text=@"当前地区";
    [_scrollView addSubview:label];
    //定位到的区域
    _locationLab=[[UILabel alloc]initWithFrame:CGRectMake(140, 5, SCREENWIDTH-140, 40)];
    _locationLab.font=[UIFont systemFontOfSize:15.0f];
    _locationLab.textColor=[UIColor grayColor];
    [_scrollView addSubview:_locationLab];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (appdelegate.province==nil||[appdelegate.province isEqualToString:@"(null)"]) {
        appdelegate.province = @"";
    }if (appdelegate.city==nil||[appdelegate.city isEqualToString:@"(null)"]) {
        appdelegate.city = @"";
    }if (appdelegate.addressDistrite==nil||[appdelegate.addressDistrite isEqualToString:@"(null)"]) {
        appdelegate.addressDistrite = @"";
    }
    _locationLab.text=[[NSString alloc] initWithFormat:@"%@%@%@",appdelegate.province,appdelegate.city,appdelegate.addressDistrite];
    //2hang--------
    UILabel *xingLab2=[[UILabel alloc]initWithFrame:CGRectMake(10, 65, 20, 20)];
    xingLab2.font=[UIFont systemFontOfSize:20.0f];
    xingLab2.textColor=[UIColor redColor];
    xingLab2.text=@"*";
    xingLab2.textAlignment=1;
    [_scrollView addSubview:xingLab2];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(10, 100, SCREENWIDTH-20, 0.3)];
    lineView2.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineView2];
    
    //名称
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(30, 55, 110, 40)];
    label2.font=[UIFont systemFontOfSize:15.0f];
    label2.text=@"街道";
    [_scrollView addSubview:label2];
    
    //输入框
    _detailAddressTF=[[UITextField alloc]initWithFrame:CGRectMake(140, 55, SCREENWIDTH-140, 40)];
    _detailAddressTF.font=[UIFont systemFontOfSize:13.0f];
    _detailAddressTF.placeholder=@"门店地址";
    _detailAddressTF.delegate = self;
    
    NSString *detail_s =shopInfoDic[@"address"];
    if (detail_s.length>_locationLab.text.length) {
        _detailAddressTF.text=[detail_s substringFromIndex:_locationLab.text.length];

    }else{
        _detailAddressTF.text=detail_s;

    }


    [_scrollView addSubview:_detailAddressTF];
    
    //new_add
    UILabel *xingLab_new=[[UILabel alloc]initWithFrame:CGRectMake(10, 115, 20, 20)];
    xingLab_new.font=[UIFont systemFontOfSize:20.0f];
    xingLab_new.textColor=[UIColor redColor];
    xingLab_new.text=@"*";
    xingLab_new.textAlignment=1;
    [_scrollView addSubview:xingLab_new];
    //名称
    UILabel *labelnew3=[[UILabel alloc]initWithFrame:CGRectMake(30, 105, 110, 40)];
    labelnew3.font=[UIFont systemFontOfSize:15.0f];
    labelnew3.text=@"详细地点";
    [_scrollView addSubview:labelnew3];

    _adddetailnewAddressTF=[[UITextField alloc]initWithFrame:CGRectMake(140, 105, SCREENWIDTH-140, 40)];
    _adddetailnewAddressTF.font=[UIFont systemFontOfSize:13.0f];
    _adddetailnewAddressTF.text=[NSString getTheNoNullStr:shopInfoDic[@"full_add"] andRepalceStr:@""];
    _adddetailnewAddressTF.placeholder=@"详细地点";
    _adddetailnewAddressTF.delegate=self;
    _adddetailnewAddressTF.returnKeyType=UIReturnKeyDone;
    [_scrollView addSubview:_adddetailnewAddressTF];
    
    UIView *lineViewnew=[[UIView alloc]initWithFrame:CGRectMake(10, 150, SCREENWIDTH-20, 0.3)];
    lineViewnew.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineViewnew];
    
    UILabel *xingLab_comName=[[UILabel alloc]initWithFrame:CGRectMake(10, 115+50, 20, 20)];
    xingLab_comName.font=[UIFont systemFontOfSize:20.0f];
    xingLab_comName.textColor=[UIColor redColor];
    xingLab_comName.text=@"*";
    xingLab_comName.textAlignment=1;
    [_scrollView addSubview:xingLab_comName];
    
    UILabel *xingLab_com=[[UILabel alloc]initWithFrame:CGRectMake(30, 105+50, 110, 40)];
    xingLab_com.font=[UIFont systemFontOfSize:15.0f];
    xingLab_com.text=@"企业名称";
    [_scrollView addSubview:xingLab_com];
    
    _company_nameTF=[[UITextField alloc]initWithFrame:CGRectMake(140, 105+50, SCREENWIDTH-140, 40)];
    _company_nameTF.font=[UIFont systemFontOfSize:13.0f];
    _company_nameTF.text=[NSString getTheNoNullStr:shopInfoDic[@"company_name"] andRepalceStr:@""];
    _company_nameTF.placeholder=@"企业名称";
    _company_nameTF.delegate=self;
    _company_nameTF.returnKeyType=UIReturnKeyDone;
    [_scrollView addSubview:_company_nameTF];
    
    UIView *lineViewnewcom=[[UIView alloc]initWithFrame:CGRectMake(10, 150+50, SCREENWIDTH-20, 0.3)];
    lineViewnewcom.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineViewnewcom];
    //
    UILabel *xingLab_comStyle=[[UILabel alloc]initWithFrame:CGRectMake(10, 115+50+50, 20, 20)];
    xingLab_comStyle.font=[UIFont systemFontOfSize:20.0f];
    xingLab_comStyle.textColor=[UIColor redColor];
    xingLab_comStyle.text=@"*";
    xingLab_comStyle.textAlignment=1;
    [_scrollView addSubview:xingLab_comStyle];
    
    UILabel *xingLab_coms=[[UILabel alloc]initWithFrame:CGRectMake(30, 105+50+50, 110, 40)];
    xingLab_coms.font=[UIFont systemFontOfSize:15.0f];
    xingLab_coms.text=@"企业性质";
    [_scrollView addSubview:xingLab_coms];
    
    _company_styleTF=[[UITextField alloc]initWithFrame:CGRectMake(140, 105+50+50, SCREENWIDTH-140, 40)];
    _company_styleTF.delegate=self;
    _company_styleTF.font=[UIFont systemFontOfSize:13.0f];
    _company_styleTF.text=[NSString getTheNoNullStr:shopInfoDic[@"company_nature"] andRepalceStr:@""];
    _company_styleTF.placeholder=@"企业性质";
    [_scrollView addSubview:_company_styleTF];
    
    UIView *lineViewnewcoms=[[UIView alloc]initWithFrame:CGRectMake(10, 150+50+50, SCREENWIDTH-20, 0.3)];
    lineViewnewcoms.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineViewnewcoms];
    
    
    
    //new_add
    
    UILabel *xingLab3=[[UILabel alloc]initWithFrame:CGRectMake(10, 115+50+100, 20, 20)];
    xingLab3.font=[UIFont systemFontOfSize:20.0f];
    xingLab3.textColor=[UIColor redColor];
    xingLab3.text=@"*";
    xingLab3.textAlignment=1;
    [_scrollView addSubview:xingLab3];
    
    //名称
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(30, 105+50+100, 110, 40)];
    label3.font=[UIFont systemFontOfSize:15.0f];
    label3.text=@"店铺名称";
    [_scrollView addSubview:label3];
    
    //输入框
    _agencyNameTF=[[UITextField alloc]initWithFrame:CGRectMake(140, 105+50+100, SCREENWIDTH-140, 40)];
    _agencyNameTF.font=[UIFont systemFontOfSize:13.0f];
    _agencyNameTF.placeholder=@"店铺名称";
    _agencyNameTF.delegate=self;
    _agencyNameTF.returnKeyType=UIReturnKeyDone;
    _agencyNameTF.text=shopInfoDic[@"store"];

    [_scrollView addSubview:_agencyNameTF];
    
    UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(10, 150+50+100, SCREENWIDTH-20, 0.3)];
    lineView3.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineView3];
    
    
    UILabel *xing_store=[[UILabel alloc]initWithFrame:CGRectMake(10, 115+50+50+100, 20, 20)];
    xing_store.font=[UIFont systemFontOfSize:20.0f];
    xing_store.textColor=[UIColor redColor];
    xing_store.text=@"*";
    xing_store.textAlignment=1;
    [_scrollView addSubview:xing_store];
    
    //名称
    UILabel *store_number=[[UILabel alloc]initWithFrame:CGRectMake(30, 105+50+50+100, 110, 40)];
    store_number.font=[UIFont systemFontOfSize:15.0f];
    store_number.text=@"联系方式";
    [_scrollView addSubview:store_number];
    
    //输入框
    self.store_textf=[[UITextField alloc]initWithFrame:CGRectMake(140, 105+50+50+100, SCREENWIDTH-140, 40)];
    self.store_textf.font=[UIFont systemFontOfSize:13.0f];
    self.store_textf.placeholder=@"联系方式";
    self.store_textf.delegate=self;
    self.store_textf.returnKeyType=UIReturnKeyDone;
    self.store_textf.text=shopInfoDic[@"store_number"];
    [_scrollView addSubview:self.store_textf];
    
    UIView *lineViewe=[[UIView alloc]initWithFrame:CGRectMake(10, 150+50+50+100, SCREENWIDTH-20, 0.3)];
    lineViewe.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineViewe];

    
    //4hang--------
    UILabel *xingLab4=[[UILabel alloc]initWithFrame:CGRectMake(10, 165+50+50+100, 20, 20)];
    xingLab4.font=[UIFont systemFontOfSize:20.0f];
    xingLab4.textColor=[UIColor redColor];
    xingLab4.text=@"*";
    xingLab4.textAlignment=1;
    [_scrollView addSubview:xingLab4];
    
    //名称
    UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(30, 155+50+50+100, 110, 40)];
    label4.font=[UIFont systemFontOfSize:15.0f];
    label4.text=@"所属行业";
    [_scrollView addSubview:label4];
    
    UIView *lineView4=[[UIView alloc]initWithFrame:CGRectMake(10, 200+50+50+100, SCREENWIDTH-20, 0.3)];
    lineView4.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineView4];
    
    //所属行业选择
    _kindLab=[[UILabel alloc]initWithFrame:CGRectMake(110, 160+50+50+100, 100, 30)];
    _kindLab.text=@"请选择";
    _kindLab.font=[UIFont systemFontOfSize:13.0f];
    _kindLab.layer.borderColor=[[UIColor grayColor]CGColor];
    _kindLab.layer.borderWidth=1;
    _kindLab.userInteractionEnabled=YES;
    [_scrollView addSubview:_kindLab];
    

    if (shopInfoDic[@"trade"]) {
        _kindLab.text=shopInfoDic[@"trade"];
        
    }
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapChooseClick:)];
    [_kindLab addGestureRecognizer:tap];
    UIImageView *zijieImage=[[UIImageView alloc]initWithFrame:CGRectMake(185, 165+50+50+100, 20, 20)];
    zijieImage.image=[UIImage imageNamed:@"zijie"];
    
    [_scrollView addSubview:zijieImage];
    //5hang------
    UILabel *xingLab5=[[UILabel alloc]initWithFrame:CGRectMake(10, 215+50+50+100, 20, 20)];
    xingLab5.font=[UIFont systemFontOfSize:20.0f];
    xingLab5.textColor=[UIColor redColor];
    xingLab5.text=@"*";
    xingLab5.textAlignment=1;
    [_scrollView addSubview:xingLab5];
    //名称
    UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(30, 205+50+50+100, 110, 40)];
    label5.font=[UIFont systemFontOfSize:15.0f];
    label5.text=@"营业执照";
    [_scrollView addSubview:label5];
    
    
    //营业执照下的有无
    _haveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _haveBtn.frame=CGRectMake(30, 250+50+50+100, 80, 25);
    
    _haveBtn.layer.cornerRadius=5.0f;
    _haveBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [_haveBtn setTitle:@"有" forState:UIControlStateNormal];
    [_haveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scrollView addSubview:_haveBtn];
    [_haveBtn addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //无
    _noneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _noneBtn.frame=CGRectMake(30, 285+50+50+100, 80, 25);
    
    _noneBtn.layer.cornerRadius=5.0f;
    _noneBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [_noneBtn setTitle:@"无" forState:UIControlStateNormal];
    [_noneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scrollView addSubview:_noneBtn];
    [_noneBtn addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(120, 220+50+50+100, (SCREENWIDTH-150)/2, ((SCREENWIDTH-150)/2)*116/176)];
    _imageView1.userInteractionEnabled=YES;
    _imageView1.image=[UIImage imageNamed:@"mohu-09"];
    [_scrollView addSubview:_imageView1];
    
    UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_imageView1 addGestureRecognizer:tapGesture1];
    
    //设state判断是否已经运行过一次
    _reasonTF=[[UITextField alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 220+50+50+100, (SCREENWIDTH-150)/2, ((SCREENWIDTH-150)/2)*116/176)];
    _reasonTF.placeholder=@"关于营业执照情况说明";
    _reasonTF.layer.borderWidth=1;
    _reasonTF.returnKeyType=UIReturnKeyDone;
    _reasonTF.layer.borderColor=[[UIColor grayColor]CGColor];
    _reasonTF.font=[UIFont systemFontOfSize:13.0f];
    [_scrollView addSubview:_reasonTF];
    
    self.reasonTF.delegate=self;
    
    //照片下端红色文字
    UILabel *underLab=[[UILabel alloc]initWithFrame:CGRectMake(120, 220+((SCREENWIDTH-150)/2)*116/176+50+50+100, (SCREENWIDTH-150)/2, 40)];
    underLab.tag=900;
    underLab.text=@"营业执照照片";
    underLab.font=[UIFont systemFontOfSize:15.0f];
    underLab.textColor=[UIColor redColor];
    underLab.textAlignment=1;
    [_scrollView addSubview:underLab];
    
    
    UIView *lineView5=[[UIView alloc]initWithFrame:CGRectMake(10, 200+totalHeight+50+50+100, SCREENWIDTH-20, 0.3)];
    lineView5.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineView5];
    
    //6hang-------
//    UILabel *xingLab6=[[UILabel alloc]initWithFrame:CGRectMake(10, 215+totalHeight, 20, 20)];
//    xingLab6.font=[UIFont systemFontOfSize:20.0f];
//    xingLab6.textColor=[UIColor redColor];
//    xingLab6.textAlignment=1;
//    xingLab6.text=@"*";
//    [_scrollView addSubview:xingLab6];
    //营业执照下的有无
    _agreeBtn1=[UIButton buttonWithType:UIButtonTypeCustom];
    _agreeBtn1.frame=CGRectMake(30, 220+totalHeight+50+50+100, 85, 25);
    _agreeBtn1.layer.cornerRadius=5.0f;
    _agreeBtn1.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [_agreeBtn1 setTitle:@"租赁合同" forState:UIControlStateNormal];
    [_agreeBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scrollView addSubview:_agreeBtn1];
    [_agreeBtn1 addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
    //无
    _agreeBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    _agreeBtn2.frame=CGRectMake(30, 255+totalHeight+50+50+100, 85, 25);
    _agreeBtn2.layer.cornerRadius=5.0f;
    _agreeBtn2.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [ _agreeBtn2 setTitle:@"房产证明" forState:UIControlStateNormal];
    [ _agreeBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scrollView addSubview: _agreeBtn2];
    [ _agreeBtn2 addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
    //tupian2
    
    _imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(120, 220+totalHeight+50+50+100, (SCREENWIDTH-150)/2, ((SCREENWIDTH-150)/2)*116/176)];
    _imageView2.userInteractionEnabled=YES;
    _imageView2.image=[UIImage imageNamed:@"mohu-10"];
    [_scrollView addSubview:_imageView2];
    UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_imageView2 addGestureRecognizer:tapGesture2];
    
    //照片下端红色文字
    _houseProvide1=[[UILabel alloc]initWithFrame:CGRectMake(120, 220+totalHeight+((SCREENWIDTH-150)/2)*116/176+50+50+100, (SCREENWIDTH-150)/2, 40)];
    
    _houseProvide1.font=[UIFont systemFontOfSize:14.0f];
    _houseProvide1.textColor=[UIColor redColor];
    _houseProvide1.textAlignment=1;
    [_scrollView addSubview:_houseProvide1];
    
    //tupian3
    _imageView3=[[UIImageView alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 220+totalHeight+50+50+100, (SCREENWIDTH-150)/2, ((SCREENWIDTH-150)/2)*116/176)];
    _imageView3.image=[UIImage imageNamed:@"mohu-11"];
    _imageView3.userInteractionEnabled=YES;
    [_scrollView addSubview:_imageView3];
    UITapGestureRecognizer *tapGesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_imageView3 addGestureRecognizer:tapGesture3];
    //照片下端红色文字
    _houseProvide2=[[UILabel alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 220+totalHeight+50+((SCREENWIDTH-150)/2)*116/176+50+100, (SCREENWIDTH-150)/2, 40)];
    
    _houseProvide2.font=[UIFont systemFontOfSize:14.0f];
    _houseProvide2.textAlignment=1;
    _houseProvide2.textColor=[UIColor redColor];
    [_scrollView addSubview:_houseProvide2];
    
    UIView *lineView6=[[UIView alloc]initWithFrame:CGRectMake(10, 200+totalHeight*2+50+50+100, SCREENWIDTH-20, 0.6)];
    lineView6.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineView6];
    //hang7-----
    UILabel *xingLab7=[[UILabel alloc]initWithFrame:CGRectMake(10, 215+totalHeight*2+50+50+100, 20, 20)];
    xingLab7.font=[UIFont systemFontOfSize:20.0f];
    xingLab7.textColor=[UIColor redColor];
    xingLab7.textAlignment=1;
    xingLab7.text=@"*";
    [_scrollView addSubview:xingLab7];
    
    //名称
    UILabel *label7=[[UILabel alloc]initWithFrame:CGRectMake(30, 205+totalHeight*2+50+50+100, 110, 40)];
    label7.font=[UIFont systemFontOfSize:15.0f];
    label7.text=@"法人照片";
    [_scrollView addSubview:label7];
    //tupian4
    _imageView4=[[UIImageView alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 220+totalHeight*2+50+50+100, (SCREENWIDTH-150)/2, ((SCREENWIDTH-150)/2)*116/176)];
    _imageView4.image=[UIImage imageNamed:@"mohu-12"];
    _imageView4.userInteractionEnabled=YES;
    [_scrollView addSubview:_imageView4];
    UITapGestureRecognizer *tapGesture4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_imageView4 addGestureRecognizer:tapGesture4];
    //照片下端红色文字
    UILabel *under_red1 =[[UILabel alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 220+50+totalHeight*2+((SCREENWIDTH-150)/2)*116/176+50+100, (SCREENWIDTH-150)/2, 40)];
    under_red1.text=@"法人正面照片";
    under_red1.font=[UIFont systemFontOfSize:14.0f];
    under_red1.textAlignment=1;
    under_red1.textColor=[UIColor redColor];
    [_scrollView addSubview:under_red1];
    
    UIView *lineView7=[[UIView alloc]initWithFrame:CGRectMake(10, 200+totalHeight*3+50+50+100, SCREENWIDTH-20, 0.6)];
    lineView7.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineView7];
    
    //hang8-----
    UILabel *xingLab8=[[UILabel alloc]initWithFrame:CGRectMake(10, 215+totalHeight*3+50+50+100, 20, 20)];
    xingLab8.font=[UIFont systemFontOfSize:20.0f];
    xingLab8.textColor=[UIColor redColor];
    xingLab8.textAlignment=1;
    xingLab8.text=@"*";
    [_scrollView addSubview:xingLab8];
    
    UILabel *label8=[[UILabel alloc]initWithFrame:CGRectMake(30, 205+totalHeight*3+50+50+100, 110, 40)];
    label8.font=[UIFont systemFontOfSize:14.0f];
    label8.text=@"经营场地照片";
    [_scrollView addSubview:label8];
    
    //tupian5
    _imageView5=[[UIImageView alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 220+totalHeight*3+50+50+100, (SCREENWIDTH-150)/2, ((SCREENWIDTH-150)/2)*116/176)];
    _imageView5.image=[UIImage imageNamed:@"mohu-13"];
    _imageView5.userInteractionEnabled=YES;
    [_scrollView addSubview:_imageView5];
    UITapGestureRecognizer *tapGesture5=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_imageView5 addGestureRecognizer:tapGesture5];
    //照片下端红色文字
    UILabel *under_red2 =[[UILabel alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 220+50+totalHeight*3+((SCREENWIDTH-150)/2)*116/176+50+100, (SCREENWIDTH-150)/2, 40)];
    under_red2.text=@"经营场地照片";
    under_red2.font=[UIFont systemFontOfSize:14.0f];
    under_red2.textAlignment=1;
    under_red2.textColor=[UIColor redColor];
    [_scrollView addSubview:under_red2];
    
    UIView *lineView8=[[UIView alloc]initWithFrame:CGRectMake(10, 200+totalHeight*4+50+50+100, SCREENWIDTH-20, 0.6)];
    lineView8.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineView8];
    
    //hang9-----
//    UILabel *xingLab9=[[UILabel alloc]initWithFrame:CGRectMake(10, 215+totalHeight*4, 20, 20)];
//    xingLab9.font=[UIFont systemFontOfSize:20.0f];
//    xingLab9.textColor=[UIColor redColor];
//    xingLab9.textAlignment=1;
//    xingLab9.text=@"*";
//    [_scrollView addSubview:xingLab9];

    
    UILabel *label9=[[UILabel alloc]initWithFrame:CGRectMake(30, 205+totalHeight*4+50+50+100, 110, 40)];
    label9.font=[UIFont systemFontOfSize:14.0f];

    label9.text=@"营业地水电票";
    [_scrollView addSubview:label9];
    
    //tupian6
    _imageView6=[[UIImageView alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 220+totalHeight*4+50+50+100, (SCREENWIDTH-150)/2, ((SCREENWIDTH-150)/2)*116/176)];
    _imageView6.image=[UIImage imageNamed:@"mohu-14"];
    _imageView6.userInteractionEnabled=YES;
    [_scrollView addSubview:_imageView6];
    UITapGestureRecognizer *tapGesture6=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_imageView6 addGestureRecognizer:tapGesture6];
    //照片下端红色文字
    UILabel *under_red3 =[[UILabel alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 220+50+totalHeight*4+((SCREENWIDTH-150)/2)*116/176+50+100, (SCREENWIDTH-150)/2, 40)];
    under_red3.text=@"水电票据照片";
    under_red3.font=[UIFont systemFontOfSize:14.0f];
    under_red3.textAlignment=1;
    under_red3.textColor=[UIColor redColor];
    [_scrollView addSubview:under_red3];
    
    UIView *lineView9=[[UIView alloc]initWithFrame:CGRectMake(10, 200+totalHeight*5+50+50+100, SCREENWIDTH-20, 0.6)];
    lineView9.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineView9];
    
    //hang10-------
    
    //最后一行，返回上一级，或者进入下一级页面
    UIButton *from=[UIButton buttonWithType:UIButtonTypeCustom];
    from.frame=CGRectMake(SCREENWIDTH/2-110, 210+totalHeight*5+50+50+100, 100, 40);
    from.backgroundColor=[UIColor whiteColor];
    [from setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [from setTitle:@"上一步" forState:UIControlStateNormal];
    from.layer.cornerRadius=8.0f;
    from.layer.borderColor=[[UIColor redColor]CGColor];
    from.layer.borderWidth=0.6;
    from.tag=1100;
    [from addTarget:self action:@selector(missSelf:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:from];
    
    UIButton *goNext=[UIButton buttonWithType:UIButtonTypeCustom];
    goNext.frame=CGRectMake(SCREENWIDTH/2+5, 210+totalHeight*5+50+50+100, 100, 40);
    goNext.backgroundColor=[UIColor redColor];
    [goNext setTitle:@"下一步" forState:UIControlStateNormal];
    [goNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    goNext.layer.cornerRadius=8.0f;
    goNext.layer.borderColor=[[UIColor redColor]CGColor];
    goNext.layer.borderWidth=0.6;
    goNext.tag=1200;
    [goNext addTarget:self action:@selector(goNext:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:goNext];
    
    //有 或 无
    NSString*exp =[NSString getTheNoNullStr:shopInfoDic[@"explain_lic"] andRepalceStr:@""];
    
    if (exp.length>0) {
        _haveBtn.backgroundColor=[UIColor lightGrayColor];
        _noneBtn.backgroundColor=[UIColor redColor];
        _haveBtn.selected=NO;
        _noneBtn.selected=YES;
        _reasonTF.text=[NSString getTheNoNullStr:shopInfoDic[@"explain_lic"] andRepalceStr:@""];
        

    }else{
        
        _haveBtn.backgroundColor=[UIColor redColor];
        _noneBtn.backgroundColor=[UIColor lightGrayColor];
        _haveBtn.selected=YES;
        _noneBtn.selected=NO;
    }
    //房产或租赁
    if ([shopInfoDic[@"house_contact"] isEqualToString:@"房产证明"]) {
        
        
        _agreeBtn1.backgroundColor=[UIColor lightGrayColor];
        _agreeBtn2.backgroundColor=[UIColor redColor];
        _agreeBtn1.selected=NO;
        _agreeBtn2.selected=YES;
        _houseProvide1.text=@"房产证明首页";
        _houseProvide2.text=@"房产证明尾页";
    }else{
        _agreeBtn1.backgroundColor=[UIColor redColor];
        _agreeBtn2.backgroundColor=[UIColor lightGrayColor];
        _agreeBtn1.selected=YES;
        _agreeBtn2.selected=NO;
        _houseProvide1.text=@"租赁合同首页";
        _houseProvide2.text=@"租赁合同尾页";
    }
    [NSThread detachNewThreadSelector:@selector(downLoadImageAndSeeIfExists) toTarget:self withObject:nil];
    
    
    _scrollView.contentSize=CGSizeMake(SCREENWIDTH, goNext.bottom+20);
    
}
#pragma mark --界面完结
//模态消失，返回上级界面
-(void)missSelf:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)goNext:(UIButton *)sender{
    if (self.haveBtn.selected==YES) {

        if ([self.locationLab.text isEqualToString:@""]||[self.detailAddressTF.text isEqualToString:@""]||[self.store_textf.text isEqualToString:@""]||[self.agencyNameTF.text isEqualToString:@""]||[self.kindLab.text isEqualToString:@""]||self.ifImageView1==NO||self.ifImageView4==NO||self.ifImageView5==NO||[_company_nameTF.text isEqualToString:@""]||[_company_styleTF.text isEqualToString:@""]) {

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
            
            [self saveRequest:0];
            //有营业执照，不须说明情况，去下个界面，不给下个页面传入说明情况
            NewLastViewController *nextVC=[[NewLastViewController alloc]init];
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

        if ([self.locationLab.text isEqualToString:@""]||[self.detailAddressTF.text isEqualToString:@""]||[self.store_textf.text isEqualToString:@""]||[self.agencyNameTF.text isEqualToString:@""]||[self.kindLab.text isEqualToString:@""]||[self.reasonTF.text isEqualToString:@""]||self.ifImageView4==NO||self.ifImageView5==NO||[_company_nameTF.text isEqualToString:@""]||[_company_styleTF.text isEqualToString:@""]) {
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
            
            [self saveRequest:0];
            
            NewLastViewController *nextVC=[[NewLastViewController alloc]init];
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
    
    for (UITextField *tf in _scrollView.subviews) {
        [tf resignFirstResponder];
    }
    
    pickView.dataSource=self.tradeArray;
    __weak typeof(self)  wealSelf = self;
    pickView.valueDidSelect = ^(NSString *value) {
        
        wealSelf.kindLab.text =  [[value componentsSeparatedByString:@"/"] firstObject];
        
    };
    [pickView show];
    
//    if (_areaTableView==nil) {
//        _areaTableView=[[UITableView alloc]initWithFrame:CGRectMake(110, _kindLab.bottom, 100, 200) style:UITableViewStylePlain];
//        _areaTableView.delegate=self;
//        _areaTableView.dataSource=self;
//        [_scrollView addSubview:_areaTableView];
//        self.tradeArray = [[NSMutableArray alloc]initWithObjects:@"美容",@"美发",@"美甲",@"足疗按摩",@"皮革养护",@"汽车服务",@"洗衣",@"瑜伽舞蹈",@"瘦身纤体",@"宠物店",@"电影院",@"运动健身",@"零售连锁",@"餐饮食品",@"医药",@"游乐场",@"娱乐KTV",@"婚纱摄影",@"游泳馆",@"超市购物",@"甜点饮品",@"酒店",@"教育培训",@"商务会所",@"全部分类", nil];
//    }
}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    return self.tradeArray.count;
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (cell==nil) {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//        cell.backgroundColor = RGB(234, 234, 234);
//    }
//    cell.textLabel.text=self.tradeArray[indexPath.row];
//    cell.textLabel.font=[UIFont systemFontOfSize:13.0f];
//    return cell;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    _areaTableView.frame=CGRectMake(110, 64+190+44, 100, 0);
//    [_areaTableView removeFromSuperview];
//    _areaTableView=nil;
//    self.kindLab.text=self.tradeArray[indexPath.row];
//}

-(void)downLoadImageAndSeeIfExists{
    
     array=[NSMutableArray array];
    NSString *name = [[[NSString alloc]initWithFormat:@"%@licenseImage/%@.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImage *image= [self getImageFromURL:name];
    if (image) {
        self.ifImageView1=YES;
        [array addObject:image];
    }else{
        image=[UIImage imageNamed:@"mohu-09"];
        [array addObject:image];
    }
    NSString *name2;
    NSString *name3;
    
    NSMutableArray *muta_arr_house= [NSMutableArray array];
    
    NSMutableArray *muta_arr_tenancy= [NSMutableArray array];
   
    //添加房产证明
    {
        name2 = [[[NSString alloc]initWithFormat:@"%@houseImage/%@_01.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        UIImage *image2= [self getImageFromURL:name2];
        
        if (image2 ) {
            if ([shopInfoDic[@"house_contact"] isEqualToString:@"房产证明"]) {
                self.ifImageView2=YES;

            }
            
            [muta_arr_house addObject:image2];
        }else{
            image2=[UIImage imageNamed:@"mohu-10"];
            [muta_arr_house addObject:image2];
        }


        name3 = [[[NSString alloc]initWithFormat:@"%@houseImage/%@_02.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        UIImage *image3= [self getImageFromURL:name3];
        if (image3 ) {
            if ([shopInfoDic[@"house_contact"] isEqualToString:@"房产证明"]) {
                self.ifImageView3=YES;
                
            }

            [muta_arr_house addObject:image3];
        }else{
            image3=[UIImage imageNamed:@"mohu-11"];
            [muta_arr_house addObject:image3];
        }

        [array addObject:muta_arr_house];

        
    }
    
    //添加租赁合同图片
    
    {
        name2 = [[[NSString alloc]initWithFormat:@"%@tenancyImage/%@_01.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        name3 = [[[NSString alloc]initWithFormat:@"%@tenancyImage/%@_02.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        UIImage *image2= [self getImageFromURL:name2];

        if (image2 ) {
            
            if ([shopInfoDic[@"house_contact"] isEqualToString:@"租赁合同"]) {
                self.ifImageView2=YES;
                
            }

            [muta_arr_tenancy addObject:image2];
        }else{
            image2=[UIImage imageNamed:@"mohu-10"];
            [muta_arr_tenancy addObject:image2];
        }

        UIImage *image3= [self getImageFromURL:name3];
        if (image3 ) {
            if ([shopInfoDic[@"house_contact"] isEqualToString:@"租赁合同"]) {
                self.ifImageView3=YES;
                
            }
            [muta_arr_tenancy addObject:image3];
        }else{
            image3=[UIImage imageNamed:@"mohu-11"];
            [muta_arr_tenancy addObject:image3];
        }

        [array addObject:muta_arr_tenancy];
        
    }
    

    

    NSString *name4 = [[[NSString alloc]initWithFormat:@"%@lpImage/%@.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImage *image4= [self getImageFromURL:name4];
    if (image4) {
        self.ifImageView4=YES;
        [array addObject:image4];
    }else{
        image4=[UIImage imageNamed:@"mohu-12"];
        [array addObject:image4];
    }
    
    NSString *name5 = [[[NSString alloc]initWithFormat:@"%@addImage/%@.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImage *image5= [self getImageFromURL:name5];
    if (image5) {
        self.ifImageView5=YES;
        [array addObject:image5];
    }else{
        image5=[UIImage imageNamed:@"mohu-13"];
        [array addObject:image5];
    }
    
    NSString *name6 = [[[NSString alloc]initWithFormat:@"%@wepImage/%@.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImage *image6= [self getImageFromURL:name6];
    if (image6) {
        self.ifImageView6=YES;
        [array addObject:image6];
    }else{
        image6=[UIImage imageNamed:@"mohu-14"];
        [array addObject:image6];
    }
    
//    DebugLog(@"array===%@",array);
    [self performSelectorOnMainThread:@selector(refreshUI:) withObject:array waitUntilDone:NO];
}
-(void)refreshUI:(NSMutableArray *)arr{
    if (self.ifImageView1==YES) {
        if (self.haveBtn.selected==YES) {
            self.imageView1.image=arr[0];
        }
    }
    if ([shopInfoDic[@"house_contact"] isEqualToString:@"房产证明"]) {
        if (self.ifImageView2==YES) {
            self.imageView2.image=arr[1][0];
        }
        if (self.ifImageView3==YES) {
            self.imageView3.image=arr[1][1];
        }

    }else{
        if (self.ifImageView2==YES) {
            self.imageView2.image=arr[2][0];
        }
        if (self.ifImageView3==YES) {
            self.imageView3.image=arr[2][1];
        }

    }
        if (self.ifImageView4==YES) {
        self.imageView4.image=arr[3];
    }
    if (self.ifImageView5==YES) {
        self.imageView5.image=arr[4];
    }
    if (self.ifImageView6==YES) {
        self.imageView6.image=arr[5];
    }
}
#pragma mark --判断有无营业执照照片
-(void)btn1Click:(UIButton *)sender{
    if (sender==self.haveBtn) {
        self.noneBtn.selected=NO;
        [self.noneBtn setBackgroundColor:[UIColor lightGrayColor]];
        self.haveBtn.selected=YES;
        [self.haveBtn setBackgroundColor:[UIColor redColor]];
        _reasonTF.text = @"";
        if (self.ifImageView1==YES) {
            self.imageView1.image=array[0];
        }
    
    }else if (sender==self.noneBtn){
        self.haveBtn.selected=NO;
        [self.haveBtn setBackgroundColor:[UIColor lightGrayColor]];
        self.noneBtn.selected=YES;
        [self.noneBtn setBackgroundColor:[UIColor redColor]];
         _reasonTF.text = [NSString getTheNoNullStr:shopInfoDic[@"explain_lic"] andRepalceStr:@""];
        self.imageView1.image=[UIImage imageNamed:@"mohu-09"];

    }
}
#pragma mark --判断是租赁合同还是房产证明
-(void)btn2Click:(UIButton *)sender{
    if (sender==self.agreeBtn1) {
        self.agreeBtn2.selected=NO;
        [self.agreeBtn2 setBackgroundColor:[UIColor lightGrayColor]];
        self.agreeBtn1.selected=YES;
        [self.agreeBtn1 setBackgroundColor:[UIColor redColor]];
        _houseProvide1.text=@"租赁合同首页";
        _houseProvide2.text=@"租赁合同尾页";
        
        if (self.ifImageView2==YES) {
            self.imageView2.image=array[2][0];
        }
        if (self.ifImageView3==YES) {
            self.imageView3.image=array[2][1];
        }

        
    }else if(sender==self.agreeBtn2){
        self.agreeBtn1.selected=NO;
        [self.agreeBtn1 setBackgroundColor:[UIColor lightGrayColor]];
        self.agreeBtn2.selected=YES;
        [self.agreeBtn2 setBackgroundColor:[UIColor redColor]];
        _houseProvide1.text=@"房产证明首页";
        _houseProvide2.text=@"房产证明尾页";
        
        if (self.ifImageView2==YES) {
            self.imageView2.image=array[1][0];
        }
        if (self.ifImageView3==YES) {
            self.imageView3.image=array[1][1];
        }
    }
}
#pragma mark --上传图片点击事件
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
        
    }else {
        
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

        
        
        
        
   if (imageViews==self.imageView2){
        self.indexTag=2;
     
        
    }else if (imageViews==self.imageView3){
        self.indexTag=3;
        
    }else if (imageViews==self.imageView4){
        self.indexTag=4;

        
    }else if (imageViews==self.imageView5){
        self.indexTag=5;

       
        
    }else if (imageViews==self.imageView6){
        self.indexTag=6;
        
    }
        
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
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/upload/upload",BASEURL];
    
    
    
    
    
    
    
    NSString *name = [[NSString alloc]initWithFormat:@"%@",shopInfoDic[@"muid"]];
    
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    
    [parmer setValue:name forKey:@"name"];
    
    if (_indexTag==1) {
        [self.imageView1 setImage:savedImage];
        [parmer setValue:@"license" forKey:@"type"];
        
        
    }else if(_indexTag==2)
    {
        
        
        NSString *name1 = [[NSString alloc]initWithFormat:@"%@_01",shopInfoDic[@"muid"]];
        

        
        [parmer setValue:name1 forKey:@"name"];
        
        
        if (self.agreeBtn1.selected==YES) {
            [parmer setValue:@"tenancy" forKey:@"type"];
            
            [array[2] insertObject:savedImage atIndex:0];
            
             [self.imageView2 setImage:array[2][0]];
            
        }else{
            [parmer setValue:@"house" forKey:@"type"];
            
            [array[1] insertObject:savedImage atIndex:0];
            
            [self.imageView2 setImage:array[1][0]];

            
        }
        
    }else if(_indexTag==3)
    {
        NSString *name2 = [[NSString alloc]initWithFormat:@"%@_02",shopInfoDic[@"muid"]];
        
        [parmer setValue:name2 forKey:@"name"];
        
        if (self.agreeBtn1.selected==YES) {
            [parmer setValue:@"tenancy" forKey:@"type"];
            
            [array[2] insertObject:savedImage atIndex:1];

            [self.imageView3 setImage:array[2][1]];

            
        }else{
            [parmer setValue:@"house" forKey:@"type"];
            [array[1] insertObject:savedImage atIndex:1];

            [self.imageView3 setImage:array[1][1]];

        }

        
        
    }else if (_indexTag==4){
        [self.imageView4 setImage:savedImage];
        [parmer setValue:@"lp" forKey:@"type"];
        
    }else if (_indexTag==5){
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [appdelegate.locService startUserLocationService];
        [self.imageView5 setImage:savedImage];
        [parmer setValue:@"add" forKey:@"type"];
    }else if (_indexTag==6){
        [self.imageView6 setImage:savedImage];
        [parmer setValue:@"wep" forKey:@"type"];
    }
    
    NSData *img_Data = [NSData dataWithContentsOfFile:fullPath];
    
    [parmer setObject:img_Data forKey:@"file1"];
    
    [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        if ([result[@"result_code"] isEqualToString:@"access"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"上传成功", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:3.f];
            
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
        NSLog(@"result===%@", result);
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        DebugLog(@"error-----%@",error.description);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"图片太大,上传失败", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:4.f];
        
    }];
    
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
    
    if (textField ==self.detailAddressTF) {
        for (UITextField *tf in _scrollView.subviews) {
            [tf resignFirstResponder];
        }
        pickView.dataSource=self.streetArray;
        __weak NewMiddleViewController *wealSelf=self;
        pickView.valueDidSelect = ^(NSString *value) {
            
            wealSelf.detailAddressTF.text =  [[value componentsSeparatedByString:@"/"] firstObject];
            
        };
        [pickView show];
        
        return NO;
    }
    
    if (textField ==self.company_styleTF) {
        for (UITextField *tf in _scrollView.subviews) {
            [tf resignFirstResponder];
        }
        pickView.dataSource=@[@"国有企业",@"集体企业",@"联营企业",@"股份合作制企业",@"私营企业",@"个体户",@"合作企业",@"有限责任公司",@"股份有限公司"];
        __weak NewMiddleViewController *wealSelf=self;
        pickView.valueDidSelect = ^(NSString *value) {
            
            wealSelf.company_styleTF.text =  [[value componentsSeparatedByString:@"/"] firstObject];
        };
        [pickView show];
        
        return NO;
    }
    
    return YES;
}
-(void)tapAndHidden{
    [_scrollView endEditing:YES];
    [self.view endEditing:YES];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //Tip:我们可以通过打印touch.view来看看具体点击的view是具体是什么名称,像点击UITableViewCell时响应的View则是UITableViewCellContentView.
    NSLog(@"%@",touch.view);
    if (gestureRecognizer.view == _scrollView) {
        
        if ([NSStringFromClass([touch.view class])    isEqualToString:@"UITableViewCellContentView"]) {
            //返回为NO则屏蔽手势事件
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];//取消第一响应者
    
    return YES;
}


@end
