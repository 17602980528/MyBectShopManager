//
//  thirdlogVC.m
//  TianXinManor
//
//  Created by apple on 15/11/5.
//  Copyright (c) 2015年 Liuyang. All rights reserved.
//
#define UPSIZE 80
#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

#import "thirdlogVC.h"
#import "SuccessController.h"
#import "CustomIOSAlertView.h"

#import "XieYiViewController.h"

@interface thirdlogVC ()<UITextFieldDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CustomIOSAlertViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate>

@property(nonatomic,strong)UIButton *getCodeBtn;
@property(nonatomic,strong)NSArray *array_code;
@property (nonatomic,strong)UIView *demoView;
@property(nonatomic,strong)UILabel *cityLabel1;
@property (nonatomic,retain)UIToolbar *toolbarCancelDone;

@end

@implementation thirdlogVC
-(NSArray *)array_code{
    if (!_array_code) {
        _array_code = [[NSArray alloc]init];
    }
    return _array_code;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"登录设置";


    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 45, SCREENWIDTH, SCREENHEIGHT-45) ];
    _scrollView.bounces= YES;
    _scrollView.delegate = self;
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    _scrollView.backgroundColor = RGB(234, 234, 234);

    [self.view addSubview:_scrollView];

    [self initScrollViewData];
    sexDic = [[NSDictionary alloc]initWithObjects:@[@"0",@"1",@"2"] forKeys:@[@"不详",@"男",@"女"]];
    marDic = [[NSDictionary alloc]initWithObjects:@[@"0",@"1",@"2"] forKeys:@[@"保密",@"未婚",@"已婚"]];
    
    
    [self initTopView];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped)];
    [_scrollView addGestureRecognizer:singleTap];


}
-(void)fingerTapped{
    
    [self.view endEditing:YES];
    
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *VW = (UITextField*)view;
            [VW resignFirstResponder];
            
            if (VW ==_recommend_person) {
                [self resetScrollViewFrame];
            }
        }
    }
    
    
    

}

-(void)initTopView{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 45)];
    view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:view];
    for (int i =0; i <2; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame  = CGRectMake(i *SCREENWIDTH/2, 0, SCREENWIDTH/2, 44);
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitle:@"绑定已有账号" forState:UIControlStateNormal];
            [button setTitleColor:NavBackGroundColor forState:UIControlStateNormal];
            mybutton = button;
            button.tag = 2;

        }else{
            [button setTitle:@"注册新账号" forState:UIControlStateNormal];
            button.tag = 1;

        }
        [button addTarget:self action:@selector(sellectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }

    UIView*shuxian=[[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 0, 1, 45)];
    shuxian.backgroundColor=RGB(234, 234, 234);
    [view addSubview:shuxian];

    line=[[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREENWIDTH, 1)];
    line.backgroundColor=RGB(234, 234, 234);
    [view addSubview:line];

    [view bringSubviewToFront:shuxian];

}

-(void)lablepriceWithHight:(CGFloat)hh andText:(NSString*)text{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hh, SCREENWIDTH, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view];

//    UILabel*price_L=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH*0.4, 50)];
//    price_L.numberOfLines=1;
//    price_L.textAlignment=NSTextAlignmentCenter;
//    price_L.textColor=[UIColor darkGrayColor];
//    price_L.font=[UIFont systemFontOfSize:15];
//    price_L.text=text;
//    [view addSubview:price_L];
    UIView *line00 = [[UIView alloc]initWithFrame:CGRectMake(0, 49, SCREENWIDTH, 1)];
    line00.backgroundColor = RGB(234, 234, 234);
    [view addSubview:line00];

//    UIView*shuxian=[[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH*0.37, 5, 1, 40)];
//    shuxian.backgroundColor=RGB(234, 234, 234);
//    [view addSubview:shuxian];
    

}
-(void)initScrollViewData
{
    for (UIView *obj in _scrollView.subviews) {
        [obj removeFromSuperview];
    }

    if (mybutton.tag==1) {
        [self initRegView];
    }else{
        [self initbindingView];
    }
    
    
}
-(void)initbindingView{
    [self lablepriceWithHight:0 andText:@""];
    
    _phone_tf=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
    _phone_tf.placeholder=@"手机号";
    _phone_tf.keyboardType = UIKeyboardTypeNumberPad;
    [_phone_tf setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _phone_tf.delegate=self;
    _phone_tf.font=[UIFont systemFontOfSize:15];
    [_scrollView addSubview:_phone_tf];


    [self lablepriceWithHight:50 andText:@""];
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneBtn.frame = CGRectMake(SCREENWIDTH-100, 10, 100, 30);
    [phoneBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [phoneBtn setBackgroundColor:NavBackGroundColor];
    phoneBtn.layer.cornerRadius = 10;
    self.getCodeBtn = phoneBtn;
    [phoneBtn addTarget:self action:@selector(getProCode) forControlEvents:UIControlEventTouchUpInside];
    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_scrollView addSubview:phoneBtn];
    
    
    _phoneCode=[[UITextField alloc]initWithFrame:CGRectMake(10, 50, SCREENWIDTH-10, 50)];
    _phoneCode.placeholder=@"请输入您的验证码";
    [_phoneCode setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _phoneCode.delegate=self;
    _phoneCode.secureTextEntry=YES;
    _phoneCode.font=[UIFont systemFontOfSize:15];
    [_scrollView addSubview:_phoneCode];


    [self lablepriceWithHight:100 andText:@"密码"];
    _password_sure_tf=[[UITextField alloc]initWithFrame:CGRectMake(10, 100, SCREENWIDTH-20, 50)];
    _password_sure_tf.placeholder=@"密码";
    _password_sure_tf.secureTextEntry=YES;
    _password_sure_tf.delegate=self;
    [_password_sure_tf setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    [_password_sure_tf setFont:[UIFont systemFontOfSize:15]];
    [_scrollView addSubview:_password_sure_tf];



    UIView*view1=[[UIView alloc]initWithFrame:CGRectMake(0, 160, SCREENWIDTH, 320)];
    view1.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:view1];

    logInBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    logInBtn.frame=CGRectMake(SCREENWIDTH*0.05, 55, SCREENWIDTH*0.9, 40);
    [logInBtn setTitle:@"绑定账号" forState:UIControlStateNormal];
    [logInBtn setBackgroundColor:NavBackGroundColor];

    logInBtn.titleLabel.font=[UIFont boldSystemFontOfSize:17];
    [logInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logInBtn addTarget:self action:@selector(logBtnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    logInBtn.layer.cornerRadius=5;
    [view1 addSubview:logInBtn];


    UIView*hengxian=[[UIView alloc]initWithFrame:CGRectMake(0, 140, SCREENWIDTH, 1)];
    hengxian.backgroundColor=RGB(234, 234, 234);
    [view1 addSubview:hengxian];
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH, 480);


}
-(void)initRegView{
    [self lablepriceWithHight:0 andText:@""];
    _phone_tf=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-120, 50)];
    _phone_tf.placeholder=@"请输入您的手机号";
    _phone_tf.keyboardType = UIKeyboardTypeNumberPad;
    [_phone_tf setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _phone_tf.delegate=self;
    _phone_tf.font=[UIFont systemFontOfSize:15];
    [_scrollView addSubview:_phone_tf];

    [self lablepriceWithHight:50 andText:@""];
    
    
    _testBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _testBtn.frame=CGRectMake(_phone_tf.right+5, 10, SCREENWIDTH-_phone_tf.right-10,30);
    [_testBtn setTitle:@"获取验证码"forState:UIControlStateNormal];
    [_testBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_testBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _testBtn.layer.cornerRadius = 10;
    _testBtn.backgroundColor = NavBackGroundColor;
    _testBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [_testBtn addTarget:self action:@selector(getProCode) forControlEvents:UIControlEventTouchUpInside];

    [_scrollView addSubview:_testBtn];

    _phoneCode=[[UITextField alloc]initWithFrame:CGRectMake(10, _phone_tf.bottom, SCREENWIDTH-20, 50)];
    _phoneCode.placeholder=@"请输入验证码";
    _phoneCode.secureTextEntry=NO;
    _phoneCode.delegate=self;
    _phoneCode.keyboardType = UIKeyboardTypeNumberPad;

    [_phoneCode setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _phoneCode.font=[UIFont systemFontOfSize:15];
    [_scrollView addSubview:_phoneCode];


    [self lablepriceWithHight:100 andText:@""];
    _password_tf=[[UITextField alloc]initWithFrame:CGRectMake(10, _phoneCode.bottom, SCREENWIDTH-20, 50)];
    _password_tf.placeholder=@"请输入您的密码(6位以上字母数字组合)";
    [_password_tf setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _password_tf.delegate=self;
    _password_tf.secureTextEntry=YES;
    _password_tf.font=[UIFont systemFontOfSize:15];
    [_scrollView addSubview:_password_tf];


    [self lablepriceWithHight:150 andText:@""];
    _password_sure_tf=[[UITextField alloc]initWithFrame:CGRectMake(10, _password_tf.bottom, SCREENWIDTH-20, 50)];
    _password_sure_tf.placeholder=@"请重复密码";
    _password_sure_tf.secureTextEntry=YES;
    _password_sure_tf.delegate=self;
    [_password_sure_tf setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    [_password_sure_tf setFont:[UIFont systemFontOfSize:15]];
    [_scrollView addSubview:_password_sure_tf];



    [self lablepriceWithHight:200 andText:@""];

    _recommend_person = [[UITextField alloc]initWithFrame:CGRectMake(10, _password_sure_tf.bottom, SCREENWIDTH-20, 50)];
    _recommend_person.placeholder= @"请输入您推荐人手机号";
    _recommend_person.delegate=self;
    _recommend_person.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:_recommend_person];


//    [self lablepriceWithHight:220+50 andText:@"姓名"];
//    _realName = [[UITextField alloc]initWithFrame:CGRectMake(SCREENWIDTH*0.43, 220+50+20, SCREENWIDTH*0.57, 50)];
//    _realName.placeholder= @"请输入真实姓名";
//    _realName.delegate=self;
//    _realName.font = [UIFont systemFontOfSize:15];
//    [_scrollView addSubview:_realName];
//
//    [self lablepriceWithHight:220+50+20+50 andText:@"性别"];
//    UIImageView *Rimg1=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH*0.9, 16+220+50+20+50, 18, 18)];
//    Rimg1.image =[UIImage imageNamed:@"cp2"];
//    Rimg1.transform =CGAffineTransformMakeRotation(M_PI*3/2);
//    [_scrollView addSubview:Rimg1];
//    _sexlab = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH*0.43, 220+50+20+50, 50, 50)];
//    _sexlab.font = [UIFont systemFontOfSize:15];
//    _sexlab.textColor =[UIColor darkGrayColor];
//    _sexlab.text = @"不详";
//    [_scrollView addSubview:_sexlab];
//    UIButton *sexBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 340, SCREENWIDTH, 50)];
//    [sexBtn addTarget:self action:@selector(sexbtn) forControlEvents:UIControlEventTouchUpInside];
//    [_scrollView addSubview:sexBtn];
//
//
//    [self lablepriceWithHight:340+50 andText:@"婚姻状态"];
//    UIImageView *Rimg0=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH*0.9, 16+390, 18, 18)];
//    Rimg0.image =[UIImage imageNamed:@"cp2"];
//    Rimg0.transform =CGAffineTransformMakeRotation(M_PI*3/2);
//    [_scrollView addSubview:Rimg0];
//    _marrayStatu = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH*0.43, 390, 50, 50)];
//    _marrayStatu.textColor =[UIColor darkGrayColor];
//    _marrayStatu.text = @"保密";
//    _marrayStatu.font =[UIFont systemFontOfSize:15];
//    [_scrollView addSubview: _marrayStatu];
//
//    UIButton *marryBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 390, SCREENWIDTH, 50)];
//    [marryBtn addTarget:self action:@selector(marrybtn) forControlEvents:UIControlEventTouchUpInside];
//    [_scrollView addSubview:marryBtn];
//
//
//
//    [self lablepriceWithHight:440 andText:@"身份证号码"];
//    _identifierCode = [[UITextField alloc]initWithFrame:CGRectMake(SCREENWIDTH*0.43, 440, SCREENWIDTH*0.57, 50)];
//    _identifierCode.placeholder= @"请输入身份证号码";
//    _identifierCode.delegate=self;
//    _identifierCode.keyboardType= UIKeyboardTypeNumbersAndPunctuation;
//    _identifierCode.font = [UIFont systemFontOfSize:15];
//    [_scrollView addSubview:_identifierCode];


    UIView*view1=[[UIView alloc]initWithFrame:CGRectMake(0, 250+20, SCREENWIDTH, 320)];
    view1.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:view1];






    logInBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    logInBtn.frame=CGRectMake(SCREENWIDTH*0.05, 55, SCREENWIDTH*0.9, 40);
    [logInBtn setTitle:@"注册新账号" forState:UIControlStateNormal];
    //            _logInBtn.backgroundColor=[UIColor grayColor];
    [logInBtn setBackgroundColor:NavBackGroundColor];

    logInBtn.titleLabel.font=[UIFont boldSystemFontOfSize:17];
    [logInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logInBtn addTarget:self action:@selector(logBtnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    logInBtn.layer.cornerRadius=5;
    [view1 addSubview:logInBtn];


    UIView*hengxian=[[UIView alloc]initWithFrame:CGRectMake(0, 140, SCREENWIDTH, 1)];
    hengxian.backgroundColor=RGB(234, 234, 234);
    [view1 addSubview:hengxian];
    
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH, view1.bottom+100);


}


-(void)sellectBtn:(UIButton *)button{
    logInBtn.tag = button.tag;
    if (button.tag==2) {
        [logInBtn setTitle:@"绑定账号" forState:UIControlStateNormal];
//        [UIView animateWithDuration:0.1 animations:^{
//            line.frame =CGRectMake(0, 44, SCREENWIDTH/2, 2);
//        }];

    }else{
        [logInBtn setTitle:@"立即注册" forState:UIControlStateNormal];
//        [UIView animateWithDuration:0.1 animations:^{
//            line.frame =CGRectMake(SCREENWIDTH/2, 44, SCREENWIDTH/2, 2);
//        }];

    }


    if (mybutton!=button) {
        [button setTitleColor:NavBackGroundColor forState:UIControlStateNormal];
        [mybutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

        mybutton = button;
    }

    [self initScrollViewData];
}

//注册新用户
-(void)logBtnBtnClick:(UIButton*)button{
    
    [self fingerTapped];
  
   
   
    NSLog(@"---%@",_phone_tf.text);
    

    

    if (![ToolManager validateMobile:_phone_tf.text]) {
        
        
        [self tishi:@"手机格式不正确！"];

    }else{
        if (_phone_tf.text.length==0) {
            // ALERT(@"请输入邮箱")
            [self tishi:@"请输入手机号"];
           
        }else
        {
            if (_phoneCode.text.length==0 || _array_code[0] != _phoneCode.text ) {
 
                [self tishi:@"请输入验证码"];

            }else{
                if (_password_sure_tf.text.length == 0) {

                    
                    [self tishi:@"请输入密码"];

                }else{

                    if (mybutton.tag!=1) {

                        [self bindUserInfo];
                       
                    }else{


                        
                        if (![_password_tf.text isEqualToString:_password_sure_tf.text]) {
                            
                            [self tishi:@"密码不一致"];
                          
                            
                        }else{
                            if (_recommend_person.text.length ==0) {
                                [self tishi:@"推荐人不能为空!"];
                            }else{
                                

                                [self registNewUser];

                                
                            }
                            
                        }

                        
                    }
                                   }
                
            }
        }
        

    }

 }



-(void)sexbtn{
    UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"性别" otherButtonTitles:@"不详",@"男",@"女", nil];
    sheet.delegate =self;
    sheet.tag =1;
    [sheet showInView:self.view];


}
-(void)marrybtn{
    UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"婚姻状态" otherButtonTitles:@"保密",@"未婚",@"已婚", nil];
    sheet.delegate =self;
    sheet.tag =2;
    [sheet showInView:self.view];
    
}
-(void)faceclick{
    UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"从相册选取" otherButtonTitles:@"拍照", nil];
    sheet.delegate =self;
    sheet.tag =0;
    [sheet showInView:self.view];

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==0) {


        if (buttonIndex==0) {
            UIImagePickerController*pc=[[UIImagePickerController alloc]init];
            pc.delegate=self;
            pc.allowsEditing=YES;
            pc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:pc animated:YES completion:^{

            }];

        }
        if (buttonIndex==1) {
            UIImagePickerController*pc=[[UIImagePickerController alloc]init];
            pc.delegate=self;
            pc.allowsEditing=YES;
            pc.sourceType=UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pc animated:YES completion:^{

            }];

        }

    }else if (actionSheet.tag==1){

        if (buttonIndex==1) {
            _sexlab.text=@"不详";
        }
        if (buttonIndex==2) {
            _sexlab.text=@"男";
        }
        if (buttonIndex==3) {
            _sexlab.text=@"女";
        }

    }else{
        if (buttonIndex==1) {
            _marrayStatu.text =@"保密";
        }
        if (buttonIndex==2) {
            _marrayStatu.text =@"未婚";

        }
        if (buttonIndex==3) {
            _marrayStatu.text =@"已婚";
        }


    }

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{

        NSIndexPath*path=[NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell*cell=[_tableView cellForRowAtIndexPath:path];

        UIImageView*imagev=(UIImageView*)[cell.contentView viewWithTag:80];
        imagev.image=[info objectForKey:UIImagePickerControllerEditedImage];
        UIImage*image=[info objectForKey:UIImagePickerControllerEditedImage];
        NSData*data=UIImageJPEGRepresentation(image, 1.0);
        _imageDataStr=[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        _userFace.image=image;

        
    }];
    
}

-(void)getProCode{
    
    NSLog(@"----%@",_phone_tf.text);
    if (_phone_tf.text.length==11) {
        
        NSString *url  = @"http://101.201.100.191/cnconsum/App/Extra/VerifyCode/sendSignMsg";
        
        NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithObject:[NSString getSecretStringWithPhone:_phone_tf.text] forKey:@"base_str"];;
        [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            NSLog(@"-result---%@",result);
            if (result) {
                if ([result[@"state"] isEqualToString:@"access"]) {
                    [self TimeNumAction];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _array_code = result[@"sms_code"];
                    });
                }else if ([result[@"state"] isEqualToString:@"sign_check_fail"]){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验签失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }else if([result[@"state"] isEqualToString:@"time_out"]){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"时间超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }else if([result[@"state"] isEqualToString:@"num_invalidate"]){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号格式错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
            
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }];
        
    }else{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码格式有误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
    }
    
}

-(void)TimeNumAction
{
    if ([_phone_tf.text isEqual: @""])
    {
        //[self textExample];
        
    }else
    {
        //[self getProCode];
        __block int timeout = 59; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _lzdtimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_lzdtimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_lzdtimer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_lzdtimer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    self.getCodeBtn.userInteractionEnabled = YES;
                    [self.getCodeBtn setBackgroundColor:NavBackGroundColor];
                });
            }else{
                int seconds = timeout % 60 ;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //NSLog(@"____%@",strTime);
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                    self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [UIView commitAnimations];
                    self.getCodeBtn.userInteractionEnabled = NO;
                    [self.getCodeBtn setBackgroundColor:tableViewBackgroundColor];
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_lzdtimer);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_recommend_person) {
        [self resetScrollViewFrame];
      
    }

    
    [textField resignFirstResponder];
    return YES;
}

/**
 用户登录
 
 @param user     账户
 @param passWord 密码
 */
-(void)postRequestLogin:(NSString *)user andPassWord:(NSString*)passWord
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/login",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:user forKey:@"phone"];
    [params setObject:passWord forKey:@"passwd"];
    NSLog(@"postRequestLogin user = %@-%@",user,passWord);
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result  ==%@", result);
        
        NSArray *arr = result[@"info"];
        
        NSDictionary *user_dic = arr[0];
        
        if ([[result objectForKey:@"result_code"]  isEqualToString: @"login_access"]) {
            NSLog(@"成功");
            
            
            
            //登录环信
            
            [[EMClient sharedClient]loginWithUsername:user_dic[@"uuid"] password:@"000000" completion:^(NSString *aUsername, EMError *aError) {
                if (!aError) {
                    NSLog(@"登录成功");
                    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [self hideHud];
                        
                        [self saveInfo:user_dic[@"uuid"]];
                        [self landingSuc];
                        
                        

                            [[EMClient sharedClient].options setIsAutoLogin:NO];
                            
                        
                        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                        appdelegate.userInfoDic = [NSMutableDictionary dictionaryWithDictionary:user_dic];
                        appdelegate.IsLogin = YES;
                        
                        
                        
                    });
                    
                }else{
                    NSLog(@"登录失败==%@",aError.errorDescription);
                    [self hideHud];
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = NSLocalizedString(aError.errorDescription, @"HUD message title");
                    hud.label.font = [UIFont systemFontOfSize:13];
                    [hud hideAnimated:YES afterDelay:3.f];
                    
                    
                }
                
            }];
            
            
            
            
            
            
        }else if ([[result objectForKey:@"result_code"] isEqualToString:@"passwd_wrong"])
        {
            [self hideHud];
            
            [self tishi:@"用户名或密码错误"];
            
        }else if ([[result objectForKey:@"result_code"] isEqualToString:@"incomplete"]){
            [self hideHud];
            
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您已注册成功，是否完善信息？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            [alertView show];
            
            
        }else{
            [self hideHud];
            
            [self tishi:@"用户不存在"];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"%@", error);
    }];
    
}

//保存用户信息到本地
-(void)saveInfo:(NSString*)auserName{
    NSString *url = [NSString stringWithFormat:@"%@Extra/IM/get",BASEURL];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
    [paramer setObject:auserName forKey:@"account"];
    NSLog(@"-saveInfo--%@",paramer);
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSArray *arr = (NSArray *)result;
        if (arr.count!=0) {
            Person *p = [Person modalWith:arr[0][@"nickname"] imgStr:arr[0][@"headimage"]  idstring:arr[0][@"account"]];
            
            [Database savePerdon:p];
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==_recommend_person) {
        
        [UIView animateWithDuration:0.5 animations:^{
            _scrollView.frame = CGRectMake(0, 45- UPSIZE, SCREENWIDTH, SCREENHEIGHT-45);
            
        }];
        
        
        
        [self NewAddVipAction];
    }
    return YES;
}

-(void)NewAddVipAction
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    [alertView setContainerView:[self createDemoView]];
    
    
    alertView.parentView = self.view;
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"是", @"否", nil]];
    
    [alertView setDelegate:self];
    
    [alertView setUseMotionEffects:true];
    
    [alertView show];
}

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 150)];
    self.demoView = demoView;
    demoView.frame=CGRectMake(0, 0, 290, 50);
    UILabel *numlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, demoView.width, 50)];
    numlabel.textAlignment = NSTextAlignmentCenter;
    numlabel.text = @"您通过在线用户推荐,入驻平台?";
    numlabel.font = [UIFont systemFontOfSize:16];
    [demoView addSubview:numlabel];
    return demoView;
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    
    
    if (alertView.tag==0&&buttonIndex==1) {
        
        _recommend_person.text = @"无人推荐";
        [_recommend_person resignFirstResponder];
        [alertView close];
        
        [self resetScrollViewFrame];
        
        
    }
    else if (alertView.tag==0&&buttonIndex==0)
    {
        _recommend_person.text =@"";
        _recommend_person.placeholder = @"请输入您的推荐人手机号";
    }
    [alertView close];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self resetScrollViewFrame];

}


-(void)resetScrollViewFrame{
    //还原scrollview位置
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.frame = CGRectMake(0, 45, SCREENWIDTH, SCREENHEIGHT-45);
        
    }];
    

    
}
//登录成功提示
- (void)landingSuc
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"登录成功", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:2.f];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)tishi:(NSString*)ts{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = NSLocalizedString(ts, @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:1.f];
    
}


-(void)completeUserInfo{
    
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
        [self lablepriceWithHight:0 andText:@""];

    UIImageView *xingView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 8, 8)];
    xingView.image = [UIImage imageNamed:@"xing"];
    [_scrollView addSubview:xingView];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(xingView.right+5, 0, 40, 50)];
    nameLab.text = @"昵称";
    nameLab.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:nameLab];

    UIView *Fen1 = [[UIView alloc]initWithFrame:CGRectMake(nameLab.width, 15, 1, nameLab.height-30)];
    Fen1.backgroundColor = [UIColor grayColor];
    Fen1.alpha = 0.3;
    [nameLab addSubview:Fen1];
    
    _nickName=[[UITextField alloc]initWithFrame:CGRectMake(nameLab.right+10, 0, SCREENWIDTH-xingView.width-nameLab.width-35, 50)];
    _nickName.placeholder=@"请设置昵称(不能为纯数字和包含特殊字符)";
    _nickName.keyboardType = UIKeyboardTypeNumberPad;
    [_nickName setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _nickName.delegate=self;
    _nickName.font=[UIFont systemFontOfSize:15];
    [_scrollView addSubview:_nickName];
    
    [self lablepriceWithHight:_nickName.bottom andText:@""];
    
    
    UIImageView *xingView2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, nameLab.bottom+20, 8, 8)];
    xingView2.image = [UIImage imageNamed:@"xing"];
    [_scrollView addSubview:xingView2];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(xingView2.right+5, nameLab.bottom, 65, 50)];
    nameLabel.text = @"真实姓名";
    nameLabel.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:nameLabel];
    UIView *fen3 = [[UIView alloc]initWithFrame:CGRectMake(nameLabel.right, nameLab.bottom+15, 1, nameLab.height-30)];
    fen3.backgroundColor = [UIColor grayColor];
    fen3.alpha = 0.3;
    [_scrollView addSubview:fen3];

    
    _realName=[[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right+10, nameLab.bottom, SCREENWIDTH-xingView2.width-nameLab.width-35, 50)];
    _realName.placeholder=@"";
    _realName.secureTextEntry=NO;
    _realName.delegate=self;
    _realName.keyboardType = UIKeyboardTypeNumberPad;
    
    [_realName setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _realName.font=[UIFont systemFontOfSize:15];
    [_scrollView addSubview:_realName];
    
    [self lablepriceWithHight:_realName.bottom andText:@""];

//    [self lablepriceWithHight:100 andText:@""];
    
    //身份证
    UIImageView *xingView3 = [[UIImageView alloc]initWithFrame:CGRectMake(10, nameLabel.bottom+20, 8, 8)];
    xingView3.image = [UIImage imageNamed:@"xing"];
    [_scrollView addSubview:xingView3];
    UILabel *idCardLabel = [[UILabel alloc]initWithFrame:CGRectMake(xingView2.right+5, _realName.bottom, 55, 50)];
    idCardLabel.text = @"身份证";
    idCardLabel.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:idCardLabel];
    UIView *fen4 = [[UIView alloc]initWithFrame:CGRectMake(idCardLabel.right, nameLabel.bottom+15, 1, nameLab.height-30)];
    fen4.backgroundColor = [UIColor grayColor];
    fen4.alpha = 0.3;
    [_scrollView addSubview:fen4];

    _identifierCode=[[UITextField alloc]initWithFrame:CGRectMake(idCardLabel.right+10, _realName.bottom, SCREENWIDTH-xingView2.width-nameLab.width-35, 50)];
    _identifierCode.placeholder=@"";
    [_identifierCode setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _identifierCode.delegate=self;

    _identifierCode.font=[UIFont systemFontOfSize:15];
    [_scrollView addSubview:_identifierCode];
    
    [self lablepriceWithHight:_identifierCode.bottom andText:@""];

//    [self lablepriceWithHight:150 andText:@""];
    
    UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _identifierCode.bottom, 65, 50)];
    cityLabel.text = @"所在区域";
    cityLabel.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:cityLabel];
    
    UIView *fen5 = [[UIView alloc]initWithFrame:CGRectMake(cityLabel.right, idCardLabel.bottom+15, 1, nameLab.height-30)];
    fen5.backgroundColor = [UIColor grayColor];
    fen5.alpha = 0.3;
    [_scrollView addSubview:fen5];
    UILabel *cityLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(cityLabel.right+10, _identifierCode.bottom, SCREENWIDTH-xingView2.width-cityLabel.width-35, 50)];
    cityLabel1.text = @"";
    cityLabel1.font = [UIFont systemFontOfSize:15];
    cityLabel1.userInteractionEnabled = YES;
    self.cityLabel1 = cityLabel1;
    [_scrollView addSubview:cityLabel1];
    
    UIGestureRecognizer *tapGestureDate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceCity)];
    [cityLabel1 addGestureRecognizer:tapGestureDate];
    
    
    [self lablepriceWithHight:cityLabel1.bottom andText:@""];

    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, cityLabel1.bottom, 65, 50)];
    addressLabel.text = @"具体地址";
    addressLabel.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:addressLabel];
    UIView *fen6 = [[UIView alloc]initWithFrame:CGRectMake(addressLabel.right, cityLabel.bottom+15, 1, nameLab.height-30)];
    fen6.backgroundColor = [UIColor grayColor];
    fen6.alpha = 0.3;
    [_scrollView addSubview:fen6];

    
    _addressText=[[UITextField alloc]initWithFrame:CGRectMake(addressLabel.right+10, cityLabel1.bottom, SCREENWIDTH-xingView2.width-addressLabel.width-35, 50)];
    _addressText.placeholder=@"";
    _addressText.delegate=self;
    [_addressText setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    [_addressText setFont:[UIFont systemFontOfSize:15]];
    [_scrollView addSubview:_addressText];
    
    

    

    
    
    UIView*view1=[[UIView alloc]initWithFrame:CGRectMake(0, _addressText.bottom+20, SCREENWIDTH, 320)];
    view1.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:view1];
    
    
    
    
    
    logInBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    logInBtn.frame=CGRectMake(SCREENWIDTH*0.05, 55, SCREENWIDTH*0.9, 40);
    [logInBtn setTitle:@"完善信息" forState:UIControlStateNormal];

    [logInBtn setBackgroundColor:NavBackGroundColor];
    
    logInBtn.titleLabel.font=[UIFont boldSystemFontOfSize:17];
    [logInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logInBtn addTarget:self action:@selector(completClick) forControlEvents:UIControlEventTouchUpInside];
    logInBtn.layer.cornerRadius=5;
    [view1 addSubview:logInBtn];
    
    
    UIButton *ChoseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ChoseBtn.frame = CGRectMake(30, logInBtn.bottom+15, 15, 15);
    
    [ChoseBtn setImage:[UIImage imageNamed:@"xuan"] forState:UIControlStateNormal];
    [ChoseBtn setImage:[UIImage imageNamed:@"xuan1"] forState:UIControlStateSelected];
    ChoseBtn.selected = YES;
    
    [ChoseBtn addTarget:self action:@selector(ChoseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //    ChoseBtn.backgroundColor = [UIColor redColor];
    [view1 addSubview:ChoseBtn];
    
    UILabel *agreeLabe = [[UILabel alloc]initWithFrame:CGRectMake(ChoseBtn.right+1, logInBtn.bottom+15, 105, 15)];
    agreeLabe.text = @"我已阅读并同意商消乐";
    agreeLabe.textColor = [UIColor grayColor];
    agreeLabe.font = [UIFont systemFontOfSize:10];
    [view1 addSubview:agreeLabe];
    UIButton *xieyiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xieyiBtn.frame = CGRectMake(agreeLabe.right, logInBtn.bottom+15, 85, 15);
    [xieyiBtn setTitle:@"《用户使用协议》" forState:UIControlStateNormal];
    [xieyiBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [xieyiBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    xieyiBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [xieyiBtn addTarget:self action:@selector(lookXieYiView) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:xieyiBtn];
    

    
    UIView*hengxian=[[UIView alloc]initWithFrame:CGRectMake(0, 140, SCREENWIDTH, 1)];
    hengxian.backgroundColor=RGB(234, 234, 234);
    [view1 addSubview:hengxian];
    
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH, view1.bottom+100);
    
    
}

-(void)completClick{
    
    
    if([_nickName.text isEqualToString:@""]||[_realName.text isEqualToString:@""]||[_identifierCode.text isEqualToString:@""])
    {
        
        [self textExample:@"请完整您的资料"];
        
    }else if([NSString isPureInt:_nickName.text]||[self isIncludeSpecialCharact:_nickName.text]||_nickName.text.length>32)
    {
        
        [self textExample:@"昵称过长或包含特殊字符,请重新设置"];
        
    }else if(![ToolManager validateIdentityCard:_identifierCode.text])
    {
        [self textExample:@"身份证格式不对,请重新输入"];
    }else{
        
        [self postRequest];
    }
}

//注册请求
-(void)postRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/complete",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_phone_tf.text forKey:@"phone"];
    [params setObject:_nickName.text forKey:@"nickname"];
    [params setObject:_realName.text forKey:@"name"];
    [params setObject:_identifierCode.text forKey:@"id"];
    
    NSString *addressInfo = [[NSString alloc]initWithFormat:@"%@%@",self.cityLabel1.text,_addressText.text];
    
    if ([addressInfo isEqualToString:@""]) {
        [params setObject:@"未设置" forKey:@"address"];
    }else
        [params setObject:addressInfo forKey:@"address"];
    
    NSLog(@"--%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        if ([result[@"result_code"] intValue]==1) {
            NSLog(@"成功");
            
            //完善信息之后绑定账户
            [self bindUserInfo];
            
            
            [self textExample:@"注册成功,正在登录..."];
//            [self performSelector:@selector(popVC) withObject:nil afterDelay:2];
            
            
            
        }else{
            [self textExample:@"完善信息失败"];
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
    }];
    
}




-(void)lookXieYiView
{
    
    
    XieYiViewController *VC = [[XieYiViewController alloc]init];
    VC.type = 888;

    [self presentViewController:VC animated:YES completion:nil];
    
}

-(void)ChoseAction:(UIButton *)btn
{
    btn.selected =! btn.selected;
    NSLog(@"勾选");
    if (btn.selected == YES) {
        logInBtn.enabled = YES;
        logInBtn.backgroundColor =  NavBackGroundColor;
    }else if(btn.selected == NO)
    {
        logInBtn.enabled = NO;
        logInBtn.backgroundColor = [UIColor grayColor];
    }
    
}

-(void)choiceCity{
    [_nickName resignFirstResponder];
    [_realName resignFirstResponder];
    [_identifierCode resignFirstResponder];
    [_addressText resignFirstResponder];

    self.view.backgroundColor = [UIColor whiteColor];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"areaAll" ofType:@"plist"];
    areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    province = [[NSArray alloc] initWithArray: provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    
    NSString *selectedCity = [city objectAtIndex: 0];
    district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    
    
    if (_picker==nil) {
        _picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, SCREENHEIGHT-64-146, SCREENWIDTH, 146)];
    }
    
    _picker.backgroundColor = tableViewBackgroundColor;
    _picker.dataSource = self;
    _picker.delegate = self;
    _picker.showsSelectionIndicator = YES;
    [_picker selectRow: 0 inComponent: 0 animated: YES];
    [self.view addSubview: _picker];
    if (self.toolbarCancelDone==nil) {
        self.toolbarCancelDone = [[UIToolbar alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-186-64, SCREENWIDTH, 40)];
    }
    
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
    
    [self.view addSubview:self.toolbarCancelDone];
    selectedProvince = [province objectAtIndex: 0];
    _picker.hidden = NO;
    self.toolbarCancelDone.hidden = NO;
   
}

- (void)actionCancel
{
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         _picker.hidden = YES;
                         self.toolbarCancelDone.hidden = YES;
                         
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
}

- (void)actionDone
{
    
    self.cityLabel1.text = [NSString stringWithFormat:@"%@%@%@",[province objectAtIndex:[_picker selectedRowInComponent:0]],[city objectAtIndex:[_picker selectedRowInComponent:1]],[district objectAtIndex:[_picker selectedRowInComponent:2]]];
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         _picker.hidden = YES;
                         self.toolbarCancelDone.hidden = YES;
                         
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    
    
}
#pragma mark- Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province count];
    }
    else if (component == CITY_COMPONENT) {
        return [city count];
    }
    else {
        return [district count];
    }
}


#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province objectAtIndex: row];
    }
    else if (component == CITY_COMPONENT) {
        return [city objectAtIndex: row];
    }
    else {
        return [district objectAtIndex: row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        selectedProvince = [province objectAtIndex: row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", (long)row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        
        city = [[NSArray alloc] initWithArray: array];
        
        
        NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [city objectAtIndex: 0]]];
        [_picker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [_picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [_picker reloadComponent: CITY_COMPONENT];
        [_picker reloadComponent: DISTRICT_COMPONENT];
        
    }
    else if (component == CITY_COMPONENT) {
        NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[province indexOfObject: selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        [_picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [_picker reloadComponent: DISTRICT_COMPONENT];
    }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return 80;
    }
    else if (component == CITY_COMPONENT) {
        return 100;
    }
    else {
        return 115;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [province objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [city objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [district objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
}

//绑定已有账号
-(void)bindUserInfo{
    NSString *urlstring=[NSString stringWithFormat:@"%@UserType/bind/bind",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.Auth_type forKey:@"type"];
    [paramer setValue:self.uid forKey:@"uid"];
    [paramer setValue:_phone_tf.text forKey:@"user"];
    
    [paramer setValue:_password_sure_tf.text forKey:@"passwd"];
    
    
    [KKRequestDataService requestWithURL:urlstring params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"====%@",result);
        if ([result[@"result_code"]integerValue]==1) {
            
            
            NSLog(@"绑定成功");
            
            
            [self postRequestLogin:_phone_tf.text andPassWord:_password_sure_tf.text];
            
            
        }else if([result[@"result_code"] isEqualToString:@"not_found"]){
            
            [self tishi:@"账号不存在"];
            
        }else if([result[@"result_code"] isEqualToString:@"passwd_wrong"]){
            
            [self tishi:@"密码错误"];
            
        }else{
            [self tishi:@"绑定失败"];
            
        }
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
//注册新账户
-(void)registNewUser{
    NSString *urlstring=[[NSString alloc]initWithFormat:@"%@UserType/user/register",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_phone_tf.text forKey:@"phone"];
    [params setObject:_password_tf.text forKey:@"passwd"];
    [params setObject:_recommend_person.text forKey:@"referrer"];
    
    [KKRequestDataService requestWithURL:urlstring params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result ==%@", result);
        if ([result[@"result_code"] intValue]==1) {
            NSLog(@"成功");
            
            //注册成功,进入完善信息页面
            
            
            [self showHint:@"注册成功请完善信息"];

            [self completeUserInfo];
            
            //                                        SuccessController *sucVC = [[SuccessController alloc]init];
            //                                        sucVC.phoneNum = _phone_tf.text;
            //                                        sucVC.passWord = _password_tf.text;
            //                                        [self.navigationController pushViewController:sucVC animated:YES];
        }else if ([result[@"result_code"] isEqualToString:@"phone_duplicate"]){
            
            [self showHint:@"该手机号已被注册"];
        }else if([result[@"result_code"] isEqualToString:@"referrer_not_exist"]){
            
            [self showHint:@"推荐人不存在"];
            
        }else{
            [self showHint:@"请重新注册"];
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
//提示遮罩
- (void)textExample:(NSString *)tishi {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(tishi, @"HUD message title");
    
    hud.label.font = [UIFont systemFontOfSize:13];
    [hud hideAnimated:YES afterDelay:1];
}
//是否包含特殊字符
-(BOOL)isIncludeSpecialCharact: (NSString *)str {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

//完善信息界面

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        SuccessController *wholeInfo=[[SuccessController alloc]init];
        wholeInfo.phoneNum=_phone_tf.text;
        wholeInfo.passWord=_password_sure_tf.text;
        
        [self.navigationController pushViewController:wholeInfo animated:YES];
        
        
    }
}
@end
