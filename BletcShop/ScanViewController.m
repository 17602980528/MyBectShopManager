//
//  ScanViewController.m
//  WoLaiYe
//
//  Created by 鲁征东 on 16/6/21.
//  Copyright © 2016年 鲁征东. All rights reserved.
//


#define Qmyalpha 0.2

#import "ScanViewController.h"
#import "SoundPaly.h"

#import "CanPayCardViewController.h"
#import "MoneyPAYViewController.h"
#import "CountPAYViewController.h"
#import "ErrorQRViewController.h"
#import "LandingController.h"

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
    AVCaptureMetadataOutput * output;
    UIImageView * _QimageView ;
    UIImageView *_QrCodeline ;
    NSTimer *_timer;
    UIImage *_linimg;
    UILabel *lab;
    int index;
    
    
    NSString *deviceid;
    NSString *passw;
    
}
@end

@implementation ScanViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    index = 0;
    [session startRunning];
    [self createTimer];

}
-(void)viewWillDisappear:(BOOL)animated{
    
    ;
    [session startRunning];
    [self stopTimer];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描二维码";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self scanCode];
    
//    UIButton* leftBtn= [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    leftBtn.frame = CGRectMake(0, 0, 50, 30);
//    
//    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = leftBtnItem;
}



- (void)scanCode{
    
    // iOS 8 后，全部都要授权
    AVAuthorizationStatus status =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    //第一次用户接受
                    //                    QMYViewController *qm = [[QMYViewController alloc] init];
                    //                    [self.navigationController pushViewController:qm animated:YES];
                    
                    dispatch_sync(dispatch_get_main_queue(),^{
                        ScanViewController *qm = [[ScanViewController alloc] init];
                        [self.navigationController pushViewController:qm animated:NO];
                    });
                    
                    
                    //                    [self scanCode];
                }else{
                    //用户拒绝
                    NSLog(@"用户明确地拒绝授权,请打开权限");
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            [self _initview];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            NSLog(@"用户明确地拒绝授权，或者相机设备无法访问,请打开权限");
            [self alertViewAction];
            
            break;
        default:
            break;
    }
}

- (void)alertViewAction{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先在手机设置-隐私-相机-里面打开该应用权限" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
    
}

- (void)_initview{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES) {
        //获取摄像设备
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //创建输入流
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        //创建输出流
        output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理 在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [session setSessionPreset:AVCaptureSessionPresetHigh];
        
        [session addInput:input];
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
        layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        layer.frame=self.view.layer.bounds;
        [self.view.layer insertSublayer:layer atIndex:0];
        //可根据此方法传入相应的扫描框和扫描线图片
        [self initWithScanViewName:@"扫描框" withScanLinaName:@"扫描线" withPickureZoom:1.1];
    }else
    {
        NSLog(@"该设备无法使用相机功能");
    }
    
}

-(void)initWithScanViewName:(NSString *)ScvName withScanLinaName:(NSString *)SclName withPickureZoom:(CGFloat)pkz
{
    
    [self setScanImageView:ScvName withZoom:pkz];
    [self setScanLine:SclName withZoom:pkz];
    [self setScanBackView];
    
    
}
#pragma mark-method

//设置扫描这该区域
-(void) setScanBackView
{
    CGFloat MaxY = CGRectGetMaxY(_QimageView.frame);
    [output setRectOfInterest:CGRectMake(_QimageView.frame.origin.y/self.view.frame.size.height, _QimageView.frame.origin.x/self.view.frame.size.width, _QimageView.frame.size.height/SCREENHEIGHT, _QimageView.frame.size.width/SCREENWIDTH)];
    
    //上方遮盖层
    UIView * upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,_QimageView.frame.origin.y  )];
    upView.backgroundColor = [UIColor blackColor];
    upView.alpha = Qmyalpha;
    [self.view addSubview:upView];
    
    
   
    
    
    
    UILabel *TX_lab = [[UILabel alloc] initWithFrame:CGRectMake(64, upView.frame.origin.y+32, self.view.frame.size.width-64*2, 40)];
    TX_lab.text = @"请将下方矩形框对准设备上的二维码进行识别扫描";
    TX_lab.textColor =RGB(170, 115, 13);
    TX_lab.font = [UIFont systemFontOfSize:16];
    TX_lab.textAlignment = NSTextAlignmentCenter;
    TX_lab.numberOfLines = 0;
    TX_lab.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:TX_lab];
    
    
    //左侧遮盖层
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, _QimageView.frame.origin.y, _QimageView.frame.origin.x, _QimageView.frame.size.height)];
    leftView.backgroundColor = [UIColor blackColor];
    leftView.alpha = Qmyalpha;
    [self.view addSubview:leftView];
    //右侧遮盖层
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) + _QimageView.frame.size.width, leftView.frame.origin.y, leftView.frame.size.width, leftView.frame.size.height)];
    rightView.backgroundColor = [UIColor blackColor];
    rightView.alpha = Qmyalpha;
    [self.view addSubview:rightView];
    //下方遮盖曾
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY, self.view.frame.size.width, SCREENHEIGHT-MaxY)];
    downView.backgroundColor = [UIColor blackColor];
    downView.alpha = Qmyalpha;
    [self.view addSubview:downView];
    
    
    UIButton *kaideng = [[UIButton alloc]initWithFrame:CGRectMake((SCREENWIDTH-38)/2.0, downView.frame.origin.y+40,38, 38)];
    [kaideng setImage:[UIImage imageNamed:@"scan-open2"] forState:UIControlStateNormal];
    [self.view addSubview:kaideng];
    [kaideng addTarget:self action:@selector(torchOnOrOff:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UIButton *shuru = [[UIButton alloc] initWithFrame:CGRectMake((SCREENWIDTH-250)/2.0,kaideng.bottom+40, 250, 64)];
//    [shuru setTitle:@"无法识别？切换到手动输入" forState:UIControlStateNormal];
//    [shuru setTitleColor:RGB(136,136,136) forState:UIControlStateNormal];
//    shuru.titleLabel.font = [UIFont systemFontOfSize:16];
//    shuru.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    [self.view addSubview:shuru];
//    shuru.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//    [shuru addTarget:self action:@selector(shuruAction) forControlEvents:UIControlEventTouchUpInside];
//    shuru.layer.cornerRadius = shuru.height/2.0;
//    shuru.layer.masksToBounds = YES;
    
}
//小数转换
-(CGFloat) conversionFloat:(CGFloat) ofloat
{
    NSString * str =[NSString stringWithFormat:@"%.1f",ofloat ];
    CGFloat a  = str.floatValue;
    return a;
}
//根据传入图片设置扫描框
-(void) setScanImageView:(NSString *) imageName withZoom:(CGFloat) imageZoom
{
    CGFloat new = [self conversionFloat:imageZoom];
    UIImage * img = [UIImage imageNamed:imageName];
    CGFloat x = (self.view.frame.size.width- img.size.width*new)/2;
    
    CGFloat y = self.view.frame.size.height/2-img.size.height*new+100-64;
    
    UIImageView * imgView = [[UIImageView alloc] initWithImage:img];
    imgView.frame = CGRectMake(x, y, img.size.width*new, img.size.height*new);
    _QimageView = imgView;
    [self.view addSubview:imgView];
}
//根据传入图片设置扫码线
-(void) setScanLine:(NSString *) lineImageName withZoom:(CGFloat) imageZoom
{
    _linimg = [UIImage imageNamed:lineImageName];
    _QrCodeline = [[ UIImageView alloc ] initWithImage:_linimg];
    _QrCodeline.frame = CGRectMake(_QimageView.frame.origin.x , _QimageView.frame.origin.y, _QimageView.frame.size.width, _linimg.size.height*imageZoom);
    
    [ self.view addSubview : _QrCodeline ];
}
- ( void )moveUpAndDownLine

{
    CGFloat QY = _QimageView.frame.origin.y;
    CGFloat QMY = CGRectGetMaxY(_QimageView.frame);
    CGFloat Y= _QrCodeline . frame . origin . y ;
    if (Y == QY ){
        
        [UIView beginAnimations: @"asa" context: nil ];
        
        [UIView setAnimationDuration: 1.5 ];
        _QrCodeline.transform = CGAffineTransformMakeTranslation(0,_QimageView.frame.size.height-4);
        [UIView commitAnimations];
        
    } else if (Y == QMY-4){
        
        [UIView beginAnimations: @"asa" context: nil ];
        
        [UIView setAnimationDuration: 1.5 ];
        _QrCodeline.transform = CGAffineTransformMakeTranslation(0, 0);
        [UIView commitAnimations];
    }
    
}

- ( void )createTimer

{
    //创建一个时间计数
    _timer=[NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector (moveUpAndDownLine) userInfo: nil repeats: YES ];
    
}

- ( void )stopTimer

{
    
    if ([_timer isValid] == YES ) {
        
        [_timer invalidate];
        
        _timer = nil ;
        
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//调用系统的开灯关灯功能
- (void)torchOnOrOff:(UIButton*)bu
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if (device.torchMode == AVCaptureTorchModeOff) {
        [device setTorchMode: AVCaptureTorchModeOn];
        [bu setImage:[UIImage imageNamed:@"scan-open"] forState:UIControlStateNormal];
    }else{
        [device setTorchMode: AVCaptureTorchModeOff];
        
        [bu setImage:[UIImage imageNamed:@"scan-open2"] forState:UIControlStateNormal];
    }
    [device unlockForConfiguration];
}

//-(void)back{
//    [self.navigationController popViewControllerAnimated:YES];
//
//}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
        
    {
       
        //处理扫描数据 此处index只是为了避免系统api多次调用此代理方法，多次处理扫描数据，置为1就表明已经获取到扫描结果并处理，无需再次处理，因为之前遇到过扫描的时候一直不停的打印扫描结果
        if (index == 0) {
            index = 1;

            
            AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
            
            stringValue = metadataObject.stringValue;
            
            printf("%s",[stringValue UTF8String]);
            SoundPaly *sound=[[SoundPaly alloc]initForPlayingSoundEffectWith:@"5383.wav"];

            [sound playSound];
            
            [session stopRunning];
            
            NSDictionary *dic =[NSDictionary dictionaryWithJsonString:stringValue];
            NSLog(@"-------%@",dic);
            
            if (dic ==nil) {
                
//                if ([[stringValue substringToIndex:7] isEqualToString:@"http://"]) {
//                    
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringValue]];
//
//                    
//                }else{
                    ErrorQRViewController *VC = [[ErrorQRViewController alloc]init];
                    VC.errorString = stringValue;
                    [self.navigationController pushViewController:VC animated:YES];

//                }

                
                
            }else{
                
                AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                if (appdelegate.IsLogin) {
                    [self getCardListInfo:dic];

                }else{
                    
                    LandingController *VC = [[LandingController alloc]init];

                    [self.navigationController pushViewController:VC animated:YES];
                }
                

 
            }

            
            
            
        }
        
    }
    

}

-(void)getCardListInfo:(NSDictionary*)dic{
    NSString *url = [NSString stringWithFormat:@"%@UserType/card/filter",BASEURL];
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:dic[@"muid"] forKey:@"muid"];
    [paramer setValue:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        printf("result====%s",[[NSString dictionaryToJson:result] UTF8String]);
        
        
        if([result[@"num"] intValue]==0){
            
            ErrorQRViewController *VC = [[ErrorQRViewController alloc]init];
            VC.errorString = @"您还未拥有该商铺的会员卡!";
            [self.navigationController pushViewController:VC animated:YES];
            
        }else
        if ([result[@"num"] intValue] ==1) {
            NSArray *array =result[@"info"];
            NSDictionary *dic = [array lastObject];
            
            if ([dic[@"card_type"] isEqualToString:@"储值卡"]) {
                
                NSLog(@"===储值卡===");
                
                MoneyPAYViewController *VC = [[MoneyPAYViewController alloc]init];
                VC.card_dic = dic;
                
                [self.navigationController pushViewController:VC animated:YES];
            }
            
            if ([dic[@"card_type"] isEqualToString:@"计次卡"]) {
                
                NSLog(@"===计次卡===");
                
                
                CountPAYViewController *VC = [[CountPAYViewController alloc]init];
                VC.card_dic = dic;
                
                [self.navigationController pushViewController:VC animated:YES];

            }
            
            
            
            
            
        }
        else if([result[@"num"] intValue]>1){
            
            CanPayCardViewController *VC = [[CanPayCardViewController alloc]init];
            VC.payCardArray =result[@"info"];
            VC.muid = dic[@"muid"];
            
            [self.navigationController pushViewController:VC animated:YES];
            
        }
        
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
