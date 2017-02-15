//
//  NewShopIntroduceViewController.m
//  BletcShop
//
//  Created by apple on 16/12/13.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NewShopIntroduceViewController.h"
#import "PictureDetailViewController.h"
#import "UIImageView+WebCache.h"
@interface NewShopIntroduceViewController ()

@end

@implementation NewShopIntroduceViewController
{
    __block UIScrollView *bgScrollView;
    __block UITextView *intrTextView;
    __block UITextField *timeTF;
    __block UITextView *serviceText;
    __block UITextView *noticeTextView;
    __block UITextView *wnoticeTextView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"商家介绍";
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick)];
    self.navigationItem.rightBarButtonItem=item;
    
    self.view.backgroundColor=RGB(240, 240, 240);
    
    bgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    bgScrollView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    bgScrollView.contentSize=CGSizeMake(SCREENWIDTH, 690);
    bgScrollView.backgroundColor=RGB(240, 240, 240);
    [self.view addSubview:bgScrollView];
    //1.
    UIView *shopIntroduceView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90)];
    shopIntroduceView.backgroundColor=[UIColor whiteColor];
    [bgScrollView addSubview:shopIntroduceView];
    
    UILabel *intrName=[[UILabel alloc]initWithFrame:CGRectMake(19, 16, 100, 16)];
    intrName.text=@"商家简介：";
    intrName.font=[UIFont systemFontOfSize:16.0f];
    [shopIntroduceView addSubview:intrName];
    //------
    intrTextView=[[UITextView alloc]initWithFrame:CGRectMake(11, 35, SCREENWIDTH-22, 45)];
    intrTextView.backgroundColor=RGB(240, 240, 240);
    intrTextView.font=[UIFont systemFontOfSize:15.0f];
    [shopIntroduceView addSubview:intrTextView];
    //2.
    UIView *businessTimeAndServiceView=[[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 170)];
    businessTimeAndServiceView.backgroundColor=[UIColor whiteColor];
    [bgScrollView addSubview:businessTimeAndServiceView];
    //timelabel
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(19, 10, 100, 16)];
    timeLabel.text=@"营业时间：";
    timeLabel.font=[UIFont systemFontOfSize:16.0f];
    [businessTimeAndServiceView addSubview:timeLabel];
    //-------
    timeTF=[[UITextField alloc]initWithFrame:CGRectMake(11, 30, SCREENWIDTH-22, 45)];
    timeTF.placeholder=@"  09:00-22:00(周末法定节假日通用)";
    timeTF.font=[UIFont systemFontOfSize:15.0f];
    timeTF.backgroundColor=RGB(240, 240, 240);
    [businessTimeAndServiceView addSubview:timeTF];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, 84, SCREENWIDTH, 1)];
    lineView1.backgroundColor=RGB(240, 240, 240);
    [businessTimeAndServiceView addSubview:lineView1];
    //servicelabel
    UILabel *serviceLabel=[[UILabel alloc]initWithFrame:CGRectMake(19, 95, 100, 16)];
    serviceLabel.text=@"门店服务：";
    serviceLabel.font=[UIFont systemFontOfSize:16.0f];
    [businessTimeAndServiceView addSubview:serviceLabel];
    //------
    serviceText=[[UITextView alloc]initWithFrame:CGRectMake(11, 95+16+3, SCREENWIDTH-22, 45)];
    serviceText.backgroundColor=RGB(240, 240, 240);
    serviceText.font=[UIFont systemFontOfSize:15.0f];
    [businessTimeAndServiceView addSubview:serviceText];

    //noticeView
    UIView *noticeView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(businessTimeAndServiceView.frame)+10, SCREENWIDTH, 230)];
    noticeView.backgroundColor=[UIColor whiteColor];
    [bgScrollView addSubview:noticeView];
    //notice
    UILabel *noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(19, 10, 100, 16)];
    noticeLabel.text=@"购买须知：";
    [noticeView addSubview:noticeLabel];
    
    noticeTextView=[[UITextView alloc]initWithFrame:CGRectMake(11, 30, SCREENWIDTH-22, 106)];
    noticeTextView.backgroundColor=RGB(240, 240, 240);
    noticeTextView.font=[UIFont systemFontOfSize:15.0f];
    [noticeView addSubview:noticeTextView];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0, 144, SCREENWIDTH, 1)];
    lineView2.backgroundColor=RGB(240, 240, 240);
    [noticeTextView addSubview:lineView2];
    //温馨提示
    UILabel *buyNote=[[UILabel alloc]initWithFrame:CGRectMake(19, 155, 100, 16)];
    buyNote.text=@"温馨提示：";
    [noticeView addSubview:buyNote];
    
    wnoticeTextView=[[UITextView alloc]initWithFrame:CGRectMake(11, 175, SCREENWIDTH-22, 45)];
    wnoticeTextView.backgroundColor=RGB(240, 240, 240);
    wnoticeTextView.font=[UIFont systemFontOfSize:15.0f];
    [noticeView addSubview:wnoticeTextView];
    
    //imageAndText
    UIView *textDetailView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(noticeView.frame)+10, SCREENWIDTH, 30)];
    textDetailView.backgroundColor=[UIColor whiteColor];
    [bgScrollView addSubview:textDetailView];
    
    UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(19, 10, 100, 16)];
    detailLabel.text=@"图文详情：";
    [textDetailView addSubview:detailLabel];
    
    UILabel *lookLable=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-100, 13, 100, 13)];
    lookLable.text=@"点击查看 >";
    lookLable.font=[UIFont systemFontOfSize:13.0f];
    lookLable.textColor=[UIColor grayColor];
    [textDetailView addSubview:lookLable];
    
    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setClick)];
    [textDetailView addGestureRecognizer:tapRecognizer];
    
    [self postRequestGetInfo];
    [self postRequestGetImageInfo];
    // Do any additional setup after loading the view.
}
-(void)btnClick{
    
    [intrTextView resignFirstResponder];
    [timeTF resignFirstResponder];
    [serviceText resignFirstResponder];
    [noticeTextView resignFirstResponder];
    [wnoticeTextView resignFirstResponder];
    
    [self postRequestSetInfo];
    
}
-(void)setClick{
    PictureDetailViewController *picVC = [[PictureDetailViewController alloc]init];
    [self.navigationController pushViewController:picVC animated:YES ];
}
//get
-(void)postRequestGetInfo
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/Info/get",BASEURL ];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    __block NewShopIntroduceViewController *tempSelf=self;
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"postRequestGetInfo%@", result);
        tempSelf.data = result;
        if (tempSelf.data.count>0) {
            intrTextView.text=tempSelf.data[0][@"intro"];
            serviceText.text=tempSelf.data[0][@"service"];
            noticeTextView.text=tempSelf.data[0][@"notice"];
            wnoticeTextView.text=tempSelf.data[0][@"tip"];
            timeTF.text=tempSelf.data[0][@"time"];
        }
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

//set
-(void)postRequestSetInfo{
    NSString *urlStr=[[NSString alloc]initWithFormat:@"%@MerchantType/Info/mod",BASEURL];
    NSMutableDictionary *userInfos=[NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    [userInfos setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    [userInfos setObject:intrTextView.text forKey:@"intro"];
    [userInfos setObject:timeTF.text forKey:@"time"];
    [userInfos setObject:serviceText.text forKey:@"service"];
    [userInfos setObject:noticeTextView.text forKey:@"notice"];
    [userInfos setObject:wnoticeTextView.text forKey:@"tip"];
    
    [KKRequestDataService requestWithURL:urlStr params:userInfos httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"postRequestGetInfo%@", result);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;

        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );

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
//获取商家图文详情的方法
-(void)postRequestGetImageInfo
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/Imgtxt/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    NewShopIntroduceViewController *tempSelf=self;
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray * result) {
        
        NSLog(@"postRequestGetInfo%@", result);
        tempSelf.imageArray = result;

        if (tempSelf.imageArray.count>0) {
            if (tempSelf.imageArray.count==1) {
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-270)/4+0%3*120, 560+0/3*120, 90, 90)];
                imageView.backgroundColor=[UIColor redColor];
                [bgScrollView addSubview:imageView];
                NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[result[0]  objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [imageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
                
            }else if (tempSelf.imageArray.count==2){
                
                UIImageView *imageView0=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-270)/4+0%3*120, 560+0/3*120, 90, 90)];
                imageView0.backgroundColor=[UIColor redColor];
                [bgScrollView addSubview:imageView0];
                NSURL * nurl0=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[result[0]  objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [imageView0 sd_setImageWithURL:nurl0 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
                
                
                UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-270)/4+1%3*120, 560+1/3*120, 90, 90)];
                imageView1.backgroundColor=[UIColor redColor];
                [bgScrollView addSubview:imageView1];
                NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[result[1]  objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [imageView1 sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
                
            }else if (tempSelf.imageArray.count==3){
                
                UIImageView *imageView0=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-270)/4+0%3*120, 560+0/3*120, 90, 90)];
                imageView0.backgroundColor=[UIColor redColor];
                [bgScrollView addSubview:imageView0];
                NSURL * nurl0=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[result[0]  objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [imageView0 sd_setImageWithURL:nurl0 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
                
                
                UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-270)/4+1%3*120, 560+1/3*120, 90, 90)];
                imageView1.backgroundColor=[UIColor redColor];
                [bgScrollView addSubview:imageView1];
                NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[result[1]  objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [imageView1 sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
                
                UIImageView *imageView3=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-270)/4+2%3*120, 560+2/3*120, 90, 90)];
                imageView3.backgroundColor=[UIColor redColor];
                [bgScrollView addSubview:imageView3];
                NSURL * nurl2=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[result[2]  objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [imageView3 sd_setImageWithURL:nurl2 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
            }else if (tempSelf.imageArray.count>3){
                UIImageView *imageView0=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-270)/4+0%3*120, 560+0/3*120, 90, 90)];
                imageView0.backgroundColor=[UIColor redColor];
                [bgScrollView addSubview:imageView0];
                NSURL * nurl0=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[result[0]  objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [imageView0 sd_setImageWithURL:nurl0 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
                
                
                UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-270)/4+1%3*120, 560+1/3*120, 90, 90)];
                imageView1.backgroundColor=[UIColor redColor];
                [bgScrollView addSubview:imageView1];
                NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[result[1]  objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [imageView1 sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
                
                UIImageView *imageView3=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-270)/4+2%3*120, 560+2/3*120, 90, 90)];
                imageView3.backgroundColor=[UIColor redColor];
                [bgScrollView addSubview:imageView3];
                NSURL * nurl2=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[result[2]  objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [imageView3 sd_setImageWithURL:nurl2 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
            }else{
                
            }
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
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
