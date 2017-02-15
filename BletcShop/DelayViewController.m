//
//  DelayViewController.m
//  BletcShop
//
//  Created by Bletc on 16/4/13.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "DelayViewController.h"
#import "ValuePickerView.h"

#import "DelayScanVC.h"
@interface DelayViewController ()

@property (nonatomic , strong) NSArray *deadLine_A;//有效期数组

@property (nonatomic , strong) NSDictionary *deadLine_dic;// <#Description#>
@property (nonatomic, strong) ValuePickerView *pickerView;


@end

@implementation DelayViewController
{
    
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

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    self.title = @"申请延期";
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREENWIDTH-75, 0, 60, 40);
    [button setTitle:@"查看" forState:0];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
   
    [button addTarget:self action:@selector(sacnClcik) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.pickerView = [[ValuePickerView alloc]init];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 8, SCREENWIDTH, 24)];
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = RGB(51,51,51);
    label1.textAlignment = NSTextAlignmentLeft;
    NSString *endString =self.card_dic[@"date_end"];
    if (endString.length>10) {
        endString = [endString substringToIndex:10];
    }
    label1.text = [NSString stringWithFormat:@"有效期截止时间为:%@",endString];
    [self.view addSubview:label1];

    NSArray *title_A = @[@"延长期限"];
    NSArray *placehodel_A = @[@"选择延长期限"];

    for (int i = 0; i <title_A.count; i ++) {
        
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, label1.bottom+i*(44+1), SCREENWIDTH, 44)];
        myView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:myView];

        UILabel *Label = [[UILabel alloc]initWithFrame:CGRectMake(20, myView.top, 70, 44)];
        Label.font = [UIFont systemFontOfSize:16];
        Label.text = title_A[i];
        [self.view addSubview:Label];
        
        
        UITextField *Text = [[UITextField alloc]initWithFrame:CGRectMake(100,  myView.top, SCREENWIDTH-130, 44)];
        Text.placeholder = placehodel_A[i];
        Text.textColor = RGB(17,141,240);
        Text.font = [UIFont systemFontOfSize:16];
        Text.delegate = self;
        [self.view addSubview:Text];
        Text.userInteractionEnabled = NO;

        if (i==0) {
        self.startText = Text;

        }
        if (i==1) {
            self.endText = Text;
            
        }

        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = Text.frame;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.view addSubview:button];
        
        
        
    }

    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 45*title_A.count+5+label1.bottom, SCREENWIDTH, 20)];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"注:申请时间内,您的会员卡将处于锁定状态,暂时不能使用";
    label.textColor = RGB(51,51,51);
    
    [self.view addSubview:label];
    
    UIButton *CreatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CreatBtn.frame = CGRectMake(12, label.bottom +37, SCREENWIDTH-24, 50);
    [CreatBtn setTitle:@"立即申请" forState:UIControlStateNormal];
    [CreatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    CreatBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [CreatBtn setBackgroundColor:NavBackGroundColor];
    CreatBtn.layer.cornerRadius = 5;
    [CreatBtn addTarget:self action:@selector(okRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:CreatBtn];
    
    
  

//    [self.view addSubview:self.toolbarCancelDone];
//    self.toolbarCancelDone.hidden = YES;
    [self _inittable];

}
- (void)okRequest
{
    //判断结束日期是否在开始日期之后
    
//    int result = [self compareDate:self.startText.text withDate:self.endText.text];
    
    if([self.startText.text isEqualToString:@""])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请选择延长期限", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        //    [hud setColor:[UIColor blackColor]];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        hud.userInteractionEnabled = YES;
        
        [hud hideAnimated:YES afterDelay:4.f];
    }
//        else if([self.endText.text isEqualToString:@""])
//    {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.label.text = NSLocalizedString(@"请选择结束日期", @"HUD message title");
//        hud.label.font = [UIFont systemFontOfSize:13];
//        //    [hud setColor:[UIColor blackColor]];
//        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
//        hud.userInteractionEnabled = YES;
//        
//        [hud hideAnimated:YES afterDelay:4.f];
//    }else if (result==-1||result==0) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.label.text = NSLocalizedString(@"请选择合适的结束日期", @"HUD message title");
//        hud.label.font = [UIFont systemFontOfSize:13];
//        //    [hud setColor:[UIColor blackColor]];
//        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
//        hud.userInteractionEnabled = YES;
//        
//        [hud hideAnimated:YES afterDelay:4.f];
//        
//    }

    // Set the annular determinate mode to show task progress.
    
    
    else {
        [self postRequestDelay];
        
        
    }
    
    
    
}
-(void)postRequestDelay
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/postpone/app",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [params setObject:self.card_dic[@"merchant"] forKey:@"muid"];
    [params setObject:self.card_dic[@"card_code"] forKey:@"card_code"];
    [params setObject:self.card_dic[@"card_level"] forKey:@"card_level"];
    [params setObject:self.card_dic[@"card_type"] forKey:@"card_type"];
    [params setObject:[self.deadLine_dic objectForKey:self.startText.text] forKey:@"postpone"];
    
//    [params setObject:self.endText.text forKey:@"date_end"];
  
    
    NSLog(@"========%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
                if ([result[@"result_code"] intValue]==1) {
                    hud.label.text = NSLocalizedString(@"延期成功", @"HUD message title");

                    hud.label.font = [UIFont systemFontOfSize:13];
                    //    [hud setColor:[UIColor blackColor]];
                    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                    hud.userInteractionEnabled = YES;
                    
                    [hud hideAnimated:YES afterDelay:4.f];

                }else if ([result[@"result_code"] intValue]==1062){
                    
                    hud.label.text = NSLocalizedString(@"已申请,不能重复申请", @"HUD message title");
                    
                    hud.label.font = [UIFont systemFontOfSize:13];

                    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                    hud.userInteractionEnabled = YES;
                    
                    [hud hideAnimated:YES afterDelay:2.f];

                }else{
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


-(void)buttonClick:(UIButton*)sender{
    
//    [self show];
//    index_=sender.tag;
    
    {
        
        self.pickerView.dataSource =self.deadLine_A;
        __weak typeof(self) weakSelf= self;
        
        self.pickerView.valueDidSelect = ^(NSString *value){
            
            NSLog(@"------------%@",value);
            weakSelf.startText.text = [[value componentsSeparatedByString:@"/"] firstObject];
            
        };
        
        
        [self.pickerView show];
        
        
    }

    
   
}

-(void)sacnClcik{
    
    DelayScanVC *VC = [[DelayScanVC alloc]init];
    VC.muid = self.card_dic[@"merchant"];
    
    [self.navigationController pushViewController:VC animated:YES];
    
}
-(NSArray*)deadLine_A{
    if (!_deadLine_A) {
        _deadLine_A = @[@"半年",@"一年",@"两年",@"三年",@"无限期"];
    }
    return _deadLine_A;
}
-(NSDictionary *)deadLine_dic{
    if (!_deadLine_dic) {
        _deadLine_dic = @{@"半年":@"0.5",@"一年":@"1",@"两年":@"2",@"三年":@"3",@"无限期":@"0"};
    }
    
    return _deadLine_dic;
}

@end
