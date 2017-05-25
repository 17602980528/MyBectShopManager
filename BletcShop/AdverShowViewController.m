//
//  AdverShowViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/2/23.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AdverShowViewController.h"

@interface AdverShowViewController ()

@end

@implementation AdverShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"广告说明";
    self.view.backgroundColor = RGB(240,240 , 240);
//    UIWebView *_webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
//    _webView.scalesPageToFit=YES;
//    [self.view addSubview:_webView];
//    
//    NSURL *url = [NSURL URLWithString:@"https://www.hao123.com"];
//    
//    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
//    
//    [_webView loadRequest:request];
    
    
    
    UIScrollView *_scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    _scrollView.contentSize=CGSizeMake(SCREENWIDTH, SCREENWIDTH*3600/750.0);
    [self.view addSubview:_scrollView];
    
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"收费标准.png"]];
    [_scrollView addSubview:imageView];
    imageView.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*3600/750.0);
    
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
