//
//  NewNextViewController.m
//  BletcShop
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NewNextViewController.h"
#import "NewMoreInfoViewController.h"
#import "ToolManager.h"
#import "NewMiddleViewController.h"
@interface NewNextViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CustomIOSAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
{
    NSArray *nameArray;
    NSArray *placeHolderArray;
    CGFloat totalHeight;
    NSData *imageData;
    NSData *imageData2;
    NSInteger state;
    NSMutableArray *textArray;
    UITableView *_tableView;
    
    NSMutableDictionary *shopInfoDic;
    
}
@end

@implementation NewNextViewController


-(UIImage *) getImageFromURL:(NSString *)fileURL {
    
    //    NSLog(@"执行图片下载函数");
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    //    NSLog(@"yyyyy%lu",(unsigned long)data.length);
    result = [UIImage imageWithData:data];
    return result;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
       
    self.view.backgroundColor=[UIColor whiteColor];
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSDictionary *dic =(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults]objectForKey:app.shopInfoDic[@"muid"]];
    
    shopInfoDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    
    self.phoneString= shopInfoDic[@"phone"];
    [self initTopView];
    [self initTableView];
    state=1;
    textArray=[[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    [NSThread detachNewThreadSelector:@selector(downLoadImageAndSeeIfExists) toTarget:self withObject:nil];
}
-(void)downLoadImageAndSeeIfExists{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *name = [[[NSString alloc]initWithFormat:@"%@idFrontImage/%@.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImage *image= [self getImageFromURL:name];
    if (image) {
        self.ifImageView=YES;
        [array addObject:image];
    }else{
        image=[UIImage imageNamed:@"mohu-06"];
        [array addObject:image];
    }
    NSString *name2 = [[[NSString alloc]initWithFormat:@"%@idBackImage/%@.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImage *image2= [self getImageFromURL:name2];
    if (image2) {
        self.ifImageView1=YES;
        [array addObject:image2];
    }else{
        image2=[UIImage imageNamed:@"mohu-07"];
        [array addObject:image2];
    }
    NSString *name3 = [[[NSString alloc]initWithFormat:@"%@idHandImage/%@.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImage *image3= [self getImageFromURL:name3];
    if (image3) {
        self.ifImageView2=YES;
        [array addObject:image3];
    }else{
        image3=[UIImage imageNamed:@"mohu-08"];
        [array addObject:image3];
    }
    
    [self performSelectorOnMainThread:@selector(refreshUI:) withObject:array waitUntilDone:NO];
}
-(void)refreshUI:(NSMutableArray *)array{
    if (self.ifImageView==YES) {
        self.imageView.image=array[0];
    }
    if (self.ifImageView1==YES) {
        self.imageView1.image=array[1];
    }
    if (self.ifImageView2==YES) {
        self.imageView3.image=array[2];
    }
    
}

-(void)initTopView{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    navView.backgroundColor = NavBackGroundColor;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 18, 70, 44)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backRegist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
    [navView addSubview:btn];
    
    UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-70, 18,70, 44)];
    [btns setTitle:@"保存" forState:UIControlStateNormal];
    [btns addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btns.tag = 999;
    [self.view addSubview:navView];
    [navView addSubview:btns];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 18, SCREENWIDTH, 44)];
    label.font=[UIFont systemFontOfSize:19.0f];
    label.text=@"预付保险认证";
    label.textAlignment=1;
    label.textColor=[UIColor whiteColor];
    [navView addSubview:label];
    UIView *landView = [[UIView alloc]initWithFrame:CGRectMake(0, (SCREENHEIGHT-300)/2, SCREENWIDTH, 240)];
    self.landView = landView;
    [self.view addSubview:landView];
    NSArray *numArray=@[@"1",@"2",@"3"];
    NSArray *nameArrays=@[@"填写店主信息",@"填写店铺信息",@"紧急联系人"];
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(-1, 64, SCREENWIDTH+2, 44)];
    topView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    topView.layer.borderWidth=1;
    [self.view addSubview:topView];
    for (int i=0; i<3; i++) {
        UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(i%3*SCREENWIDTH/3, 0, SCREENWIDTH/3, 44)];
        backView.backgroundColor=[UIColor whiteColor];
        [topView addSubview:backView];
        
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, 20, 20)];
        label1.layer.cornerRadius=10;
        label1.clipsToBounds=YES;
        label1.text=numArray[i];
        label1.textColor=[UIColor whiteColor];
        label1.textAlignment=1;
        [backView addSubview:label1];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(30, 10, SCREENWIDTH/3-30, 20)];
        //label2.backgroundColor=[UIColor redColor];
        label2.text=nameArrays[i];
        label2.font=[UIFont systemFontOfSize:12.0f];
        [backView addSubview:label2];
        if (i==0) {
            label2.textColor=[UIColor redColor];
            label1.backgroundColor=[UIColor redColor];
            UIView *slidView=[[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH/3, 4)];
            slidView.backgroundColor=[UIColor redColor];
            [backView addSubview:slidView];
        }else{
            label2.textColor=[UIColor grayColor];
            label1.backgroundColor=[UIColor grayColor];
        }
    }
    
}
-(void)initTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 108, SCREENWIDTH, SCREENHEIGHT-108)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    nameArray=@[@"姓名",@"",@"开户人",@"住宅地址",@"身份证号",@"上传图片",@"开户行",@"银行账号  ",@"手机查询授权",@""];
    placeHolderArray=@[@"长度不超过16位",@"",@"请输入您的真实姓名",@"请输入您现在具体住宅地址",@"请输入真实有效的18位身份证号",@"您的照片仅用于审核，我们将严格保密",@"请输入开户行",@"法人本人,目前仅支持建行储蓄卡",@"",@""];
    UITapGestureRecognizer *tapClick=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAndHidden)];
    [_tableView addGestureRecognizer:tapClick];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        UILabel *xingLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
        xingLab.tag=99;
        xingLab.font=[UIFont systemFontOfSize:20.0f];
        xingLab.textColor=[UIColor redColor];
        xingLab.textAlignment=1;
        xingLab.text=@"*";
        [cell addSubview:xingLab];
        //名称
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 110, 50)];
        label.tag=100;
        label.font=[UIFont systemFontOfSize:15.0f];
        [cell addSubview:label];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    UILabel *xing=[cell viewWithTag:99];
    UILabel *nickLab=[cell viewWithTag:100];
    

    if (indexPath.row==0) {
        nickLab.text=nameArray[0];

        // 输入框
        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(140, 5, SCREENWIDTH-140, 40)];
        textField.placeholder=@"请输入注册人姓名";
        textField.tag=200;
        textField.delegate=self;
        textField.returnKeyType=UIReturnKeyDone;
        textField.font=[UIFont systemFontOfSize:13.0f];
        [cell addSubview:textField];

        if (self.nickTextTF.text&&![self.nickTextTF.text isEqualToString:@""]) {
            textField.text=self.nickTextTF.text;
        }else{
            textField.text= [NSString getTheNoNullStr:shopInfoDic[@"bname"] andRepalceStr:@""];
        }
        self.nickTextTF=textField;
    }else if (indexPath.row==1){
//        nickLab.hidden=YES;
//        xing.hidden=YES;

        //        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(140, 5, SCREENWIDTH-140, 40)];
//        textField.hidden=YES;
//        textField.delegate=self;
//        textField.placeholder=@"";
//        textField.tag=201;
//        textField.font=[UIFont systemFontOfSize:13.0f];
//        [cell addSubview:textField];
//        textField.text=self.personText.text;
//        self.personText=textField;
    }else if (indexPath.row==5){
        // xing.hidden = YES;
        nickLab.text=nameArray[2];

        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(140, 5, SCREENWIDTH-140, 40)];
        textField.delegate=self;
        textField.placeholder=@"请输入开户人姓名";
        textField.tag=202;
        textField.returnKeyType=UIReturnKeyDone;
        textField.font=[UIFont systemFontOfSize:13.0f];
        [cell addSubview:textField];
        

        textField.text= [NSString getTheNoNullStr:shopInfoDic[@"name"] andRepalceStr:@""];

        
        self.realNameTF=textField;
    }else if (indexPath.row==2){
        nickLab.text=nameArray[3];

        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(140, 5, SCREENWIDTH-140, 40)];
        textField.delegate=self;
        textField.placeholder=@"请输入您现在具体住宅地址";
        textField.tag=203;
         textField.returnKeyType=UIReturnKeyDone;
        textField.font=[UIFont systemFontOfSize:13.0f];
        [cell addSubview:textField];
        

        textField.text= [NSString getTheNoNullStr:shopInfoDic[@"house_add"] andRepalceStr:@""];
        

       

        self.addressTF=textField;
    }else if (indexPath.row==3){
        nickLab.text=nameArray[4];

        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(140, 5, SCREENWIDTH-140, 40)];
        textField.delegate=self;
        textField.placeholder=@"请输入真实有效的18位身份证号";
        textField.tag=204;
         textField.returnKeyType=UIReturnKeyDone;
        textField.font=[UIFont systemFontOfSize:13.0f];
        [cell addSubview:textField];
        

        textField.text= [NSString getTheNoNullStr:shopInfoDic[@"id"] andRepalceStr:@""];


        
        self.idenCardText=textField;
    }else if (indexPath.row==4){
        nickLab.text=nameArray[5];

        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(140, 0, SCREENWIDTH-140, 50)];
        label.textColor=[UIColor grayColor];
        label.font=[UIFont systemFontOfSize:13.0f];
        label.text=@"照片仅用于审核，将严格保密";
        [cell addSubview:label];
        for (int i=0; i<3; i++) {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(15+i%3*((SCREENWIDTH-60)/3+15), 50, (SCREENWIDTH-60)/3, ((SCREENWIDTH-60)/3)*116/176)];
            imageView.tag=i+1;
            imageView.userInteractionEnabled=YES;
            [cell addSubview:imageView];
            //给图片绑定手势
            UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait:)];
            [imageView addGestureRecognizer:portraitTap];
            CGFloat zuobiao=15+i%3*((SCREENWIDTH-60)/3+15);
            CGFloat kuandu=(((SCREENWIDTH-60)/3)*116/176)+50;
            UILabel *noticeLab=[[UILabel alloc]initWithFrame:CGRectMake(zuobiao, kuandu, (SCREENWIDTH-60)/3, 30)];
            noticeLab.tag=i+10;
            noticeLab.textAlignment=1;
            noticeLab.font=[UIFont systemFontOfSize:13.0f];
            noticeLab.textColor=[UIColor redColor];
            [cell addSubview:noticeLab];
            totalHeight=kuandu+30+10;
            if (i==0) {
                self.imageView=imageView;
                self.imageView.image=[UIImage imageNamed:@"mohu-06"];
                noticeLab.text=@"身份证正面照片";
                //
            }else if (i==1){
                self.imageView1=imageView;
                self.imageView1.image=[UIImage imageNamed:@"mohu-07"];
                noticeLab.text=@"身份证反面照片";
            }else if (i==2){
                self.imageView3=imageView;
                self.imageView3.image=[UIImage imageNamed:@"mohu-08"];
                noticeLab.text=@"本人持身份证照片";
            }
        }
        
    }
    else if (indexPath.row==6){
        nickLab.text=nameArray[6];
        // xing.hidden = YES;

        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(140, 5, SCREENWIDTH-140, 40)];
        textField.delegate=self;
        textField.placeholder=@"请输入开户行";
        textField.tag=203;
         textField.returnKeyType=UIReturnKeyDone;
        textField.font=[UIFont systemFontOfSize:13.0f];
        [cell addSubview:textField];
        

        textField.text= [NSString getTheNoNullStr:shopInfoDic[@"bank"] andRepalceStr:@""];
        
        self.kaihuTF=textField;
    }else if (indexPath.row==7){
        nickLab.text=nameArray[7];
        // xing.hidden = YES;

        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(140, 5, SCREENWIDTH-140, 40)];
        textField.keyboardType=UIKeyboardTypeNumberPad;
        textField.delegate=self;
        textField.placeholder=@"目前仅支持建行储蓄卡";
        textField.tag=203;
         textField.returnKeyType=UIReturnKeyDone;
        textField.font=[UIFont systemFontOfSize:13.0f];
        [cell addSubview:textField];

        
        textField.text= [NSString getTheNoNullStr:shopInfoDic[@"account"] andRepalceStr:@""];
        

        
        self.zhanghaoTF=textField;
    }else if (indexPath.row==8){
        nickLab.text=nameArray[8];
        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(140, 5, SCREENWIDTH-140, 40)];
        textField.delegate=self;
        textField.placeholder=@"";
        textField.tag=203;
        textField.font=[UIFont systemFontOfSize:13.0f];
        [cell addSubview:textField];
        
        if (self.phonePswText.text&&![self.phonePswText.text isEqualToString:@""]) {
            textField.text=self.phonePswText.text;
        }else{
            textField.text = [NSString getTheNoNullStr:shopInfoDic[@"phone_search_pwd"] andRepalceStr:@""];
        }
        

        
        self.phonePswText=textField;
    }else if (indexPath.row==9){

        UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
        nextButton.backgroundColor=[UIColor redColor];
        nextButton.frame=CGRectMake(SCREENWIDTH/2-50, 5, 100, 40);
        [nextButton setTintColor:[UIColor whiteColor]];
        nextButton.tag=300;
        nextButton.layer.cornerRadius=8.0f;
        nextButton.clipsToBounds=YES;
        [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:nextButton];
        xing.text=@"";

        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==1){

        return 0.01;
    }else if(indexPath.row==4){
        return totalHeight;
    }else{
        return 50;
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
//返回上一层
-(void)backRegist
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view endEditing:YES];
    [_tableView endEditing:YES];
}

//点击顶部，让键盘消失
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
//点击下一步，去下一个页面
-(void)btnClick:(UIButton *)sender{

    NSLog(@"%@1---%@2---%@3---",self.nickTextTF.text,self.addressTF.text,self.idenCardText.text);
    if ([self.nickTextTF.text isEqualToString:@""]||[self.addressTF.text isEqualToString:@""]||[self.idenCardText.text isEqualToString:@""]||[self.kaihuTF.text isEqualToString:@""]||[self.realNameTF.text isEqualToString:@""]||[self.zhanghaoTF.text isEqualToString:@""]||[self.phonePswText.text isEqualToString:@""]) {
//        ||self.ifImageView==NO||self.ifImageView1==NO||self.ifImageView2==NO
        
        [self tishi:@"至少一项不完善!"];

           }else{
        if ([self.phonePswText.text isEqualToString:@"已拒绝，点击可修改。"]) {
            [self tishi:@"未授权手机查询，请授权"];

          
            
        }else if ([self.nickTextTF.text length]>16||[self isPureInt:self.nickTextTF.text]||[self isIncludeSpecialCharact:self.nickTextTF.text]){
            [self tishi:@"姓名过长或包含特殊字符,请重新设置"];

           
        }else  if(![ToolManager validateIdentityCard:self.idenCardText.text])
        {
            
            [self tishi:@"身份证格式不对,请重新输入"];

          
            
        }
        
        else  if([self isPureInt:self.zhanghaoTF.text]){
            
            if([self.zhanghaoTF.text length]==16||[self.zhanghaoTF.text length]==19)
            {
                [self saveRequest:0];


                
            }else{
                [self tishi:@"银行卡格式不对"];

//                [self saveInfo];
//                NewMiddleViewController *middleVC=[[NewMiddleViewController alloc]init];
//                middleVC.phoneStr=self.phoneString;
//                middleVC.nibNameString=self.nickTextTF.text;
//                [self presentViewController:middleVC animated:YES completion:nil];
            }
            
//            else  if(self.zhanghaoTF.text.length!=0){
//                
//                if([self.zhanghaoTF.text length]!=16||[self.zhanghaoTF.text length]!=19||![self isPureInt:self.zhanghaoTF.text])
//                {
//                    [self tishi:@"银行卡格式不对"];
//                    
//                }else{
//                    
//                   
//                    
//                }
// 
//                
//            }else{
//                [self saveRequest:0];
//            }

        }
        else{
            

            [self saveRequest:0];
        
        }
    }
}

//15158218965
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==self.personText||textField==self.phonePswText) {
        if (textField!=self.idenCardText) {
            [self NewAddVipAction:textField];
            return NO;
        }
    }
    UIView *view = textField.superview;
    
    while (![view isKindOfClass:[UITableViewCell class]]) {
        
        view = [view superview];
        
    }
    
    UITableViewCell *cell = (UITableViewCell*)view;
    
    CGRect rect = [cell convertRect:cell.frame toView:self.view];
    
    if (rect.origin.y + rect.size.height>=SCREENHEIGHT-260) {
        
        _tableView.frame=CGRectMake(0, 108, SCREENWIDTH, SCREENHEIGHT-108-260);
        [_tableView scrollToRowAtIndexPath:[_tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
        [self saveInfo];
        
    }
    
    return YES;
}
-(void)NewAddVipAction:(UITextField *)tf
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView:tf]];
    
    // Modify the parameters
    
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"是", @"否", nil]];
    
    [alertView setDelegate:self];
    
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
}
- (UIView *)createDemoView:(UITextField *)tf2
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 150)];
    self.demoView = demoView;
    demoView.frame=CGRectMake(0, 0, 290, 50);
    UILabel *numlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, demoView.width, 50)];
    numlabel.textAlignment = NSTextAlignmentCenter;
    if (tf2==self.personText) {
        numlabel.text = @"您通过在线用户推荐,入驻平台?";
        state=100;
    }else{
        numlabel.text = @"是否同意提供手机查询授权?";
        state=200;
    }
    numlabel.font = [UIFont systemFontOfSize:16];
    [demoView addSubview:numlabel];
    return demoView;
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (alertView.tag==0&&buttonIndex==1) {
        if (state==100) {
            self.personText.text = @"无人推荐";
            [alertView close];
            [self.personText resignFirstResponder];
            [self.personText endEditing:YES];
        }else if (state==200){
            self.phonePswText.text=@"已拒绝，点击可修改。";
            [alertView close];
            [self.phonePswText resignFirstResponder];
        }
    }
    else if (alertView.tag==0&&buttonIndex==0)
    {
        if (state==100) {
            self.personText.text =@"";
            self.personText.placeholder = @"请输入您的推荐人";
            
        }else if (state==200){
            self.phonePswText.text = @"同意提供手机查询授权。";
            [self.phonePswText resignFirstResponder];
        }
    }
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
}
//点击手势触发方法
-(void)editPortrait:(UITapGestureRecognizer *)tap
{
    if (![self.nickTextTF.text isEqualToString:@""]) {
        UIImageView *imageViews=(UIImageView *)[tap view];
        if (imageViews.tag==1) {
            self.imageView=imageViews;
        }else if(imageViews.tag==2){
            self.imageView1=imageViews;
        }else if (imageViews.tag==3){
            self.imageView3=imageViews;
        }
        [self.view endEditing:YES];
        UIActionSheet *sheet;
        
        self.indexTag=imageViews.tag;
        
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
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"昵称不能为空", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }
    
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
    // 保存图片至本地，方法见下文
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/RegisterUpload/upload",BASEURL];
   
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *name = [[NSString alloc]initWithFormat:@"%@",appdelegate.shopInfoDic[@"muid"]];

    
    
    _isFullScreen = NO;
    
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    
    [parmer setValue:name forKey:@"name"];
    
    [parmer setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];

    if (_indexTag==1) {
        [self.imageView setImage:savedImage];
        [parmer setValue:@"id_front" forKey:@"type"];
        
        
    }else if(_indexTag==2)
    {
        [self.imageView1 setImage:savedImage];
        [parmer setValue:@"id_back" forKey:@"type"];
        
    }else if(_indexTag==3)
    {
        [self.imageView3 setImage:savedImage];
        [parmer setValue:@"id_hand" forKey:@"type"];
        
    }
    
    
    NSData *img_Data = [NSData dataWithContentsOfFile:fullPath];
    
    [parmer setObject:img_Data forKey:@"file1"];
    
    [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        if ([result[@"result_code"] isEqualToString:@"access"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"上传成功", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:3.f];
            
            if (self.indexTag==1)
            {
                self.ifImageView=YES;
            }else if (self.indexTag==2)
            {
                self.ifImageView1=YES;
            }else if (self.indexTag==3)
            {
                self.ifImageView2=YES;
            }
            
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
    
    NSLog(@"+++++++=++++=+++=+%lu",(unsigned long)imageData.length);
    
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:self.idenCardText])
    {
        if (![ToolManager validateIdentityCard:self.idenCardText.text])
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"身份证格式错误,请重新输入", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:3.f];
            
        }
    }
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    _tableView.frame =CGRectMake(0, 108, SCREENWIDTH, SCREENHEIGHT-108);
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:YES];
    [_tableView endEditing:YES];
    [_nickTextTF resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSDictionary *dic =[[NSUserDefaults standardUserDefaults]objectForKey:app.shopInfoDic[@"muid"]];
    
    shopInfoDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    
    DebugLog(@"shopInfoDic==%@",shopInfoDic);
}
-(void)tapAndHidden{
    [_tableView endEditing:YES];
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string]; //定义一个NSScanner，扫描string
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
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
//保存信息
-(void)saveBtnClick:(UIButton *)sender{
    //调接口
    [self saveRequest:999];
}


-(void)saveRequest:(NSInteger)tag{
    //开始发起请求,请求成功，显示一下信息
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/register/auth_01",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:self.phoneString forKey:@"phone"];
    [params setObject:self.nickTextTF.text forKey:@"bname"];
    [params setObject:self.realNameTF.text forKey:@"name"];
    [params setObject:self.addressTF.text forKey:@"house_add"];
    [params setObject:self.idenCardText.text forKey:@"id"];
    [params setObject:self.kaihuTF.text forKey:@"bank"];
    [params setObject:self.zhanghaoTF.text forKey:@"account"];
    [params setObject:self.phonePswText.text forKey:@"psp"];
    if (tag==0) {
        [params setValue:@"next" forKey:@"operate"];
    }else if (tag==999){
        [params setValue:@"save" forKey:@"operate"];
    }

    //保存信息
    [self saveInfo];

    DebugLog(@"url==%@\n\n pareme==%@",url,params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"NewNext==%@", result);
        
        if (tag ==999) {
            if ([result[@"result_code"] intValue]==1){
                [self tishi:@"已保存成功"];

            }else{
                [self tishi:@"保存失败"];

            }
            
            
        }else if (tag==0){
            if ([result[@"result_code"] intValue]==1 ||[result[@"result_code"] intValue]==0 ) {
                NewMiddleViewController *middleVC=[[NewMiddleViewController alloc]init];
                middleVC.phoneStr=self.phoneString;
                middleVC.nibNameString=self.nickTextTF.text;
                [self presentViewController:middleVC animated:YES completion:nil];
            }else if([result[@"result_code"] intValue]==-1){
                
                [self tishi:[NSString stringWithFormat:@"%@",result[@"tip"]]];
                
               
            }else{
                [self tishi:@"提交失败"];

            }
            
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
}
-(void)saveInfo{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [shopInfoDic setValue:self.nickTextTF.text forKey:@"bname"];
    [shopInfoDic setValue:self.realNameTF.text forKey:@"name"];
    [shopInfoDic setValue:self.addressTF.text forKey:@"house_add"];
    [shopInfoDic setValue:self.idenCardText.text forKey:@"id"];
    [shopInfoDic setValue:self.kaihuTF.text forKey:@"bank"];
    [shopInfoDic setValue:self.zhanghaoTF.text forKey:@"account"];

    [shopInfoDic setValue:self.phonePswText.text forKey:@"phone_search_pwd"];
    
    [userDefault setObject:shopInfoDic forKey:shopInfoDic[@"muid"]];
    [userDefault synchronize];
    
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    
    [self saveInfo];
    
    
   
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];//取消第一响应者
    
    return YES;
}

-(void)tishi:(NSString *)ts{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(ts, @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    [hud hideAnimated:YES afterDelay:2.f];

}
@end
