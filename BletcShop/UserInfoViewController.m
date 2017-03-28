//
//  UserInfoViewController.m
//  BletcShop
//
//  Created by Bletc on 16/4/12.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "UserInfoViewController.h"

#import "UIImageView+WebCache.h"

#import "NameSignViewController.h"

#import "NewChangePsWordViewController.h"

#import "ResetPhoneViewController.h"

#import "ValuePickerView.h"
@interface UserInfoViewController ()
{
    
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSMutableArray *monthMutableArray;
    NSMutableArray *DaysMutableArray;
    NSMutableArray *DaysArray;
    NSString *currentMonthString;
    NSString *currentDateString;
    NSString *currentyearString;
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    
    BOOL firstTimeLoad;
    
    NSInteger m ;
    int year;
    int month;
    int day;
    //yue ri shi
    NSInteger selectedHourRowOnLine;
    NSInteger selectedMonthRowOnLine;
    NSInteger selectedDayRowOnLine;
    NSData *imageData;
    NSData *imageData2;
    
    NSArray *labelStringArray;
    NSArray *section2_A;
    
}

@property (nonatomic, strong) ValuePickerView *pickerView;
@property (nonatomic, strong) NSArray *marray_A;
@property (nonatomic, strong) NSArray *education_A;
@property (nonatomic, strong) NSArray *profession_A;


@end


@implementation UserInfoViewController

-(NSArray *)marray_A{
    if (!_marray_A) {
        _marray_A = @[@"已婚",@"单身"];
    }
    return _marray_A;
}
-(NSArray *)education_A{
    if (!_education_A) {
        _education_A = @[@"小学",@"初中",@"高中",@"大专",@"本科",@"硕士",@"博士",@"其他"];
    }
    return _education_A;
}
-(NSArray *)profession_A{
    if (!_profession_A) {
        _profession_A = @[@"教师",@"软件工程师",@"科学家"];
    }
    return _profession_A;
}
-(ValuePickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[ValuePickerView alloc]init];
        
    }
    return _pickerView;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
     labelStringArray =@[@"昵称",@"地址",@"手机号",@"邮箱",@"性别",@"生日",@"修改密码"];
    section2_A = @[@"职业",@"教育状况",@"婚姻状况",@"个人爱好"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectRow = 99;
    self.navigationController.navigationBarHidden=YES;
    [self initNavBar];
    [self _inittableDate];
    [self _initTable];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden=NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}
-(void)initNavBar{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 285)];
    headView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:headView];
    
    UIImageView *backGroundImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 196+20)];
    backGroundImageView.clipsToBounds=YES;
    backGroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backGroundImageView.userInteractionEnabled=YES;
    //backGroundImageView.backgroundColor=[UIColor whiteColor];
    
    [headView addSubview:backGroundImageView];
    self.backGroundImageView=backGroundImageView;
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0,0,backGroundImageView.frame.size.width, backGroundImageView.frame.size.height);
    [backGroundImageView addSubview:effectView];
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame=CGRectMake(12, 20+15, 60, 16);
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:16.0f];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backGroundImageView addSubview:cancelBtn];
    
//    UILabel *heading=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-30 , 20+14, 60, 17)];
//    heading.text=@"资料";
//    heading.font=[UIFont systemFontOfSize:18.0f];
//    heading.textColor=[UIColor whiteColor];
//    heading.textAlignment=1;
//    [backGroundImageView addSubview:heading];
    
//    UIButton *completeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    completeBtn.frame=CGRectMake(SCREENWIDTH-75, 20+15, 60, 16);
//    [completeBtn setTitle:@"背景" forState:UIControlStateNormal];
//    completeBtn.titleLabel.font=[UIFont systemFontOfSize:16.0f];
//    [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [completeBtn addTarget:self action:@selector(completeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [backGroundImageView addSubview:completeBtn];
    
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-45, 168, 90, 90)];
    self.imageView=headImage;
    headImage.clipsToBounds=YES;
    headImage.layer.cornerRadius=45;
    headImage.image=[UIImage imageNamed:@""];
    [headView addSubview:headImage];
    headImage.contentMode = UIViewContentModeScaleAspectFill;

    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *str = [[NSString alloc]init];
    
    str = [[[NSString alloc]initWithFormat:@"%@%@",HEADIMAGE,[appdelegate.userInfoDic objectForKey:@"headimage"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DebugLog(@"headerImg ==%@",str);
    
    [headImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"头像.png"] options:SDWebImageRetryFailed];
    [backGroundImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"头像.png"] options:SDWebImageRetryFailed];

    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePhoto)];
    headImage.userInteractionEnabled=YES;
    [headImage addGestureRecognizer:tap];
    
    UIButton *changePhotoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    changePhotoBtn.frame=CGRectMake(SCREENWIDTH/2-50, 277, 100, 15);
    [changePhotoBtn setTitle:@"修改头像" forState:UIControlStateNormal];
    changePhotoBtn.titleLabel.font=[UIFont systemFontOfSize:16.0f];
    [changePhotoBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    [headView addSubview:changePhotoBtn];
    [changePhotoBtn addTarget:self action:@selector(changePhoto) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)_inittableDate
{
    
    m=0;
    
    NSDate *date = [NSDate date];
    
    // Get Current Year
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    
    currentyearString = [NSString stringWithFormat:@"%@",
                         [formatter stringFromDate:date]];
    year =[currentyearString intValue];
    
    
    // Get Current  Month
    
    [formatter setDateFormat:@"MM"];
    
    currentMonthString = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    month=[currentMonthString intValue];
    
    // Get Current  Date
    
    [formatter setDateFormat:@"dd"];
    currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    day =[currentDateString intValue];
    
    
    yearArray = [[NSMutableArray alloc]init];
    monthMutableArray = [[NSMutableArray alloc]init];
    DaysMutableArray= [[NSMutableArray alloc]init];
    for (int i = year-100; i <= year ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    monthArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    for (int i=1; i<month+1; i++) {
        [monthMutableArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    DaysArray = [[NSMutableArray alloc]init];
    
    for (int i = 1; i <= 31; i++)
    {
        [DaysArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    for (int i = 1; i <day+1; i++)
    {
        [DaysMutableArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
}
-(void)_initTable
{
    UITableView *mytable = [[UITableView alloc]initWithFrame:CGRectMake(0, 350-44, SCREENWIDTH, SCREENHEIGHT-350+44) style:UITableViewStyleGrouped];
    mytable.backgroundColor = [UIColor clearColor];
    mytable.dataSource = self;
    mytable.delegate = self;
    mytable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mytable.showsVerticalScrollIndicator = NO;
    mytable.bounces = NO;
    self.Mytable = mytable;
    mytable.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:mytable];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return labelStringArray.count;
    } if( section ==1){
        return section2_A.count;
    }
    else
        return 1;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.01;
    }
    else if(section==1){
        return 30;
    }else
        return 11;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 10;
    }
    else
        return 0.01;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    view.backgroundColor = tableViewBackgroundColor;
    
    if (section==1) {
        view.frame = CGRectMake(0, 0, SCREENWIDTH, 30);
        
        for (UIView *v in view.subviews) {
            [v removeFromSuperview];
        }
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, SCREENWIDTH-12, view.height)];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = RGB(51, 51, 51);
        lab.text = @"完成以下信息可获赠更多积分";
        [view addSubview:lab];
        
    }else{
        view.frame = CGRectMake(0, 0, SCREENWIDTH, 11);
    }
    return view;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    view.backgroundColor = tableViewBackgroundColor;
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    // 通过indexPath创建cell实例 每一个cell都是单独的
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0 || (indexPath.section==1)) {


        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.frame = CGRectMake(12, 0, 80, 44);
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.tag = 1000;
        [cell addSubview:nameLabel];
        
        UILabel *descripLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, SCREENWIDTH-110, 44)];
        descripLabel.backgroundColor = [UIColor clearColor];
        descripLabel.textAlignment = NSTextAlignmentLeft;
        descripLabel.font = [UIFont systemFontOfSize:16];
        descripLabel.tag = 1000;
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        if (indexPath.section==0) {
            nameLabel.text = [labelStringArray objectAtIndex:indexPath.row];

            if (indexPath.row==0) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                descripLabel.text = appdelegate.userInfoDic[@"nickname"];
            }else if (indexPath.row==1) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                descripLabel.text = appdelegate.userInfoDic[@"address"];
            }else if (indexPath.row==2) {
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                descripLabel.text = appdelegate.userInfoDic[@"phone"];
            }else if (indexPath.row==3) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                descripLabel.text = [NSString getTheNoNullStr:appdelegate.userInfoDic[@"mail"] andRepalceStr:@"未设置"];
            }else if (indexPath.row==4) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                descripLabel.text = [NSString getTheNoNullStr:appdelegate.userInfoDic[@"sex"] andRepalceStr:@"未设置"];
                
            }else if (indexPath.row==5)
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                descripLabel.text = [NSString getTheNoNullStr:appdelegate.userInfoDic[@"age"] andRepalceStr:@"未设置"];
            }else
                if (indexPath.row==6) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    descripLabel.text =@"";
                    
                }else{
                    //            if (indexPath.row==7){
                    //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    //
                    //            descripLabel.text =@"";
                    //        }
                    //        else
                    
                    descripLabel.text =@"未设置";
                    
                }
        }else{
            nameLabel.text = [section2_A objectAtIndex:indexPath.row];

            
            if (indexPath.row==0) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                descripLabel.text = appdelegate.userInfoDic[@""];
            }else if (indexPath.row==1) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                descripLabel.text = appdelegate.userInfoDic[@""];
            }else{
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                descripLabel.text = appdelegate.userInfoDic[@""];
            }
        }

        
        
        [cell addSubview:descripLabel];
        
        
    }
    else
    {
        cell.textLabel.text = @"退出当前账号";
    }
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(12, 0, SCREENWIDTH, 1)];
    viewLine.backgroundColor = RGB(234, 234, 234);
    [cell addSubview:viewLine];
    
    return cell;
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
    
    self.backGroundImageView.image = savedImage;

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        if (indexPath.row==0) {
            self.selectRow =1;
            [self NewAddAction];
        }else if (indexPath.row==1) {
            self.selectRow =2;
            [self NewAddAction];
        }else if (indexPath.row==2) {
            //            self.selectRow =3;
            //            [self NewAddAction];
            
            
            ResetPhoneViewController *VC = [[ResetPhoneViewController alloc]init];
            
            [self.navigationController pushViewController:VC animated:YES];
            
            
        }else if (indexPath.row==3) {
            self.selectRow =4;
            [self NewAddAction];
        }else if (indexPath.row==4) {
            self.selectRow =5;
            [self NewAddAction];
        }else if (indexPath.row==5) {
            self.selectRow =6;
            [self NewAddAction];
        }else if (indexPath.row==6) {
            //            self.selectRow =7;
            //            [self NewAddAction];
            NewChangePsWordViewController *passVC=[[NewChangePsWordViewController alloc]init];
            [self.navigationController pushViewController:passVC animated:YES];
        }else if (indexPath.row==7) {
            NameSignViewController *signVC=[[NameSignViewController alloc]init];
            [self.navigationController pushViewController:signVC animated:YES];
        }
        
    } if (indexPath.section==1) {
        
        if (indexPath.row == 0) {
            self.pickerView.dataSource = self.profession_A;
        }
        if (indexPath.row == 1) {
            self.pickerView.dataSource = self.education_A;
        }
        if (indexPath.row == 2) {
            self.pickerView.dataSource = self.marray_A;
        }
        
        if (indexPath.row == 3) {
            self.pickerView.dataSource = self.marray_A;
        }
        
        self.pickerView.valueDidSelect = ^(NSString * value){
            
            NSLog(@"======%@",[[value componentsSeparatedByString:@"/"] firstObject]);
        };
        
        [self.pickerView show];
        
    }
    else  if(indexPath.section==2){
        
       
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        [appdelegate loginOutBletcShop];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    if (alertView.tag==0&&buttonIndex==0) {
        if (self.selectRow==7) {
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            if (![[appdelegate.userInfoDic objectForKey:@"passwd"] isEqualToString:self.oldPswText.text]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"原密码输入错误", @"HUD message title");
                
                hud.label.font = [UIFont systemFontOfSize:13];
                //    [hud setColor:[UIColor blackColor]];
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                hud.userInteractionEnabled = YES;
                
                [hud hideAnimated:YES afterDelay:2.f];
            }
            else if (![self.pswText.text isEqualToString:self.pswdText.text])
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"请重新输入密码", @"HUD message title");
                
                hud.label.font = [UIFont systemFontOfSize:13];
                //    [hud setColor:[UIColor blackColor]];
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                hud.userInteractionEnabled = YES;
                
                [hud hideAnimated:YES afterDelay:2.f];
            }else if ([self.oldPswText.text isEqualToString:self.pswdText.text])
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"新密码和原密码相同,请重新输入", @"HUD message title");
                
                hud.label.font = [UIFont systemFontOfSize:13];
                //    [hud setColor:[UIColor blackColor]];
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                hud.userInteractionEnabled = YES;
                
                [hud hideAnimated:YES afterDelay:2.f];
            }else
                [self postChangePsw];
        }else
            [self postRevise];
    }
    [alertView close];
}


/**
 改变密码
 */
-(void)postChangePsw
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountSet",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.userInfoDic objectForKey:@"uuid"] forKey:@"uuid"];
    [params setValue:@"passwd" forKey:@"type"];
    [params setObject:self.oldPswText.text forKey:@"pwd_old"];
    [params setObject:self.pswdText.text forKey:@"pwd_new"];
    
    NSLog(@"%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"%@", result);
         
         if ([result[@"result_code"] intValue]==1) {
             
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.label.text = NSLocalizedString(@"密码修改成功", @"HUD message title");
             
             hud.label.font = [UIFont systemFontOfSize:13];
             //    [hud setColor:[UIColor blackColor]];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             hud.userInteractionEnabled = YES;
             
             [hud hideAnimated:YES afterDelay:2.f];
             
             NSMutableDictionary *new_dic = [appdelegate.userInfoDic mutableCopy];
             [new_dic setValue:result[@"para"] forKey:result[@"type"]];
             appdelegate.userInfoDic = new_dic;
             
         }else
         {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.label.text = NSLocalizedString(@"修改失败!", @"HUD message title");
             
             hud.label.font = [UIFont systemFontOfSize:13];
             //    [hud setColor:[UIColor blackColor]];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             hud.userInteractionEnabled = YES;
             
             [hud hideAnimated:YES afterDelay:2.f];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@", error);
         
     }];
    
    
}
-(void)postRevise
{
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountSet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    if (self.selectRow==1) {
        [params setObject:@"nickname" forKey:@"type"];
        [params setObject:self.nameText.text forKey:@"para"];
    }else if (self.selectRow==2) {
        [params setObject:@"address" forKey:@"type"];
        [params setObject:self.nameText.text forKey:@"para"];
    }else if (self.selectRow==4) {
        [params setObject:@"mail" forKey:@"type"];
        [params setObject:self.nameText.text forKey:@"para"];
    }else if (self.selectRow==5) {
        [params setObject:@"sex" forKey:@"type"];
        if (self.boyBtn.selected ==YES) {
            [params setObject:@"男" forKey:@"para"];
        }else if (self.girlBtn.selected ==YES) {
            [params setObject:@"女" forKey:@"para"];
            
        }
    }else if (self.selectRow==6) {
        [params setObject:@"age" forKey:@"type"];
        [params setObject:self.nameText.text forKey:@"para"];
    }
    NSLog(@"params===%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         DebugLog(@"result===+%@",result);
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
         hud.mode = MBProgressHUDModeText;
         if ([result[@"result_code"] intValue]==1 ) {
             hud.label.text = NSLocalizedString(@"修改成功", @"HUD message title");
             
             hud.label.font = [UIFont systemFontOfSize:13];
             //    [hud setColor:[UIColor blackColor]];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             hud.userInteractionEnabled = YES;
             
             [hud hideAnimated:YES afterDelay:2.f];
             
             
             NSMutableDictionary *new_dic = [appdelegate.userInfoDic mutableCopy];
             
             
             [new_dic setValue:result[@"para"] forKey:result[@"type"]];
             
             appdelegate.userInfoDic = new_dic;
             
             
             
             [self.Mytable reloadData];
         }else
         {
             hud.label.text = NSLocalizedString(@"请求失败 请重试", @"HUD message title");
             
             hud.label.font = [UIFont systemFontOfSize:13];
             //    [hud setColor:[UIColor blackColor]];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             hud.userInteractionEnabled = YES;
             
             [hud hideAnimated:YES afterDelay:2.f];
             
             
         }
         
         
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@", error);
         
     }];
    
}
-(void)NewAddAction
{
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    self.alertView = alertView;
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView]];
    
    // Modify the parameters
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

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] init ];
    demoView.frame =CGRectMake(0, 0, 290, 80);
    if(self.selectRow==1)
    {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 40)];
        label.text = @"修改昵称";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:label];
        UITextField *nameText = [[UITextField alloc]initWithFrame:CGRectMake(30, 45, 230, 30)];
        self.nameText = nameText;
        nameText.placeholder = @" ";
        nameText.textAlignment = NSTextAlignmentCenter;
        nameText.layer.borderWidth = 0.5;
        nameText.font = [UIFont systemFontOfSize:11];
        nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:nameText];
        
    }else if(self.selectRow==2)
    {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 40)];
        label.text = @"修改地址";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:label];
        UITextField *nameText = [[UITextField alloc]initWithFrame:CGRectMake(30, 45, 230, 30)];
        self.nameText = nameText;
        nameText.placeholder = @" ";
        nameText.textAlignment = NSTextAlignmentCenter;
        nameText.layer.borderWidth = 0.5;
        nameText.font = [UIFont systemFontOfSize:11];
        nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:nameText];
        
    }else if(self.selectRow==4)
    {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 40)];
        label.text = @"修改邮箱";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:label];
        UITextField *nameText = [[UITextField alloc]initWithFrame:CGRectMake(30, 45, 230, 30)];
        self.nameText = nameText;
        nameText.placeholder = @" ";
        nameText.textAlignment = NSTextAlignmentCenter;
        nameText.layer.borderWidth = 0.5;
        nameText.font = [UIFont systemFontOfSize:11];
        nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:nameText];
        
    }else if(self.selectRow==5)
    {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 40)];
        label.text = @"修改性别";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:label];
        //男
        UILabel *boylabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 45, 20, 30)];
        boylabel.text = @"男";
        boylabel.textAlignment = NSTextAlignmentCenter;
        boylabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:boylabel];
        UIButton *boyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        boyBtn.frame = CGRectMake(80, 53, 15, 15);
        //    choseBtn.backgroundColor = [UIColor redColor];
        [boyBtn setImage:[UIImage imageNamed:@"weigouxuan"] forState:UIControlStateNormal];
        [boyBtn setImage:[UIImage imageNamed:@"gouxuan@"] forState:UIControlStateSelected];
        [boyBtn addTarget:self action:@selector(boyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        self.boyBtn = boyBtn;
        [demoView addSubview:boyBtn];
        //
        
        ////女
        UILabel *girllabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 45, 20, 30)];
        girllabel.text = @"女";
        girllabel.font = [UIFont systemFontOfSize:13];
        girllabel.textAlignment = NSTextAlignmentCenter;
        [demoView addSubview:girllabel];
        UIButton *girlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        girlBtn.frame = CGRectMake(200, 53, 15, 15);
        //    choseBtn.backgroundColor = [UIColor redColor];
        [girlBtn setImage:[UIImage imageNamed:@"weigouxuan"] forState:UIControlStateNormal];
        [girlBtn setImage:[UIImage imageNamed:@"gouxuan@"] forState:UIControlStateSelected];
        [girlBtn addTarget:self action:@selector(girlBtnAction) forControlEvents:UIControlEventTouchUpInside];
        self.girlBtn = girlBtn;
        [demoView addSubview:girlBtn];
        //
        
        
    }else if(self.selectRow==6)
    {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 40)];
        label.text = @"修改生日";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:label];
        UITextField *nameText = [[UITextField alloc]initWithFrame:CGRectMake(30, 45, 230, 30)];
        self.nameText = nameText;
        nameText.delegate = self;
        nameText.tag = 2001;
        nameText.placeholder = @" ";
        nameText.textAlignment = NSTextAlignmentCenter;
        nameText.layer.borderWidth = 0.5;
        nameText.font = [UIFont systemFontOfSize:11];
        nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:nameText];
        
    }else if(self.selectRow==7)
    {
        demoView.frame =CGRectMake(0, 0, 290, 160);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 40)];
        label.text = @"修改密码";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:label];
        //原密码
        UILabel *oldlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 50, 30)];
        oldlabel.text = @"原密码";
        oldlabel.textAlignment = NSTextAlignmentCenter;
        oldlabel.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:oldlabel];
        
        UITextField *nameText = [[UITextField alloc]initWithFrame:CGRectMake(70, 45, 200, 30)];
        nameText.keyboardType = UIKeyboardTypeASCIICapable;
        self.oldPswText = nameText;
        nameText.delegate = self;
        nameText.tag = 2002;
        //nameText.placeholder = @" ";
        nameText.textAlignment = NSTextAlignmentLeft;
        nameText.layer.borderWidth = 0.5;
        nameText.font = [UIFont systemFontOfSize:11];
        nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:nameText];
        //新密码
        UILabel *newlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 85, 50, 30)];
        newlabel.text = @"新密码";
        newlabel.textAlignment = NSTextAlignmentCenter;
        newlabel.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:newlabel];
        UITextField *pswText = [[UITextField alloc]initWithFrame:CGRectMake(70, 85, 200, 30)];
        pswText.keyboardType = UIKeyboardTypeASCIICapable;
        self.pswText = pswText;
        pswText.delegate = self;
        pswText.tag = 2002;
        //pswText.placeholder = @" ";
        pswText.textAlignment = NSTextAlignmentLeft;
        pswText.layer.borderWidth = 0.5;
        pswText.font = [UIFont systemFontOfSize:11];
        pswText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:pswText];
        //重复密码
        UILabel *newlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 125, 60, 30)];
        newlabel1.text = @"确认密码";
        newlabel1.textAlignment = NSTextAlignmentCenter;
        newlabel1.font = [UIFont boldSystemFontOfSize:13];
        [demoView addSubview:newlabel1];
        UITextField *pswdText = [[UITextField alloc]initWithFrame:CGRectMake(70, 125, 200, 30)];
        pswdText.keyboardType = UIKeyboardTypeASCIICapable;
        self.pswdText = pswdText;
        pswdText.delegate = self;
        pswdText.tag = 2002;
        //pswdText.placeholder = @" ";
        pswdText.textAlignment = NSTextAlignmentLeft;
        pswdText.layer.borderWidth = 0.5;
        pswdText.font = [UIFont systemFontOfSize:11];
        pswdText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:pswdText];
        
        
    }
    return demoView;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (pickerView.tag == 1001) {
        UILabel *pickerLabel = (UILabel *)view;
        
        if (pickerLabel == nil) {
            CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
            pickerLabel = [[UILabel alloc] initWithFrame:frame];
            [pickerLabel setTextAlignment:NSTextAlignmentCenter];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
        }
        if (component == 0)
        {
            pickerLabel.text =  [yearArray objectAtIndex:row]; // Year
        }
        else if (component == 1)
        {
            pickerLabel.text =  [monthArray objectAtIndex:row];  // Month
        }
        else if (component == 2)
        {
            pickerLabel.text =  [DaysArray objectAtIndex:row]; // Date
            
        }
        
        
        return pickerLabel;
    }
    
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor greenColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:12]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag ==1001||pickerView.tag ==1002) {
        return 3;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag==1001)
    {
        if (component == 0)
        {
            return [yearArray count];
            
        }
        else if (component == 1)
        {
            NSInteger selectRow =  [pickerView selectedRowInComponent:0];
            int n;
            n= year-1970;
            if (selectRow==n) {
                return [monthMutableArray count];
            }else
            {
                return [monthArray count];
                
            }
        }
        else
        {
            NSInteger selectRow1 =  [pickerView selectedRowInComponent:0];
            int n;
            n= year-1970;
            NSInteger selectRow =  [pickerView selectedRowInComponent:1];
            
            if (selectRow==month-1 &selectRow1==n) {
                
                return day;
                
            }else{
                
                if (selectedMonthRow == 0 || selectedMonthRow == 2 || selectedMonthRow == 4 || selectedMonthRow == 6 || selectedMonthRow == 7 || selectedMonthRow == 9 || selectedMonthRow == 11)
                {
                    return 31;
                }
                else if (selectedMonthRow == 1)
                {
                    int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                    
                    if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                        return 29;
                    }
                    else
                    {
                        return 28; // or return 29
                    }
                    
                }
                else
                {
                    return 30;
                }
            }
        }
    }
    else
        return 30;
}


-(void)choiceBirthDate
{
    
}
-(void)boyBtnAction
{
    self.boyBtn.selected=YES;
    self.girlBtn.selected=NO;
    
}

-(void)girlBtnAction
{
    self.girlBtn.selected=YES;
    self.boyBtn.selected=NO;
    
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor grayColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self.view endEditing:YES];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField.tag == 2001) {
        self.nameText.text = @"";
        
        self.customPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-160, SCREENWIDTH, 160)] ;
        self.customPicker.tag = 1001;
        self.customPicker.backgroundColor = [UIColor whiteColor];
        self.customPicker.delegate = self;
        self.customPicker.dataSource = self;
        self.toolbarCancelDone = [[UIToolbar alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-200, SCREENWIDTH, 40)];
        [self.alertView addSubview: self.customPicker];
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        okBtn.frame = CGRectMake(SCREENWIDTH-60, 0, 60, 40);
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        //[okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [okBtn addTarget:self action:@selector(actionDone) forControlEvents:UIControlEventTouchUpInside];
        [self.toolbarCancelDone addSubview:okBtn];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, 60, 40);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelBtn addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
        [self.toolbarCancelDone addSubview:cancelBtn];
        
        [self.alertView addSubview:self.toolbarCancelDone];
        self.customPicker.hidden = NO;
        self.toolbarCancelDone.hidden = NO;
    }
    [self.customPicker selectRow:[yearArray indexOfObject:currentyearString] inComponent:0 animated:NO];
    
    // [pickerView selectRow:30 inComponent:0 animated:NO];
    
    [self.customPicker selectRow:[monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];
    
    //[self.customPicker selectRow:[DaysMutableArray indexOfObject:currentDateString] inComponent:2 animated:YES];
    
    if ([textField isEqual:self.nameText]) {
        return NO;
    }else
        return YES;
    
}
- (void)actionCancel
{
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.customPicker.hidden = YES;
                         self.toolbarCancelDone.hidden = YES;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    
}
- (void)actionDone
{
    
    
    self.nameText.text = [NSString stringWithFormat:@"%@-%@-%@",[yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]],[monthArray objectAtIndex:[self.customPicker selectedRowInComponent:1]],[DaysArray objectAtIndex:[self.customPicker selectedRowInComponent:2]]];
    
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.customPicker.hidden = YES;
                         self.toolbarCancelDone.hidden = YES;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return  YES;
    
}


/**
 修改用户头像
 
 @param image 所修改的头像
 */
-(void)changeUserImage:(UIImage *)image{
    
    self.imageView.image=image;
    self.backGroundImageView.image = image;
    

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
            //            self.isImageSuccess = YES;
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
        //        DebugLog(@"-----%@",error.description);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"图片太大,上传失败", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:4.f];
        NSLog(@"请求失败");
        
    }];
    
    
    
}
//取消
-(void)cancelBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//背景
-(void)completeBtnClick:(UIButton *)sender{
    
}
//修改图像
-(void)changePhoto{
    [self changeUserImg];
}
@end
