//
//  VCOPView.h
//  iqiyi_ios_sdk_demo
//
//  Created by 苏 瑞强 on 13-4-20.
//  Copyright (c) 2013年 meiwen li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCOPView : UIView<UITextFieldDelegate,UIAlertViewDelegate>
{
    float _progress;
    UIScrollView* scrollView;
    UIButton* refreshTokenButton;
    UIButton* enterpriseAuthorizeButton;
    UIButton* personAuthorizeButton;
    UIButton* logoutButton;
    UIButton* uploadButton;
    UIButton* pauseButton;
    UIButton* resumeButton;
    UIButton* cancelButton;
    
    UIButton* videoListsButton;
    
    UIButton* videoInfoButton;
    UIButton* videoCountButton;
    UIButton* setMetaButton;
    UIButton* getVideoUrlButton;
    UIButton* sdkVersionButton;
    
//    UIImageView *imageView;
    
    UIButton* uploadingHistoryListButton;
    
}

@property(nonatomic,assign)id target;
@property(nonatomic,strong)UITextField* pageIndexTextField;
@property(nonatomic,strong)UITextField* threadNumTextField;
@property (nonatomic, retain) UIButton* deleteButton;
@property (nonatomic)NSInteger pageIndex;
@property (nonatomic)NSInteger threadCount;
@property (nonatomic, strong) UIProgressView* progressView;
@property (nonatomic, strong) UILabel* progressValue;
@property (nonatomic, retain)UITextView* virtualUrlView;
@property (nonatomic, retain)UITextView* filedIdView;
@property (nonatomic,retain)UIButton* getRealPlayUrlBtn;
@property (nonatomic, retain)UITextField* fileIdTextField;
@property (nonatomic, retain)UITextField* fileIdTextField2;
@property (nonatomic,retain)UIButton* getSingleFileVideoInfo;
@property(nonatomic, retain)UITextView* groupFileIdsView;
@property(nonatomic,retain)UIButton* groupDeleteBtn;
@property(nonatomic,retain)UIButton* groupQueryBtn;
@property(nonatomic,retain)UIButton* fullStatusBtn;
@property(nonatomic,retain)UITextView* fullStatusView;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIWebView *webView;

-(id)initWithFrame:(CGRect)frame target:(id)target;
-(void)updateBtnStateWithAuthorFlag:(BOOL)isAuthored isUploading:(BOOL)isUploading;
-(void)startUpload;
-(void)uploadFailed;
-(void)uploadSucceed;
-(void)pauseUpload;
-(void)cancelUpload;
-(void) setMetaInfoAlertViewShow;
-(void)updateProgress:(float)newProgress;
@end
