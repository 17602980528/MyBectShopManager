//
//  AddPakageServiceVC.m
//  BletcShop
//
//  Created by apple on 2017/6/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AddPakageServiceVC.h"

@interface AddPakageServiceVC ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
     NSString *photoName;
    UIImage *savedImage;
    NSString *_fullPath;
}
@property (strong, nonatomic) IBOutlet UITextField *productNameTF;
@property (strong, nonatomic) IBOutlet UITextField *oldPriceTF;
@property (strong, nonatomic) IBOutlet UIImageView *productImage;

@end

@implementation AddPakageServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addProduoctImage:)];
    [_productImage addGestureRecognizer:tap];
}
-(void)addProduoctImage:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        
    }
    
    
    [sheet showInView:self.view];
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
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
        }
    }
    else {
        if (buttonIndex == 0) {
            
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
    
    
}
//点击选取按钮触发事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 保存图片至本地，方法见下文
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = time;
    
    photoName = [[NSString alloc]initWithFormat:@"%@_%lld",appdelegate.shopInfoDic[@"muid"],date];
    
    [self saveImage:image withName:photoName];
    
    _fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:photoName];
    savedImage = [[UIImage alloc] initWithContentsOfFile:_fullPath];
    if (savedImage) {
        _productImage.image=savedImage;
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData2=[NSData data];
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 1.0);
    NSLog(@"+++++++=++++=+++=+%lu",(unsigned long)imageData.length);
    while ([imageData length]/1000>400) {
        if (imageData.length==imageData2.length) {
            break;
        }
        imageData2=imageData;
        UIImage *image=[[UIImage alloc]initWithData:imageData];
        imageData = UIImageJPEGRepresentation(image, 0.2);
    }
       NSLog(@"+++++++=++++=+++=+%lu",(unsigned long)imageData.length);
       // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
    
}
-(void)tishi:(NSString *)tishi{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.label.text = tishi;
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:3.f];
}

- (IBAction)confirmBtnClick:(id)sender {
    if ([_productNameTF.text isEqualToString:@""]) {
        [self tishi:@"请输入名称"];
    }else if ([_oldPriceTF.text isEqualToString:@""]){
        [self tishi:@"请输入价格"];
    }else if(!savedImage){
        [self tishi:@"请上传图片"];
    }else{
        [self postRequestAddPictureAndInfo];
    }
}
-(void)postRequestAddPictureAndInfo{
     AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/MealCard/addOption",BASEURL];
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    [parmer setValue:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [parmer setValue:_productNameTF.text forKey:@"name"];
    [parmer setValue:_oldPriceTF.text forKey:@"price"];
    
    NSData *img_Data = [NSData dataWithContentsOfFile:_fullPath];
    [parmer setObject:img_Data forKey:@"file1"];
    NSLog(@"0-----%@",parmer);
    
    [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        if ([result[@"result_code"] integerValue] ==1) {
            [self showTishi:@"上传成功" dele:self cancel:@"取消" operate:@"返回"];
            
        }else if([result[@"result_code"] isEqualToString:@"image_upload_fail"]){
            [self showTishi:@"图片上传失败" dele:nil cancel:nil operate:@"确认"];
        }else if ([result[@"result_code"] integerValue] ==1062){
            [self showTishi:@"请勿重复上传" dele:nil cancel:nil operate:@"确认"];
        }
        NSLog(@"result===%@", result);

    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"error-----%@",error.description);
        
        [self tishi:@"上传失败"];
        
    }];

}
-(void)showTishi:(NSString *)mess dele:(id) delegate cancel:(NSString *)cancel operate:(NSString *)operate{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:mess message:nil delegate:delegate cancelButtonTitle:cancel otherButtonTitles:operate, nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
