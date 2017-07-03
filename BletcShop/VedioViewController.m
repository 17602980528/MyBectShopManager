//
//  VedioViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/3/22.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "VedioViewController.h"
//#import "VCOPClient.h"
#import "UIImageView+WebCache.h"
#import "UploadVedioVC.h"
#import "SRVideoPlayer.h"
#import "PictureAndVeidoDetailVC.h"


@interface VedioViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UIView *videoplayerView;

@property(nonatomic,strong)SRVideoPlayer *videoPlayer;
@end

@implementation VedioViewController


//- (VCOPClient *)VCOPClientInstance
//{
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    return delegate.VCOPClientInstance;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-43);

    _webView.scrollView.bounces = NO;
    [self ifExistsAFielID];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_videoPlayer pause];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    ;
    
    
   
    if (![self.navigationController.viewControllers[2] isKindOfClass:[PictureAndVeidoDetailVC class]]) {
        
        NSLog(@"-----[_videoPlayer destroyPlayer]===%@=--%@",self,self.navigationController.viewControllers);
        
        [_videoPlayer destroyPlayer];
        
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (IBAction)tapClick:(id)sender {
    
    UploadVedioVC *VC = [[UploadVedioVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
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
             
             
            
             
             NSString*videoID=dic[@"video"];
             if (![videoID isEqualToString:@""]) {
                 

                 if ([dic[@"state"] isEqualToString:@"true"]) {
                     tempSelf.imgView.hidden = YES;
                     
                     NSString *returnedurl = [NSString stringWithFormat:@"%@%@",VEDIO_URL,videoID];
                     
                     NSURL *url=[NSURL URLWithString:returnedurl];
//                     NSURLRequest *request=[NSURLRequest requestWithURL:url];
//                     [self.webView loadRequest:request];
                     
                    
                     self.videoPlayer = [SRVideoPlayer playerWithVideoURL:url playerView:_videoplayerView playerSuperView:_videoplayerView.superview andImgUrl:nil];
                     
                     _videoPlayer.videoName = @"";
                     
                     
                     _videoPlayer.playerEndAction = SRVideoPlayerEndActionStop;
                     [_videoPlayer pause];
                    
                     NSLog(@"VEDIO_URL===%@",url);

                 }else  if ([dic[@"state"] isEqualToString:@"false"]){
                     self.lab.text = @"审核未通过!";

                 }else{
                     self.lab.text = @"视频正在审核中...";

                 }
                 
                

             }
         }else{
             
                         self.lab.text = @"暂无视频!";
           
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    
}



//获取视频信息
//-(void)vedioStatusCheck:(NSString *)fieldID{
//    VCOPClient * client = [self VCOPClientInstance];
//    __block typeof(self) tempSelf = self;
//    
//    [client fetchSingleVideoInfoByFileId:fieldID success:^(NSString *queryKey, id responseObj) {
//        NSLog(@"vedioStatusCheck=%@",responseObj);
//        NSArray *array= [(NSDictionary *)responseObj objectForKey:@"data"];
//        NSString *stateStr=[[NSString alloc]initWithFormat:@"%@",[array[0] objectForKey:@"fileStatus"]];
//        if ([stateStr isEqualToString:@"2"]) {
//            NSLog(@"%@",fieldID);
//            tempSelf.imgView.hidden = YES;
//            //1.获取虚拟url
//            [tempSelf vitualUrl:fieldID];
//        }else if ([stateStr isEqualToString:@"1"]){
//            
//            [tempSelf.imgView sd_setImageWithURL:[NSURL URLWithString:[array[0] objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"jiaopian"]];
//            
//           
//            self.lab.text = @"视频正在审核中...";
//            
//        }
//        
//    } failure:^(NSString *queryKey, NSError *error) {
//        [tempSelf alertViewShow:@"获取video Info 失败" andError:error];
//    }];
//    
//}

//-(void)vitualUrl:(NSString *)fielID{
//    VCOPClient * client = [self VCOPClientInstance];
//    __block typeof(self) tempSelf = self;
//    NSLog(@"1111111%@",fielID);
//    [client fetchVideoUrlStrWithFileId:fielID fileType:@"1" success:^(NSString *queryKey, id responseObj) {
//        NSLog(@"%@",responseObj);
//        NSString *viturlStr= [[responseObj objectForKey:@"mp4"] objectForKey:@"1"];
//        NSLog(@"%@__-_____-%@",fielID,viturlStr);
//        [tempSelf accessRealUrlID:fielID vitualUrl:viturlStr];
//        
//    } failure:^(NSString *queryKey, NSError *error) {
//        NSLog(@"%@",error);
//    }];
//    
//}

//-(void)accessRealUrlID:(NSString *)fielID vitualUrl:(NSString *)url{
//    // [_contentView.virtualUrlView resignFirstResponder];
//    VCOPClient * client = [self VCOPClientInstance];
//    [client fetchVideoUrlStrWithViutualUrl:url fileId:fielID
//                                   success:^(NSString *queryKey, NSString *returnedurl) {
//                                       //得到了real url保存到服务器
//                                       NSURL *url=[NSURL URLWithString:returnedurl];
//                                       NSURLRequest *request=[NSURLRequest requestWithURL:url];
//                                       [self.webView loadRequest:request];
//                                       
//                                   } failure:^(NSString *queryKey, NSError *error) {
//                                       NSLog(@")))))))))");
//                                   }];
//    
//}


#pragma mark - VCOPClient Delegate

//-(void) alertViewShow:(NSString *)info andError:(NSError *)error
//{
//    if (error != nil) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error! ! !"
//                                                            message:[NSString stringWithFormat:@"\"Token info:%@\" ,Error:%@", info,error]
//                                                           delegate:nil cancelButtonTitle:@"Cancel"
//                                                  otherButtonTitles:@"OK", nil];
//        alertView.tag = 0;
//        [alertView show];
//        
//    }else{
//        
//        //        QYShowResultView* showView = [[QYShowResultView alloc] initWithFrame:self.view.bounds];
//        //        [[UIApplication sharedApplication].keyWindow addSubview:showView];
//        //        showView.content = info;
//        //        [showView setContent:info];
//        
//    }
//}


@end
