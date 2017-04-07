//
//  ChouJiangVC.m
//  BletcShop
//
//  Created by Bletc on 2017/4/6.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ChouJiangVC.h"

@interface ChouJiangVC ()<UIWebViewDelegate>
{
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ChouJiangVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"积分抽奖";
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.userInteractionEnabled = YES;

    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    
    [self.webView loadRequest:request];
    


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
