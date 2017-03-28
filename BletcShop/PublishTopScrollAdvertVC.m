//
//  PublishTopScrollAdvertVC.m
//  BletcShop
//
//  Created by apple on 17/2/22.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PublishTopScrollAdvertVC.h"
#import "SingleModel.h"
#import "PayBaseCountOrTimeVC.h"
@interface PublishTopScrollAdvertVC ()<UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UILabel *limitDataLength;
    NSData *imageData;
    NSData *imageData2;
    UIImageView *imageView;
    UITextField *advertTitleTF;
    UITextView *_textView;
    NSInteger state;
    SingleModel *model;
}
@property long long int date;//发送图片的时间戳
@end

@implementation PublishTopScrollAdvertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    state=-1;
    model=[SingleModel sharedManager];
    self.navigationItem.title=@"发布广告";
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(goNextVC)];
    self.navigationItem.rightBarButtonItem=rightItem;
    //section1
    self.view.backgroundColor=RGB(238, 238, 238);
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90)];
    topView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topView];
    
    UILabel *advertTitle=[[UILabel alloc]initWithFrame:CGRectMake(19, 16, SCREENWIDTH-19, 16)];
    advertTitle.text=@"广告标题";
    advertTitle.font=[UIFont systemFontOfSize:16.0f];
    [topView addSubview:advertTitle];
    
    advertTitleTF=[[UITextField alloc]initWithFrame:CGRectMake(12, 35, SCREENWIDTH-24, 45)];
    advertTitleTF.delegate=self;
    advertTitleTF.backgroundColor=RGB(240, 240, 240);
    advertTitleTF.placeholder=@"  给你的广告起个响亮的名字吧           0/20字";
    advertTitleTF.font=[UIFont systemFontOfSize:16.0f];
    [topView addSubview:advertTitleTF];
    
    //section2
    UIView *middleView=[[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 130)];
    middleView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:middleView];
    
    UILabel *addDescription=[[UILabel alloc]initWithFrame:CGRectMake(17, 11, SCREENWIDTH-17, 16)];
    addDescription.text=@"添加描述";
    addDescription.font=[UIFont systemFontOfSize:16.0f];
    [middleView addSubview:addDescription];
    
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(12, 31 , SCREENWIDTH-24, 90)];
    _textView.backgroundColor=RGB(240, 240, 240);
    _textView.font=[UIFont systemFontOfSize:15.0f];
    _textView.delegate=self;
    [middleView addSubview:_textView];
    
    limitDataLength=[[UILabel alloc]initWithFrame:CGRectMake(_textView.width-100, 70+30, 100, 20)];
    limitDataLength.text=@"0/500字";
    limitDataLength.textColor=RGB(153, 153, 153);
    limitDataLength.textAlignment=NSTextAlignmentRight;
    limitDataLength.font=[UIFont systemFontOfSize:15.0f];
    [middleView addSubview:limitDataLength];
    
    //section3
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 240, SCREENWIDTH, 106)];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"adver_sample"]];
    imageView.frame=CGRectMake(27, 5, 90, 90);
    [bottomView addSubview:imageView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification" object:advertTitleTF];
    
    UIButton *addPictureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addPictureBtn.frame=imageView.frame;
    [bottomView addSubview:addPictureBtn];
    [addPictureBtn addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    limitDataLength.text = [NSString stringWithFormat:@"%lu/500", (unsigned long)textView.text.length];
    //字数限制操作
    if (textView.text.length >= 500) {
        
        textView.text = [textView.text substringToIndex:500];
        limitDataLength.text = @"500/500";
    }
    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    //limitDataLength.hidden=YES;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (textView.text.length==0) {
        //limitDataLength.hidden=NO;
    }
    return YES;
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > 20)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:20];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:20];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 20)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}
-(void)goNextVC{
//    //加条件判断，广告信息－标题－描述－广告图片完善时跳下个页面
    if ([advertTitleTF.text isEqualToString:@""]||[_textView.text isEqualToString:@""]||state==-1){
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"信息不完善，请检查", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        //    [hud setColor:[UIColor blackColor]];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        hud.userInteractionEnabled = YES;
        
        [hud hideAnimated:YES afterDelay:2.f];
        
    }else{
        model.advertSmallTitle=advertTitleTF.text;
        model.advertDescription=_textView.text;
        PayBaseCountOrTimeVC *VC=[[PayBaseCountOrTimeVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}
-(void)addPicture{
    NSLog(@"点击上传图片");
    //
    [self.view endEditing:YES];
    [self changeUserImg];
}
-(void)changeUserImg
{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择",nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择",nil];
        
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
        } else{
            if (buttonIndex == 0) {
                
                return;
            }else if (buttonIndex==1){
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
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    [imageView setImage:savedImage];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/upload/upload",BASEURL];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSLog(@"%f",time);
    self.date = (long long int)time;
    
    NSString *nameValue = [[NSString alloc]initWithFormat:@"%@_%lld",[appdelegate.shopInfoDic objectForKey:@"muid"],self.date];
    NSData *img_Data = [NSData dataWithContentsOfFile:fullPath];
    
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    [parmer setValue:nameValue forKey:@"name"];
    if (model.advertIndex==2) {
        [parmer setValue:@"advert_activity_image" forKey:@"type"];
    }else{
        [parmer setValue:@"advert_top_image" forKey:@"type"];
    }
    [parmer setObject:img_Data forKey:@"file1"];
    [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"%@",result);
        if ([result[@"result_code"] isEqualToString:@"access"]) {
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.mode = MBProgressHUDModeText;
            
                        hud.label.text = NSLocalizedString(@"上传成功", @"HUD message title");
                        hud.label.font = [UIFont systemFontOfSize:13];
                        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                        [hud hideAnimated:YES afterDelay:3.f];
            state=1;
            model.advertImageUlr=[NSString stringWithFormat:@"%@.png",nameValue];

        }
        NSLog(@"result===%@", result);
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        DebugLog(@"error-----%@",error.description);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"图片太大,上传失败", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
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
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
