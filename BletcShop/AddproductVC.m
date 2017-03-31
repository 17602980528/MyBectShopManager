//
//  AddproductVC.m
//  BletcShop
//
//  Created by Bletc on 2016/11/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "AddproductVC.h"
#import "UIButton+WebCache.h"
@interface AddproductVC ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIScrollView *backView;
    UIButton *imgButton;
    
    NSString *photoName;
}
@property (strong, nonatomic)  UITextField *title_textField;
@property (strong, nonatomic)  UILabel *title_len;
@property (strong, nonatomic)  UIButton *img_btn;
@property (strong, nonatomic)  UITextField *price_textfield;
@property (strong, nonatomic)  UITextField *count_textField;
@property (strong, nonatomic)  UITextField *number_textField;

@end

@implementation AddproductVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWillShow:(NSNotification*)aNotification{
//    NSLog(@"----keyboardWillShow-");

    CGRect keyboardRect = [[[aNotification userInfo]objectForKey:UIKeyboardBoundsUserInfoKey]CGRectValue];
    
        NSTimeInterval animationDuration = [[[aNotification userInfo]objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    
    UITextField *textField;
    
    if ([self.number_textField isFirstResponder]) {
        textField = self.number_textField;
    }
    if ([self.price_textfield isFirstResponder]) {
        textField = self.price_textfield;
    }
    if ([self.count_textField isFirstResponder]) {
        textField = self.count_textField;
    }

    
//    NSLog(@"=====%@---%f",textField,keyboardRect.size.height);
        CGFloat offset = textField.bottom+64 - ((SCREENHEIGHT)-keyboardRect.size.height);
    CGFloat maxoffset = self.count_textField.bottom+64 - ((SCREENHEIGHT)-keyboardRect.size.height);
        
        //NSLog(@"offset=keyboardWillShow==%f",offset);
        
  
    
    if (offset>0 && backView.origin.y > -maxoffset) {
        
    
            [UIView beginAnimations:@"ResizeForkeyboard" context:nil];
            [UIView setAnimationDuration:animationDuration];
        
        CGRect frame = backView.frame;
        frame.origin.y = frame.origin.y - offset-10;
        backView.frame = frame;
        

        
            [UIView commitAnimations];
            
        }
    
        
    
    
    
    
    
    
}

-(void)keyboardWillHide:(NSNotification*)aNotification{
    
    //NSLog(@"----keyboardWillHide-");
    
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
            NSTimeInterval animationDuartion = [[[aNotification userInfo]objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];

    
    UITextField *textField;
    
    if ([self.number_textField isFirstResponder]) {
        textField = self.number_textField;
    }
    if ([self.price_textfield isFirstResponder]) {
        textField = self.price_textfield;
    }
    if ([self.count_textField isFirstResponder]) {
        textField = self.count_textField;
    }

    
    CGFloat offset = textField.bottom+64 - ((SCREENHEIGHT)-keyboardRect.size.height);

    
    //NSLog(@"offset==keyboardWillHide=%f",offset);
    
    
    if (offset>0) {
        
        
        [UIView beginAnimations:@"ResizeForkeyboard" context:nil];
        [UIView setAnimationDuration:animationDuartion];
        
        CGRect frame = backView.frame;
        frame.origin.y =0;
        backView.frame = frame;
        
        
        [UIView commitAnimations];
        
    }
    

    
    
    
        
  
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布商品";
    
    if (self.editTag ==1) {
        self.navigationItem.title = @"编辑商品";

    }
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
    self.navigationItem.rightBarButtonItem = barItem;
    self.view.backgroundColor = RGB(240, 240, 240);
    
    
    
    [self creatSubViews];
    
    

}
-(void)creatSubViews{
     backView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    backView.backgroundColor = RGB(240, 240, 240);
    [self.view addSubview:backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(canEditClick)];
    [backView addGestureRecognizer:tap];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 89)];
    view1.backgroundColor =[UIColor whiteColor];
    [backView addSubview:view1];
    
    UILabel *title_lable = [[UILabel alloc]initWithFrame:CGRectMake(19, 15, 164, 16)];
    
    title_lable.text = @"商品名称";
    title_lable.textColor = RGB(51,51,51);
    title_lable.font = [UIFont systemFontOfSize:16];
    [view1 addSubview:title_lable];
    
    UIView *view1_1 = [[UIView alloc]initWithFrame:CGRectMake(12, 35, SCREENWIDTH-24, 44)];
    view1_1.backgroundColor = RGB(240, 240, 240);
    [view1 addSubview:view1_1];
    
    self.title_textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 7, view1_1.width-20, 30)];
    self.title_textField.font = [UIFont systemFontOfSize:16];
    self.title_textField.placeholder = @"请输入商品名称";
    self.title_textField.textColor = RGB(153,153,153);
    self.title_textField.text = [NSString getTheNoNullStr:self.product_dic[@"name"] andRepalceStr:@""];
    self.title_textField.delegate = self;
    [view1_1 addSubview:self.title_textField];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, view1.bottom+10, SCREENWIDTH, 105)];
    view2.backgroundColor =[UIColor whiteColor];
    [backView addSubview:view2];
    

    
    imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imgButton.frame = CGRectMake(27, 5, 95, 95);
    imgButton.backgroundColor = RGB(240, 240, 240);
    [imgButton addTarget:self action:@selector(imgSelect:) forControlEvents:UIControlEventTouchUpInside];
    if (self.product_dic) {
        NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCE_PRODUCT stringByAppendingString:self.product_dic[@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];

        [imgButton sd_setImageWithURL:nurl1 forState:0 placeholderImage:[UIImage imageNamed:@"add_yellow"]];
        
    }else{
        [imgButton setImage:[UIImage imageNamed:@"add_yellow"] forState:0];
  
    }
    [view2 addSubview:imgButton];
   
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, view2.bottom+10, SCREENWIDTH, 130+35+50)];
    view3.backgroundColor =[UIColor whiteColor];
    [backView addSubview:view3];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(19, 15, 166, 16)];
    
    lable.text = @"提供商品信息";
    lable.textColor = RGB(51,51,51);
    lable.font = [UIFont systemFontOfSize:16];
    [view3 addSubview:lable];
    
    UIView *view3_1 = [[UIView alloc]initWithFrame:CGRectMake(12, lable.bottom+5, SCREENWIDTH-24, 130)];
    view3_1.backgroundColor =RGB(240, 240, 240);
    [view3 addSubview:view3_1];
    
    for (int i = 0; i <3; i ++) {
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(24,view3.top+35+10+i*40, 40, 30)];
        lab.textColor = RGB(51,51,51);
        lab.font = [UIFont systemFontOfSize:16];
        [backView addSubview:lab];
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(lab.right+5, lab.top, 200, 30)];
        textField.font = [UIFont systemFontOfSize:16];
        textField.textColor = RGB(153,153,153);
        textField.delegate = self;
        [backView addSubview:textField];
        
        if (i==0) {
            lab.text = @"编号:";
            textField.placeholder = @"请输入编号";
            self.number_textField = textField;
            self.number_textField.text =  [NSString getTheNoNullStr:self.product_dic[@"number"] andRepalceStr:@""];
            self.number_textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            
        }
        if (i==1) {
            lab.text = @"价格:";
            textField.placeholder = @"请输入价格";
            self.price_textfield = textField;
            self.price_textfield.keyboardType = UIKeyboardTypeDecimalPad;

            self.price_textfield.text =  [NSString getTheNoNullStr:self.product_dic[@"price"] andRepalceStr:@""];

        }
        if (i==2) {
            lab.text = @"库存:";
            textField.placeholder = @"请输入库存";
            self.count_textField = textField;
            self.count_textField.keyboardType = UIKeyboardTypeNumberPad;

            self.count_textField.text =  [NSString getTheNoNullStr:self.product_dic[@"remain"] andRepalceStr:@""];


        }
        
    }
    

    
    
}

-(void)sureClick{
    NSLog(@"完成");
    [self canEditClick];

  
    
    
        if ([self.number_textField.text isEqualToString:@""]) {
            [self tishi:@"请填写商品编号"];

        }
        else if ([self.title_textField.text isEqualToString:@""])
        {
            [self tishi:@"请填写商品名称"];

        }
       else if ([self.price_textfield.text isEqualToString:@""])
        {
            [self tishi:@"请填写商品价格"];

        }else
        {
            if (self.editTag == 0) {
                 if(photoName.length==0){
                    [self tishi:@"请添加商品图片"];
                    
                 }else{
                     [self postRequestAddVipCard];

                 }

            }
            if (self.editTag == 1) {
                [self postRequestEditProduct];
                
            }

        }
        
}

-(void)postRequestAddVipCard
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@/MerchantType/commodity/add",BASEURL ];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    [params setObject:self.price_textfield.text forKey:@"price"];
    [params setObject:self.count_textField.text forKey:@"remain"];
    [params setObject:self.title_textField.text forKey:@"name"];
    [params setObject:self.number_textField.text forKey:@"code"];
    
    [params setObject:[photoName stringByAppendingString:@".png"]  forKey:@"image_url"];

    NSLog(@"params  %@", params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result %@", result);
        NSDictionary *dic = result;
        if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"result_code"]] isEqualToString:@"1"]) {
    
            
            [self tishi:@"添加商品成功"];

            [self performSelector:@selector(popView) withObject:nil afterDelay:2];
            
            
        }else if([[NSString stringWithFormat:@"%@",[dic objectForKey:@"result_code"]] isEqualToString:@"1062"]){
       
            [self tishi:@"已添加该商品,请勿重复添加"];

        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

-(void)postRequestEditProduct
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/commodity/mod",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    [params setObject:[self.product_dic objectForKey:@"number"] forKey:@"ecode"];
    [params setObject:self.price_textfield.text forKey:@"price"];
    [params setObject:self.count_textField.text forKey:@"remain"];
    [params setObject:self.title_textField.text forKey:@"name"];
    [params setObject:self.number_textField.text forKey:@"code"];
    if (photoName.length ==0) {
        [params setObject:self.product_dic[@"image_url"]  forKey:@"image_url"];

    }else{
        [params setObject:[photoName stringByAppendingString:@".png"]  forKey:@"image_url"];

    }

    NSLog(@"params =%@", params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        NSDictionary *dic = result;
        if ([dic[@"result_code"] intValue]==1) {
       
            
            [self tishi:@"修改商品成功"];
            [self performSelector:@selector(popView) withObject:nil afterDelay:1];

            
        }
        if ([dic[@"result_code"] intValue]==0) {
            [self tishi:@"修改商品失败"];
            
        }

        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (void)imgSelect:(UIButton *)sender {
    [self canEditClick];
    NSLog(@"选择图片");
    
    
    
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
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:photoName];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];

    [imgButton setImage:savedImage forState:0];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/upload/upload",BASEURL];
    
    
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    [parmer setValue:photoName forKey:@"name"];
    
    
        [parmer setValue:@"commodity" forKey:@"type"];
        
    
    
    
    NSData *img_Data = [NSData dataWithContentsOfFile:fullPath];
    [parmer setObject:img_Data forKey:@"file1"];
    
    
   // NSLog(@"0-----%@",parmer);
    [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        if ([result[@"result_code"] isEqualToString:@"access"]) {
        
            
            [self tishi:@"上传成功"];

        }
        NSLog(@"result===%@", result);
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"error-----%@",error.description);
        
        [self tishi:@"图片太大,上传失败"];

        
    }];
    
    
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
    //    if ([imageData length]/1000>400) {
    //            UIImage *image=[[UIImage alloc]initWithData:imageData];
    //            imageData = UIImageJPEGRepresentation(image, 0.1);
    //    }
    NSLog(@"+++++++=++++=+++=+%lu",(unsigned long)imageData.length);
    //    UIImage *result = [UIImage imageWithData:imageData];
    //
    //    while ((imageData.length/1024)>500) {
    //        imageData = UIImageJPEGRepresentation(result, 0.5);
    //         result = [UIImage imageWithData:imageData];
    //    }
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件

    [imageData writeToFile:fullPath atomically:NO];
    
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

-(void)canEditClick{
    [self.title_textField resignFirstResponder];
    [self.number_textField resignFirstResponder];
    [self.price_textfield resignFirstResponder];
    [self.count_textField resignFirstResponder];
    
    
}

-(void)popView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadTheAPI)]) {
        [self.delegate reloadTheAPI];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tishi:(NSString *)tishi{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.label.text = tishi;
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:1.f];
}
-(void)dealloc{
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
