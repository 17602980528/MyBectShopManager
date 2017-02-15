//
//  MoreInfoViewController.m
//  BletcShop
//
//  Created by Bletc on 16/4/5.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MoreInfoViewController.h"

@interface MoreInfoViewController ()

@end

@implementation MoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRegistView];
    // Do any additional setup after loading the view.
}
-(void)initRegistView
{
    UIView *landView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT-10)];
    [self.view addSubview:landView];
    //昵称
    UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 10, 40)];
    redLabel.text = @"*";
    redLabel.textColor = [UIColor redColor];
    redLabel.font = [UIFont systemFontOfSize:15];
    
    [landView addSubview:redLabel];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 40)];
    nameLabel.text = @"身份证";
    nameLabel.font = [UIFont systemFontOfSize:15];
    
    [landView addSubview:nameLabel];
    UITextField *phoneText = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, SCREENWIDTH-90, 40)];
    phoneText.placeholder = @"请输入您的身份证";
    phoneText.font = [UIFont systemFontOfSize:15];
    phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [landView addSubview:phoneText];
    //银行账户
    UILabel *zhanghuLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, phoneText.bottom, 10, 40)];
    zhanghuLabel.text = @"*";
    zhanghuLabel.textColor = [UIColor redColor];
    zhanghuLabel.font = [UIFont systemFontOfSize:15];
    [landView addSubview:zhanghuLabel];
    UILabel *personLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, phoneText.bottom, 60, 40)];
    personLabel.text = @"银行账户";
    personLabel.font = [UIFont systemFontOfSize:15];
    [landView addSubview:personLabel];
    UITextField *proText = [[UITextField alloc]initWithFrame:CGRectMake(90, phoneText.bottom, SCREENWIDTH-90, 40)];
    //proText.secureTextEntry = YES;
    proText.font = [UIFont systemFontOfSize:15];
    proText.placeholder = @"请输入您的银行卡号";
    proText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [landView addSubview:proText];
    UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(20+nameLabel.width+1,0,  0.3, proText.bottom)];
    lines.backgroundColor = [UIColor grayColor];
    lines.alpha = 0.3;
    [landView addSubview:lines];
//    UIView *lines1 = [[UIView alloc]initWithFrame:CGRectMake(20+personLabel.width+1,0,  0.3, personLabel.height)];
//    lines1.backgroundColor = [UIColor grayColor];
//    lines1.alpha = 0.3;
//    [landView addSubview:lines1];
    
    //营业执照
    UIView *choiceView = [[UIView alloc]initWithFrame:CGRectMake(0, personLabel.bottom, SCREENWIDTH/2-20, 100)];
    
    [landView addSubview:choiceView];
//    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, personLabel.bottom, SCREENHEIGHT/2-10, 100)];
//    
//    [choiceView addSubview:tableView];
    UILabel *zhizhaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 10, 30)];
    zhizhaoLabel.text = @"*";
    zhizhaoLabel.textColor = [UIColor redColor];
    zhizhaoLabel.font = [UIFont systemFontOfSize:15];
    [choiceView addSubview:zhizhaoLabel];
    
    UILabel *zhizhaoBtn = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 85, 20)];
    zhizhaoBtn.font = [UIFont systemFontOfSize:15];
    zhizhaoBtn.layer.borderColor = [[UIColor grayColor]CGColor];
    zhizhaoBtn.textAlignment = NSTextAlignmentCenter;
    zhizhaoBtn.layer.borderWidth = 0.5f;
    
    zhizhaoBtn.layer.masksToBounds = YES;
    zhizhaoBtn.text=@"营业执照";
    [choiceView addSubview:zhizhaoBtn];
    UIButton *jiantouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jiantouBtn.frame = CGRectMake(20+zhizhaoBtn.width, 5, 25, 20);
    jiantouBtn.backgroundColor=[UIColor grayColor];
//    [jiantouBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [choiceView addSubview:jiantouBtn];
    UIView *lines1 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-20,zhanghuLabel.bottom,  0.3, choiceView.height)];
    lines1.backgroundColor = [UIColor grayColor];
    lines1.alpha = 0.3;
    [landView addSubview:lines1];
    UIView *zzLine = [[UIView alloc]initWithFrame:CGRectMake(0,choiceView.bottom,  SCREENWIDTH,0.3)];
    zzLine.backgroundColor = [UIColor grayColor];
    zzLine.alpha = 0.3;
    [landView addSubview:zzLine];
    //上传图片
    UILabel *redPhotoLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-10, 0, 10, 30)];
    redPhotoLabel.text = @"*";
    redPhotoLabel.textColor = [UIColor redColor];
    redPhotoLabel.font = [UIFont systemFontOfSize:15];
    [choiceView addSubview:redPhotoLabel];
    UILabel *photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 5, 60, 30)];
    photoLabel.text = @"上传图片";
    photoLabel.font = [UIFont systemFontOfSize:15];
    [choiceView addSubview:photoLabel];
    UIImageView *photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-100, personLabel.bottom+5, 80, 80)];
    photoImgView.backgroundColor=[UIColor grayColor];
    photoImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
    [photoImgView addGestureRecognizer:portraitTap];
    
    
    [landView addSubview:photoImgView];
    
    //人行征信授权

    UIView *grantView = [[UIView alloc]initWithFrame:CGRectMake(0, choiceView.bottom, SCREENWIDTH/2-20, 100)];
    
    [landView addSubview:grantView];

    UILabel *shouquanRed = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 10, 30)];
    shouquanRed.text = @"*";
    shouquanRed.textColor = [UIColor redColor];
    shouquanRed.font = [UIFont systemFontOfSize:15];
    [grantView addSubview:shouquanRed];
    
    UILabel * shouquanLabel= [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 20)];
    shouquanLabel.font = [UIFont systemFontOfSize:15];
//    shouquanLabel.layer.borderColor = [[UIColor grayColor]CGColor];
    shouquanLabel.textAlignment = NSTextAlignmentCenter;
//    shouquanLabel.layer.borderWidth = 0.5f;
    
//    zhizhaoBtn.layer.masksToBounds = YES;
    shouquanLabel.text=@"人行征信授权";
    [grantView addSubview:shouquanLabel];

    UIView *glines1 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-20,choiceView.bottom,  0.3, grantView.height)];
    glines1.backgroundColor = [UIColor grayColor];
    glines1.alpha = 0.3;
    [landView addSubview:glines1];
    UIView *sqLine = [[UIView alloc]initWithFrame:CGRectMake(0,grantView.bottom,  SCREENWIDTH,0.3)];
    sqLine.backgroundColor = [UIColor grayColor];
    sqLine.alpha = 0.3;
    [landView addSubview:sqLine];
    //上传图片
    UILabel *redPhotoLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-10, 0, 10, 30)];
    redPhotoLabel1.text = @"*";
    redPhotoLabel1.textColor = [UIColor redColor];
    redPhotoLabel1.font = [UIFont systemFontOfSize:15];
    [grantView addSubview:redPhotoLabel1];
    UILabel *photoLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 5, 60, 30)];
    photoLabel1.text = @"上传图片";
    photoLabel1.font = [UIFont systemFontOfSize:15];
    [grantView addSubview:photoLabel1];
    UIImageView *photoImgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-100, choiceView.bottom+5, 80, 80)];
    photoImgView1.backgroundColor=[UIColor grayColor];
    photoImgView1.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *portraitTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
    [photoImgView1 addGestureRecognizer:portraitTap1];
    
    
    [landView addSubview:photoImgView1];
    //紧急联系ren1
    UILabel *contactRed = [[UILabel alloc]initWithFrame:CGRectMake(10, grantView.bottom, 10, 30)];
    contactRed.text = @"*";
    contactRed.textColor = [UIColor redColor];
    contactRed.font = [UIFont systemFontOfSize:15];
    [landView addSubview:contactRed];
    UILabel *contactLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, grantView.bottom, 120, 30)];
    contactLabel.text = @"紧急联系人一";
    contactLabel.font = [UIFont systemFontOfSize:15];
    [landView addSubview:contactLabel];
    UIView *oneLine = [[UIView alloc]initWithFrame:CGRectMake(0,contactLabel.bottom,  SCREENWIDTH,0.3)];
    oneLine.backgroundColor = [UIColor grayColor];
    oneLine.alpha = 0.3;
    [landView addSubview:oneLine];
    //联系人1的姓名电话
    UILabel *nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(20, contactLabel.bottom, 40, 40)];
    nameLabel1.text = @"姓名:";
    nameLabel1.tintColor = [UIColor redColor];
    nameLabel1.font = [UIFont systemFontOfSize:15];
    [landView addSubview:nameLabel1];
    UITextField *nameText1 = [[UITextField alloc]initWithFrame:CGRectMake(70, contactLabel.bottom, SCREENWIDTH/2-80, 40)];
    //nameText1.secureTextEntry = YES;
    nameText1.font = [UIFont systemFontOfSize:15];
    nameText1.placeholder = @"";
    nameText1.clearButtonMode = UITextFieldViewModeWhileEditing;
    [landView addSubview:nameText1];
    UILabel *phoneLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+20, contactLabel.bottom, 40, 40)];
    phoneLabel1.text = @"电话:";
    phoneLabel1.font = [UIFont systemFontOfSize:15];
    [landView addSubview:phoneLabel1];
    UIView *phoneLine1 = [[UIView alloc]initWithFrame:CGRectMake(0,nameLabel1.bottom,  SCREENWIDTH,0.3)];
    phoneLine1.backgroundColor = [UIColor grayColor];
    phoneLine1.alpha = 0.3;
    [landView addSubview:phoneLine1];
    UITextField *phoneText1 = [[UITextField alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+60, contactLabel.bottom, SCREENWIDTH/2-80, 40)];
    //phoneText1.secureTextEntry = YES;
    phoneText1.font = [UIFont systemFontOfSize:15];
    phoneText1.placeholder = @"";
    phoneText1.clearButtonMode = UITextFieldViewModeWhileEditing;
    [landView addSubview:phoneText1];
    UIView *nameLine = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2,contactLabel.bottom,  0.3,nameLabel1.height)];
    nameLine.backgroundColor = [UIColor grayColor];
    nameLine.alpha = 0.3;
    [landView addSubview:nameLine];
    //紧急联系ren2
    UILabel *contactRed2 = [[UILabel alloc]initWithFrame:CGRectMake(10, nameLabel1.bottom, 10, 30)];
    contactRed2.text = @"*";
    contactRed2.textColor = [UIColor redColor];
    contactRed2.font = [UIFont systemFontOfSize:15];
    [landView addSubview:contactRed2];
    UILabel *contactLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(20, nameLabel1.bottom, 120, 30)];
    contactLabel2.text = @"紧急联系人二";
    contactLabel2.font = [UIFont systemFontOfSize:15];
    [landView addSubview:contactLabel2];
    UIView *oneLine2 = [[UIView alloc]initWithFrame:CGRectMake(0,contactLabel2.bottom,  SCREENWIDTH,0.3)];
    oneLine2.backgroundColor = [UIColor grayColor];
    oneLine2.alpha = 0.3;
    [landView addSubview:oneLine2];
    //联系人2的姓名电话
    UILabel *nameLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(20, contactLabel2.bottom, 40, 40)];
    nameLabel2.text = @"姓名:";
    nameLabel2.tintColor = [UIColor redColor];
    nameLabel2.font = [UIFont systemFontOfSize:15];
    [landView addSubview:nameLabel2];
    UITextField *nameText2 = [[UITextField alloc]initWithFrame:CGRectMake(70, contactLabel2.bottom, SCREENWIDTH/2-80, 40)];
    //nameText2.secureTextEntry = YES;
    nameText2.font = [UIFont systemFontOfSize:15];
    nameText2.placeholder = @"";
    nameText2.clearButtonMode = UITextFieldViewModeWhileEditing;
    [landView addSubview:nameText2];
    UILabel *phoneLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+20, contactLabel2.bottom, 40, 40)];
    phoneLabel2.text = @"电话:";
    phoneLabel2.font = [UIFont systemFontOfSize:15];
    [landView addSubview:phoneLabel2];
    UIView *phoneLine2 = [[UIView alloc]initWithFrame:CGRectMake(0,nameLabel2.bottom,  SCREENWIDTH,0.3)];
    phoneLine2.backgroundColor = [UIColor grayColor];
    phoneLine2.alpha = 0.3;
    [landView addSubview:phoneLine2];
    UITextField *phoneText2 = [[UITextField alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+60, contactLabel2.bottom, SCREENWIDTH/2-80, 40)];
    //phoneText2.secureTextEntry = YES;
    phoneText2.font = [UIFont systemFontOfSize:15];
    phoneText2.placeholder = @"";
    phoneText2.clearButtonMode = UITextFieldViewModeWhileEditing;
    [landView addSubview:phoneText2];
    UIView *nameLine2 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2,contactLabel2.bottom,  0.3,nameLabel2.height)];
    nameLine2.backgroundColor = [UIColor grayColor];
    nameLine2.alpha = 0.3;
    [landView addSubview:nameLine2];
    //    // 添加下拉菜单
//    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithFrame:CGRectMake(20, phoneText.bottom, SCREENHEIGHT/4, 30)];
//    menu.delegate = self;
//    menu.dataSource = self;
//    [landView addSubview:menu];
//    _menu = menu;
//    [menu selectDefalutIndexPath];
//    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, personLabel.bottom, 70, 30)];
//    addressLabel.text = @"营业地址";
//    addressLabel.font = [UIFont systemFontOfSize:15];
//    [landView addSubview:addressLabel];
//    
//    UITextField *passwordText = [[UITextField alloc]initWithFrame:CGRectMake(90, proText.bottom, SCREENWIDTH-90, 30)];
//    passwordText.secureTextEntry = YES;
//    passwordText.font = [UIFont systemFontOfSize:15];
//    passwordText.placeholder = @"请输入您的营业地址";
//    passwordText.clearButtonMode = UITextFieldViewModeWhileEditing;
//    
//    [landView addSubview:passwordText];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, landView.width, 0.3)];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.3;
    [landView addSubview:line];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, phoneText.bottom, landView.width, 0.3)];
    line1.backgroundColor = [UIColor grayColor];
    line1.alpha = 0.3;
    [landView addSubview:line1];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, proText.bottom, landView.width, 0.3)];
    line2.backgroundColor = [UIColor grayColor];
    line2.alpha = 0.3;
    [landView addSubview:line2];
//    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, passwordText.bottom, landView.width, 0.3)];
//    line3.backgroundColor = [UIColor grayColor];
//    line3.alpha = 0.3;
//    [landView addSubview:line3];
    UIButton *LandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    LandBtn.frame = CGRectMake(30, nameLabel2.bottom+20, SCREENWIDTH-60, 35);
    [LandBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [LandBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [LandBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [LandBtn setBackgroundColor:NavBackGroundColor];
    LandBtn.layer.cornerRadius = 10;
    [LandBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    LandBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [landView addSubview:LandBtn];
    
}
-(void)nextAction
{}
//-(void)chooseImage{
//    
//    UIActionSheet *sheet;
//    
//    // 判断是否支持相机
//    
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//        
//    {
//        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
//        
//    }
//    
//    else {
//        
//        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
//        
//    }
//    
//    sheet.tag = 255;
//    
//    [sheet showInView:self.view];
//    
//}
//-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (actionSheet.tag == 255) {
//        
//        NSUInteger sourceType = 0;
//        
//        // 判断是否支持相机
//        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            
//            switch (buttonIndex) {
//                case 0:
//                    // 取消
//                    return;
//                case 1:
//                    // 相机
//                    sourceType = UIImagePickerControllerSourceTypeCamera;
//                    break;
//                    
//                case 2:
//                    // 相册
//                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                    break;
//            }
//        }
//        else {
//            if (buttonIndex == 0) {
//                
//                return;
//            } else {
//                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//            }
//        }
//        // 跳转到相机或相册页面
//        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//        
//        imagePickerController.delegate = self;
//        
//        imagePickerController.allowsEditing = YES;
//        
//        imagePickerController.sourceType = sourceType;
//        
//        [self presentViewController:imagePickerController animated:YES completion:^{}];
//        
//    }
//}
-(void)photoNow
{
    // 拍照
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([self isFrontCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
    }

}
-(void)choicePhoto
{
    // 从相册中选取
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
    }

}
#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}





- (void)editPortrait {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    //添加Button
    [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //处理点击拍照
        [self photoNow];
        
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self choicePhoto];
        //处理点击从相册选取
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
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
