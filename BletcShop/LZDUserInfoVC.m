//
//  LZDUserInfoVC.m
//  BletcShop
//
//  Created by Bletc on 2017/3/15.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "LZDUserInfoVC.h"
#import "UserInfoCell.h"
#import "UserInfoHeaderCell.h"
#import "UIImageView+WebCache.h"
#import "NewChangePsWordViewController.h"
#import "ResetPhoneViewController.h"
#import "ProfessionEditVC.h"
#import "UserInfoEditVC.h"

#import "NewModelImageViewController.h"
@interface LZDUserInfoVC ()<UITableViewDelegate,UITableViewDataSource,NewModelImageViewControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    
    NSData *imageData;
    NSData *imageData2;
}
@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property(nonatomic,strong)NSArray *title_A;
@property (nonatomic,strong) UIImageView* imageView;
@property long long int date;//发送图片的时间戳
@property (strong, nonatomic) IBOutlet UIView *footView;

@property (weak, nonatomic) IBOutlet UIView *tishiview;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *tishiwenzi;

@end

@implementation LZDUserInfoVC
-(NSArray *)title_A{
    if (!_title_A) {
        _title_A = @[@"昵称",@"地址",@"手机号",@"邮箱",@"性别",@"生日",@"职业",@"教育",@"婚姻",@"爱好",@"修改密码"];
    }
    return _title_A;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear: animated];
    [self.tabView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资料";
    
    self.tabView.estimatedRowHeight = 100;
    self.tabView.rowHeight = UITableViewAutomaticDimension;
    self.tabView.tableFooterView = self.footView;
    
    self.tishiview.frame = CGRectMake(0, 0, SCREENWIDTH,SCREENHEIGHT);
    self.cancleBtn.layer.borderColor = NavBackGroundColor.CGColor;
    self.cancleBtn.layer.borderWidth =1;
    self.tishiview.hidden = YES;
    [self.view addSubview:self.tishiview];


}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   return  0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.title_A.count+1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    
    
    if (indexPath.row==0) {
        UserInfoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userinfoHeadID"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserInfoHeaderCell" owner:self options:nil] lastObject];
        }
        
        NSString *str = [[NSString alloc]init];
        
        str = [[[NSString alloc]initWithFormat:@"%@%@",HEADIMAGE,[appdelegate.userInfoDic objectForKey:@"headimage"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        DebugLog(@"headerImg ==%@",str);
        
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"头像.png"] options:SDWebImageRetryFailed];
        
        return cell;
    
    }else{
        
        UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userinfoID"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserInfoCell" owner:self options:nil] lastObject];
        }
        cell.title_lab.text = _title_A[indexPath.row-1];
        
        NSArray *key_A = @[@"nickname",@"address",@"phone",@"mail",@"sex",@"age",@"occupation",@"education",@"mate",@"hobby",@"",@"",@"",@"",@""];
        cell.content_lab.text = appdelegate.userInfoDic[key_A[indexPath.row-1]];
        
        
          return cell;
        
    }
    
  }


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row ==0) {
        [self changeUserImg];
    }
    
    
    if (indexPath.row ==1 || indexPath.row ==2 || indexPath.row ==4 || indexPath.row ==5 || indexPath.row ==6 || indexPath.row ==8|| indexPath.row ==9|| indexPath.row ==10) {
        UserInfoEditVC *VC = [[UserInfoEditVC alloc]init];
        
        VC.resultBlock=^(NSDictionary*result) {
            
            NSLog(@"UserInfoEditVC.block====%@",result);
            self.tishiwenzi.text = [NSString stringWithFormat:@"恭喜你，完成个人信息获得 20 个积分，快去看看吧"];
            self.tishiview.hidden = NO;

        };
        VC.leibie = self.title_A[indexPath.row-1];
        [self.navigationController pushViewController:VC animated:YES];    }
    
    
    if (indexPath.row ==3) {
        ResetPhoneViewController *VC = [[ResetPhoneViewController alloc]init];
        
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    if (indexPath.row ==11) {
        NewChangePsWordViewController *passVC=[[NewChangePsWordViewController alloc]init];
        [self.navigationController pushViewController:passVC animated:YES];

    }
    
    if (indexPath.row ==7) {
        ProfessionEditVC *VC=[[ProfessionEditVC alloc]init];
        VC.prodessionBlock=^(NSDictionary*result) {
            
            NSLog(@"UserInfoEditVC.block====%@",result);
            self.tishiwenzi.text = [NSString stringWithFormat:@"恭喜你，完成个人信息获得%@个积 分，快去看看吧",result[@"result_code"]];
            self.tishiview.hidden = NO;
            
        };

        [self.navigationController pushViewController:VC animated:YES];
        
    }

}


-(void)changeUserImg
{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择",@"系统推荐", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", @"系统推荐",nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 3:{
                    NewModelImageViewController *ModelImageVC=[[NewModelImageViewController alloc]init];
                    ModelImageVC.image=self.imageView.image;
                    ModelImageVC.delegate=self;
                    [self.navigationController pushViewController:ModelImageVC animated:YES];
                    return;
                }
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            }else if (buttonIndex==1){
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }else {
                NewModelImageViewController *ModelImageVC=[[NewModelImageViewController alloc]init];
                ModelImageVC.image=self.imageView.image;
                ModelImageVC.delegate=self;
                [self.navigationController pushViewController:ModelImageVC animated:YES];
                //[self presentViewController:ModelImageVC animated:YES completion:nil];
                return;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}
//点击选取按钮触发事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    // 保存图片至本地，方法见下文
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/upload/upload",BASEURL];
    [self.imageView setImage:savedImage];
    
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    self.date = (long long int)time;
    
    NSString *nameValue = [[NSString alloc]initWithFormat:@"%@_%lld",[appdelegate.userInfoDic objectForKey:@"uuid"],self.date];
    
    
    NSData *img_Data = [NSData dataWithContentsOfFile:fullPath];
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    [parmer setValue:nameValue forKey:@"name"];
    [parmer setValue:@"head_image" forKey:@"type"];
    [parmer setObject:img_Data forKey:@"file1"];
    
    [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        if ([result[@"result_code"] isEqualToString:@"access"]) {
            //            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //            hud.mode = MBProgressHUDModeText;
            //
            //            hud.label.text = NSLocalizedString(@"上传成功", @"HUD message title");
            //            hud.label.font = [UIFont systemFontOfSize:13];
            //            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            //            [hud hideAnimated:YES afterDelay:3.f];
            [self postUploadImageWithNameValue:nameValue];
            
            
            
        }
        NSLog(@"result===%@", result);
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        DebugLog(@"error-----%@",error.description);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"图片太大,上传失败", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:4.f];
        
    }];
    
    
}

-(void)postUploadImageWithNameValue:(NSString*)nameValue
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountSet",BASEURL];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    //    NSString *nameValue = [[NSString alloc]initWithFormat:@"%@_%lld.png",[appdelegate.userInfoDic objectForKey:@"uuid"],self.date ];
    
    nameValue =[NSString stringWithFormat:@"%@.png",nameValue];
    
    [params setObject:@"headImage" forKey:@"type"];
    [params setObject:nameValue forKey:@"para"];
    
    
    NSLog(@"%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result===%@", result);
         
         if ([result[@"result_code"] intValue]==1) {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             
             hud.label.text = NSLocalizedString(@"图片上传成功", @"HUD message title");
             hud.label.font = [UIFont systemFontOfSize:13];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             [hud hideAnimated:YES afterDelay:3.f];
             AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
             NSMutableDictionary *new_dic = [appdelegate.userInfoDic mutableCopy];
             [new_dic setValue:result[@"para"] forKey:@"headimage"];
             
             appdelegate.userInfoDic = new_dic;
             
             
             [self.tabView reloadData];
             
         }else
         {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             //            hud.frame = CGRectMake(0, 64, 375, 667);
             // Set the annular determinate mode to show task progress.
             hud.mode = MBProgressHUDModeText;
             
             hud.label.text = NSLocalizedString(@"图片上传失败,请重试", @"HUD message title");
             hud.label.font = [UIFont systemFontOfSize:13];
             // Move to bottm center.
             //    hud.offset = CGPointMake(0.f, );
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             [hud hideAnimated:YES afterDelay:3.f];
         }
         
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
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
    //    if ([imageData length]/1000>400) {
    //            UIImage *image=[[UIImage alloc]initWithData:imageData];
    //            imageData = UIImageJPEGRepresentation(image, 0.1);
    //    }
    NSLog(@"+++++++=++++=+++=+%lu",(unsigned long)imageData.length);
    //    UIImage *result = [UIImage imageWithData:imageData];
    //
    //    while ((imageData.length/1024)>500) {
    //        imageData = UIImageJPEGRepresentation(result, 0.5);
    //        result = [UIImage imageWithData:imageData];
    //    }
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

/**
 修改用户头像
 
 @param image 所修改的头像
 */
-(void)changeUserImage:(UIImage *)image{
    
    self.imageView.image=image;
    
    
    [self saveImage:image withName:@"currentImage.png"];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/upload/upload",BASEURL];
    [self.imageView setImage:savedImage];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    self.date = (long long int)time;
    NSString *nameValue = [[NSString alloc]initWithFormat:@"%@_%lld",appdelegate.userInfoDic[@"uuid"],self.date ];
    NSLog(@"userInfoArray===%@",appdelegate.userInfoArray);
    
    
    
    
    
    
    NSData *img_Data = [NSData dataWithContentsOfFile:fullPath];
    
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    [parmer setValue:nameValue forKey:@"name"];
    [parmer setValue:@"head_image" forKey:@"type"];
    [parmer setObject:img_Data forKey:@"file1"];
    
    //    DebugLog(@"pareme ===%@",parmer);
    [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        if ([result[@"result_code"] isEqualToString:@"access"]) {
          
            [self postUploadImageWithNameValue:nameValue];
            
            
            
        }
        NSLog(@"result===%@", result);
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"图片太大,上传失败", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:4.f];
        NSLog(@"请求失败");
        
    }];
    
    
    
}
- (IBAction)logOut:(id)sender {
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [appdelegate loginOutBletcShop];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cancleClick:(UIButton *)sender {
    
    self.tishiview.hidden = YES;

}
- (IBAction)sureBtnClcik:(UIButton *)sender {

    self.tishiview.hidden = YES;

}
@end
