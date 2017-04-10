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
//    [self refrshToken];

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

    
    [self ifExistsAFielID];
}


- (IBAction)choseVedioClick:(UITapGestureRecognizer *)sender
{
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
            item.fileName = [NSString stringWithFormat:@"%@.%@",videoName,videoType];
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
    progressView = [[LZDProgressView alloc]init];
    progressView.center = self.webView.center;
    progressView.bounds =CGRectMake(0, 0, 60, 60);
    
    progressView.arcFinishColor = [UIColor colorWithHexString:@"#75AB33"];
    progressView.arcUnfinishColor = [UIColor colorWithHexString:@"#0D6FAE"];
    progressView.arcBackColor = [UIColor colorWithHexString:@"#EAEAEA"];
    [self.view addSubview:progressView];
    progressView.percent = 0.0;
    self.imageView.image = [UIImage imageNamed:@"jiaopian"];
    
    
   
    __block UploadVedioVC* tempSelf = self;

    
    NSString *url = [[NSString alloc]initWithFormat:@"%@Extra/upload/uploadVideo",BASEURL];

    NSURL *fileUrl = [NSURL fileURLWithPath:self.onUploadingItem.filePath];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    
    NSString *nameValue = [appdelegate.shopInfoDic objectForKey:@"muid"];
    
    [paramer setValue:nameValue forKey:@"muid"];
    
    
    
    
    NSError *error = nil;
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:paramer constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSLog(@"formData-----%@",formData);
        [formData appendPartWithFileURL:fileUrl name:nameValue fileName:self.onUploadingItem.fileName mimeType:@"application/octet-stream" error:nil];
        
    } error:&error];
    
    NSProgress *progress = nil;
    __block NSURLSessionDataTask *task = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        
        [progressView removeFromSuperview];
        //                       tempSelf.videoID=fileId;
        tempSelf.cancleBtn.enabled = NO;
        tempSelf.deleteBtn.enabled = YES;
        NSLog(@"-responseObject-----%@",responseObject);
        
        if ([responseObject[@"result_code"] isEqualToString:@"access"]) {
            BOOL isHave =  [[NSFileManager defaultManager] fileExistsAtPath:self.onUploadingItem.filePath];
            
            if (isHave) {
                BOOL isDelete = [[NSFileManager defaultManager] removeItemAtPath:self.onUploadingItem.filePath error:nil];
                if (isDelete) {
                    NSLog(@"delete");
                    
                }else{
                    NSLog(@"delete fail");
                    
                }
                
            }else{
                NSLog(@"文件不存在");
            }
            
        }
        
        
        
    }];
    
    [task resume];
    
    [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
    
    NSLog(@"---%ld",task.state);
 
    
   
}

#pragma UIAlertViewDelegate implementation
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
    if (buttonIndex ==0) {
        return;
    
    }
    if (alertView.tag ==888) {
        
//        VCOPClient *client = [self VCOPClientInstance];
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
        
       //
     /**
      
      
      [manager POST:url parameters:paramer constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
      [formData appendPartWithFileURL:fileUrl name:@"我的视频1" fileName:self.onUploadingItem.fileName mimeType:@"application/octet-stream" error:nil];
      } success:^(NSURLSessionDataTask *task, id responseObject) {
      NSLog(@"-responseObject-----%@",responseObject);
      
      
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
      NSLog(@"error------%@",error);
      
      }];
 
      
      
      
      
      */
        



    }
    
    
   }

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    NSProgress *progress = nil;
    if ([object isKindOfClass:[NSProgress class]]) {
        progress = (NSProgress *)object;
    }
    if (progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 在主线程中更新 UI
            NSLog(@"=====%lf",progress.fractionCompleted);
            progressView.percent = progress.fractionCompleted;
//            self.progressHUD.progress = progress.fractionCompleted;
        });
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
             
//             [self ifExistsAFielID];
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
//-(void)enterPriseAuthorzieButtonPressed
//{
//    VCOPClient *client = [self VCOPClientInstance];
//    
//    __block typeof(self) tempSelf = self;
//    [client authorizeWithSuccess:^(NSString* queryKey, id responseObjct){
//        NSLog(@"success!");
//        [tempSelf storeAuthData];
//       // [tempSelf alertViewShow:[tempSelf getAccessTokenInfo:client] andError:nil];
//        BOOL isUploading = NO;
//        if (tempSelf.onUploadingItem.fileId) {
//            isUploading = YES;
//        }
//       // [tempSelf.contentView updateBtnStateWithAuthorFlag:YES isUploading:isUploading];
//        //[tempSelf.contentView.deleteButton setEnabled:YES];
//    }
//                         failure:^(NSString* queryKey, NSError* error) {
//                             NSLog(@"error.useinfo=%@",error.userInfo);
//                             //[tempSelf alertViewShow:[tempSelf getAccessTokenInfo:client] andError:error];
//                         }];
//    
//}
- (IBAction)cancleBtnclick:(UIButton *)sender {
    
    
    UIAlertView *altView= [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要取消上传?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    altView.tag = 888;
    [altView show];
    

    
    
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
             NSDictionary *dic = [result firstObject];
             __block typeof(self) tempSelf = self;
             
             tempSelf.videoID=dic[@"video"];
             
             if (![tempSelf.videoID isEqualToString:@""]) {
                 
                 tempSelf.deleteBtn.enabled = YES;

                 tempSelf.imageView.hidden = YES;
//                 //1.获取虚拟url
//                 [tempSelf vitualUrl:fieldID];
                 
                 NSString *returnedurl = [NSString stringWithFormat:@"%@%@",VEDIO_URL,tempSelf.videoID];
                 
                 NSURL *url=[NSURL URLWithString:returnedurl];
                 NSURLRequest *request=[NSURLRequest requestWithURL:url];
                 [self.webView loadRequest:request];
                 

             }else{
                 
             }
             
             
//             if ([stateStr isEqualToString:@"2"]) {
//                 NSLog(@"%@",fieldID);
//                
//             }else if ([stateStr isEqualToString:@"1"]){
//                 
//                 [tempSelf.imageView sd_setImageWithURL:[NSURL URLWithString:[array[0] objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"jiaopian"]];
//                 
//                 
//                 
//                 self.lab.text = @"视频正在审核中...";
//                 
//             }

             
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    
}



@end
