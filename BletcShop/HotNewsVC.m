//
//  HotNewsVC.m
//  BletcShop
//
//  Created by apple on 17/3/1.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "HotNewsVC.h"

@interface HotNewsVC ()<UIWebViewDelegate>
{
    MBProgressHUD *hud;
}
@end

@implementation HotNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"商消乐头条";
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.userInteractionEnabled = YES;
    
    UIWebView *_webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    _webView.delegate=self;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mp.weixin.qq.com/s/5YhVWVpyc4lSg59_1rASzQ"]]];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [hud hideAnimated:YES afterDelay:0.0f];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [hud hideAnimated:YES afterDelay:5.0];
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
