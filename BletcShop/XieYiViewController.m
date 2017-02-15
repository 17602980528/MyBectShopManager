//
//  XieYiViewController.m
//  BletcShop
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "XieYiViewController.h"

@interface XieYiViewController ()

@end

@implementation XieYiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    topView.backgroundColor =NavBackGroundColor;
    [self.view addSubview:topView];
    
//    UIImageView*backImg=[[UIImageView alloc]init];
//    backImg.frame=CGRectMake(9, 30, 12, 20);
//    backImg.image=[UIImage imageNamed:@"leftArrow"];
//    [topView addSubview:backImg];
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, +20, SCREENWIDTH, 44)];
    label.font=[UIFont systemFontOfSize:19];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    [topView addSubview:label];
    
    
    if (self.type==9999)
    {
        label.text = @"安全保障";
    }else if(self.type ==8888){
        label.text = @"协议";

    }else
        label.text = @"使用规则";
    
    
    LZDButton*backTi=[LZDButton creatLZDButton];
    backTi.frame=CGRectMake(0, 20, SCREENWIDTH*0.2, 44);
    [backTi setTitle:@"返回" forState:0];
    [backTi setTitleColor:[UIColor whiteColor] forState:0];
    backTi.block = ^(LZDButton*btn){
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    };
    [topView addSubview:backTi];

    [self _initWebView];

}
-(void)_initWebView
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) ];
    //webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    NSString *urlStr =[[NSString alloc]init];
    if (self.type==99) {
        urlStr = [[NSString alloc]initWithFormat:@"http://%@/VipCard/integral.html",SOCKETHOST ];
    }else if (self.type==999)
    {
        urlStr = [[NSString alloc]initWithFormat:@"http://%@/VipCard/voucher.html",SOCKETHOST ];
    }else if (self.type==9999)
    {
        urlStr = [[NSString alloc]initWithFormat:@"http://%@/VipCard/risk_control.html",SOCKETHOST ];
    }else if (self.type==888)
    {
        urlStr = [[NSString alloc]initWithFormat:@"http://%@/VipCard/user_protocol.html",SOCKETHOST ];
    }else if (self.type==8888)
    {
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

        NSLog(@"shopInfoDic==%@",appdelegate.shopInfoDic);
        
        
        urlStr = [[[NSString alloc]initWithFormat:@"http://101.201.100.191/cnconsum/index.php/App/Extra/source/mpt?store=%@&address=%@&phone=%@",appdelegate.shopInfoDic[@"store"],appdelegate.shopInfoDic[@"address"],appdelegate.shopInfoDic[@"phone"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 发送请求给服务器
    [webView loadRequest:request];
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
