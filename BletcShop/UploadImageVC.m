//
//  UploadImageVC.m
//  BletcShop
//
//  Created by Bletc on 2017/3/22.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "UploadImageVC.h"
#import "HKModelMarco.h"
#import "HKImageClipperViewController.h"
#import "CustomeAlertView.h"
#import "UIImageView+WebCache.h"
@interface UploadImageVC ()<CustomeAlertViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSString *stateNum;

}
@property (weak, nonatomic) IBOutlet UIImageView *upImagView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *miaoshulab;

@property (nonatomic, assign) ClipperType clipperType;
@property (nonatomic, assign) BOOL systemEditing;
@property (nonatomic, assign) BOOL isSystemType;

@property long long int date;//发送图片的时间戳
@property BOOL isImageSuccess;

@end

@implementation UploadImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"上传图片";
    NSLog(@"------%@",self.infoDic);
    if (!self.infoDic) {
        
        
        [self getTheTemplate];
        
       
    }else{
        
        
        
        
        
        NSString *url = [[SHOPIMAGE_New stringByAppendingString:self.infoDic[@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [self.upImagView sd_setImageWithURL:[NSURL URLWithString:  url] placeholderImage:[UIImage imageNamed:@""]];
        stateNum = self.infoDic[@"type"];
        
        if ([stateNum integerValue]==3) {
            self.textView.hidden = YES;
            self.miaoshulab.hidden = YES;

        }else{
            self.textView.text = self.infoDic[@"content"];
            
            if (_textView.text.length !=0) {
                self.miaoshulab.hidden = YES;
            }else{
                self.miaoshulab.hidden = NO;
                
            }
 
        }
       
        
        
    }
    
  

}

-(void)ClickBtnAtIndex:(NSInteger)index state:(NSInteger)state{
    
    if (index==1) {
        NSString * newState=[NSString stringWithFormat:@"%ld",(long)state];
        stateNum=newState;
        
        
        if ([stateNum integerValue]==3) {
            self.textView.hidden = YES;
            self.miaoshulab.hidden = YES;
            
        }
        NSLog(@"===%ld===%ld",index,state);
    }
 
    
    
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length !=0) {
        self.miaoshulab.hidden = YES;
    }else{
        self.miaoshulab.hidden = NO;

    }
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([stateNum intValue]==3) {
        return NO;
    }else
    return YES;
}

- (IBAction)uploadImgClick:(UITapGestureRecognizer *)sender {
    
    self.clipperType = ClipperTypeImgMove;
    self.systemEditing = NO;
    self.isSystemType = NO;
    [self takePhoto];
}
- (void)takePhoto {
    UIActionSheet *_sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"拍照", @"相机胶卷", nil];
    [_sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    
        if (buttonIndex == 0) {
            [self photoWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else if(buttonIndex == 1) {
            [self photoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }

}
- (void)photoWithSourceType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = type;
    imagePicker.allowsEditing = self.systemEditing;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}


//点击选取按钮触发事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (!self.isSystemType) {
        //自定义裁剪方式
        UIImage*image = [self turnImageWithInfo:info];
        HKImageClipperViewController *clipperVC = [[HKImageClipperViewController alloc]initWithBaseImg:image resultImgSize:self.upImagView.frame.size clipperType:self.clipperType];
        __weakSelf(self);
        clipperVC.cancelClippedHandler = ^(){
            [picker dismissViewControllerAnimated:YES completion:nil];
        };
        clipperVC.successClippedHandler = ^(UIImage *clippedImage){
          //  self.alertView.hidden=NO;
            __strongSelf(weakSelf);
            strongSelf.upImagView.image = clippedImage;
            [picker dismissViewControllerAnimated:YES completion:nil];
            
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            NSString *photoName =[NSString stringWithFormat:@"%@.png",[appdelegate.shopInfoDic objectForKey:@"name"]];
            [self saveImage:clippedImage withName:photoName];
            
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:photoName];
            UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
            
            //_isFullScreen = NO;
            [self.upImagView setImage:savedImage];
            
            NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/upload/upload",BASEURL];
            NSLog(@"%@",url);
            NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
            self.date = (long long int)time;
            NSString *nameValue = [[NSString alloc]initWithFormat:@"%@_%@_%lld",[appdelegate.shopInfoDic objectForKey:@"name"],[appdelegate.shopInfoDic objectForKey:@"phone"],self.date ];
            NSData *img_Data = [NSData dataWithContentsOfFile:fullPath];
            NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
            [parmer setValue:nameValue forKey:@"name"];
            [parmer setValue:@"merchant_info" forKey:@"type"];
            [parmer setObject:img_Data forKey:@"file1"];
            
            [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
                NSLog(@"%@",result);
                if ([[result objectForKey:@"result_code"] isEqualToString:@"access"]) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    
                    hud.label.text = NSLocalizedString(@"上传成功", @"HUD message title");
                    hud.label.font = [UIFont systemFontOfSize:13];
                    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                    [hud hideAnimated:YES afterDelay:3.f];
                    self.isImageSuccess = YES;
                }
                NSLog(@"result===%@", result);
                
                
            } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                //                DebugLog(@"error-----%@",error.description);
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"图片太大,上传失败", @"HUD message title");
                hud.label.font = [UIFont systemFontOfSize:13];
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                [hud hideAnimated:YES afterDelay:4.f];
                
            }];
            
        };
        
        [picker pushViewController:clipperVC animated:YES];
    } else {
        //系统方式，区分是否需要裁剪
        NSString *imgKey;
        UIImage *image;
        if (!self.systemEditing) {
            imgKey = UIImagePickerControllerOriginalImage;
            image = [self turnImageWithInfo:info];
        } else {
            imgKey = UIImagePickerControllerEditedImage;
            image=[info objectForKey:imgKey];
        }
        self.upImagView.image = [info objectForKey:imgKey];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
   NSData* imageData2=[NSData data];
  NSData*  imageData = UIImageJPEGRepresentation(currentImage, 1.0);
    while ([imageData length]/1000>400) {
        if (imageData.length==imageData2.length) {
            break;
        }
        imageData2=imageData;
        UIImage *image=[[UIImage alloc]initWithData:imageData];
        imageData = UIImageJPEGRepresentation(image, 0.2);
    }
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

- (UIImage *)turnImageWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //类型为 UIImagePickerControllerOriginalImage 时调整图片角度
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp) {
            // 原始图片可以根据照相时的角度来显示，但 UIImage无法判定，于是出现获取的图片会向左转90度的现象。
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    return image;
    
}
- (IBAction)sureClick:(id)sender {
    if (!self.infoDic) {
        

   
        NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/Imgtxt/add",BASEURL];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
        NSString *nameValue = [[NSString alloc]initWithFormat:@"%@_%@_%lld.png",[appdelegate.shopInfoDic objectForKey:@"name"],[appdelegate.shopInfoDic objectForKey:@"phone"],self.date ];
        [params setObject:nameValue forKey:@"image_url"];
        [params setObject:self.textView.text forKey:@"content"];
        [params setObject:stateNum forKey:@"type"];
        
        NSLog(@"=====%@",params);
        [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            
            NSLog(@"postRequestGetInfo%@", result);
            NSDictionary *dic = result;
            
            if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"result_code"]] isEqualToString:@"1"]) {
                [self tishi:@"信息上传成功,等待审核"];
            }else{
                
                [self tishi:@"信息上传失败!"];
                
            }
            
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@", error);
            
        }];
        
       }else
    
    {
        
        NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/Imgtxt/mod",BASEURL ];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
//        NSString *nameValue = [[NSString alloc]initWithFormat:@"%@_%@_%lld.png",[appdelegate.shopInfoDic objectForKey:@"name"],[appdelegate.shopInfoDic objectForKey:@"phone"],self.date ];
        [params setObject:self.infoDic[@"image_url"] forKey:@"image_url"];
        [params setObject:self.textView.text forKey:@"content"];
        [params setObject:self.infoDic[@"datetime"] forKey:@"datetime"];
        NSLog(@"=====%@",params);

        [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            
            NSLog(@"postRequestGetInfo%@", result);
            NSDictionary *dic = result;
            if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"result_code"]] isEqualToString:@"1"]) {
                [self tishi:@"信息上传成功,等待审核"];
            }else{
                
                [self tishi:@"信息上传失败!"];

            }
            
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@", error);
            
        }];
        
    }
    
 
    
}


-(void)getTheTemplate{
    
    
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/imgtxt/getTemp",BASEURL];
    
    
 
    
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        CustomeAlertView *noticeView=[[CustomeAlertView alloc]initWithArray:result];
        noticeView.delegate=self;
        noticeView.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64);
        noticeView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:noticeView];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

-(void)tishi:(NSString*)tishi{
    
    [self showHint:tishi];
   
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
