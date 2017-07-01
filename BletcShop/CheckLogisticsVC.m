//
//  CheckLogisticsVC.m
//  BletcShop
//
//  Created by Bletc on 2017/6/30.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CheckLogisticsVC.h"

#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"

@interface CheckLogisticsVC ()<UIWebViewDelegate>
{
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条

}
@property (weak, nonatomic) IBOutlet UIWebView *web_view;

@end

@implementation CheckLogisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title  = @"物流信息";
    
    [self showHudInView:self.view hint:@"记载中..."];
    
    
    _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://m.kuaidi100.com/result.jsp?com=%@&nu=%@",self.order_dic[@"trackcom"],self.order_dic[@"trackno"]]];
    
    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://m.kuaidi100.com/index_all.html?type=%@&postid=%@",@"中通",@"719815725596"]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.web_view loadRequest:request];
    
   
    

}



- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_progressLayer startLoad];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideHud];
    
    [_progressLayer finishedLoad];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideHud];
    [_progressLayer finishedLoad];
}



@end
