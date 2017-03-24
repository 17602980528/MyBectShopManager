//
//  UploadVedioVC.m
//  BletcShop
//
//  Created by Bletc on 2017/3/22.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "UploadVedioVC.h"
#import "VCOPClient.h"
#import "Item.h"
#import "UIImageView+WebCache.h"
#import "LZDProgressView.h"
#import <AVFoundation/AVFoundation.h>
@interface UploadVedioVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    LZDProgressView *progressView;
}
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property(nonatomic, strong)    Item* onUploadingItem;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

static int threadCount;

@implementation UploadVedioVC
- (VCOPClient *)VCOPClientInstance
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.VCOPClientInstance;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self refrshToken];

}

-(void)refrshToken{
    VCOPClient *client = [self VCOPClientInstance];
    
    //测试重新获取accessToken
    NSString* refreshToken = client.refreshToken;
    __block typeof(self) tempSelf = self;
    [client refreshTokenWithRefreshToken:refreshToken success:^(NSString *queryKey, id responseObjct) {
        [tempSelf storeAuthData];
        //[tempSelf alertViewShow:[tempSelf getAccessTokenInfo:client] andError:nil];
        
    } failure:^(NSString *queryKey, NSError *error) {
       // [tempSelf alertViewShow:[tempSelf getAccessTokenInfo:client] andError:error];
    }];
    return;
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.deleteBtn.enabled = NO;
    self.cancleBtn.enabled = NO;
    self.videoID=@"";
//    VCOPClient *client = [self VCOPClientInstance];

//    BOOL isLogIn = [client isLoggedIn];

    [self ifExistsAFielID];
    

    [self enterPriseAuthorzieButtonPressed];
}

-(void)ifExistsAFielID{
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/videoGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:delegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"ifExistsAFielID==%@",result);
         if ([result count] > 0) {
             NSDictionary *dic = result[0];
             __block typeof(self) tempSelf = self;
             
             tempSelf.videoID=dic[@"video"];
             if (![tempSelf.videoID isEqualToString:@""]) {
                 
                 tempSelf.deleteBtn.enabled = YES;
               // [tempSelf uploadSucceed];
                [tempSelf vedioStatusCheck:tempSelf.videoID];
             }
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    
}


- (IBAction)choseVedioClick:(UITapGestureRecognizer *)sender
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


#pragma mark --
#pragma mark image Picker Controller delegate
-(void) imagePickerController:(UIImagePickerController *)UIPicker didFinishPickingMediaWithInfo:(NSDictionary *) info
{
    [UIPicker dismissViewControllerAnimated:YES completion:^{
        NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ( [ mediaType isEqualToString:@"public.image" ]) {
        }
        else if ( [ mediaType isEqualToString:@"public.movie" ]){
            NSLog(@"info==%@",info);
            NSURL *url =  [info objectForKey:UIImagePickerControllerMediaURL];
            NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
            AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
            long long  second = 0;
            second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
            NSLog(@"second==%lld",second);
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
            
            
           // self.contentView.progressView.progress = 0;
         //   self.contentView.progressValue.text = @"0.00";
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

-(void)prepareParamsBeforeUpload{
    
    UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"设置视频信息" message:@"视频名称:" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    passwordAlert.tag =1001;
    passwordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField* metaNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10,72,263,32)];
    metaNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    metaNameTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    metaNameTextField.delegate = self;
    [metaNameTextField becomeFirstResponder];
    metaNameTextField.placeholder = @"视频名称";
    [passwordAlert addSubview:metaNameTextField];
    
    
  
    UITextField *textfield = [passwordAlert textFieldAtIndex:0];
    textfield.placeholder = @"视频名称";
    textfield.secureTextEntry = NO;
    
    [passwordAlert show];
    

   
}

#pragma UIAlertViewDelegate implementation
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
    if (buttonIndex ==0) {
        return;
    
    }
    if (alertView.tag ==888) {
        
        VCOPClient *client = [self VCOPClientInstance];
        __block typeof(self) tempSelf = self;
        NSLog(@"----%@",self.onUploadingItem.fileId);
        
        NSString *url = @"http://upload.iqiyi.com/cancelupload";
        NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithObject:self.onUploadingItem.fileId forKey:@"file_id"];
        [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            if ([result isKindOfClass:[NSDictionary class]]) {
                if ([result[@"code"] isEqualToString:@"A00000"]) {
                    [tempSelf alertViewShow:@"取消成功" andError:nil];
                    progressView.percent = 0.0;
                    [progressView removeFromSuperview];
                    self.imageView.image = [UIImage imageNamed:@"jiaopian(1)"];
                    self.cancleBtn.enabled = NO;
                }
                
            }
            
          
      

            
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [tempSelf alertViewShow:@"取消失败" andError:nil];

        }];
       
        /**
         
        [client cancelUploadWithfileId:self.onUploadingItem.fileId
                               success:^(NSString *fileId, id responseObj) {
                                   //如果是批量取消，这个id用来标示取消的是哪个。
                                   
                                   [tempSelf alertViewShow:@"取消成功" andError:nil];
                                   progressView.percent = 0.0;
                                   [progressView removeFromSuperview];
                                   self.imageView.image = [UIImage imageNamed:@"jiaopian(1)"];
                                   
                                   
                                   
                               }
                               failure:^(NSString *fileId, NSError *error) {
                                   //取消任务  失败
                                   [tempSelf alertViewShow:@"取消失败" andError:nil];
                                   
                               }];
         */


    }else
    if (alertView.tag==999) {
        
        VCOPClient *client = [self VCOPClientInstance];
        __block typeof(self) tempSelf = self;
        if (![tempSelf.videoID isEqualToString:@""]) {
            [client deleteVideoByFileId:self.videoID
                                success:^(NSString *queryKey, id responseObj) {
                                    tempSelf.imageView.hidden = NO;
                                    self.lab.text = @"";
                                    self.imageView.image = [UIImage imageNamed:@"jiaopian(1)"];

                                    //[tempSelf.contentView.imageView setImage:[UIImage imageNamed:@"icon3.png"]];
                                    NSURL *url=[NSURL URLWithString:@""];
                                    NSURLRequest *request=[NSURLRequest requestWithURL:url];
                                    [tempSelf.webView loadRequest:request];
                                    
                                    tempSelf.videoID=@"";
                                    //将服务器的id也换为@“”；
                                    //[tempSelf saveFielIDToSever:@""];
                                    //删除服务器的fielid
                                    [self deleteFieldIdBymuid];
                                    
                                }
                                failure:^(NSString *queryKey, NSError *error) {
                                   [tempSelf alertViewShow:@"删除失败" andError:error];
                                    
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

        
        
        
    }else if(alertView.tag ==1001){
        
         progressView = [[LZDProgressView alloc]init];
        progressView.center = self.webView.center;
        progressView.bounds =CGRectMake(0, 0, 60, 60);
        
        progressView.arcFinishColor = [UIColor colorWithHexString:@"#75AB33"];
        progressView.arcUnfinishColor = [UIColor colorWithHexString:@"#0D6FAE"];
        progressView.arcBackColor = [UIColor colorWithHexString:@"#EAEAEA"];
        [self.view addSubview:progressView];
        progressView.percent = 0.0;
        self.imageView.image = [UIImage imageNamed:@"jiaopian"];
      
        UITextField* metaNameTextField = [alertView textFieldAtIndex:0];
        [metaNameTextField resignFirstResponder];
        UITextField* metaDescTextField = (UITextField *)[alertView viewWithTag:1002];
        NSString* metaName = metaNameTextField.text;
        if (metaName==nil || (id)metaName==[NSNull null]) {
            metaName = @"暂不命名";
        }
        NSString* metaDesc = metaDescTextField.text;
        if (metaDesc==nil || (id)metaDesc==[NSNull null]) {
            metaDesc = @"暂不描述";
        }
        
        
        /*
         file_name   固定的名字
         description  固定的名字
         */
        __block UploadVedioVC* tempSelf = self;
        NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:metaName,@"file_name",metaDesc,@"description",nil];
        NSLog(@"====%@",params);
        VCOPClient *client = [self VCOPClientInstance];
        self.onUploadingItem.params = params;
        [client uploadVideoWithContentOfFile:self.onUploadingItem.filePath fileType:self.onUploadingItem.fileType params:params threadCount:threadCount willStart:^(NSString* filePath, NSString *fileId) {
            //将要开始上传
            //这里近行一些存储操作， 在客户端也要存储上传的列表。
            NSLog(@"fileId=%@",fileId);
            tempSelf.onUploadingItem.fileId = fileId;
            tempSelf.cancleBtn.enabled = YES;
            //        [tempSelf.contentView startUpload];
        } progress:^(NSString *fileId, NSNumber *percent) {
            //上传过程中
            NSLog(@"-------%ld====%d===%@===%lf",percent.integerValue,percent.intValue,percent.stringValue,percent.floatValue);
            
            progressView.percent = percent.floatValue;

            //        [tempSelf.contentView updateProgress:percent.floatValue];
        } complete:^(NSString* fileId, NSDictionary *videoInfo) {
            //上传成功结束
            [progressView removeFromSuperview];
            tempSelf.videoID=fileId;
            tempSelf.cancleBtn.enabled = NO;
            tempSelf.deleteBtn.enabled = YES;
            //        [tempSelf.contentView uploadSucceed];
            
            NSLog(@"complete fileId=%@",fileId);
            //上传id到我们的服务器
            [tempSelf saveFielIDToSever:fileId];
            //[tempSelf realUrl:tempSelf.onUploadingItem.fileId];
            
        } failure:^(NSString* fileId, NSError *error) {
            //上传失败
            self.imageView.image = [UIImage imageNamed:@"jiaopian(1)"];

            [progressView removeFromSuperview];
            
                        [tempSelf alertViewShow:@"上传失败" andError:error];
            
            //        [tempSelf.contentView uploadFailed];
        }];

    }
    
    
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
             
             [self ifExistsAFielID];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    
}
//获取视频信息
-(void)vedioStatusCheck:(NSString *)fieldID{
    VCOPClient * client = [self VCOPClientInstance];
    __block typeof(self) tempSelf = self;
    
    [client fetchSingleVideoInfoByFileId:fieldID success:^(NSString *queryKey, id responseObj) {
        NSLog(@"vedioStatusCheck=%@",responseObj);
        NSArray *array= [(NSDictionary *)responseObj objectForKey:@"data"];
        NSString *stateStr=[[NSString alloc]initWithFormat:@"%@",[array[0] objectForKey:@"fileStatus"]];
        if ([stateStr isEqualToString:@"2"]) {
            NSLog(@"%@",fieldID);
            tempSelf.imageView.hidden = YES;
            //1.获取虚拟url
            [tempSelf vitualUrl:fieldID];
        }else if ([stateStr isEqualToString:@"1"]){
            
            [tempSelf.imageView sd_setImageWithURL:[NSURL URLWithString:[array[0] objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"jiaopian"]];
            
          
            
           self.lab.text = @"视频正在审核中...";
          
        }
        
    } failure:^(NSString *queryKey, NSError *error) {
        [tempSelf alertViewShow:@"获取video Info 失败" andError:error];
    }];
    
}

-(void)vitualUrl:(NSString *)fielID{
    VCOPClient * client = [self VCOPClientInstance];
    __block typeof(self) tempSelf = self;
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
   // [_contentView.virtualUrlView resignFirstResponder];
    VCOPClient * client = [self VCOPClientInstance];
    [client fetchVideoUrlStrWithViutualUrl:url fileId:fielID
                                   success:^(NSString *queryKey, NSString *returnedurl) {
                                       //得到了real url保存到服务器
                                       NSURL *url=[NSURL URLWithString:returnedurl];
                                       NSURLRequest *request=[NSURLRequest requestWithURL:url];
                                       [self.webView loadRequest:request];
                                       
                                   } failure:^(NSString *queryKey, NSError *error) {
                                       NSLog(@")))))))))");
                                   }];
    
}

#pragma mark - VCOPClient Delegate

-(void) alertViewShow:(NSString *)info andError:(NSError *)error
{
    if (error != nil) {
        NSString *errorMes = [NSString stringWithFormat:@"\"Token info:%@\" ,Error:%@", info,error];
        
        if ([error.userInfo[@"code"] isEqualToString:@"A00018"]) {
           errorMes = @"视频上传今日已达上限!";
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error! ! !"
                                                            message:errorMes
                                                           delegate:nil cancelButtonTitle:@"取消"
                                                  otherButtonTitles: nil];
        alertView.tag = 0;
        [alertView show];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示 !"
                                                            message:info
                                                           delegate:nil cancelButtonTitle:@"取消"
                                                  otherButtonTitles: nil];
        alertView.tag = 0;
        [alertView show];
        
      }
}


//删除某任务
-(IBAction)deleteVedio:(UIButton *)sender
{
    UIAlertView *altView= [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除已上传的视频?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    altView.tag = 999;
    [altView show];
    
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

/*
 //企业用户授权
 */
-(void)enterPriseAuthorzieButtonPressed
{
    VCOPClient *client = [self VCOPClientInstance];
    
    __block typeof(self) tempSelf = self;
    [client authorizeWithSuccess:^(NSString* queryKey, id responseObjct){
        NSLog(@"success!");
        [tempSelf storeAuthData];
       // [tempSelf alertViewShow:[tempSelf getAccessTokenInfo:client] andError:nil];
        BOOL isUploading = NO;
        if (tempSelf.onUploadingItem.fileId) {
            isUploading = YES;
        }
       // [tempSelf.contentView updateBtnStateWithAuthorFlag:YES isUploading:isUploading];
        //[tempSelf.contentView.deleteButton setEnabled:YES];
    }
                         failure:^(NSString* queryKey, NSError* error) {
                             NSLog(@"error.useinfo=%@",error.userInfo);
                             //[tempSelf alertViewShow:[tempSelf getAccessTokenInfo:client] andError:error];
                         }];
    
}
- (IBAction)cancleBtnclick:(UIButton *)sender {
    
    
    UIAlertView *altView= [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要取消上传?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    altView.tag = 888;
    [altView show];
    

    
    
}


@end
