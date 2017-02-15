//
//  QYPlayBackView.m
//  iqiyi_ios_sdk_demo
//
//  Created by 苏 瑞强 on 13-8-8.
//  Copyright (c) 2013年 meiwen li. All rights reserved.
//

#import "QYPlayBackView.h"

@interface QYPlayBackView ()

@property(nonatomic,strong)UITextField* inputField;
@property(nonatomic, strong)UIWebView* playBackView;

@end

@implementation QYPlayBackView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
        UIToolbar* topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        topBar.barStyle = UIBarStyleBlackTranslucent;
        
        NSMutableArray *myToolBarItems = [[NSMutableArray alloc] init];
        [myToolBarItems addObject:[[UIBarButtonItem alloc]
                                    initWithTitle:@"关闭"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(action:)] ];
  

        
        _inputField = [[UITextField alloc] initWithFrame:CGRectMake(0, 6, 200, 30)];
        _inputField.borderStyle = UITextBorderStyleRoundedRect;
        _inputField.backgroundColor=[UIColor redColor];
        _inputField.placeholder = @"播放地址";
        _inputField.returnKeyType = UIReturnKeyDone;
        
        UIBarButtonItem* barItem = [[UIBarButtonItem alloc] initWithCustomView:_inputField];
        [myToolBarItems addObject:barItem];
        
        [myToolBarItems addObject:[[UIBarButtonItem alloc]
                                    initWithTitle:@"播放"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(play:)]];

        [topBar setItems:myToolBarItems animated:YES];
        
        [self addSubview:topBar];
        
        CGRect webViewFrame = CGRectMake(0,60, 320, 200);
        UIWebView* aplayBackView = [[UIWebView alloc] initWithFrame:webViewFrame];
        aplayBackView.backgroundColor=[UIColor cyanColor];
        self.playBackView = aplayBackView;
        
        [self addSubview:self.playBackView];
    }
    return self;
}


-(void)action:(id)sender
{
    [self removeFromSuperview];
}

-(void)play:(id)sender
{
    [_inputField resignFirstResponder];
    NSString* urlStr = _inputField.text;
    NSURL* videoUrl = [NSURL URLWithString:urlStr];
    NSURLRequest* videoRequest = [NSURLRequest requestWithURL:videoUrl];
    [self.playBackView loadRequest:videoRequest];

}


@end
