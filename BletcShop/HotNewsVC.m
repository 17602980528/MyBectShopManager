//
//  HotNewsVC.m
//  BletcShop
//
//  Created by apple on 17/3/1.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "HotNewsVC.h"
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
@interface HotNewsVC ()<UIWebViewDelegate>
{
    MBProgressHUD *hud;
    UIWebView *_webView;
    UILabel *label;
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
}
@end

@implementation HotNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = YES;
    
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    _webView.delegate=self;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.href]]];
    
    _progressLayer = [WYWebProgressLayer new];
    if ([self.href containsString:@"http://www.cnconsum.com/cnconsum/helpCenter/"]) {
        _webView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
        
        
        UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
        navView.backgroundColor = NavBackGroundColor;
        [self.view addSubview:navView];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 18, 70, 44)];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:navView];
        [navView addSubview:btn];
        
        label=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-50, 18, 100, 44)];
        label.font=[UIFont systemFontOfSize:19.0f];
        label.text=@"常见问题";
        label.textAlignment=1;
        label.textColor=[UIColor whiteColor];
        [navView addSubview:label];
        _progressLayer.frame = CGRectMake(0, 62, SCREEN_WIDTH, 2);
        [self.view.layer addSublayer:_progressLayer];
    }else{
        _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
        [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    }
    
}
-(void)backClick{
    NSLog(@"======%d===%d",_webView.canGoBack,_webView.canGoForward);
    
    [_webView goBack];
    if (!_webView.canGoBack) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_progressLayer startLoad];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [hud hideAnimated:YES afterDelay:0.0f];
    [_progressLayer finishedLoad];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [hud hideAnimated:YES afterDelay:5.0];
    [_progressLayer finishedLoad];
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
