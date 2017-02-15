//
//  VCOPView.m
//  iqiyi_ios_sdk_demo
//
//  Created by 苏 瑞强 on 13-4-20.
//  Copyright (c) 2013年 meiwen li. All rights reserved.
//

#import "VCOPView.h"
@implementation VCOPView

- (UIButton *)buttonWithFrame:(CGRect)frame action:(SEL)action
{
    UIImage *buttonBackgroundImage = [[UIImage imageNamed:@"shipin.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage *disabledButtonBackgroundImage = [[UIImage imageNamed:@"button_background_disabled.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:disabledButtonBackgroundImage forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [button addTarget:self.target action:action forControlEvents:UIControlEventTouchUpInside];
    return button ;
}

-(void)updateProgress:(float)newProgress
{
    _progressView.progress = newProgress;
    _progressValue.text = [NSString stringWithFormat:@"%.2f%%",newProgress*100];
}

- (id)initWithFrame:(CGRect)frame target:(id)target
{
    self = [super initWithFrame:frame];
    if (self) {
        //LOGO
        _target = target;
        
       scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
        scrollView.showsVerticalScrollIndicator=YES;
        scrollView.scrollEnabled=YES;
        scrollView.userInteractionEnabled=YES;
        scrollView.backgroundColor = [UIColor underPageBackgroundColor];
        [self addSubview:scrollView];
        scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,614);
        
        personAuthorizeButton = [self buttonWithFrame:CGRectMake(160, 100, 145, 40) action:@selector(personalButtonPressed:)];
        [personAuthorizeButton setTitle:@"Personal Authorize" forState:UIControlStateNormal];
        [personAuthorizeButton setTitle:@"Personal Authorize" forState:UIControlStateDisabled];
      //  [scrollView addSubview:personAuthorizeButton];

        
        //refresh Token
//        refreshTokenButton = [self buttonWithFrame:CGRectMake(20, 250, [UIScreen mainScreen].bounds.size.width-40, 40) action:@selector(refrshTokenButtonPressed:)];
//        [refreshTokenButton setTitle:@"Refresh Token" forState:UIControlStateNormal];
//        [refreshTokenButton setTitle:@"Refresh Token" forState:UIControlStateDisabled];
//        [scrollView addSubview:refreshTokenButton];
        
//        enterpriseAuthorizeButton  = [self buttonWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2+5, 20, [UIScreen mainScreen].bounds.size.width/2-25, 40) action:@selector(enterPriseAuthorzieButtonPressed:)];
//        enterpriseAuthorizeButton.layer.cornerRadius=8;
//        enterpriseAuthorizeButton.clipsToBounds=YES;
//        [enterpriseAuthorizeButton setTitle:@"开启" forState:UIControlStateNormal];
//        [enterpriseAuthorizeButton setTitle:@"开启" forState:UIControlStateDisabled];
//        [scrollView addSubview:enterpriseAuthorizeButton];
        
        
        //登出
//        _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 70, [UIScreen mainScreen].bounds.size.width-40, 150)];
//        _imageView.backgroundColor=[UIColor underPageBackgroundColor];
//        [scrollView addSubview:_imageView];
        //改用webview
        _webView=[[UIWebView alloc]initWithFrame:CGRectMake(20, 70-50, [UIScreen mainScreen].bounds.size.width-40, 150)];
        _webView.backgroundColor=[UIColor underPageBackgroundColor];
        [scrollView addSubview:_webView];
        [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setBounces:NO];
        
//        logoutButton = [self buttonWithFrame:CGRectMake(5, 20,[UIScreen mainScreen].bounds.size.width/2-25 , 40) action:@selector(logoutButtonPressed)];
//        logoutButton.clipsToBounds=YES;
//        logoutButton.layer.cornerRadius=8;
//        [logoutButton setTitle:@"关闭" forState:UIControlStateNormal];
//        [logoutButton setTitle:@"关闭" forState:UIControlStateDisabled];
//        [scrollView addSubview:logoutButton];
        
        uploadButton = [self buttonWithFrame:CGRectMake(20, 250-50, [UIScreen mainScreen].bounds.size.width-40, 40) action:@selector(uploadButtonPressed)];
        uploadButton.clipsToBounds=YES;
        uploadButton.layer.cornerRadius=8;
        [uploadButton setTitle:@"开始上传" forState:UIControlStateNormal];
        [uploadButton setTitle:@"开始上传" forState:UIControlStateDisabled];
        [scrollView addSubview:uploadButton];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(threadNumTextFieldChanged:)
         name:UITextFieldTextDidChangeNotification
         object:_threadNumTextField];
        
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, 225-50, 230, 20)];
        _progressView.progressTintColor=NavBackGroundColor;
        [scrollView addSubview:_progressView];
        
        _progressValue = [[UILabel alloc] init];
        _progressValue.text = @"0";
        _progressValue.backgroundColor = [UIColor clearColor];
        _progressValue.textColor = [UIColor whiteColor];
        _progressValue.font = [UIFont systemFontOfSize:15];
        _progressValue.frame = CGRectMake(255, 220-50, [UIScreen mainScreen].bounds.size.width-255, 20);
        _progressValue.textAlignment = UITextAlignmentCenter;
        [scrollView addSubview:_progressValue];
        
        pauseButton = [self buttonWithFrame:CGRectMake(20, 300-50, [UIScreen mainScreen].bounds.size.width-40, 40) action:@selector(pauseButtonPressed)];
        pauseButton.clipsToBounds=YES;
        pauseButton.layer.cornerRadius=8;
        [pauseButton setTitle:@"暂停上传" forState:UIControlStateNormal];
        [scrollView addSubview:pauseButton];
        
       resumeButton = [self buttonWithFrame:CGRectMake(20, 350-50, [UIScreen mainScreen].bounds.size.width-40, 40) action:@selector(resumeButtonPressed)];
        resumeButton.clipsToBounds=YES;
        resumeButton.layer.cornerRadius=8;
        [resumeButton setTitle:@"继续上传" forState:UIControlStateNormal];
        [scrollView addSubview:resumeButton];
        cancelButton = [self buttonWithFrame:CGRectMake(20, 400-50, [UIScreen mainScreen].bounds.size.width-40, 40) action:@selector(cancelButtonPressed)];
        cancelButton.clipsToBounds=YES;
        cancelButton.layer.cornerRadius=8;
        [cancelButton setTitle:@"取消上传" forState:UIControlStateNormal];
        [scrollView addSubview:cancelButton];
        
        
        _deleteButton = [self buttonWithFrame:CGRectMake(20, 450-50, [UIScreen mainScreen].bounds.size.width-40, 40) action:@selector(deleteButtonPressed)];
        _deleteButton.layer.cornerRadius=8;
        _deleteButton.clipsToBounds=YES;
        [_deleteButton setTitle:@"删除视频" forState:UIControlStateNormal];
       [scrollView addSubview:_deleteButton];
        
       uploadingHistoryListButton = [self buttonWithFrame:CGRectMake(20, 500-50, [UIScreen mainScreen].bounds.size.width-40, 40) action:@selector(uploadingHistoryListButtonPressed)];
        uploadingHistoryListButton.clipsToBounds=YES;
        uploadingHistoryListButton.layer.cornerRadius=8;
        [uploadingHistoryListButton setTitle:@"未完上传" forState:UIControlStateNormal];
        [scrollView addSubview:uploadingHistoryListButton];

    }
    return self;
}


-(void)pageIndexTextFieldChanged:(NSNotification*)notify
{
    _pageIndex = _pageIndexTextField.text.integerValue;
}

-(void)threadNumTextFieldChanged:(NSNotification*)notify
{
    _threadCount = _threadNumTextField.text.integerValue;
    //NSLog(@"threadCount=%d",threadCount);
}

-(void)updateBtnStateWithAuthorFlag:(BOOL)isAuthored isUploading:(BOOL)isUploading
{
    BOOL authValid = isAuthored;
    refreshTokenButton.enabled = authValid;
    logoutButton.enabled = authValid;
    uploadButton.enabled = authValid;
    pauseButton.enabled = authValid;
    resumeButton.enabled = authValid;
    cancelButton.enabled = authValid;
    _deleteButton.enabled = authValid;
    videoInfoButton.enabled = authValid;
    _getRealPlayUrlBtn.enabled = authValid;
    setMetaButton.enabled = authValid;
    getVideoUrlButton.enabled = authValid;
    videoListsButton.enabled = authValid;
    videoCountButton.enabled = authValid;
    uploadingHistoryListButton.enabled = authValid;
    if (isUploading==NO && isAuthored) {
        pauseButton.enabled = NO;
        resumeButton.enabled = NO;
        cancelButton.enabled = NO;
        _deleteButton.enabled = NO;
        //getVideoUrlButton.enabled = NO;
        videoInfoButton.enabled = NO;
        setMetaButton.enabled = NO;
    }
    _threadNumTextField.enabled = authValid;
    _pageIndexTextField.enabled = authValid;
}

-(void)startUpload
{
    pauseButton.enabled = YES;
    resumeButton.enabled = NO;
    cancelButton.enabled = YES;
    _deleteButton.enabled = NO;
    videoInfoButton.enabled = YES;
    setMetaButton.enabled = YES;
    getVideoUrlButton.enabled = YES;
}

-(void)pauseUpload
{
    pauseButton.enabled = NO;
    resumeButton.enabled = YES;
    cancelButton.enabled = YES;
    _deleteButton.enabled = NO;
    videoInfoButton.enabled = YES;
    setMetaButton.enabled = YES;
    getVideoUrlButton.enabled = YES;
}

-(void)cancelUpload
{
    pauseButton.enabled = NO;
    resumeButton.enabled = NO;
    cancelButton.enabled = NO;
    _deleteButton.enabled = NO;
    videoInfoButton.enabled = YES;
    setMetaButton.enabled = YES;
    getVideoUrlButton.enabled = YES;
    _progressView.progress = 0.0;
    _progressValue.text = @"0";
}

-(void)uploadSucceed
{
    pauseButton.enabled = NO;
    resumeButton.enabled = NO;
    cancelButton.enabled = NO;
    _deleteButton.enabled = YES;
    videoInfoButton.enabled = YES;
    setMetaButton.enabled = YES;
    getVideoUrlButton.enabled = YES;
}


-(void)uploadFailed
{
    pauseButton.enabled = NO;
    resumeButton.enabled = YES;
    cancelButton.enabled = YES;
    _deleteButton.enabled = NO;
    videoInfoButton.enabled = YES;
    setMetaButton.enabled = YES;
    getVideoUrlButton.enabled = NO;
}


-(void) setMetaInfoAlertViewShow
{
    UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"Set Meta Info" message:@"Enter Video Name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    passwordAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    UITextField* metaNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10,72,263,32)];
    metaNameTextField.tag = 9998;
    metaNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    metaNameTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    metaNameTextField.delegate = self;
    [metaNameTextField becomeFirstResponder];
    metaNameTextField.placeholder = @"视频名称";
    [passwordAlert addSubview:metaNameTextField];
    
    
    UITextField* metaDescribeTextField = [[UITextField alloc] initWithFrame:CGRectMake(10,105,263,30)];
    metaDescribeTextField.borderStyle = UITextBorderStyleRoundedRect;
    metaDescribeTextField.tag = 9999;
    metaDescribeTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    metaDescribeTextField.delegate = self;
    metaDescribeTextField.placeholder = @"视频描述";
    [passwordAlert addSubview:metaDescribeTextField];
    
    [passwordAlert show];
    
}


#pragma UITextFieldDelegate implementation
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //NSLog(@"textField.frame=%@",NSStringFromCGRect(textField.frame));
    CGPoint offset = CGPointMake(0, textField.frame.origin.y-100);
    [scrollView setContentOffset:offset];
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.tag==1001) {
        _pageIndex = textField.text.integerValue;
    }
    if (textField.tag==1000) {
        _threadCount = textField.text.integerValue;
    }
    return YES;
}


#pragma UIAlertViewDelegate implementation
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        return;
    }
    UITextField* metaNameTextField = (UITextField *)[alertView viewWithTag:9998];
    UITextField* metaDescTextField = (UITextField *)[alertView viewWithTag:9999];
//    if (metaDescTextField.text==nil || metaDescTextField.text.length<=0) {
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"内容不能为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
//        [alertView release];
//    }
    NSString* metaName = metaNameTextField.text;
    if (metaName==nil || (id)metaName==[NSNull null]) {
        metaName = @" ";
    }
    NSString* metaDesc = metaDescTextField.text;
    if (metaDesc==nil || (id)metaDesc==[NSNull null]) {
        metaDesc = @" ";
    }
    
    /*
        file_name   固定的名字
        description  固定的名字
     */
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:metaName,@"file_name",metaDesc,@"description",nil];
    //NSLog(@"params=%@",params);
    if(self.target)
    {
        [self.target performSelector:@selector(setVideoMetaInfo:) withObject:params];
    }
}

@end
