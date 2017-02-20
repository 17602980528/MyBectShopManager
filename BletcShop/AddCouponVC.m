//
//  AddCouponVC.m
//  BletcShop
//
//  Created by apple on 17/2/20.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AddCouponVC.h"

@interface AddCouponVC ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIScrollView *_scrollView;
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSMutableArray *monthMutableArray;
    NSMutableArray *DaysMutableArray;
    NSMutableArray *DaysArray;
    NSString *currentMonthString;
    
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    
    BOOL firstTimeLoad;
    
    NSInteger index_;
    
    
    NSInteger m ;
    int year;
    int month;
    int day;
    UIView *_contentView;
    UITextField *couponMoneyTF;
    UITextField *useLimitTF;
    UITextField *couponRemainTF;

}
@property(nonatomic,strong)UITextField *startText;
@property(nonatomic,strong)UITextField *endText;
@property (nonatomic,retain)UIDatePicker *datePicker;
@property (nonatomic,retain)UIPickerView *customPicker;
@property (nonatomic,retain)UIToolbar *toolbarCancelDone;
@end

@implementation AddCouponVC
#pragma mark 初始化UI界面
- (void)viewDidLoad {
    [super viewDidLoad];
    index_=-1;
    self.view.backgroundColor=RGB(234,234,234);
    self.navigationItem.title=@"优惠券";
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    [self.view addSubview:_scrollView];
    
    UITapGestureRecognizer *tapBgView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tfDismiss:)];
    [self.view addGestureRecognizer:tapBgView];
    
    UILabel *couponInfo=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-10, 40)];
    couponInfo.text=@"券信息";
    couponInfo.font=[UIFont systemFontOfSize:13.0f];
    couponInfo.textColor=[UIColor grayColor];
    couponInfo.backgroundColor=RGB(234,234,234);
    [_scrollView addSubview:couponInfo];
    
    UIView *section1=[[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 81)];
    section1.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:section1];
    //券面额
    UILabel *couponMoney=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
    couponMoney.text=@"券的面额: ¥";
    couponMoney.font=[UIFont systemFontOfSize:15.0f];
    couponMoney.textColor=[UIColor grayColor];
    [section1 addSubview:couponMoney];
    //券面额输入框
    couponMoneyTF=[[UITextField alloc]initWithFrame:CGRectMake(90,0 , SCREENWIDTH-100, 40)];
    couponMoneyTF.placeholder=@"优惠券金额";
    couponMoneyTF.keyboardType=UIKeyboardTypePhonePad;
    couponMoneyTF.font=couponMoney.font=[UIFont systemFontOfSize:15.0f];
    [section1 addSubview:couponMoneyTF];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(10, 41, SCREENWIDTH-10, 1)];
    line1.backgroundColor=RGB(238, 238, 238);
    [section1 addSubview:line1];
    //使用条件
    UILabel *useLimit=[[UILabel alloc]initWithFrame:CGRectMake(10, 41, 80, 40)];
    useLimit.text=@"使用条件: ¥";
    useLimit.font=[UIFont systemFontOfSize:15.0f];
    useLimit.textColor=[UIColor grayColor];
    [section1 addSubview:useLimit];
    //使用条件输入框
    useLimitTF=[[UITextField alloc]initWithFrame:CGRectMake(90,41 , SCREENWIDTH-100, 40)];
    useLimitTF.placeholder=@"用券最低订单金额";
    useLimitTF.keyboardType=UIKeyboardTypePhonePad;
    useLimitTF.font=couponMoney.font=[UIFont systemFontOfSize:15.0f];
    [section1 addSubview:useLimitTF];
    
    UIView *section2=[[UIView alloc]initWithFrame:CGRectMake(0, 131, SCREENWIDTH, 40)];
    section2.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:section2];
    //券的库存
    UILabel *couponRemain=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
    couponRemain.text=@"券的库存: ";
    couponRemain.font=[UIFont systemFontOfSize:15.0f];
    couponRemain.textColor=[UIColor grayColor];
    [section2 addSubview:couponRemain];
    //券的库存输入框
    couponRemainTF=[[UITextField alloc]initWithFrame:CGRectMake(90,0 , SCREENWIDTH-100, 40)];
    couponRemainTF.placeholder=@"可被领取的总券数";
    couponRemainTF.keyboardType=UIKeyboardTypePhonePad;
    couponRemainTF.font=couponMoney.font=[UIFont systemFontOfSize:15.0f];
    [section2 addSubview:couponRemainTF];
    //有效期
    UILabel *validityPeriod=[[UILabel alloc]initWithFrame:CGRectMake(10, 40+81+10+40, SCREENWIDTH-10, 40)];
    validityPeriod.text=@"有效期";
    validityPeriod.font=[UIFont systemFontOfSize:13.0f];
    validityPeriod.textColor=[UIColor grayColor];
    validityPeriod.backgroundColor=RGB(234,234,234);
    [_scrollView addSubview:validityPeriod];
    
    UIView *section3=[[UIView alloc]initWithFrame:CGRectMake(0, 40+81+10+40+40, SCREENWIDTH, 81)];
    section3.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:section3];
    //开始时间
    UILabel *beginDate=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
    beginDate.text=@"开始时间: ";
    beginDate.font=[UIFont systemFontOfSize:15.0f];
    beginDate.textColor=[UIColor grayColor];
    [section3 addSubview:beginDate];
    //开始时间输入框
    _startText=[[UITextField alloc]initWithFrame:CGRectMake(90,0 , SCREENWIDTH-100, 40)];
    _startText.delegate=self;
    _startText.placeholder=@"使用券的开始时间";
    _startText.font=couponMoney.font=[UIFont systemFontOfSize:15.0f];
    [section3 addSubview:_startText];
    
    UIButton *startBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame=CGRectMake(0, 0, SCREENWIDTH, 40);
    [startBtn addTarget:self action:@selector(showBeginTime) forControlEvents:UIControlEventTouchUpInside];
    [section3 addSubview:startBtn];
    
    //结束时间
    UILabel *overDate=[[UILabel alloc]initWithFrame:CGRectMake(10, 41, 80, 40)];
    overDate.text=@"结束时间: ";
    overDate.font=[UIFont systemFontOfSize:15.0f];
    overDate.textColor=[UIColor grayColor];
    [section3 addSubview:overDate];
    //结束时间输入框
    _endText=[[UITextField alloc]initWithFrame:CGRectMake(90,41 , SCREENWIDTH-100, 40)];
    _endText.delegate=self;
    _endText.placeholder=@"使用券的开始时间";
    _endText.font=couponMoney.font=[UIFont systemFontOfSize:15.0f];
    [section3 addSubview:_endText];
    
    UIButton *endBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    endBtn.frame=CGRectMake(0, 41, SCREENWIDTH, 40);
    [endBtn addTarget:self action:@selector(showEndTime) forControlEvents:UIControlEventTouchUpInside];
    [section3 addSubview:endBtn];
    
    UIButton *completeAddAction=[UIButton buttonWithType:UIButtonTypeCustom];
    completeAddAction.frame=CGRectMake(15, section3.bottom+20, SCREENWIDTH-30, 44);
    completeAddAction.backgroundColor=NavBackGroundColor;
    [completeAddAction setTitle:@"添加完成" forState:UIControlStateNormal];
    [completeAddAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scrollView addSubview:completeAddAction];
    completeAddAction.layer.cornerRadius=5.0f;
    completeAddAction.clipsToBounds=YES;
    [completeAddAction addTarget:self action:@selector(completeAddActionEvents) forControlEvents:UIControlEventTouchUpInside];
    [self _inittable];
    
    

}
#pragma mark 完成添加按钮点击事件
-(void)completeAddActionEvents{
    //
    int result = [self compareDate:self.startText.text withDate:self.endText.text];
    if([self.startText.text isEqualToString:@""])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请选择延长期限", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        //    [hud setColor:[UIColor blackColor]];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        hud.userInteractionEnabled = YES;
        
        [hud hideAnimated:YES afterDelay:3.f];
    }else if([self.endText.text isEqualToString:@""]){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请选择结束日期", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        //    [hud setColor:[UIColor blackColor]];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        hud.userInteractionEnabled = YES;
        
        [hud hideAnimated:YES afterDelay:3.f];
    }else if (result==-1||result==0){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请选择合适的结束日期", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        //    [hud setColor:[UIColor blackColor]];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        hud.userInteractionEnabled = YES;
        
        [hud hideAnimated:YES afterDelay:3.f];

    }else if ([couponMoneyTF.text isEqualToString:@""]||[useLimitTF.text isEqualToString:@""]||[couponRemainTF.text isEqualToString:@""]){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请检查输入项", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        //    [hud setColor:[UIColor blackColor]];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        hud.userInteractionEnabled = YES;
        
        [hud hideAnimated:YES afterDelay:3.f];
    }else{
        [self postAddCouponRequest];
    }
}
#pragma mark 调用接口发布优惠券
-(void)postAddCouponRequest{
    //
}
#pragma mark 显示时间选取器页面
-(void)showBeginTime{
    index_=0;
    [self show];
}
-(void)showEndTime{
    index_=1;
    [self show];
}
#pragma mark 输入框禁编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}
#pragma mark 输入框禁隐藏
-(void)tfDismiss:(UITapGestureRecognizer *)gesture{
    [gesture.view endEditing:YES];
}

#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 3;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
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
#pragma mark 初始化pickerview
/**弹出视图*/
- (void)show
{
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [[[UIApplication sharedApplication].delegate window] addSubview:_contentView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCancleClick)];
    [_contentView addGestureRecognizer:tap];
    
    self.customPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 160)] ;
    self.customPicker.delegate = self;
    self.customPicker.dataSource = self;
    self.customPicker.backgroundColor = [UIColor whiteColor];
    self.toolbarCancelDone = [[UIToolbar alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 40)];
    [_contentView addSubview: self.customPicker];
    [_contentView addSubview: self.toolbarCancelDone];
    
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREENWIDTH-60, 0, 60, 40);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    
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
    _contentView.hidden = NO;
    //动画出现
    CGRect frame = self.customPicker.frame;
    
    if (frame.origin.y == SCREENHEIGHT) {
        frame.origin.y -= self.customPicker.height;
        [UIView animateWithDuration:0.3 animations:^{
            self.customPicker.frame = frame;
            self.toolbarCancelDone.frame = CGRectMake(0, SCREENHEIGHT-200, SCREENWIDTH, 40);
            
        }];
    }
}
/**移除视图*/
- (void)removeSelfFromSupView
{
    CGRect selfFrame = self.customPicker.frame;
    if (selfFrame.origin.y == SCREENHEIGHT-self.customPicker.height) {
        selfFrame.origin.y += self.customPicker.height;
        [UIView animateWithDuration:0.3 animations:^{
            self.customPicker.frame = selfFrame;
            self.toolbarCancelDone.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 40);
            
        }completion:^(BOOL finished) {
            NSLog(@"==finished=");
            [self.customPicker removeFromSuperview];
            [self.toolbarCancelDone removeFromSuperview];
            [_contentView removeFromSuperview];
        }];
    }
}

- (void)tapCancleClick
{
    [self removeSelfFromSupView];
}

-(void)_inittable
{
    
    m=0;
    //    firstTimeLoad = YES;
    //    self.customPicker.hidden = YES;
    //    self.toolbarCancelDone.hidden = YES;
    
    NSDate *date = [NSDate date];
    
    // Get Current Year
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    
    NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    year =[currentyearString intValue];
    
    
    // Get Current  Month
    
    [formatter setDateFormat:@"MM"];
    
    currentMonthString = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    month=[currentMonthString intValue];
    
    
    
    
    // Get Current  Date
    
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    day =[currentDateString intValue];
    
    
    yearArray = [[NSMutableArray alloc]init];
    monthMutableArray = [[NSMutableArray alloc]init];
    DaysMutableArray= [[NSMutableArray alloc]init];
    for (int i = year; i <= year+2 ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    // PickerView -  Months data
    
    
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
    
    // PickerView - Default Selection as per current Date
    // 设置初始默认值
    [self.customPicker selectRow:0 inComponent:0 animated:YES];
    
    // [pickerView selectRow:30 inComponent:0 animated:NO];
    
    [self.customPicker selectRow:[monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];
    
    [self.customPicker selectRow:0 inComponent:2 animated:YES];

}
#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    m=row;
    
    if (component == 0)
    {
        selectedYearRow = row;
        [self.customPicker reloadAllComponents];
    }
    else if (component == 1)
    {
        selectedMonthRow = row;
        [self.customPicker reloadAllComponents];
    }
    else if (component == 2)
    {
        selectedDayRow = row;
        
        [self.customPicker reloadAllComponents];
        
    }
    
}
#pragma mark 时间对比
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

- (void)actionCancel
{
    [self removeSelfFromSupView];
    
    //    [UIView animateWithDuration:0.5
    //                          delay:0.1
    //                        options: UIViewAnimationOptionCurveEaseIn
    //                     animations:^{
    //
    //                         self.customPicker.hidden = YES;
    //                         self.toolbarCancelDone.hidden = YES;
    //
    //
    //                     }
    //                     completion:^(BOOL finished){
    //
    //
    //                     }];
    
    
}

- (void)actionDone
{
    if (index_==0) {
        self.startText.text = [NSString stringWithFormat:@"%@-%@-%@",[yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]],[monthArray objectAtIndex:[self.customPicker selectedRowInComponent:1]],[DaysArray objectAtIndex:[self.customPicker selectedRowInComponent:2]]];
        
    }
    
    if (index_==1) {
        self.endText.text = [NSString stringWithFormat:@"%@-%@-%@",[yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]],[monthArray objectAtIndex:[self.customPicker selectedRowInComponent:1]],[DaysArray objectAtIndex:[self.customPicker selectedRowInComponent:2]]];
        
    }
    
    [self removeSelfFromSupView];
    
    
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
