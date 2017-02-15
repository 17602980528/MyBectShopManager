//
//  OrderViewController.m
//  BletcShop
//
//  Created by Bletc on 16/5/19.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "OrderViewController.h"
#import "ValuePickerView.h"
#import "AppointStateViewController.h"
@interface OrderViewController ()
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
    
    UIView *_contentView;
    
}
@property (nonatomic, strong) ValuePickerView *pickerView;

@end

@implementation OrderViewController

-(void)checkClick{
    AppointStateViewController *stateVC=[[AppointStateViewController alloc]init];
    stateVC.dic=self.card_dic;
    [self.navigationController pushViewController:stateVC animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要预约";
    self.pickerView = [[ValuePickerView alloc]init];

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREENWIDTH-75, 0, 60, 40);
    [button setTitle:@"查看" forState:0];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [button addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    

    self.timeArray = [[NSMutableArray alloc]initWithObjects:@"09:00-10:00",@"10:00-11:00",@"11:00-12:00",@"12:00-13:00",@"13:00-14:00",@"14:00-15:00",@"15:00-16:00",@"16:00-17:00",@"17:00-18:00", nil];
    self.view.backgroundColor = RGB(240, 240, 240);
    [self initOderView];
    [self _inittable];

}
-(void)initOderView
{
    
    NSArray *title_A = @[@"预约项目",@"预约日期",@"预约时间"];
    NSArray *placehodel_A = @[@"选择预约项目",@"选择预约日期",@"选择预约时间"];

   
    for (int i =0; i <3; i++) {
        
        
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 10+i*(44+1), SCREENWIDTH, 44)];
        myView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:myView];
        
        UILabel *lbel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 70, 44)];
        lbel.font = [UIFont systemFontOfSize:16];
        lbel.text = title_A[i];
        [myView addSubview:lbel];

        UITextField *orderClassLabel1 = [[UITextField alloc]initWithFrame:CGRectMake(100, 10+i*(44+1), 200, 44)];
        orderClassLabel1.font = [UIFont systemFontOfSize:16];
        [orderClassLabel1 setTextAlignment:NSTextAlignmentLeft];
        orderClassLabel1.placeholder = placehodel_A[i];
        orderClassLabel1.userInteractionEnabled = NO;
        orderClassLabel1.textColor = RGB(17,141,240);
        [self.view addSubview:orderClassLabel1];
        
        if (i==0) {
            self.orderClassLable = orderClassLabel1;
        }
        if (i==1) {
            self.orderDateLable = orderClassLabel1;
        }
        if (i==2) {
            self.orderTimeLable = orderClassLabel1;
        }

        
       
        
        
        UIImageView *imgView3 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-20, (44-15)/2, 7.5, 15)];
        imgView3.image = [UIImage imageNamed:@"arraw_right"];
        [myView addSubview:imgView3];
        
        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        Btn.frame = CGRectMake(0, 0, myView.width, myView.height);
        Btn.tag = i;
        [Btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [myView addSubview:Btn];

        
        
    }
    
    
    
    UIButton *CreatBtnOK = [UIButton buttonWithType:UIButtonTypeCustom];
    CreatBtnOK.frame = CGRectMake(12, 45*3+100, SCREENWIDTH-24, 50);
    [CreatBtnOK setTitle:@"提交预约" forState:UIControlStateNormal];
    [CreatBtnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CreatBtnOK.titleLabel.font = [UIFont systemFontOfSize:18];
    [CreatBtnOK setBackgroundColor:NavBackGroundColor];
    CreatBtnOK.layer.cornerRadius = 5;
    [CreatBtnOK addTarget:self action:@selector(creatActionOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:CreatBtnOK];

}

-(void)btnClick:(UIButton*)sender{
    
    if (sender.tag == 0) {
        [self choiceOrderClass];
    }
    if (sender.tag == 1) {
        [self choiceOrderDate];
    }
    if (sender.tag == 2) {
        [self choiceOrderTime];
    }

}
-(void)creatActionOrder
{
    if([self.orderClassLable.text isEqualToString:@""]||[self.orderClassLable.text isEqualToString:@"(null)"]||self.orderClassLable.text==nil)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请选择预约项目", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:15];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
    }else if([self.orderDateLable.text isEqualToString:@""]||[self.orderDateLable.text isEqualToString:@"(null)"]||self.orderDateLable.text==nil)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请选择预约日期", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
    }else if([self.orderTimeLable.text isEqualToString:@""]||[self.orderTimeLable.text isEqualToString:@"(null)"]||self.orderTimeLable.text==nil)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请选择预约时间", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
    }
    else
    {
        NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/appoint/app",BASEURL];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        [params setObject:self.card_dic[@"merchant"] forKey:@"muid"];
        [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
        [params setObject:appdelegate.userInfoDic[@"phone"] forKey:@"phone"];
        [params setObject:appdelegate.userInfoDic[@"nickname"] forKey:@"name"];

        [params setObject:self.orderClassLable.text forKey:@"content"];
        [params setObject:self.orderDateLable.text forKey:@"date"];
        [params setObject:self.orderTimeLable.text forKey:@"time"];

        
        NSLog(@"pareme = %@", params);

        [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            

            if ([result[@"result_code"] intValue]==1) {
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                
                hud.label.text = NSLocalizedString(@"预约成功", @"HUD message title");
                hud.label.font = [UIFont systemFontOfSize:13];
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                [hud hideAnimated:YES afterDelay:3.f];
                

            }
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@", error);
            
        }];
    }

}
-(void)choiceOrderDate
{


        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        _contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCancleClick)];
    [_contentView addGestureRecognizer:tap];

        self.customPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 160)] ;
        self.customPicker.backgroundColor = [UIColor whiteColor];
        
        self.toolbarCancelDone = [[UIToolbar alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH,40)];
        self.customPicker.delegate = self;
        self.customPicker.dataSource = self;
        
        [_contentView addSubview:self.customPicker];
        [_contentView addSubview:self.toolbarCancelDone];

       
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
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelBtn addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
        [self.toolbarCancelDone addSubview:cancelBtn];
        
        
        [self.customPicker selectRow:[yearArray indexOfObject:currentyearString] inComponent:0 animated:NO];
        
        
        [self.customPicker selectRow:[monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];
        
       
        
        [[[UIApplication sharedApplication].delegate window]addSubview:_contentView];
        
        CGRect frame = self.customPicker.frame;
        if (frame.origin.y == SCREENHEIGHT) {
            frame.origin.y -= 160;
            [UIView animateWithDuration:0.3 animations:^{
                self.customPicker.frame = frame;
                self.toolbarCancelDone.frame = CGRectMake(0, SCREENHEIGHT-200, SCREENWIDTH, 40);
                
            }];
        }



}
-(void)choiceOrderTime
{
    if (self.timeArray.count>0) {
        
            self.pickerView.dataSource =self.timeArray;
            
            __weak typeof(self) weakSelf = self;
            self.pickerView.valueDidSelect = ^(NSString *value){
                NSArray * stateArr = [value componentsSeparatedByString:@"/"];
                weakSelf.orderTimeLable.text= stateArr[0];
            };
            
            [self.pickerView show];
            

    
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"暂无可预约时间", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
    }

}

-(void)choiceOrderClass
{
    if (self.allClassArray.count>0) {
        
            NSMutableArray *muta_A = [NSMutableArray array];
            for (NSDictionary *dic in self.allClassArray) {
                [muta_A addObject:dic[@"name"]];
                
            }
            
            self.pickerView.dataSource =muta_A;

            __weak typeof(self) weakSelf = self;
            self.pickerView.valueDidSelect = ^(NSString *value){
                NSArray * stateArr = [value componentsSeparatedByString:@"/"];
                weakSelf.orderClassLable.text= stateArr[0];
            };
            
            [self.pickerView show];
            

    
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"暂无可预约项目", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];

    }
    
    
}

- (void)actionCancel
{
    [self removeSelfFromSupView];

}
- (void)actionDone
{
    
    self.orderDateLable.text = [NSString stringWithFormat:@"%@-%@-%@",[yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]],[monthArray objectAtIndex:[self.customPicker selectedRowInComponent:1]],[DaysArray objectAtIndex:[self.customPicker selectedRowInComponent:2]]];
    
    [self removeSelfFromSupView];

    
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

-(void)_inittable
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
    

    // 设置初始默认值
    [self.customPicker selectRow:0 inComponent:0 animated:YES];
    
    // [pickerView selectRow:30 inComponent:0 animated:NO];
    
    [self.customPicker selectRow:[monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];
    
    [self.customPicker selectRow:0 inComponent:2 animated:YES];
    
    
    
    
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

@end
