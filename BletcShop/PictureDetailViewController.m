//
//  PictureDetailViewController.m
//  BletcShop
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "PictureDetailViewController.h"
#import "CustomeAlertView.h"
#import "ShopAllInfoTableViewCell.h"
//#import "ASIHTTPRequest.h"
//#import "ASIFormDataRequest.h"
#import "PictureDetailViewController.h"
#import "HKModelMarco.h"
#import "HKImageClipperViewController.h"
#import "UploadImageVC.h"
@interface PictureDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CustomeAlertViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    NSMutableArray *dataArr;
    UIToolbar *toolView;
    NSData *imageData;
    NSData *imageData2;
    NSString *stateNum;
    UITableView *_tableView;
    NSInteger indexNum;
    NSInteger kind;
    UIImage *image_eric;
}
@property (nonatomic, assign) ClipperType clipperType;
@property (weak, nonatomic) UIImageView *clippedImageView; //显示结果图片
@property (nonatomic, assign) BOOL systemEditing;
@property (nonatomic, assign) BOOL isSystemType;
@end

@implementation PictureDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-43);
    
    kind=44;
    stateNum=@"1";
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-43) style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    
    dataArr =[[NSMutableArray alloc]initWithCapacity:0];
    [self postRequestGetInfo];
    
    self.isImageSuccess = NO;
    toolView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    [toolView setBarStyle:UIBarStyleBlackTranslucent];
    toolView.barTintColor=[UIColor whiteColor];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btna = [UIButton buttonWithType:UIButtonTypeCustom];
    btna.frame = CGRectMake(2, 5, 50, 25);
    [btna setTitle:@"收回" forState:UIControlStateNormal];
    [btna setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btna addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    //[btna setImage:[UIImage imageNamed:@"shouqi2"] forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btna];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [toolView setItems:buttonsArray];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    if (cell==nil) {
        
        
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*2/3)];
        imageView.tag=100;
        UITapGestureRecognizer *recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editOrDelete:)];
        //        recognizer.minimumPressDuration=0.15;
        //        recognizer.numberOfTouchesRequired=1;
        [cell addGestureRecognizer:recognizer];
        [cell addSubview:imageView];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0,(SCREENWIDTH*9/16)-80 , SCREENWIDTH, 100)];
        label.tag=200;
        //label.textAlignment=1;
        label.alpha=0.5;
        label.font=[UIFont systemFontOfSize:13.0f];
        label.numberOfLines=0;
        label.backgroundColor=[UIColor blackColor];
        label.textColor=[UIColor whiteColor];
        [cell addSubview:label];
        UIImageView *imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH/2, (SCREENWIDTH/2-10)*2/3)];
        imageView2.tag=300;
        
        [cell addSubview:imageView2];
        
        //        UILabel *lab=[[UILabel alloc]init];
        //        lab.frame=CGRectMake(SCREENWIDTH-105, 5, 100, 40);
        //        lab.userInteractionEnabled=YES;
        //        lab.layer.cornerRadius=8;
        //        lab.clipsToBounds=YES;
        //        lab.backgroundColor=[UIColor grayColor];
        //        lab.font=[UIFont systemFontOfSize:13.0f];
        //        lab.alpha=0.4;
        //        lab.tag=400;
        //        lab.text=@"长按上传视频";
        //        lab.textAlignment=NSTextAlignmentCenter;
        //        [cell addSubview:lab];
    }
    UIImageView *imgView=(UIImageView*)[cell viewWithTag:100];
    
    UILabel *label=[cell viewWithTag:200];
    UIImageView *imgView2=[cell viewWithTag:300];
    UILabel *lab=[cell viewWithTag:400];
    if (indexPath.row==0) {
        lab.hidden=NO;
        label.hidden=NO;
        imgView2.hidden=YES;
        imgView.hidden = NO;
        imgView.image=[UIImage imageNamed:@"icon3"];
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        if (image_eric) {
            imgView.image=image_eric;
        }else{
            
            NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[appdelegate.shopInfoDic  objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            NSLog(@"+++++%@",nurl1);
            [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        }
        NSString *newStr=appdelegate.shopInfoDic[@"store"];
        CGFloat lableHeight=[newStr getTextHeightWithShowWidth:SCREENWIDTH AndTextFont:[UIFont systemFontOfSize:13.0f] AndInsets:5];
        label.text=newStr;
        label.frame=CGRectMake(0, SCREENWIDTH*2/3-lableHeight, SCREENWIDTH, lableHeight);
    }else{
        
        imgView2.contentMode = UIViewContentModeScaleAspectFit;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        lab.hidden=YES;
        NSString *newStr=dataArr[indexPath.row-1][@"content"];
        CGFloat lableHeight=[newStr getTextHeightWithShowWidth:SCREENWIDTH AndTextFont:[UIFont systemFontOfSize:13.0f] AndInsets:5];
        CGFloat labelHeight2=[newStr getTextHeightWithShowWidth:SCREENWIDTH/2 AndTextFont:[UIFont systemFontOfSize:13.0f] AndInsets:5];
        label.text=newStr;
        label.frame=CGRectMake(0, SCREENWIDTH*2/3-lableHeight, SCREENWIDTH, lableHeight);
        if([[NSString stringWithFormat:@"%@",dataArr[indexPath.row-1][@"type"]] isEqualToString:@"0"]){
            label.hidden=NO;
            imgView2.hidden=NO;
            imgView.hidden=YES;
            imgView2.frame=CGRectMake(5, 5, SCREENWIDTH/2-10, (SCREENWIDTH/2-10)*2/3);
            if (labelHeight2<(SCREENWIDTH/2-10)*2/3) {
                label.frame=CGRectMake(SCREENWIDTH/2, (SCREENWIDTH/2-10)*1/3-labelHeight2/2+5, SCREENWIDTH/2, labelHeight2);
            }else{
                label.frame=CGRectMake(SCREENWIDTH/2, 5, SCREENWIDTH/2, SCREENWIDTH/3);
            }
            
            label.backgroundColor=[UIColor whiteColor];
            label.textColor=[UIColor blackColor];
            NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[dataArr[indexPath.row-1]  objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [imgView2 sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        }else if ([[NSString stringWithFormat:@"%@",dataArr[indexPath.row-1][@"type"]] isEqualToString:@"1"]){
            NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[dataArr[indexPath.row-1]  objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
            imgView2.hidden=YES;
            imgView.hidden=NO;
            label.hidden=NO;
        }else if ([[NSString stringWithFormat:@"%@",dataArr[indexPath.row-1][@"type"]] isEqualToString:@"2"]){
            label.hidden=NO;
            imgView2.hidden=NO;
            imgView.hidden=YES;
            imgView2.frame=CGRectMake(SCREENWIDTH/2+5, 5, SCREENWIDTH/2-10, (SCREENWIDTH/2-10)*2/3);
            if (labelHeight2<(SCREENWIDTH/2-10)*2/3) {
                label.frame=CGRectMake(0, (SCREENWIDTH/2-10)*1/3-labelHeight2/2+5, SCREENWIDTH/2, labelHeight2);
            }else{
                label.frame=CGRectMake(0, 5, SCREENWIDTH/2, SCREENWIDTH/3);
            }
            
            label.backgroundColor=[UIColor whiteColor];
            label.textColor=[UIColor blackColor];
            NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[dataArr[indexPath.row-1]  objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [imgView2 sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        }else if ([[NSString stringWithFormat:@"%@",dataArr[indexPath.row-1][@"type"]] isEqualToString:@"3"]){
            
            NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[dataArr[indexPath.row-1]  objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
            imgView2.hidden=YES;
            imgView.hidden=NO;
            label.hidden=YES;
            
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return SCREENWIDTH*2/3;
    }else{
        NSDictionary *dic =dataArr[indexPath.row-1];
        NSString *str=[NSString stringWithFormat:@"%@",dic[@"type"]];
        if ([str isEqualToString:@"1"]) {
            return SCREENWIDTH*2/3;
        }else if([str isEqualToString:@"0"]||[str isEqualToString:@"2"]){
            return (SCREENWIDTH/2-10)*2/3+10;
        }
        return SCREENWIDTH*2/3;
    }
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
//    //view.backgroundColor=[UIColor redColor];
//    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:[UIImage imageNamed:@"grey_add"] forState:UIControlStateNormal];
//    button.frame=CGRectMake(SCREENWIDTH/2-30, 0, 60, 60);
//    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:button];
//
//    return view;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)btnClick{
//    CustomeAlertView *noticeView=[[CustomeAlertView alloc]init];
//    noticeView.delegate=self;
//    noticeView.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
//    noticeView.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:noticeView];
//}

-(void)ClickBtnAtIndex:(NSInteger)index state:(NSInteger)state{
    if (index==1) {
        //点击确认按钮，执行相关逻辑
        NSString * newState=[NSString stringWithFormat:@"%ld",(long)state];
        stateNum=newState;
        
        NSLog(@"===%ld===%ld",index,state);
        [self NewAddVipAction];
    }
}
//获取商家图文详情的方法
-(void)postRequestGetInfo
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/Imgtxt/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray * result) {
        
        NSLog(@"postRequestGetInfo%@", result);
        if(kind==88){
            [dataArr removeAllObjects];
            for (int i=0; i<result.count; i++) {
                [dataArr addObject:result[i]];
            }
            [_tableView reloadData];
            kind=44;
        }else{
            [dataArr removeAllObjects];
            for (int i=0; i<result.count; i++) {
                [dataArr addObject:result[i]];
            }
            [_tableView reloadData];
        }
        self.data = result;
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
-(void)NewAddVipAction
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    self.alertView = alertView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Shandow:)];
    [alertView addGestureRecognizer:tap];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView]];
    
    // Modify the parameters
    if (self.deleteTag==1) {
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"删除", @"取消", nil]];
    }
    else
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确定", @"取消", nil]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
}
- (void)Shandow:(UITapGestureRecognizer*)tap
{
    [self.alertView resignFirstResponder];
    NSLog(@"dfdfd");
}
- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] init];
    if (self.deleteTag==1) {
        demoView.frame=CGRectMake(0, 0, SCREENWIDTH-40, 40);
        UILabel *imageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-40, 40)];
        imageLabel.text = @"确定删除本项吗?";
        imageLabel.textAlignment = NSTextAlignmentCenter;
        imageLabel.font = [UIFont systemFontOfSize:15];
        [demoView addSubview:imageLabel];
    }else
    {
        demoView.frame=CGRectMake(0, 0, SCREENWIDTH-40, 200);
        self.demoView = demoView;
        UILabel *imageLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 90, 30)];
        imageLabel.text = @"上传图片:";
        imageLabel.font = [UIFont systemFontOfSize:15];
        [demoView addSubview:imageLabel];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(130, 10, 120, 80)];
        self.clippedImageView=imageView;
        //加默认图片
        if (kind==44) {
            imageView.image = [UIImage imageNamed:@"点击-04"];
        }else if (kind==88){
            if(dataArr.count>0){
                NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[dataArr[indexNum]  objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [imageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
            }
        }
        //imageView.backgroundColor = [UIColor grayColor];
        self.imageView = imageView;
        [demoView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choicePicture)];
        [imageView addGestureRecognizer:tapGesture];
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 140, 90, 40)];
        contentLabel.text = @"图片介绍:";
        contentLabel.font = [UIFont systemFontOfSize:15];
        [demoView addSubview:contentLabel];
        UITextField *contentText = [[UITextField alloc]initWithFrame:CGRectMake(130, 110, SCREENWIDTH-190, 80)];
        [contentText setInputAccessoryView:toolView];
        //加默认文字
        if (kind==44) {
            contentText.text = @"";
        }else if(kind==88){
            contentText.text=dataArr[indexNum][@"content"];
        }
        contentText.layer.borderWidth = 0.3;
        contentText.delegate = self;
        
        self.contentText = contentText;
        
        contentText.font = [UIFont systemFontOfSize:10];
        //添加点击事件
        
        [demoView addSubview:contentText];
        UIView *lineLevel = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 0.3)];
        lineLevel.backgroundColor = [UIColor grayColor];
        lineLevel.alpha = 0.3;
        [demoView addSubview:lineLevel];
    }
    
    return demoView;
    
}
-(void)choicePicture
{
    self.clipperType = ClipperTypeImgStay;
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
    self.alertView.hidden=YES;
    dispatch_after(0., dispatch_get_main_queue(), ^{
        if (buttonIndex == 0) {
            [self photoWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else if(buttonIndex == 1) {
            [self photoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    });
}
- (void)photoWithSourceType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = type;
    imagePicker.allowsEditing = self.systemEditing;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
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

//点击选取按钮触发事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.alertView.hidden = YES;
    if (!self.isSystemType) {
        //自定义裁剪方式
        UIImage*image = [self turnImageWithInfo:info];
        CGSize size=CGSizeMake(SCREENWIDTH, 9*SCREENWIDTH/16);
        HKImageClipperViewController *clipperVC = [[HKImageClipperViewController alloc]initWithBaseImg:image resultImgSize:size clipperType:self.clipperType];
        __weakSelf(self);
        clipperVC.cancelClippedHandler = ^(){
            [picker dismissViewControllerAnimated:YES completion:nil];
        };
        clipperVC.successClippedHandler = ^(UIImage *clippedImage){
            self.alertView.hidden=NO;
            __strongSelf(weakSelf);
            // strongSelf.clippedImageView.image = clippedImage;
            [picker dismissViewControllerAnimated:YES completion:nil];
            
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            NSString *photoName =[NSString stringWithFormat:@"%@.png",[appdelegate.shopInfoDic objectForKey:@"name"]];
            [self saveImage:clippedImage withName:photoName];
            
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:photoName];
            UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
            
            _isFullScreen = NO;
            
            NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/Imgtxt/modStoreImage",BASEURL];
            NSLog(@"%@",url);
            
            NSData *img_Data = [NSData dataWithContentsOfFile:fullPath];
            NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
            [parmer setValue:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
            [parmer setObject:img_Data forKey:@"file1"];
            
            [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
                NSLog(@"%@",result);
                if ([result[@"result_code"]integerValue]==1) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    
                    hud.label.text = NSLocalizedString(@"上传成功", @"HUD message title");
                    hud.label.font = [UIFont systemFontOfSize:13];
                    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                    [hud hideAnimated:YES afterDelay:3.f];
                    self.isImageSuccess = YES;
                    
                    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                    NSMutableDictionary *mutab_dic =[appdelegate.shopInfoDic mutableCopy];
                    
                    [mutab_dic setValue:result[@"image"] forKey:@"image_url"];
                    appdelegate.shopInfoDic = mutab_dic;
                    image_eric=[[UIImage alloc]init];
                    image_eric=savedImage;
                    [_tableView reloadData];
                }else{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    
                    hud.label.text = NSLocalizedString(@"上传失败", @"HUD message title");
                    hud.label.font = [UIFont systemFontOfSize:13];
                    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                    [hud hideAnimated:YES afterDelay:3.f];
                    self.isImageSuccess = NO;
                }
                
            } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                //                DebugLog(@"error-----%@",error.description);
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"图片太大,上传失败", @"HUD message title");
                hud.label.font = [UIFont systemFontOfSize:13];
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                [hud hideAnimated:YES afterDelay:3.f];
                
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
        self.clippedImageView.image = [info objectForKey:imgKey];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    imageData2=[NSData data];
    imageData = UIImageJPEGRepresentation(currentImage, 1.0);
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

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.===%d", (int)buttonIndex, (int)[alertView tag],self.deleteTag);
    if (alertView.tag==0&&buttonIndex==0) {
        [self postSocketAddShopInfo];
    }
    [alertView close];
}

-(void)postSocketAddShopInfo
{
    if (kind==44) {
        NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/Imgtxt/add",BASEURL];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
        NSString *nameValue = [[NSString alloc]initWithFormat:@"%@_%@_%lld.png",[appdelegate.shopInfoDic objectForKey:@"name"],[appdelegate.shopInfoDic objectForKey:@"phone"],self.date ];
        [params setObject:nameValue forKey:@"image_url"];
        [params setObject:self.contentText.text forKey:@"content"];
        [params setObject:stateNum forKey:@"type"];
        
        [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            
            NSLog(@"postRequestGetInfo%@", result);
            NSDictionary *dic = result;
            if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"result_code"]] isEqualToString:@"1"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.frame = CGRectMake(0, 64, 375, 667);
                // Set the annular determinate mode to show task progress.
                hud.mode = MBProgressHUDModeText;
                
                hud.label.text = NSLocalizedString(@"信息上传成功,等待审核", @"HUD message title");
                hud.label.font = [UIFont systemFontOfSize:13];
                // Move to bottm center.
                //    hud.offset = CGPointMake(0.f, );
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                [hud hideAnimated:YES afterDelay:4.f];
                [self postRequestGetInfo];
                
            }
            
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@", error);
            
        }];
        
    }else{
        
        NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/Imgtxt/mod",BASEURL ];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
        NSString *nameValue = [[NSString alloc]initWithFormat:@"%@_%@_%lld.png",[appdelegate.shopInfoDic objectForKey:@"name"],[appdelegate.shopInfoDic objectForKey:@"phone"],self.date ];
        [params setObject:nameValue forKey:@"image_url"];
        [params setObject:self.contentText.text forKey:@"content"];
        [params setObject:dataArr[indexNum][@"datetime"] forKey:@"datetime"];
        
        [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            
            NSLog(@"postRequestGetInfo%@", result);
            NSDictionary *dic = result;
            if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"result_code"]] isEqualToString:@"1"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.frame = CGRectMake(0, 64, 375, 667);
                // Set the annular determinate mode to show task progress.
                hud.mode = MBProgressHUDModeText;
                
                hud.label.text = NSLocalizedString(@"信息上传成功,等待审核", @"HUD message title");
                hud.label.font = [UIFont systemFontOfSize:13];
                // Move to bottm center.
                //    hud.offset = CGPointMake(0.f, );
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                [hud hideAnimated:YES afterDelay:4.f];
                [self postRequestGetInfo];
                
            }
            
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@", error);
            
        }];
        
    }
    //NSString *url = @"http://192.168.0.117/VipCard/merchant_info_set.php";
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)dismissKeyBoard{
    
    [self.contentText resignFirstResponder];
}

-(void)editOrDelete:(UITapGestureRecognizer *)recognizer{
    UITableViewCell *cell=(UITableViewCell *)[recognizer view];
    NSIndexPath *indexPathes=[_tableView indexPathForCell:cell];
    
    if (indexPathes.row==0) {
        [self takePhoto];
    }else{
        NSLog(@"长按了%ld行",(long)indexPathes.row);
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"删除或编辑信息？" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"编辑", @"取消",nil];
        [alert show];
        indexNum=indexPathes.row-1;
        
    }
    
    //    }
}
//删除的请求
-(void)deletePictureAndContextRequest:(NSInteger)index{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/Imgtxt/del",BASEURL ];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    [params setObject:dataArr[index][@"datetime"] forKey:@"datetime"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"postRequestGetInfo%@", result);
        if ([[NSString stringWithFormat:@"%@",result[@"result_code"]] isEqualToString:@"1"]) {
            [dataArr removeObjectAtIndex:index];
            [NSThread isMainThread] ?NSLog(@"zhuxiancheng") : NSLog(@"fenxiancheng");
            [_tableView reloadData];
        }
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        //删除的操作
        [self deletePictureAndContextRequest:indexNum];
    }else if(buttonIndex==1){
        //编辑修改图片和文字的操作
        kind=88;
        
        UploadImageVC *VC = [[UploadImageVC alloc]init];
        NSDictionary *dic;
        
        if (dataArr.count!=0) {
            dic =  dataArr[indexNum];
            VC.infoDic = dic;
        }
        
        [self.navigationController pushViewController:VC animated:YES];
        //        [self NewAddVipAction];
    }
    
}
//顶端rightbtn
//下端设置btn



@end
