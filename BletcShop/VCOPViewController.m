//
//  SNViewController.m
//  sinaweibo_ios_sdk_demo
//
//  Created by Wade Cheng on 4/23/12.
//  Copyright (c) 2012 SINA. All rights reserved.
//

#import "VCOPViewController.h"
#import "UploadHistoryViewController.h"
#import "QYShowResultView.h"
#import "QYPlayBackView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#define kVCOPAuthData @"VCOPAuthData"

@interface VCOPViewController ()

@end

static int threadCount;


@implementation VCOPViewController

#pragma --
#pragma System
- (VCOPClient *)VCOPClientInstance
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.VCOPClientInstance;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refrshToken];
}


-(void)showPlayView:(id)sender
{
    QYPlayBackView* playBackView = [[QYPlayBackView alloc] initWithFrame:CGRectMake(0, 64,self.view.frame.size.width, self.view.frame.size.height-64)];
    playBackView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:playBackView];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.videoID=@"";
    
    
    VCOPClient *client = [self VCOPClientInstance];
    _uploadHistory = [[NSMutableArray alloc] init];
    [_uploadHistory addObjectsFromArray:[client getUploadingVideoList]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeHistory:) name:@"ResumeOneHistory" object:nil];
    
    self.title = @"视频上传";
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    _contentView = [[VCOPView alloc] initWithFrame:self.view.bounds target:self];
    [self.view addSubview:_contentView];
    BOOL isLogIn = [client isLoggedIn];
    [_contentView updateBtnStateWithAuthorFlag:isLogIn isUploading:NO];
    [self ifExistsAFielID];
    //[_contentView.imageView setImage:[UIImage imageNamed:@"icon3.png"]];
    
    [self enterPriseAuthorzieButtonPressed];
    
}

-(void)ifExistsAFielID{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/videoGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:delegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"%@",result);
         if ([result count] > 0) {
             NSDictionary *dic = result[0];
             __block VCOPViewController* tempSelf = self;
             tempSelf.videoID=dic[@"video"];
             if (![tempSelf.videoID isEqualToString:@""]) {
                 [tempSelf.contentView uploadSucceed];
                 [tempSelf vedioStatusCheck:tempSelf.videoID];
             }
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    
}
-(void)resumeHistory:(NSNotification *)notify
{
    NSDictionary* userInfo = [notify userInfo];
    Item* item = [[Item alloc] initWithDict:userInfo];
    self.onUploadingItem = item;
    
    if (item.params==nil) {
        [self prepareParamsBeforeUpload];
        return;
    }
    
    // [self resumeButtonPressed];
    VCOPClient *client = [self VCOPClientInstance];
    __block VCOPViewController* tempSelf = self;
    [client uploadVideoWithContentOfFile:item.filePath fileType:item.fileType params:item.params threadCount:threadCount
                               willStart:^(NSString* filePath,NSString *fileId) {
                                   //将要开始上传
                                   //这里近些一些存储操作， 在客户端也要存储上传的列表。
                                   NSLog(@"willStart fileId=%@",fileId);
                                   tempSelf.onUploadingItem.fileId = fileId;
                                   [_contentView startUpload];
                               }
                                progress:^(NSString *fileId, NSNumber *percent) {
                                    //上传过程中
                                    NSLog(@"....percent %f",percent.floatValue);
                                    [tempSelf.contentView updateProgress:percent.floatValue];
                                }
                                complete:^(NSString* fileId, NSDictionary *videoInfo) {
                                    //上传成功结束
                                    [tempSelf.contentView uploadSucceed];
                                    [tempSelf alertViewShow:[NSString stringWithFormat:@"上传成功 fileId:%@",tempSelf.onUploadingItem.fileId] andError:nil];
                                }
                                 failure:^(NSString* fileId, NSError *error) {
                                     //上传失败
                                     [tempSelf alertViewShow:@"上传失败" andError:error];
                                     NSLog(@"succeed=%@",fileId);
                                     [_contentView uploadFailed];
                                 }];
}


- (void)storeAuthDataWithKey:(NSString *)key value:(NSDictionary*)info
{
    //   VCOPClient *client = [self VCOPClientInstance];
    //modify by ray
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



#pragma 各按钮处理事件
//个人用户认证
-(void)personalButtonPressed:(UIButton *)sender
{
    VCOPClient *client = [self VCOPClientInstance];
    __block VCOPViewController* tempSelf = self;
    [client authorizeWithUid:@"0003"//2010552774
                     success:^(NSString* queryKey, id responseObjct){
                         // NSLog(@"success!");
                         [tempSelf storeAuthData];
                         [tempSelf alertViewShow:[tempSelf getAccessTokenInfo:client] andError:nil];
                         BOOL isUploading = NO;
                         if (tempSelf.onUploadingItem.fileId) {
                             isUploading = YES;
                         }
                         [tempSelf.contentView updateBtnStateWithAuthorFlag:YES isUploading:isUploading];
                     }
                     failure:^(NSString* queryKey, NSError* error) {
                         //NSLog(@"error.useinfo=%@",error.userInfo);
                         [tempSelf alertViewShow:[tempSelf getAccessTokenInfo:client] andError:error];
                     }];
}


//refresh Token
-(void)refrshTokenButtonPressed:(UIButton*)sender
{
    VCOPClient *client = [self VCOPClientInstance];
    
    //测试重新获取accessToken
    NSString* refreshToken = client.refreshToken;
    __block VCOPViewController* tempSelf = self;
    [client refreshTokenWithRefreshToken:refreshToken success:^(NSString *queryKey, id responseObjct) {
        [tempSelf storeAuthData];
        //[tempSelf alertViewShow:[tempSelf getAccessTokenInfo:client] andError:nil];
        
    } failure:^(NSString *queryKey, NSError *error) {
        //[tempSelf alertViewShow:[tempSelf getAccessTokenInfo:client] andError:error];
    }];
    return;
}
-(void)refrshToken{
    VCOPClient *client = [self VCOPClientInstance];
    
    //测试重新获取accessToken
    NSString* refreshToken = client.refreshToken;
    __block VCOPViewController* tempSelf = self;
    [client refreshTokenWithRefreshToken:refreshToken success:^(NSString *queryKey, id responseObjct) {
        [tempSelf storeAuthData];
        //[tempSelf alertViewShow:[tempSelf getAccessTokenInfo:client] andError:nil];
        
    } failure:^(NSString *queryKey, NSError *error) {
        //[tempSelf alertViewShow:[tempSelf getAccessTokenInfo:client] andError:error];
    }];
    return;
}

/*
 //企业用户授权
 */
-(void)enterPriseAuthorzieButtonPressed
{
    VCOPClient *client = [self VCOPClientInstance];
    
    __block VCOPViewController* tempSelf = self;
    [client authorizeWithSuccess:^(NSString* queryKey, id responseObjct){
        NSLog(@"success!");
        [tempSelf storeAuthData];
        //[tempSelf alertViewShow:[tempSelf getAccessTokenInfo:client] andError:nil];
        BOOL isUploading = NO;
        if (tempSelf.onUploadingItem.fileId) {
            isUploading = YES;
        }
        [tempSelf.contentView updateBtnStateWithAuthorFlag:YES isUploading:isUploading];
        [tempSelf.contentView.deleteButton setEnabled:YES];
    }
                         failure:^(NSString* queryKey, NSError* error) {
                             NSLog(@"error.useinfo=%@",error.userInfo);
                             //[tempSelf alertViewShow:[tempSelf getAccessTokenInfo:client] andError:error];
                         }];
    
}


//登出
- (void)logoutButtonPressed
{
    VCOPClient *client = [self VCOPClientInstance];
    __block VCOPViewController* tempSelf = self;
    [client logOutWithSuccess:^{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VCOPAuthData"];
        BOOL isUploading = NO;
        if (tempSelf.onUploadingItem.fileId) {
            isUploading = YES;
        }
        [tempSelf.contentView updateBtnStateWithAuthorFlag:NO isUploading:isUploading];
    }];
}


//上传视频
-(void)uploadButtonPressed
{
    threadCount = 1;//[_contentView.threadNumTextField.text intValue];
    if ([self.videoID isEqualToString:@""]) {
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        NSArray *mediaTypesAllowed = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [picker setMediaTypes:mediaTypesAllowed];
        
        picker.delegate=self;
        picker.allowsEditing = NO;
        picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"已有视频，无法上传", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
    }
}


//暂停某条上传任务
- (void)pauseButtonPressed
{
    VCOPClient *client = [self VCOPClientInstance];
    __block VCOPViewController* tempSelf = self;
    [client pauseUploadVideoWithfileId:self.onUploadingItem.fileId
                               success:^(NSString *fileId) {
                                   [tempSelf.contentView pauseUpload];
                               } failure:^(NSString *fileId, NSError *error) {
                                   NSLog(@"pauseButtonPressed error=%@",error.description);
                               }];
    
    
}

//重新开始某条上传任务
-(void)resumeButtonPressed
{
    VCOPClient *client = [self VCOPClientInstance];
    __block VCOPViewController* tempSelf = self;
    [client resumeUploadWithfileId:self.onUploadingItem.fileId
                           success:^(NSString *fileId) {
                               NSLog(@"resumeButtonPressed succeed");
                               [tempSelf.contentView startUpload];
                           }
                           failure:^(NSString *fileId, NSError *error) {
                               //重新开始 失败
                               //很有可能是上一次ID没有获取到就暂停了， 所以需要重新上传，而不是继续上传
                           }];
}


//取消某上传任务
-(void)cancelButtonPressed
{
    VCOPClient *client = [self VCOPClientInstance];
    __block VCOPViewController* tempSelf = self;
    [client cancelUploadWithfileId:self.onUploadingItem.fileId
                           success:^(NSString *fileId, id responseObj) {
                               //如果是批量取消，这个id用来标示取消的是哪个。
                               [tempSelf alertViewShow:@"取消成功" andError:nil];
                               [_contentView cancelUpload];
                               
                           }
                           failure:^(NSString *fileId, NSError *error) {
                               //取消任务  失败
                               [tempSelf alertViewShow:@"取消失败" andError:nil];
                               
                           }];
    
    
}


//删除某任务
-(void)deleteButtonPressed
{
    VCOPClient *client = [self VCOPClientInstance];
    __block VCOPViewController* tempSelf = self;
    if (![tempSelf.videoID isEqualToString:@""]) {
        [client deleteVideoByFileId:self.videoID
                            success:^(NSString *queryKey, id responseObj) {
                                //[tempSelf.contentView.imageView setImage:[UIImage imageNamed:@"icon3.png"]];
                                NSURL *url=[NSURL URLWithString:@""];
                                NSURLRequest *request=[NSURLRequest requestWithURL:url];
                                [tempSelf.contentView.webView loadRequest:request];
                                
                                [tempSelf.contentView.deleteButton setEnabled:NO];
                                tempSelf.videoID=@"";
                                //将服务器的id也换为@“”；
                                //[tempSelf saveFielIDToSever:@""];
                                //删除服务器的fielid
                                [self deleteFieldIdBymuid];
                                
                            }
                            failure:^(NSString *queryKey, NSError *error) {
                                //[tempSelf alertViewShow:@"删除失败" andError:error];
                                
                            }];
        
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"没有视频", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
    }
}

//获取已上传视频列表
-(void)videoListsButtonPressed
{
    
    VCOPClient *client = [self VCOPClientInstance];
    NSInteger pageIndex = _contentView.pageIndex;//[_contentView.pageIndexTextField.text intValue];
    NSLog(@"_contentView.pageIndexTextField=%@",_contentView.pageIndexTextField.text);
    __block VCOPViewController* tempSelf = self;
    NSLog(@"pageIndex＝%ld",(long)pageIndex);
    [client fetchVideoInfoListWithPageIndex:pageIndex perPage:20
                                    success:^(NSString *queryKey, id responseObj) {
                                        //获取到视频列表  成功
                                        NSDictionary* resonseDict = (NSDictionary *)responseObj;
                                        NSArray* returnedArray = [resonseDict objectForKey:@"data"];
                                        NSLog(@"returnedArray=%@",returnedArray);
                                        if (returnedArray.count<=0) {
                                            [tempSelf alertViewShow:@"已无数据!" andError:nil];
                                        }else
                                        {
                                            [tempSelf alertViewShow:[returnedArray componentsJoinedByString:@","] andError:nil];
                                            
                                        }
                                        
                                    } failure:^(NSString *queryKey, NSError *error) {
                                        //获取到视频列表  失败
                                        [tempSelf alertViewShow:@"获取视频列表失败" andError:error];
                                    }];
}

//获取某视频信息
-(void)videoInfoButtonPressed
{
    VCOPClient *client = [self VCOPClientInstance];
    NSArray *fileIDS = [[NSArray alloc] initWithObjects:self.onUploadingItem.fileId, nil];
    __block VCOPViewController* tempSelf = self;
    [client fetchVideoInfoWithFileIds:fileIDS
                              success:^(NSString *queryKey, id responseObj) {
                                  NSArray *returnedArray = [(NSDictionary*)responseObj objectForKey:@"data"];
                                  [tempSelf alertViewShow:[returnedArray componentsJoinedByString:@","] andError:nil];
                              } failure:^(NSString *queryKey, NSError *error) {
                                  [tempSelf alertViewShow:@"获取视频信息失败" andError:error];
                              }];
    
}


//获取已经上传的视频数量
-(void)videoCountButtonPressed
{
    VCOPClient *client = [self VCOPClientInstance];
    __block VCOPViewController* tempSelf = self;
    [client fetchVideoListCountSuccess:^(NSString *queryKey, id responseObj) {
        NSDictionary *dataDic = (NSDictionary *)[(NSDictionary *)responseObj objectForKey:@"data"];
        NSInteger videoCount = [[dataDic objectForKey:@"count"] integerValue];
        [tempSelf alertViewShow:[NSString stringWithFormat:@"video Count:%ld",(long)videoCount] andError:nil];
    }
                               failure:^(NSString *queryKey, NSError *error) {
                                   //获取视频数量  失败
                                   [tempSelf alertViewShow:@"获取视频数量失败" andError:error];
                               }];
}


//设置视频meta信息
-(void)setVideoMetaInfo:(NSDictionary*)useInfo
{
    VCOPClient * client = [self VCOPClientInstance];
    __block VCOPViewController* tempSelf = self;
    [client setVideoMetaDataWithFileId:self.onUploadingItem.fileId params:useInfo
                               success:^(NSString *queryKey, id responseObj) {
                                   [tempSelf alertViewShow: [NSString stringWithFormat:@"设置meta信息成功: fileId=%@",queryKey] andError:nil];
                                   tempSelf.onUploadingItem.fileName = [useInfo objectForKey:@"metaName"];
                                   tempSelf.onUploadingItem.fileDesc = [useInfo objectForKey:@"metaDesc"];
                               } failure:^(NSString *queryKey, NSError *error) {
                                   [tempSelf alertViewShow:@"设置meta失败" andError:error];
                               }];
}


//获取视频播放地址
-(void)getVideoUrlButtonPressed
{
    NSString* fileId = _contentView.fileIdTextField.text;
    VCOPClient * client = [self VCOPClientInstance];
    __block VCOPViewController* tempSelf = self;
    
    [client fetchVideoUrlStrWithFileId:fileId fileType:@"1" success:^(NSString *queryKey, id responseObj) {
        NSLog(@"%@",responseObj);
        [tempSelf alertViewShow:[(NSDictionary*)responseObj description] andError:nil];
    } failure:^(NSString *queryKey, NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(void)getSingleFileVideoInfoBtnPressed:(id)sender
{
    NSString* fileId = _contentView.fileIdTextField2.text;
    VCOPClient * client = [self VCOPClientInstance];
    __block VCOPViewController* tempSelf = self;
    
    [client fetchSingleVideoInfoByFileId:fileId success:^(NSString *queryKey, id responseObj) {
        NSArray *array= [(NSDictionary *)responseObj objectForKey:@"data"];
        NSString *stateStr=[[NSString alloc]initWithFormat:@"%@",[array[0] objectForKey:@"fileStatus"]];
        if ([stateStr isEqualToString:@"2"]) {
            NSURL *nurl1=[NSURL URLWithString:[array[0] objectForKey:@"img"]];
            [_contentView.imageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        }
        [tempSelf alertViewShow:[(NSDictionary*)responseObj description] andError:nil];
    } failure:^(NSString *queryKey, NSError *error) {
        [tempSelf alertViewShow:@"获取video Info 失败" andError:error];
    }];
}

//获取上传历史（本地存储）
-(void)uploadingHistoryListButtonPressed
{
    VCOPClient * client = [self VCOPClientInstance];
    UploadHistoryViewController * uploadVC = [[UploadHistoryViewController alloc ] init];
    uploadVC.uploadingHistoryArray = [client getUploadingVideoList];
    [self.navigationController pushViewController:uploadVC animated:YES];
    
}
-(void)readPlayUrlBtnPressed:(UIButton*)sender
{
    NSString* virtualStr = _contentView.virtualUrlView.text;
    [_contentView.virtualUrlView resignFirstResponder];
    VCOPClient * client = [self VCOPClientInstance];
    NSString* fileId = _contentView.filedIdView.text;
    __block VCOPViewController* tempSelf = self;
    [client fetchVideoUrlStrWithViutualUrl:virtualStr fileId:fileId
                                   success:^(NSString *queryKey, NSString *returnedurl) {
                                       [tempSelf alertViewShow: [NSString stringWithFormat:@"%@",returnedurl] andError:nil];
                                   } failure:^(NSString *queryKey, NSError *error) {
                                       [tempSelf alertViewShow:@"获取播放地址失败" andError:error];
                                   }];
    
}

-(void)groupDeletePressed:(id)sender
{
    NSString* fileIds = _contentView.groupFileIdsView.text;
    VCOPClient *client = [self VCOPClientInstance];
    __block VCOPViewController* tempSelf = self;
    [client deleteVideoByFileId:fileIds
                        success:^(NSString *queryKey, id responseObj) {
                            [tempSelf alertViewShow:@"删除成功" andError:nil];
                            [tempSelf.contentView.deleteButton setEnabled:NO];
                            
                        }
                        failure:^(NSString *queryKey, NSError *error) {
                            [tempSelf alertViewShow:@"删除失败" andError:error];
                        }];
    
}

-(void)groupqueryPressed:(id)sender
{
    NSString* fileIds = _contentView.groupFileIdsView.text;
    VCOPClient *client = [self VCOPClientInstance];
    NSArray *fileIDS = [fileIds componentsSeparatedByString:@","] ;
    __block VCOPViewController* tempSelf = self;
    [client fetchVideoInfoWithFileIds:fileIDS
                              success:^(NSString *queryKey, id responseObj) {
                                  NSArray *returnedArray = [(NSDictionary*)responseObj objectForKey:@"data"];
                                  [tempSelf alertViewShow:[returnedArray componentsJoinedByString:@","] andError:nil];
                              } failure:^(NSString *queryKey, NSError *error) {
                                  [tempSelf alertViewShow:@"获取视频信息失败" andError:error];
                              }];
    
    
}

-(void)fetchFullStatusPressed:(id)sender
{
    //NSString* fileId = _contentView.fullStatusView.text;
    VCOPClient *client = [self VCOPClientInstance];
    //fetchVideoFullStatusBtFileId
    __block VCOPViewController* tempSelf = self;
    if (![tempSelf.onUploadingItem.fileId isEqualToString:@""]) {
        [client fetchVideoFullStatusByFileId:tempSelf.onUploadingItem.fileId success:^(NSString *queryKey, id responseObj) {
            
            [tempSelf alertViewShow:[(NSDictionary*)responseObj description] andError:nil];
        } failure:^(NSString *queryKey, NSError *error) {
            [tempSelf alertViewShow:@"获取视频状态失败" andError:error];
            
        }];
    }
}

//SDK版本号
//-(void)sdkVersionButtonPressed:(UIButton*)button
//{
//    NSString* sdkVersion = [VCOPClient sdkVersion];
//    [button setTitle:sdkVersion forState:UIControlStateNormal];
//    [button setTitle:sdkVersion forState:UIControlStateHighlighted];
//}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


-(void)prepareParamsBeforeUpload
{
    UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"设置视频信息" message:@"视频名称:" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    passwordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField* metaNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10,72,263,32)];
    metaNameTextField.tag = 1001;
    metaNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    metaNameTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    metaNameTextField.delegate = self;
    [metaNameTextField becomeFirstResponder];
    metaNameTextField.placeholder = @"视频名称";
    [passwordAlert addSubview:metaNameTextField];
    
    
//    UITextField* metaDescribeTextField = [[UITextField alloc] initWithFrame:CGRectMake(10,105,263,30)];
//    metaDescribeTextField.borderStyle = UITextBorderStyleRoundedRect;
//    metaDescribeTextField.tag = 1002;
//    metaDescribeTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
//    metaDescribeTextField.delegate = self;
//    metaNameTextField.secureTextEntry=NO;
//    metaDescribeTextField.placeholder = @"视频描述";
//    [passwordAlert addSubview:metaDescribeTextField];
//    
    UITextField *textfield = [passwordAlert textFieldAtIndex:0];
    textfield.placeholder = @"视频名称";
    textfield.secureTextEntry = NO;
//
//    UITextField *text2 = [passwordAlert textFieldAtIndex:1];
//    text2.placeholder = @"视频描述";
//    text2.secureTextEntry = NO;
    [passwordAlert show];
    
    
}

#pragma mark --
#pragma mark image Picker Controller delegate
-(void) imagePickerController:(UIImagePickerController *)UIPicker didFinishPickingMediaWithInfo:(NSDictionary *) info
{
    [UIPicker dismissViewControllerAnimated:YES completion:^{
        NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ( [ mediaType isEqualToString:@"public.image" ]) {
        }
        else if ( [ mediaType isEqualToString:@"public.movie" ]){
            NSLog(@"%@",info);
            NSURL *url =  [info objectForKey:UIImagePickerControllerMediaURL];
            NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
            AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
            long long  second = 0;
            second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
            NSLog(@"%lld",second);
            NSString *urlString = [url absoluteString];
            NSArray *videoArray = [urlString componentsSeparatedByString:@"."];
            NSInteger videoArrayCount = [videoArray count];
            NSString *videoName = [videoArray objectAtIndex: (videoArrayCount -2)];
            NSString *videoType = [videoArray objectAtIndex:(videoArrayCount -1)];
            NSData *videoData = [NSData dataWithContentsOfURL:url];
            NSString *videoPath = [NSString stringWithFormat:@"%@/Documents/%@.%@",NSHomeDirectory(),videoName,videoType];
            [videoData writeToFile:videoPath atomically:NO];
            Item* item = [[Item alloc] init];
            item.filePath = videoPath;
            item.fileType = videoType;
            self.onUploadingItem = item;
            
            
            self.contentView.progressView.progress = 0;
            self.contentView.progressValue.text = @"0.00";
            if (second<=30) {
                [self prepareParamsBeforeUpload];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.frame = CGRectMake(0, 64, 375, 667);
                // Set the annular determinate mode to show task progress.
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"视频时长不能大于30秒", @"HUD message title");
                hud.label.font = [UIFont systemFontOfSize:13];
                // Move to bottm center.
                //    hud.offset = CGPointMake(0.f, );
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                [hud hideAnimated:YES afterDelay:4.f];
            }
            
        }
    }];
    
}

#pragma mark - VCOPClient Delegate

-(void) alertViewShow:(NSString *)info andError:(NSError *)error
{
    if (error != nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error! ! !"
                                                            message:[NSString stringWithFormat:@"\"Token info:%@\" ,Error:%@", info,error]
                                                           delegate:nil cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
        alertView.tag = 0;
        [alertView show];
        
    }else{
        
        //        QYShowResultView* showView = [[QYShowResultView alloc] initWithFrame:self.view.bounds];
        //        [[UIApplication sharedApplication].keyWindow addSubview:showView];
        //        showView.content = info;
        //        [showView setContent:info];
        
    }
}

#pragma UIAlertViewDelegate implementation
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        return;
    }
    UITextField* metaNameTextField = [alertView textFieldAtIndex:0];
    UITextField* metaDescTextField = (UITextField *)[alertView viewWithTag:1002];
    NSString* metaName = metaNameTextField.text;
    if (metaName==nil || (id)metaName==[NSNull null]) {
        metaName = @"";
    }
    NSString* metaDesc = metaDescTextField.text;
    if (metaDesc==nil || (id)metaDesc==[NSNull null]) {
        metaDesc = @"暂不描述";
    }
    
    /*
     file_name   固定的名字
     description  固定的名字
     */
    __block VCOPViewController* tempSelf = self;
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:metaName,@"file_name",metaDesc,@"description",nil];
    NSLog(@"====%@",params);
    VCOPClient *client = [self VCOPClientInstance];
    self.onUploadingItem.params = params;
    [client uploadVideoWithContentOfFile:self.onUploadingItem.filePath fileType:self.onUploadingItem.fileType params:params threadCount:threadCount willStart:^(NSString* filePath, NSString *fileId) {
        //将要开始上传
        //这里近行一些存储操作， 在客户端也要存储上传的列表。
        NSLog(@"fileId=%@",fileId);
        tempSelf.onUploadingItem.fileId = fileId;
        [tempSelf.contentView startUpload];
    } progress:^(NSString *fileId, NSNumber *percent) {
        //上传过程中
        [tempSelf.contentView updateProgress:percent.floatValue];
    } complete:^(NSString* fileId, NSDictionary *videoInfo) {
        //上传成功结束
        tempSelf.videoID=fileId;
        [tempSelf.contentView uploadSucceed];
        
        NSLog(@"complete fileId=%@",fileId);
        //上传id到我们的服务器
        [tempSelf saveFielIDToSever:fileId];
        //[tempSelf realUrl:tempSelf.onUploadingItem.fileId];
        
    } failure:^(NSString* fileId, NSError *error) {
        //上传失败
        [tempSelf alertViewShow:@"上传失败" andError:error];
        [tempSelf.contentView uploadFailed];
    }];
}

-(NSString *)getAccessTokenInfo:(VCOPClient *)client
{
    return [NSString stringWithFormat:@"accessToken=%@, expireationDate=%@, refreshToken=%@",client.accessToken,client.expirationDate,client.refreshToken];
}


- (void)storeAuthData
{
    VCOPClient *client = [self VCOPClientInstance];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              client.accessToken, @"AccessTokenKey",
                              client.expirationDate, @"ExpirationDateKey",
                              client.refreshToken,@"FefreshTokenKey",
                              nil
                              ];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"VCOPAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientatio
{
    return toInterfaceOrientatio==UIInterfaceOrientationPortrait;
}

//获取视频信息
-(void)vedioStatusCheck:(NSString *)fieldID{
    VCOPClient * client = [self VCOPClientInstance];
    __block VCOPViewController* tempSelf = self;
    
    [client fetchSingleVideoInfoByFileId:fieldID success:^(NSString *queryKey, id responseObj) {
        NSLog(@"%@",responseObj);
        NSArray *array= [(NSDictionary *)responseObj objectForKey:@"data"];
        NSString *stateStr=[[NSString alloc]initWithFormat:@"%@",[array[0] objectForKey:@"fileStatus"]];
        if ([stateStr isEqualToString:@"2"]) {
            NSLog(@"%@",fieldID);
            //1.获取虚拟url
            [tempSelf vitualUrl:fieldID];
        }
        
    } failure:^(NSString *queryKey, NSError *error) {
        [tempSelf alertViewShow:@"获取video Info 失败" andError:error];
    }];
    
}
-(void)vitualUrl:(NSString *)fielID{
    VCOPClient * client = [self VCOPClientInstance];
    __block VCOPViewController* tempSelf = self;
    NSLog(@"1111111%@",fielID);
    [client fetchVideoUrlStrWithFileId:fielID fileType:@"1" success:^(NSString *queryKey, id responseObj) {
        NSLog(@"%@",responseObj);
        NSString *viturlStr= [[responseObj objectForKey:@"mp4"] objectForKey:@"1"];
        NSLog(@"%@__-_____-%@",fielID,viturlStr);
        [tempSelf accessRealUrlID:fielID vitualUrl:viturlStr];
        
    } failure:^(NSString *queryKey, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
-(void)accessRealUrlID:(NSString *)fielID vitualUrl:(NSString *)url{
    [_contentView.virtualUrlView resignFirstResponder];
    VCOPClient * client = [self VCOPClientInstance];
    [client fetchVideoUrlStrWithViutualUrl:url fileId:fielID
                                   success:^(NSString *queryKey, NSString *returnedurl) {
                                       //得到了real url保存到服务器
                                       NSURL *url=[NSURL URLWithString:returnedurl];
                                       NSURLRequest *request=[NSURLRequest requestWithURL:url];
                                       [_contentView.webView loadRequest:request];
                                       
                                   } failure:^(NSString *queryKey, NSError *error) {
                                       NSLog(@")))))))))");
                                   }];
    
}
-(void)saveFielIDToSever:(NSString *)fielID{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"%@",delegate.shopUserInfoArray);
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/videoCommit",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:fielID forKey:@"video"];
    [params setObject:delegate.shopInfoDic[@"muid"] forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"%@",result);
         if ([[NSString stringWithFormat:@"%@",result[@"result_code"]] isEqualToString:@"1"]) {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.frame = CGRectMake(0, 64, 375, 667);
             // Set the annular determinate mode to show task progress.
             hud.mode = MBProgressHUDModeText;
             hud.label.text = NSLocalizedString(@"上传成功，等待审核", @"HUD message title");
             hud.label.font = [UIFont systemFontOfSize:13];
             
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             [hud hideAnimated:YES afterDelay:3.f];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    
}
-(void)deleteFieldIdBymuid{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/videoDel",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:delegate.shopInfoDic[@"muid"] forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"%@",result);
         if ([[NSString stringWithFormat:@"%@",result[@"result_code"]] isEqualToString:@"1"]) {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.frame = CGRectMake(0, 64, 375, 667);
             // Set the annular determinate mode to show task progress.
             hud.mode = MBProgressHUDModeText;
             hud.label.text = NSLocalizedString(@"删除成功", @"HUD message title");
             hud.label.font = [UIFont systemFontOfSize:13];
             // Move to bottm center.
             //    hud.offset = CGPointMake(0.f, );
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             [hud hideAnimated:YES afterDelay:3.f];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    
}
@end
