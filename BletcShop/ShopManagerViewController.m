//
//  ShopManagerViewController.m
//  BletcShop
//
//  Created by Bletc on 16/4/18.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShopManagerViewController.h"
#import "ShopManagerTableViewCell.h"
#import "ShopTabBarController.h"
#import "MerchantDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface ShopManagerViewController ()
@property(nonatomic,weak)UIScrollView *back_scrollView;//背景滑动视图

@property (nonatomic,retain)UITextField *phoneText;

@property (nonatomic,strong)NSArray *applyArray;
@property NSInteger editTag;

@property (nonatomic,retain)UIButton *agreeBtn;
@property (nonatomic,retain)UIButton *noAgreeBtn;

@property(strong,nonatomic)NSArray *data_A;

@property(nonatomic,weak)UIView *NewView;

@end

@implementation ShopManagerViewController
{
    UIToolbar *toolView;
    
    UIButton *addList_btn;
    
    CustomIOSAlertView *_alertView;
}
-(NSArray *)applyArray{
    if (!_applyArray) {
        _applyArray = [NSArray array];
    }
    return _applyArray;
}
-(NSArray *)data_A{
    if (!_data_A) {
        _data_A = [NSArray array];
    }
    return _data_A;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺管理";
    self.view.backgroundColor = [UIColor whiteColor];

    [self initSubViews];

    
    toolView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    [toolView setBarStyle:UIBarStyleBlackTranslucent];
    toolView.barTintColor=[UIColor whiteColor];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btna = [UIButton buttonWithType:UIButtonTypeCustom];
    btna.frame = CGRectMake(2, 5, 50, 25);
    [btna addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [btna setImage:[UIImage imageNamed:@"shouqi2"] forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btna];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [toolView setItems:buttonsArray];
    
    self.editTag = 0;

    [self postApplyRequest];
    [self postRequest];

    
}
-(void)initSubViews{
    //顶部按钮
    UIView *Newview = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 50)];
    [self.view addSubview:Newview];
    UIView *linview = [[UIView alloc]initWithFrame:CGRectMake(0, 49, SCREENWIDTH, 1)];
    linview.backgroundColor = [UIColor grayColor];
    linview.alpha = 0.3;
    [Newview addSubview:linview];
    self.NewView = Newview;
    
    UIButton *NewAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    NewAdd.frame = CGRectMake((SCREENWIDTH/2-120)/2, 5, 120, 30);
    [NewAdd setTitle:@"+申请管理商铺" forState:UIControlStateNormal];
    NewAdd.backgroundColor = NavBackGroundColor;
    NewAdd.layer.cornerRadius = 10;
    [NewAdd.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [NewAdd addTarget:self action:@selector(addManagerShop) forControlEvents:UIControlEventTouchUpInside];
    [Newview addSubview:NewAdd];
    
    
    addList_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addList_btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    addList_btn.frame = CGRectMake(SCREENWIDTH/2+(SCREENWIDTH/2-120)/2, 5, 120, 30);
   
    [addList_btn setTitle:@"申请列表(0)" forState:UIControlStateNormal];
    addList_btn.backgroundColor = NavBackGroundColor;
    addList_btn.layer.cornerRadius = 10;
    [addList_btn addTarget:self action:@selector(applyList) forControlEvents:UIControlEventTouchUpInside];
    [Newview addSubview:addList_btn];
    
    //创建scrollView,展示用户
    UIScrollView *back_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NewView.height+10, SCREENWIDTH, SCREENHEIGHT-64-self.NewView.height-10)];
    back_scrollView.backgroundColor = RGB(234, 234, 234);
    [self.view addSubview:back_scrollView];
    self.back_scrollView = back_scrollView;
    

}
-(void)creatSubviewsForScrollviewWithArray:(NSArray*)arr{
    
    for (UIView *view in  self.back_scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i=0; i<arr.count; i++) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-240)/5+i%4*(60+(SCREENWIDTH-240)/5), (SCREENWIDTH-240)/5+i/4*(60+(SCREENWIDTH-240)/5+10), 60, 60)];
        imageView.tag=i+10;
        imageView.layer.cornerRadius=8.0f;
        imageView.clipsToBounds=YES;
        imageView.userInteractionEnabled=YES;
        //        NSURL * nurl1=[[NSURL alloc] initWithString:[[HEADIMAGE stringByAppendingString:[[self.data objectAtIndex:i] objectForKey:@"name "]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        
        //        [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"mhead_default.png"]];
        
        imageView.image=[UIImage imageNamed:@"mhead_default.png"];
        UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [imageView addGestureRecognizer:tapRecognizer];


        [_back_scrollView addSubview:imageView];

        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((SCREENWIDTH-240)/5+i%4*(60+(SCREENWIDTH-240)/5), (SCREENWIDTH-240)/5+i/4*(60+(SCREENWIDTH-240)/5+10)+60+8, 60, 12)];
        label.font=[UIFont systemFontOfSize:15.0f];
        label.textAlignment=1;
        
        label.text=[[arr objectAtIndex:i] objectForKey:@"name"];
        [_back_scrollView addSubview:label];
        
        
        
        
        _back_scrollView.contentSize = CGSizeMake(0, label.bottom);
    }


    

}

//获取已管理店铺列表
-(void)postRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/store/manageGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        DebugLog(@"result==%@",result);
        
        self.data_A = [result copy];
        
        [self creatSubviewsForScrollviewWithArray:self.data_A];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

/**
 获取申请里列表
 */
-(void)postApplyRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/store/appGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.shopInfoDic[@"phone"] forKey:@"phone"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);
        
        self.applyArray = [result copy];
        
        [addList_btn setTitle:[[NSString alloc]initWithFormat:@"申请列表(%ld)",self.applyArray.count] forState:0];

        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}


-(void)applyList
{
    if (self.applyArray.count==0) {
        
//        UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无申请!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
//        [altView show];

        
    }else{
        self.editTag=1;
        [self NewAddVipAction];
 
    }
}

-(void)addManagerShop

{
//    self.editTag=0;
//    [self NewAddVipAction];
    
    
    UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"输入店铺注册手机号:" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    altView.alertViewStyle = UIAlertViewStylePlainTextInput;
    altView.tag = 999;
    [altView show];
    
}

-(void)NewAddVipAction
{
     _alertView = [[CustomIOSAlertView alloc] init];
    
    [_alertView setContainerView:[self createDemoView]];
    
    if (self.editTag==0) {
        [_alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确定", @"取消", nil]];
    }else if (self.editTag==1) {
        [_alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"返回", nil]];
    }else if (self.editTag==2)
    {
        [_alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"删除", @"取消", nil]];
    }

    [_alertView setDelegate:self];
    
    [_alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        [alertView close];
    }];
    
    [_alertView setUseMotionEffects:true];
    
    [_alertView show];
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (alertView.tag==0&&buttonIndex==1) {
        [alertView close];
    }
    else if (alertView.tag==0&&buttonIndex==0)
    {
        if (self.editTag==0) {
            [self postRequestAddShop];
        }
        
    }

}



/**
 申请管理店铺
 */
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
            [self tishi:@"已存在"];
           
        }else{
            [self tishi:@"申请错误"];

           }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        [self tishi:@"添加出错,请重新添加"];

        
        
    }];

}
- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] init];
    if (self.editTag==0) {
        demoView.frame =CGRectMake(0, 0, 280, 50);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 30)];
        label.text = @"输入店铺注册手机号:";
        label.font = [UIFont systemFontOfSize:12];
        [demoView addSubview:label];
        UITextField *nameText = [[UITextField alloc]initWithFrame:CGRectMake(140, 10, 130, 30)];
        [nameText setInputAccessoryView:toolView];
        self.phoneText = nameText;
        nameText.layer.borderWidth = 0.3;
        nameText.backgroundColor = tableViewBackgroundColor;
        nameText.placeholder = @"";
        nameText.font = [UIFont systemFontOfSize:10];
        nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:nameText];
    }
    if (self.editTag==1) {

        demoView.frame =CGRectMake(0, 0, 280, 50+self.applyArray.count*50);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, demoView.width, 50)];
        label.text = @"店铺申请列表";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        [demoView addSubview:label];
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, demoView.width, 0.3)];
        line2.backgroundColor = [UIColor grayColor];
        line2.alpha = 0.3;
        [demoView addSubview:line2];
        for(int i=0; i<self.applyArray.count; i++) {
          
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 50*(i+1), demoView.width/2, 30)];
            
            label.text = [[self.applyArray objectAtIndex:i] objectForKey:@"store"];
                //label.text = @"修改昵称";
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont boldSystemFontOfSize:12];
            [demoView addSubview:label];
            UILabel *delabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50*(i+1)+30, 110, 20)];
            
            delabel.text = @"申请管理您的店铺";
            //label.text = @"修改昵称";
            delabel.textAlignment = NSTextAlignmentLeft;
            delabel.font = [UIFont systemFontOfSize:10];
            [demoView addSubview:delabel];
            
            UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //self.agreeBtn =agreeBtn;
            agreeBtn.frame = CGRectMake(demoView.width/2+20, 50*(i+1)+10, 50, 30);
            agreeBtn.backgroundColor = ButtonGreenColor;
            agreeBtn.layer.cornerRadius = 10;
            agreeBtn.tag = i;
            agreeBtn.titleLabel.font=[UIFont systemFontOfSize:12];
            [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
            [agreeBtn addTarget:self action:@selector(agreeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [demoView addSubview:agreeBtn];
            UIButton *noBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //self.noAgreeBtn = noBtn;
            noBtn.frame = CGRectMake(demoView.width/2+80, 50*(i+1)+10, 50, 30);
            noBtn.titleLabel.font=[UIFont systemFontOfSize:12];
            noBtn.backgroundColor = NavBackGroundColor;
            noBtn.layer.cornerRadius = 10;
            noBtn.tag = i;
            [noBtn setTitle:@"拒绝" forState:UIControlStateNormal];
            [noBtn addTarget:self action:@selector(noAgreeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [demoView addSubview:noBtn];
            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50*(i+1),SCREENWIDTH, 0.3)];
            line1.backgroundColor = [UIColor grayColor];
            line1.alpha = 0.3;
            [demoView addSubview:line1];
        }
        

    }
    
    return demoView;
}
/**
 不同意管理店铺
 */
-(void)noAgreeBtnAction:(LZDButton *)btn
{
    self.noAgreeBtn = btn;
    NSDictionary*dic = [self.applyArray objectAtIndex:btn.tag];
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/store/set",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:appdelegate.shopInfoDic[@"phone"] forKey:@"phone"];

    [params setObject:@"fail" forKey:@"state"];
    [params setObject:dic[@"muid"] forKey:@"store"];
    
    DebugLog(@"params==no=%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        [_alertView close];

        
        DebugLog(@"result=====%@",result);
        if ([result[@"result_code"] intValue]==1) {
            
            [self.noAgreeBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
            
            [self tishi:@"拒绝管理"];
            
            [self postApplyRequest];

            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

/**
 同意管理店铺
 */
-(void)agreeBtnAction:(LZDButton *)btn
{
    self.agreeBtn = btn;
    NSDictionary *dic = [self.applyArray objectAtIndex:btn.tag];
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/store/set",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:appdelegate.shopInfoDic[@"phone"] forKey:@"phone"];

    [params setObject:@"access" forKey:@"state"];
    [params setObject:dic[@"muid"] forKey:@"store"];
    
    DebugLog(@"params==yes=%@",params);

    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [_alertView close];

        DebugLog(@"result==yes=%@",result);

        if ([result[@"result_code"] intValue]==1) {
            
            [self.agreeBtn setTitle:@"已同意" forState:UIControlStateNormal];
            
            [self tishi:@"同意管理"];
            

            [self postApplyRequest];

        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];

}








-(void)tishi:(NSString*)tishi{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = NSLocalizedString(tishi, @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:3.f];

}
-(void)tapClick:(UITapGestureRecognizer *)gesture{
    UIImageView *imageView=(UIImageView *)[gesture view];
    MerchantDetailViewController *detailVC=[[MerchantDetailViewController alloc]init];
    detailVC.array=self.data_A;
    detailVC.index=imageView.tag-10;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==999&&buttonIndex==0) {
        
        self.phoneText = [alertView textFieldAtIndex:0];
        [self postRequestAddShop];

    }
    
}
-(void)dismissKeyBoard{
    
    [self.phoneText resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
