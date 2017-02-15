//
//  LastRegistViewController.m
//  BletcShop
//
//  Created by Bletc on 16/4/26.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LastRegistViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ShopProtocolViewController.h"
@interface LastRegistViewController ()
{
    //声明一个全局的toolbar
    UIToolbar * topView;
    NSData *imageData;
    NSData *imageData2;
}
@end

@implementation LastRegistViewController
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    
    [self.view endEditing:YES];
    
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField

{
    if (textField==self.phonePswText) {
        [self NewAddVipAction];
        return NO;
    }
    UIView *view = textField.superview;
    
    while (![view isKindOfClass:[UITableViewCell class]]) {
        
        view = [view superview];
        
    }
    
    UITableViewCell *cell = (UITableViewCell*)view;
    
    CGRect rect = [cell convertRect:cell.frame toView:self.view];
    
    if (rect.origin.y / 2 + rect.size.height>=SCREENHEIGHT-200) {
        
        self.infoTableView.contentInset = UIEdgeInsetsMake(0, 0, 216, 0);
        
        [self.infoTableView scrollToRowAtIndexPath:[self.infoTableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
    }
    
    return YES;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.infoTableView resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:self.idenCardText])
    {
        if (self.idenCardText.text.length!=18)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"身份证格式错误,请重新输入", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            // Move to bottm center.
            //    hud.offset = CGPointMake(0.f, );
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:4.f];

        }
    }
    [textField resignFirstResponder];
    [self.infoTableView resignFirstResponder];
    self.infoTableView.frame =CGRectMake(0, 64, self.infoTableView.frame.size.width, SCREENHEIGHT-64);
}
-(void)backRegist
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //Eric 新增
    topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    [topView setBarStyle:UIBarStyleBlackTranslucent];
    topView.barTintColor=[UIColor whiteColor];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btna = [UIButton buttonWithType:UIButtonTypeCustom];
    [btna setTitle:@"收回" forState:UIControlStateNormal];
    [btna setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btna.frame = CGRectMake(2, 5, 50, 25);
    [btna addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    //[btna setImage:[UIImage imageNamed:@"shouqi2"] forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btna];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    //[textfield setInputAccessoryView:topView];
    //Eric 新增结束

    self.ifLicence = NO;
    self.ifProperty = NO;
    NSLog(@"propertyString%@",self.propertyString);
//    self.licenceString = @"有";
//    self.propertyString = @"租赁合同";
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    navView.backgroundColor = NavBackGroundColor;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 18, 70, 44)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backRegist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
    [navView addSubview:btn];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-35, 18, 70, 44)];
    label.font=[UIFont systemFontOfSize:19.0f];
    label.text=@"注册";
    label.textAlignment=1;
    label.textColor=[UIColor whiteColor];
    [navView addSubview:label];
    self.infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    [self.infoTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    [self.view addSubview:self.infoTableView];
    
    self.view.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *singleTap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1001||tableView.tag == 1002) {
        return 2;
    }else{
//        if ([self.personString isEqualToString:@"无人推荐"]) {
//            return 18;
//        }else
            return 19;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 1001||tableView.tag == 1002) {
        return 0.01;
    }
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1001||tableView.tag == 1002) {
        return 30;
    }
    else{
//        if ([self.personString isEqualToString:@"无人推荐"])
//        {
//            if (indexPath.row == 0||indexPath.row==6||indexPath.row==8||indexPath.row==9||indexPath.row==10) {
//                return 80;
//            }
//            else if (indexPath.row==2||indexPath.row==3||indexPath.row==4||indexPath.row==5||indexPath.row==1||indexPath.row==7||indexPath.row==12||indexPath.row==13||indexPath.row==14||indexPath.row==11||indexPath.row==15||indexPath.row==16)
//            {
//                return 40;
//            }
//            else
//                return 60;
//        }else
//        {
            if (indexPath.row == 0||indexPath.row==6||indexPath.row==8||indexPath.row==9||indexPath.row==10||indexPath.row==11)
            {
                return 80;
            }
            else if (indexPath.row==2||indexPath.row==3||indexPath.row==4||indexPath.row==5||indexPath.row==1||indexPath.row==7||indexPath.row==12||indexPath.row==13||indexPath.row==14||indexPath.row==15||indexPath.row==16||indexPath.row==17)
            {
                return 40;
            }
            else
                return 100;
//        }
    }
    return 60;
}
- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 150)];
    self.demoView = demoView;
    demoView.frame=CGRectMake(0, 0, 290, 50);
    UILabel *numlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, demoView.width, 50)];
    numlabel.textAlignment = NSTextAlignmentCenter;
    numlabel.text = @"是否同意提供手机查询授权";
    numlabel.font = [UIFont systemFontOfSize:16];
    [demoView addSubview:numlabel];
    return demoView;
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (alertView.tag==0&&buttonIndex==1) {
        self.phonePswText.text = @"已拒绝，点击可修改。";
        [alertView close];
    }
    else if (alertView.tag==0&&buttonIndex==0)
    {
        //self.phonePswText.text =@"";
        self.phonePswText.text = @"同意提供手机查询授权。";
    }
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
}

-(void)NewAddVipAction
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView]];
    
    // Modify the parameters
    
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"是", @"否", nil]];
    
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

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    [self NewAddVipAction];
//    return YES;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    // 定义唯一标识
    // 通过indexPath创建cell实例 每一个cell都是单独的
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    if (tableView.tag == 1001) {
        UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        redLabel.font = [UIFont systemFontOfSize:13];
        redLabel.backgroundColor = [UIColor lightGrayColor];
        redLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:redLabel];
        if (indexPath.row ==0) {
            redLabel.text = @"有";
        }else
            redLabel.text = @"无";
    }else if (tableView.tag == 1002) {
        
        UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        redLabel.font = [UIFont systemFontOfSize:13];
        redLabel.backgroundColor = [UIColor lightGrayColor];
        redLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:redLabel];
        if (indexPath.row ==0) {
            redLabel.text = @"租赁合同";
        }else
            redLabel.text = @"房产证明";
    }else
    {

            if (indexPath.row==0) {
                UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 10, 30)];
                redLabel.text = @"*";
                redLabel.textColor = [UIColor redColor];
                redLabel.font = [UIFont systemFontOfSize:13];
                
                [cell addSubview:redLabel];
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, 50, 30)];
                nameLabel.text = @"身份证";
                nameLabel.font = [UIFont systemFontOfSize:13];
                
                [cell addSubview:nameLabel];
                
                UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(70,10,0.3, 60)];
                lines.backgroundColor = [UIColor grayColor];
                lines.alpha = 0.3;
                [cell addSubview:lines];
                float offset=(SCREENWIDTH-75-10-210)/2;
                UIImageView *photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(75, 5, 70, 70)];
                photoImgView.tag = 10001;
                if (self.imageView==nil) {
                    photoImgView.image = [UIImage imageNamed:@"点击-01"];
                }else
                    photoImgView.image =self.imageView.image;
                self.imageView = photoImgView;
                
                photoImgView.userInteractionEnabled = YES;
                
                
                [cell addSubview:photoImgView];
                UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
                [photoImgView addGestureRecognizer:portraitTap];
                //反面
                UIImageView *photoImgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(75+70+offset, 5, 70, 70)];
                if (self.imageView1==nil) {
                    photoImgView2.image = [UIImage imageNamed:@"点击-02"];
                }else
                    photoImgView2.image =self.imageView1.image;
//                photoImgView2.image = [UIImage imageNamed:@"点击-02"];
                self.imageView1 = photoImgView2;
                photoImgView2.userInteractionEnabled = YES;
                photoImgView2.tag = 10002;
                UITapGestureRecognizer *portraitTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fditPortrait)];
                [photoImgView2 addGestureRecognizer:portraitTap2];
                
                
                [cell addSubview:photoImgView2];
                UIImageView *photoImgView3 = [[UIImageView alloc]initWithFrame:CGRectMake(75+70*2+offset*2, 5, 70, 70)];
                if (self.imageView11==nil) {
                    photoImgView3.image = [UIImage imageNamed:@"点击-03"];
                }else
                    photoImgView3.image =self.imageView11.image;
//                photoImgView3.image = [UIImage imageNamed:@"点击-03"];
                self.imageView11 = photoImgView3;
                photoImgView3.userInteractionEnabled = YES;
                photoImgView3.tag = 10002;
                UITapGestureRecognizer *portraitTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sditPortrait)];
                [photoImgView3 addGestureRecognizer:portraitTap3];
                
                
                [cell addSubview:photoImgView3];

            }else if (indexPath.row==1) {
                UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 10, 40)];
                redLabel.text = @"*";
                redLabel.textColor = [UIColor redColor];
                redLabel.font = [UIFont systemFontOfSize:13];
                
                [cell addSubview:redLabel];
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 90, 40)];
                nameLabel.text = @"身份证:";
                nameLabel.font = [UIFont systemFontOfSize:13];
                
                [cell addSubview:nameLabel];
                UITextField *phoneText = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, SCREENWIDTH-120, 40)];
                //Eric
                if ([self.idenCardText.text isEqualToString:@""]) {
                    phoneText.text=@"";
                }else
                    phoneText.text=self.idenCardText.text;
                [phoneText setInputAccessoryView:topView];
                phoneText.keyboardType = UIKeyboardTypeASCIICapable;
                self.idenCardText = phoneText;
                phoneText.delegate =self;
                phoneText.placeholder = @"请输入您的18位身份证号";
                phoneText.font = [UIFont systemFontOfSize:13];
                phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:phoneText];
                
            }else if (indexPath.row==2) {
                UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 10, 40)];
                redLabel.text = @"*";
                redLabel.textColor = [UIColor redColor];
                redLabel.font = [UIFont systemFontOfSize:13];
                
                [cell addSubview:redLabel];
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 90, 40)];
                nameLabel.text = @"姓名:";
                nameLabel.font = [UIFont systemFontOfSize:13];
                
                [cell addSubview:nameLabel];
                UITextField *phoneText = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, SCREENWIDTH-120, 40)];
                if ([self.realNameText.text isEqualToString:@""]) {
                    phoneText.text=@"";
                }else
                    phoneText.text=self.realNameText.text;
                [phoneText setInputAccessoryView:topView];
                self.realNameText = phoneText;
                phoneText.delegate =self;
                phoneText.placeholder = @"请输入您的真实姓名";
                phoneText.font = [UIFont systemFontOfSize:13];
                phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:phoneText];
                
            }else if (indexPath.row==3) {
                UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 10, 40)];
                redLabel.text = @"*";
                redLabel.textColor = [UIColor redColor];
                redLabel.font = [UIFont systemFontOfSize:13];
                
                [cell addSubview:redLabel];
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 90, 40)];
                nameLabel.text = @"开户行";
                nameLabel.font = [UIFont systemFontOfSize:13];
                
                [cell addSubview:nameLabel];
                UITextField *phoneText = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, SCREENWIDTH-120, 40)];
                if ([self.openBankText.text isEqualToString:@""]) {
                    phoneText.text=@"";
                }else
                    phoneText.text=self.openBankText.text;
                [phoneText setInputAccessoryView:topView];
                self.openBankText = phoneText;
                
                phoneText.placeholder = @"请输入建设银行开户行";
                phoneText.font = [UIFont systemFontOfSize:13];
                
                [cell addSubview:phoneText];
                
            }
            else if (indexPath.row==4) {
                UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 10, 40)];
                redLabel.text = @"*";
                redLabel.textColor = [UIColor redColor];
                redLabel.font = [UIFont systemFontOfSize:13];
                
                [cell addSubview:redLabel];
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 90, 40)];
                nameLabel.text = @"银行账户";
                nameLabel.font = [UIFont systemFontOfSize:13];
                
                [cell addSubview:nameLabel];
                UITextField *phoneText = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, SCREENWIDTH-120, 40)];
                if ([self.bankText.text isEqualToString:@""]) {
                    phoneText.text=@"";
                }else
                    phoneText.text=self.bankText.text;
                [phoneText setInputAccessoryView:topView];
                phoneText.keyboardType = UIKeyboardTypeNumberPad;
                phoneText.delegate =self;
                self.bankText = phoneText;
                phoneText.placeholder = @"请输入您的银行账户";
                phoneText.font = [UIFont systemFontOfSize:13];
                phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:phoneText];
                
            }else if (indexPath.row==5) {
                UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 10, 40)];
                redLabel.text = @"*";
                redLabel.textColor = [UIColor redColor];
                redLabel.font = [UIFont systemFontOfSize:13];
                
                [cell addSubview:redLabel];
                
                UILabel *personLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 90, 40)];
                personLabel.text = @"手机查询授权";
                personLabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:personLabel];
                UITextField *proText = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, SCREENWIDTH-120, 40)];
                if ([self.phonePswText.text isEqualToString:@""]) {
                    proText.text=@"";
                }else
                    proText.text=self.phonePswText.text;
                proText.delegate =self;
                [proText setInputAccessoryView:topView];
                self.phonePswText = proText;
                proText.keyboardType = UIKeyboardTypeNumberPad;
                proText.font = [UIFont systemFontOfSize:13];
                proText.placeholder = @"";
                proText.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:proText];
                
            }else if (indexPath.row==6)
            {
                UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 10, 40)];
                redLabel.text = @"*";
                redLabel.textColor = [UIColor redColor];
                redLabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:redLabel];
                //营业执照
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 40)];
                nameLabel.text = @"营业执照";
                nameLabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:nameLabel];
                UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 30, 30)];
                self.licenceLabel = placeLabel;
                NSLog(@"%@",placeLabel.text);
                //self.placeLabel=placeLabel;
                placeLabel.layer.borderWidth = 0.3;
                placeLabel.textAlignment = NSTextAlignmentCenter;
                placeLabel.text = self.licenceString;
                NSLog(@"%@",placeLabel.text);
                placeLabel.font = [UIFont systemFontOfSize:10];
                [cell addSubview:placeLabel];
                //箭头
                UIButton *choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                choiceBtn.backgroundColor = [UIColor grayColor];
                choiceBtn.frame = CGRectMake(120, 10, 30, 30);
                //    choseBtn.backgroundColor = [UIColor redColor];
                [choiceBtn setImage:[UIImage imageNamed:@"arraw_right"] forState:UIControlStateNormal];
                [choiceBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateSelected];
                [choiceBtn addTarget:self action:@selector(choiceLicenceAction) forControlEvents:UIControlEventTouchUpInside];
                //    self.boyBtn = boyBtn;
                [cell addSubview:choiceBtn];
                //线
                UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2,10,0.3, 60)];
                lines.backgroundColor = [UIColor grayColor];
                lines.alpha = 0.3;
                [cell addSubview:lines];
                //上传照片(营业执照)
                UILabel *photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+10, 25, 60, 30)];
                photoLabel.text = @"上传照片";
                photoLabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:photoLabel];
                UIImageView *photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-90, 5, 70, 70)];
                if (self.imageView2==nil) {
                    photoImgView.image = [UIImage imageNamed:@"点击-04"];
                }else
                    photoImgView.image =self.imageView2.image;
//                photoImgView.image = [UIImage imageNamed:@"点击-04"];
                photoImgView.tag = 10003;
                self.imageView2 = photoImgView;
                
                photoImgView.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fditPortrait3)];
                [photoImgView addGestureRecognizer:portraitTap];
                [cell addSubview:photoImgView];
            }
            else if(indexPath.row==7)
            {
                //附加情况说明
                UITextField *otherText = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH, 40)];
                if ([self.otherText.text isEqualToString:@""]) {
                    otherText.text=@"";
                }else
                    otherText.text=self.otherText.text;
                self.otherText = otherText;;
                [otherText setInputAccessoryView:topView];
                otherText.delegate =self;
                //otherText.secureTextEntry = YES;
                otherText.font = [UIFont systemFontOfSize:13];
                otherText.placeholder = @"附加情况说明";
                otherText.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:otherText];
                
            }
            else if (indexPath.row==8)
            {
                static NSString *cellIndentifier = @"cellIndentifier";
                // 定义唯一标识
                // 通过indexPath创建cell实例 每一个cell都是单独的
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
                }
                cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 10, 40)];
                redLabel.text = @"*";
                redLabel.textColor = [UIColor redColor];
                redLabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:redLabel];
                UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 60, 30)];
                self.propertyLabel = placeLabel;
                placeLabel.text = @"";
                //self.placeLabel=placeLabel;
                NSLog(@"pppppppp%@",placeLabel.text);
                placeLabel.layer.borderWidth = 0.3;
                placeLabel.textAlignment = NSTextAlignmentCenter;
                placeLabel.text = self.propertyString;
                NSLog(@"pppppppp%@",placeLabel.text);
                placeLabel.font = [UIFont systemFontOfSize:10];
                [cell addSubview:placeLabel];
                //箭头
                UIButton *choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                choiceBtn.backgroundColor = [UIColor grayColor];
                choiceBtn.frame = CGRectMake(80, 10, 30, 30);
                //    choseBtn.backgroundColor = [UIColor redColor];
                [choiceBtn setImage:[UIImage imageNamed:@"arraw_right"] forState:UIControlStateNormal];
                [choiceBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateSelected];
                [choiceBtn addTarget:self action:@selector(choicePropertyAction) forControlEvents:UIControlEventTouchUpInside];
                //    self.boyBtn = boyBtn;
                [cell addSubview:choiceBtn];
                //线
                UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2,10,0.3, 60)];
                lines.backgroundColor = [UIColor grayColor];
                lines.alpha = 0.3;
                [cell addSubview:lines];
                //上传照片(营业执照)
                UILabel *photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+10, 25, 60, 30)];
                photoLabel.text = @"上传照片";
                photoLabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:photoLabel];
                UIImageView *photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-90, 5, 70, 70)];
                if (self.imageView3==nil) {
                    photoImgView.image = [UIImage imageNamed:@"点击-04"];
                }else
                    photoImgView.image =self.imageView3.image;
                photoImgView.tag = 10004;
                self.imageView3 = photoImgView;
                
                photoImgView.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fditPortrait4)];
                [photoImgView addGestureRecognizer:portraitTap];
                [cell addSubview:photoImgView];
                return cell;
            }
            else if (indexPath.row==9)
            {
                UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 10, 40)];
                redLabel.text = @"*";
                redLabel.textColor = [UIColor redColor];
                redLabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:redLabel];
                UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 60, 40)];
                //self.propertyLabel = placeLabel;
                placeLabel.font = [UIFont systemFontOfSize:13];
                placeLabel.text = @"法人照片";
                [cell addSubview:placeLabel];
                //线
                UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2,10,0.3, 60)];
                lines.backgroundColor = [UIColor grayColor];
                lines.alpha = 0.3;
                [cell addSubview:lines];
                //上传照片(营业执照)
                UILabel *photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+10, 25, 60, 30)];
                photoLabel.text = @"上传照片";
                photoLabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:photoLabel];
                UIImageView *photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-90, 5, 70, 70)];
                if (self.imageView4==nil) {
                    photoImgView.image = [UIImage imageNamed:@"点击-04"];
                }else
                    photoImgView.image =self.imageView4.image;
                photoImgView.tag = 10005;
                self.imageView4 = photoImgView;
                
                photoImgView.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fditPortrait5)];
                [photoImgView addGestureRecognizer:portraitTap];
                [cell addSubview:photoImgView];
            }else if (indexPath.row==10)
            {
                UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 10, 40)];
                redLabel.text = @"*";
                redLabel.textColor = [UIColor redColor];
                redLabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:redLabel];
                UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 80, 40)];
                //self.propertyLabel = placeLabel;
                placeLabel.font = [UIFont systemFontOfSize:13];
                placeLabel.text = @"经营场地图片";
                [cell addSubview:placeLabel];
                //线
                UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2,10,0.3, 60)];
                lines.backgroundColor = [UIColor grayColor];
                lines.alpha = 0.3;
                [cell addSubview:lines];
                //上传照片(营业执照)
                UILabel *photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+10, 25, 60, 30)];
                photoLabel.text = @"上传照片";
                photoLabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:photoLabel];
                UIImageView *photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-90, 5, 70, 70)];
                if (self.imageView5==nil) {
                    photoImgView.image = [UIImage imageNamed:@"点击-04"];
                }else
                    photoImgView.image =self.imageView5.image;
                photoImgView.tag = 10006;
                self.imageView5 = photoImgView;
                
                photoImgView.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fditPortrait6)];
                [photoImgView addGestureRecognizer:portraitTap];
                [cell addSubview:photoImgView];
            }else if (indexPath.row==11)
            {
                UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 10, 40)];
                redLabel.text = @"*";
                redLabel.textColor = [UIColor redColor];
                redLabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:redLabel];
                UILabel *woterLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 80, 40)];
                //self.propertyLabel = placeLabel;
                woterLabel.font = [UIFont systemFontOfSize:13];
                woterLabel.text = @"营业地水电票";
                [cell addSubview:woterLabel];
                //线
                UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2,10,0.3, 60)];
                lines.backgroundColor = [UIColor grayColor];
                lines.alpha = 0.3;
                [cell addSubview:lines];
                //上传照片
                UILabel *photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+10, 25, 60, 30)];
                photoLabel.text = @"上传照片";
                photoLabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:photoLabel];
                UIImageView *photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-90, 5, 70, 70)];
                if (self.imageView6==nil) {
                    photoImgView.image = [UIImage imageNamed:@"点击-04"];
                }else
                    photoImgView.image =self.imageView6.image;
                photoImgView.tag = 10006;
                self.imageView6 = photoImgView;
                
                photoImgView.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fditPortrait7)];
                [photoImgView addGestureRecognizer:portraitTap];
                [cell addSubview:photoImgView];
            }
            else if (indexPath.row == 12)
            {
                UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 10, 40)];
                redLabel.text = @"*";
                redLabel.textColor = [UIColor redColor];
                redLabel.font = [UIFont systemFontOfSize:13];
                
                [cell addSubview:redLabel];
                
                UILabel *personLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 40)];
                personLabel.text = @"紧急联系人(亲属)";
                personLabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:personLabel];
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 0, 40, 40)];
                nameLabel.text = @"姓名:";
                nameLabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:nameLabel];
                UITextField *nameText1 = [[UITextField alloc]initWithFrame:CGRectMake(170, 0, SCREENWIDTH-200, 40)];
                if ([self.nameText.text isEqualToString:@""]) {
                    nameText1.text=@"";
                }else
                    nameText1.text=self.nameText.text;
                self.nameText = nameText1;;
                //Eric
                [nameText1 setInputAccessoryView:topView];
                nameText1.delegate =self;
                //nameText1.secureTextEntry = YES;
                nameText1.font = [UIFont systemFontOfSize:13];
                nameText1.placeholder = @"姓名1";
                nameText1.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:nameText1];
                
                
            }else if (indexPath.row == 13)
            {
                UILabel *nameLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(130, 0, 40, 40)];
                nameLabel2.text = @"手机:";
                nameLabel2.font = [UIFont systemFontOfSize:13];
                [cell addSubview:nameLabel2];
                UITextField *phoneText1 = [[UITextField alloc]initWithFrame:CGRectMake(170, 0, SCREENWIDTH-200, 40)];
                if ([self.phoneText.text isEqualToString:@""]) {
                    phoneText1.text=@"";
                }else
                    phoneText1.text=self.phoneText.text;
                phoneText1.keyboardType = UIKeyboardTypeNumberPad;
                //Eric
                [phoneText1 setInputAccessoryView:topView];
                self.phoneText = phoneText1;;
                phoneText1.delegate =self;
                //phoneText1.secureTextEntry = YES;
                phoneText1.font = [UIFont systemFontOfSize:13];
                phoneText1.placeholder = @"手机1";
                phoneText1.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:phoneText1];
            }else if (indexPath.row == 14)
            {
                UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 10, 40)];
                redLabel.text = @"*";
                redLabel.textColor = [UIColor redColor];
                redLabel.font = [UIFont systemFontOfSize:13];
                
                [cell addSubview:redLabel];
                
                UILabel *personLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 40)];
                personLabel.text = @"紧急联系人(同事)";
                personLabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:personLabel];
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 0, 40, 40)];
                nameLabel.text = @"姓名:";
                nameLabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:nameLabel];
                UITextField *nameText1 = [[UITextField alloc]initWithFrame:CGRectMake(170, 0, SCREENWIDTH-200, 40)];
                if ([self.nameText1.text isEqualToString:@""]) {
                    nameText1.text=@"";
                }else
                    nameText1.text=self.nameText1.text;
                //Eric
                [nameText1 setInputAccessoryView:topView];
                self.nameText1 = nameText1;;
                nameText1.delegate =self;
                //nameText1.secureTextEntry = YES;
                nameText1.font = [UIFont systemFontOfSize:13];
                nameText1.placeholder = @"姓名2";
                nameText1.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:nameText1];
                
                
            }
            else if (indexPath.row == 15)
            {
                UILabel *nameLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(130, 0, 40, 40)];
                nameLabel2.text = @"手机:";
                nameLabel2.font = [UIFont systemFontOfSize:13];
                [cell addSubview:nameLabel2];
                UITextField *phoneText2 = [[UITextField alloc]initWithFrame:CGRectMake(170, 0, SCREENWIDTH-200, 40)];
                if ([self.phoneText1.text isEqualToString:@""]) {
                    phoneText2.text=@"";
                }else
                    phoneText2.text=self.phoneText1.text;
                phoneText2.keyboardType = UIKeyboardTypeNumberPad;
                self.phoneText1 = phoneText2;;
                //Eric
                [phoneText2 setInputAccessoryView:topView];
                phoneText2.delegate =self;
                //phoneText2.secureTextEntry = YES;
                phoneText2.font = [UIFont systemFontOfSize:13];
                phoneText2.placeholder = @"手机2";
                phoneText2.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:phoneText2];
            }
            else if (indexPath.row == 16)
            {
                UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 10, 40)];
                redLabel.text = @"*";
                redLabel.textColor = [UIColor redColor];
                redLabel.font = [UIFont systemFontOfSize:13];
                
                [cell addSubview:redLabel];
                
                UILabel *personLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 40)];
                personLabel.text = @"紧急联系人(朋友)";
                personLabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:personLabel];
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 0, 40, 40)];
                nameLabel.text = @"姓名:";
                nameLabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:nameLabel];
                UITextField *nameText2 = [[UITextField alloc]initWithFrame:CGRectMake(170, 0, SCREENWIDTH-200, 40)];
                if ([self.nameText2.text isEqualToString:@""]) {
                    nameText2.text=@"";
                }else
                    nameText2.text=self.nameText2.text;
                self.nameText2 = nameText2;
                //Eric
                [nameText2 setInputAccessoryView:topView];
                nameText2.delegate =self;
                //nameText1.secureTextEntry = YES;
                nameText2.font = [UIFont systemFontOfSize:13];
                nameText2.placeholder = @"姓名3";
                nameText2.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:nameText2];

                
                
            }
            else if (indexPath.row == 17)
            {
                UILabel *nameLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(130, 0, 40, 40)];
                nameLabel2.text = @"手机:";
                nameLabel2.font = [UIFont systemFontOfSize:13];
                [cell addSubview:nameLabel2];
                UITextField *phoneText2 = [[UITextField alloc]initWithFrame:CGRectMake(170, 0, SCREENWIDTH-200, 40)];
                if ([self.phoneText2.text isEqualToString:@""]) {
                    phoneText2.text=@"";
                }else
                    phoneText2.text=self.phoneText2.text;
                phoneText2.keyboardType = UIKeyboardTypeNumberPad;
                self.phoneText2 = phoneText2;;
                //Eric
                [phoneText2 setInputAccessoryView:topView];
                phoneText2.delegate =self;
                //phoneText2.secureTextEntry = YES;
                phoneText2.font = [UIFont systemFontOfSize:13];
                phoneText2.placeholder = @"手机3";
                phoneText2.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:phoneText2];
            }

            else if (indexPath.row == 18)
            {
                UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                registBtn.backgroundColor = [UIColor grayColor];
                registBtn.frame = CGRectMake(30, 10, SCREENWIDTH-60, 40);
                //    choseBtn.backgroundColor = [UIColor redColor];
                registBtn.layer.masksToBounds = 7;
                registBtn.backgroundColor = [UIColor orangeColor];
                [registBtn setTitle:@"立即注册" forState:UIControlStateNormal];
                self.registBtn = registBtn;
                [registBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
                //    self.boyBtn = boyBtn;
                [cell addSubview:registBtn];
                UIButton *ChoseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                ChoseBtn.frame = CGRectMake(30, registBtn.bottom+15, 15, 15);
                ChoseBtn.selected=NO;
                [ChoseBtn setImage:[UIImage imageNamed:@"xuan"] forState:UIControlStateNormal];
                [ChoseBtn setImage:[UIImage imageNamed:@"xuan1"] forState:UIControlStateSelected];
                [ChoseBtn addTarget:self action:@selector(ChoseAction:) forControlEvents:UIControlEventTouchUpInside];
                
                //    ChoseBtn.backgroundColor = [UIColor redColor];
                [cell addSubview:ChoseBtn];
                
                UILabel *agreeLabe = [[UILabel alloc]initWithFrame:CGRectMake(ChoseBtn.right+1, registBtn.bottom+15, 120, 15)];
                //    agreeLabe.backgroundColor  = [UIColor redColor];
                agreeLabe.text = @"我已阅读并同意商消乐";
                agreeLabe.textColor = [UIColor grayColor];
                agreeLabe.font = [UIFont systemFontOfSize:11];
                [cell addSubview:agreeLabe];
                UIButton *xieyiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                xieyiBtn.frame = CGRectMake(agreeLabe.right, registBtn.bottom+15, 100, 15);
                [xieyiBtn setTitle:@"《商户使用协议》" forState:UIControlStateNormal];
                [xieyiBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [xieyiBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                xieyiBtn.titleLabel.font = [UIFont systemFontOfSize:11];
                [xieyiBtn addTarget:self action:@selector(lookXieYiView) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:xieyiBtn];
                
            }
            UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(0,0.3,SCREENWIDTH, 1)];
            lines.backgroundColor = [UIColor grayColor];
            lines.alpha = 0.3;
            [cell addSubview:lines];
            
            
        
//        }
    }
    
    return cell;
}

-(void)lookXieYiView
{
    ShopProtocolViewController *shopProtocolView = [[ShopProtocolViewController alloc]init];
    [self presentViewController:shopProtocolView animated:YES completion:nil];
}
-(void)ChoseAction:(UIButton *)btn
{
    btn.selected =! btn.selected;
    NSLog(@"勾选");
    if (btn.selected == YES) {
        self.registBtn.enabled = YES;
    }else if(btn.selected == NO)
    {
        self.registBtn.enabled = NO;
    }
    
}
//手持
-(void)sditPortrait
{
    [self dismissKeyBoard];
    UIActionSheet *sheet;
    self.indexTag=11;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];

}
-(void)fditPortrait//身份证反面照片
{
    [self dismissKeyBoard];
    UIActionSheet *sheet;
    self.indexTag=2;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}

-(void)fditPortrait3//营业执照
{
    [self dismissKeyBoard];
    UIActionSheet *sheet;
    self.indexTag=3;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}

-(void)fditPortrait4//租赁合同  /房产证明
{
    [self dismissKeyBoard];
    UIActionSheet *sheet;
    self.indexTag=4;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}
-(void)fditPortrait5//法人照片
{
    [self dismissKeyBoard];
    UIActionSheet *sheet;
    self.indexTag=5;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}
-(void)fditPortrait6//经营场地图片
{
    [self dismissKeyBoard];
    UIActionSheet *sheet;
    self.indexTag=6;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}
-(void)fditPortrait7//人行征信证明
{
    [self dismissKeyBoard];
    UIActionSheet *sheet;
    self.indexTag=7;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}


-(void)editPortrait
{
    [self dismissKeyBoard];
    UIActionSheet *sheet;

        self.indexTag=1;

    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        
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
    NSString *url =[[NSString alloc]initWithFormat:@"http://%@/VipCard/upload.php",SOCKETHOST ];
    //ASIFormDataRequest请求是post请求，可以查看其源码
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    //request.tag = 20;
    request.delegate = self;
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *name = [[NSString alloc]initWithFormat:@"%@",self.nibNameString];
    [request addPostValue:name forKey:@"name"];//商家用户名.png
    _isFullScreen = NO;
    if (_indexTag==1) {
        [self.imageView setImage:savedImage];
        [request addPostValue:@"id_front" forKey:@"type"];
        [request addFile:fullPath forKey:@"file1"];//如果有路径，上传文件
        //[request setData:data  withFileName:photoName andContentType:@"image/png" forKey:@"file1"];
        //               数据                文件名,随便起                 文件类型            设置key
        
        [request startAsynchronous];

    }else if(_indexTag==2)
    {
        [self.imageView1 setImage:savedImage];
        [request addPostValue:@"id_back" forKey:@"type"];
        [request addFile:fullPath forKey:@"file1"];//如果有路径，上传文件
        //[request setData:data  withFileName:photoName andContentType:@"image/png" forKey:@"file1"];
        //               数据                文件名,随便起                 文件类型            设置key
        
        [request startAsynchronous];

    }else if(_indexTag==11)
    {
        [self.imageView11 setImage:savedImage];
        [request addPostValue:@"id_hand" forKey:@"type"];
        [request addFile:fullPath forKey:@"file1"];//如果有路径，上传文件
        //[request setData:data  withFileName:photoName andContentType:@"image/png" forKey:@"file1"];
        //               数据                文件名,随便起                 文件类型            设置key
        
        [request startAsynchronous];
        
    }else if(_indexTag==3)
    {
        [self.imageView2 setImage:savedImage];//营业执照
        [request addPostValue:@"license" forKey:@"type"];
        [request addFile:fullPath forKey:@"file1"];//如果有路径，上传文件
        //[request setData:data  withFileName:photoName andContentType:@"image/png" forKey:@"file1"];
        //               数据                文件名,随便起                 文件类型            设置key
        
        [request startAsynchronous];

    }else if(_indexTag==4)
    {
        [self.imageView3 setImage:savedImage];
        if ([self.propertyString isEqualToString: @"租赁合同"]) {
            [request addPostValue:@"tenancy" forKey:@"type"];
        }else
            [request addPostValue:@"house" forKey:@"type"];
        [request addFile:fullPath forKey:@"file1"];//如果有路径，上传文件
        //[request setData:data  withFileName:photoName andContentType:@"image/png" forKey:@"file1"];
        //               数据                文件名,随便起                 文件类型            设置key
        
        [request startAsynchronous];

    }else if(_indexTag==5)
    {
        [self.imageView4 setImage:savedImage];//法人
        [request addPostValue:@"lp" forKey:@"type"];
        [request addFile:fullPath forKey:@"file1"];//如果有路径，上传文件
        //[request setData:data  withFileName:photoName andContentType:@"image/png" forKey:@"file1"];
        //               数据                文件名,随便起                 文件类型            设置key
        
        [request startAsynchronous];

    }else if(_indexTag==6)
    {
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [appdelegate.locService startUserLocationService];
        [self.imageView5 setImage:savedImage];
        [request addPostValue:@"add" forKey:@"type"];
        [request addFile:fullPath forKey:@"file1"];//如果有路径，上传文件
        //self.addressPhoto = fullPath;
        [request startAsynchronous];
    }else if(_indexTag==7)
    {
        [self.imageView6 setImage:savedImage];//wep营业地水电票
        [request addPostValue:@"wep" forKey:@"type"];//referrer推荐人
        [request addFile:fullPath forKey:@"file1"];//如果有路径，上传文件
        //[request setData:data  withFileName:photoName andContentType:@"image/png" forKey:@"file1"];
        //               数据                文件名,随便起                 文件类型            设置key
        
        [request startAsynchronous];

    }
//    [self.imageView setImage:savedImage];
//    [self.imageView1 setImage:savedImage];
//    self.imageView.tag = 100;
    //[self.infoTableView reloadData];
   
    
    //    [request setPostValue:@"" forKey:@"m_auth"];
    
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"图片太大,上传失败", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:4.f];
    NSLog(@"请求失败");
}

- (void)requestFinished:(ASIHTTPRequest *)request {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    
        NSLog(@"%@", dic);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;

        hud.label.text = NSLocalizedString(@"图片上传成功", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:4.f];
    if (self.indexTag==1)
    {
        self.ifImageView=YES;
    }else if (self.indexTag==2)
    {
        self.ifImageView1=YES;
    }else if (self.indexTag==11)
    {
        self.ifImageView11=YES;
    }else if (self.indexTag==3)
    {
        self.ifImageView2=YES;
    }else if (self.indexTag==4)
    {
        self.ifImageView3=YES;
    }else if (self.indexTag==5)
    {
        self.ifImageView4=YES;
    }else if (self.indexTag==6)
    {
        self.ifImageView5=YES;
    }else if (self.indexTag==7)
    {
        self.ifImageView6=YES;
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    _isFullScreen = !_isFullScreen;
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self.view];
    
    CGPoint imagePoint = self.imageView.frame.origin;
    //touchPoint.x ，touchPoint.y 就是触点的坐标
    
    // 触点在imageView内，点击imageView时 放大,再次点击时缩小
    if(imagePoint.x <= touchPoint.x && imagePoint.x +self.imageView.frame.size.width >=touchPoint.x && imagePoint.y <=  touchPoint.y && imagePoint.y+self.imageView.frame.size.height >= touchPoint.y)
    {
        // 设置图片放大动画
        [UIView beginAnimations:nil context:nil];
        // 动画时间
        [UIView setAnimationDuration:1];
        
        if (_isFullScreen) {
            // 放大尺寸
            
            self.imageView.frame = CGRectMake(0, 0, 320, 480);
        }
        else {
            // 缩小尺寸
            self.imageView.frame = CGRectMake(50, 65, 90, 115);
        }
        
        // commit动画
        [UIView commitAnimations];
        
    }
    
}

//有无营业执照
-(void)choiceLicenceAction
{
//    if (self.ifLicence == NO) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(160, 280+30, 60, 60) style:UITableViewStylePlain];
        self.licenceTableView = table;
        [table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        table.delegate = self;
        table.dataSource = self;
        self.ifLicence = YES;
        table.tag = 1001;
        [self.infoTableView addSubview:table];
//    }
    
    
}
-(void)choicePropertyAction
{
//    if (self.ifProperty == NO) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(20, 400+self.propertyLabel.bottom, 60, 60) style:UITableViewStylePlain];
        self.propertyTableView = table;
        [table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        table.delegate = self;
        table.dataSource = self;
        
        table.tag = 1002;
        [self.infoTableView addSubview:table];
        self.ifProperty=YES;
//    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag ==1002) {
        if (indexPath.row==0)
        {
            //self.propertyString = @"";
            self.propertyLabel.text = @"";
            self.propertyString = @"租赁合同";
        }else if (indexPath.row==1)
        {
            //self.propertyStringf = @"";
            self.propertyLabel.text = @"";
            self.propertyString = @"房产证明";
        }
        self.ifProperty = NO;
        [self.propertyTableView removeFromSuperview];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:8 inSection:0];
        [self.infoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if (tableView.tag ==1001) {
        if (indexPath.row==0)
        {
            self.licenceLabel.text = @"";
            self.licenceString = @"有";
        }else if (indexPath.row==1)
        {
            self.licenceLabel.text = @"";
            self.licenceString = @"无";
        }
        self.ifLicence = NO;
        [self.licenceTableView removeFromSuperview];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:6 inSection:0];
        [self.infoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}
-(void)registAction
{
//    //注册传参
//    地址:    http://192.168.0.117/VipCard/merchant_register.php
//    post参数:
//    ['phone'] ->['value']//电话
//    ['nickname'] ->['value']//昵称
//    ['store'] ->['value']//店铺
//    ['passwd'] ->['value']//密码
//    ['referer'] ->['value']//推荐人
//    ['address'] ->['value']//地址
//    ['id'] ->['value']//查询密码
//    ['account'] ->['value']//银行账户
//    ['frel_name'] ->['value']//联系人
//    ['frel_phone'] ->['value']
//    ['srel_name'] ->['value']
//    ['srel_phone'] ->['value']//
//    ['state'] ->['value']
//    ['image_url'] ->['value']//经营场地
//    ['trade']//行业
//    ['explain']//说明
//    ['house_contact']//
   
    if ([self.realNameText.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请输入真实姓名", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];

    }else if ([self.idenCardText.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请输入18位身份证号", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }else if ([self.bankText.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请输入银行账户", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }else if (![self.phonePswText.text isEqualToString:@"同意提供手机查询授权。"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"同意提供手机查询授权。", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }else if ([self.licenceLabel.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请选择有无营业执照", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }else if ([self.nameText.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请输入您的紧急联系人", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }else if ([self.nameText1.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请输入您的紧急联系人", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }else if ([self.nameText2.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请输入您的紧急联系人", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }else if ([self.phoneText.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请输入您的紧急联系电话", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }else if ([self.phoneText1.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请输入您的紧急联系电话", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }else if ([self.phoneText2.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请输入您的紧急联系电话", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }else
    {
        [self postSocketRegist];
    }
   }
-(void)postSocketRegist
{
    
    if (!self.imageView) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;

        hud.label.text = NSLocalizedString(@"身份证正面照片上传失败", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
    }else if (!self.imageView1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"身份证反面照片上传失败", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
    }else if (!self.imageView11) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"手持身份证上传失败", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
    }else if (!self.imageView2&&[self.licenceString isEqualToString:@"有"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"营业执照照片上传失败", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
    }else if (!self.imageView3) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"房产证明或租赁合同照片上传失败", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
    }else if (!self.imageView4) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"法人照片上传失败", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
    }else if (!self.imageView5) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"经营场地照片上传失败", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
    }else if (!self.imageView6) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"营业地水电票照片上传失败", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
    }else if (self.idenCardText.text.length!=18)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"身份证格式错误,请重新输入", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }
    else{
    NSString *url =[[NSString alloc]initWithFormat:@"http://%@/VipCard/merchant_register.php",SOCKETHOST ];
    //[[NSString alloc]initWithFormat:@"http://%@/VipCard/merchant_register.php",SOCKETHOST ];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneString forKey:@"phone"];
    [params setObject:self.pswString forKey:@"passwd"];
    [params setObject:self.nibNameString forKey:@"nickname"];
    [params setObject:self.shopNameString forKey:@"store"];
    [params setObject:self.personString forKey:@"referrer"];
    [params setObject:self.addressString forKey:@"address"];
    [params setObject:self.phonePswText.text forKey:@"psp"];
    [params setObject:self.bankText.text forKey:@"account"];
    [params setObject:self.nameText.text forKey:@"frel_name"];
    [params setObject:self.phoneText.text forKey:@"frel_phone"];
    [params setObject:self.nameText1.text forKey:@"srel_name"];
    [params setObject:self.phoneText1.text forKey:@"srel_phone"];
    [params setObject:self.tradeString forKey:@"trade"];
    [params setObject:self.otherText.text forKey:@"explain"];
    [params setObject:self.propertyString forKey:@"house_contact"];
    NSString *name = [[NSString alloc]initWithFormat:@"%@.png",self.nibNameString ];
    [params setObject:name forKey:@"image_url"];
    if ([self.licenceString isEqualToString:@"有" ]) {
        [params setObject:@"true" forKey:@"state"];
    }else{
        [params setObject:@"false" forKey:@"state"];
    }
    [params setObject:self.idenCardText.text forKey:@"id"];
    [params setObject:self.realNameText.text forKey:@"bname"];
    [params setObject:self.openBankText.text forKey:@"back"];
    [params setObject:self.nameText2.text forKey:@"trel_name"];
    [params setObject:self.phoneText2.text forKey:@"trel_phone"];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    float lat = appdelegate.userLocation.location.coordinate.latitude;
    NSString *latitude =[[NSString alloc]initWithFormat:@"%f",lat];
    [params setObject:latitude forKey:@"latitude"];
    float longti = appdelegate.userLocation.location.coordinate.longitude;
    NSString *longtitude =[[NSString alloc]initWithFormat:@"%f",longti];
    [params setObject:longtitude forKey:@"longtitude"];
    //userLocation.location.coordinate.latitude
    NSLog(@"%@",self.phoneString);
    NSLog(@"%@",self.pswString);
    NSLog(@"%@",self.nibNameString);
    NSLog(@"%@",self.shopNameString);
    NSLog(@"%@",self.personString);
    NSLog(@"%@",self.addressString);
    NSLog(@"%@",self.phonePswText.text);
    NSLog(@"%@",self.bankText.text);
    NSLog(@"%@",self.nameText.text);
    NSLog(@"%@",self.phoneText.text);
    NSLog(@"%@",self.nameText1.text);
    NSLog(@"%@",self.phoneText1.text);
    NSLog(@"%@",self.tradeString);
    NSLog(@"%@",self.otherText.text);
    NSLog(@"%@",self.propertyString);
    //NSLog(@"%@",name);
    NSLog(@"%@",self.phoneString);
    
//    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        NSArray *arr = [result copy];
        if ([[arr objectAtIndex:0] isEqualToString:@"1"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"信息提交成功,等待3-5个工作日", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            // Move to bottm center.
            //    hud.offset = CGPointMake(0.f, );
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:3.f];
        }else if ([[arr objectAtIndex:0] isEqualToString:@"1062"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"对不起,该手机号已注册或正在审核", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            // Move to bottm center.
            //    hud.offset = CGPointMake(0.f, );
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString([arr objectAtIndex:0], @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            // Move to bottm center.
            //    hud.offset = CGPointMake(0.f, );
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:3.f];
        }
      
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    }
}
#pragma mark -隐藏键盘
-(void)dismissKeyBoard
{
    [self.bankText resignFirstResponder];
    [self.openBankText resignFirstResponder];
    [self.phonePswText resignFirstResponder];
    [self.otherText resignFirstResponder];
    [self.idenCardText resignFirstResponder];
    [self.realNameText resignFirstResponder];
    [self.nameText resignFirstResponder];
    [self.phoneText resignFirstResponder];
    [self.nameText1 resignFirstResponder];
    [self.phoneText1 resignFirstResponder];
    [self.nameText2 resignFirstResponder];
    [self.phoneText2 resignFirstResponder];
    
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
