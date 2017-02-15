//
//  PointRuleViewController.m
//  BletcShop
//
//  Created by Bletc on 16/7/29.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "PointRuleViewController.h"

@interface PointRuleViewController ()

@end

@implementation PointRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.type==9999)
    {
        self.title = @"安全保障";
    }else
        self.title = @"使用规则";
    
    [self _initWebView];

}
-(void)_initWebView
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) ];
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
        self.title = @"安全保障";

        urlStr = [[NSString alloc]initWithFormat:@"http://%@/VipCard/risk_control.html",SOCKETHOST ];
    }else if (self.type==888)
    {
         self.title = @"用户协议";
        urlStr = [[NSString alloc]initWithFormat:@"http://%@/VipCard/user_protocol.html",SOCKETHOST ];
    }else if (self.type==8888)
    {
        self.title = @"协议详情";

        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

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
