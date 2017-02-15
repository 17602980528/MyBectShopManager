//
//  AdvertViewController.m
//  BletcShop
//
//  Created by Bletc on 16/4/19.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "AdvertViewController.h"
@interface AdvertViewController ()
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
    //选城市tableview
    UITableView *cityAreaTableView;
}
@end

@implementation AdvertViewController
{
    UIToolbar *toolView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.ifoneView = NO;
    self.ifTextYear = NO;
    self.ifArea = NO;
    self.ifPlace = NO;
    self.title = @"广告推送";
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.areaArray = appdelegate.areaListArray;//@[@"高新区",@"雁塔区",@"碑林区",@"新城区"];
    self.placeArray = @[@"第一位",@"第二位",@"第三位",@"第四位"];
    self.view.backgroundColor = tableViewBackgroundColor;
    self.onLineDay = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
    self.onLineHour = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24"];
    [self _initUI];
    
    toolView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    [toolView setBarStyle:UIBarStyleBlackTranslucent];
    toolView.barTintColor=[UIColor whiteColor];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btna = [UIButton buttonWithType:UIButtonTypeCustom];
    [btna setTitle:@"收回" forState:UIControlStateNormal];
    [btna setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btna.frame = CGRectMake(2, 5, 50, 25);
    [btna addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btna];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [toolView setItems:buttonsArray];
}
-(void)_initUI
{
    UIScrollView *BjSc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 160)];
    //选择区域
    UIView *quyuView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 50)];
    quyuView.backgroundColor = [UIColor whiteColor];
    [BjSc addSubview:quyuView];
    UILabel *choiceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 70, 40)];
    choiceLabel.text = @"选择区域:";
    choiceLabel.font = [UIFont systemFontOfSize:13];
    [quyuView addSubview:choiceLabel];
    //高新区 雁塔区
    UILabel *quyuLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 10, 80, 30)];
    quyuLabel.layer.borderWidth = 0.3;
    quyuLabel.textAlignment = NSTextAlignmentCenter;
    self.quyuLabel=quyuLabel;
    quyuLabel.text = @"高新区";
    if (self.areaArray.count>0) {
        quyuLabel.text=self.areaArray[0];
    }
    NSLog(@"%@",self.areaArray);
    quyuLabel.font = [UIFont systemFontOfSize:13];
    [quyuView addSubview:quyuLabel];
    
    UIButton *choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    choiceBtn.frame = CGRectMake(65, 0, 220, 50);
//        choiceBtn.backgroundColor = [UIColor redColor];
    [choiceBtn setImage:[UIImage imageNamed:@"arraw_right"] forState:UIControlStateNormal];
    [choiceBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateSelected];
    [choiceBtn addTarget:self action:@selector(choiceAreaAction) forControlEvents:UIControlEventTouchUpInside];
    //    self.boyBtn = boyBtn;
    [quyuView addSubview:choiceBtn];
    //
    NSArray *array=@[@"欢迎页广告",@"首页广告",@"搜索页广告"];
    UISegmentedControl *segmentControl=[[UISegmentedControl alloc]initWithItems:array];
    //设置位置 大小
    segmentControl.frame=CGRectMake(0, 70, SCREENWIDTH, 80);
    //默认选择
    segmentControl.selectedSegmentIndex=0;
    //设置背景色
    //segmentControl.backgroundColor = [UIColor grayColor];
    segmentControl.tintColor=[UIColor orangeColor];
    self.segmentControl = segmentControl;

    [self.segmentControl addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
            
    [BjSc addSubview:segmentControl];
    [self.view addSubview:BjSc];
    BjSc.bounces = NO;
    BjSc.showsVerticalScrollIndicator = NO;
    self.Bjsc = BjSc;
    self.myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 160, SCREENWIDTH, SCREENHEIGHT-170-64)];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    [self.view addSubview:self.myTableView];
    [self _inittable];
  
    [self creatPickView];
    [self creatOnLinePickView];


}
/**
 *  欢迎页上线日期选择器
 */

-(void)creatPickView{
    self.customPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-160-64, SCREENWIDTH, 160)] ;
    self.customPicker.backgroundColor = [UIColor lightGrayColor];
    self.customPicker.tag = 1001;
    self.customPicker.delegate = self;
    self.customPicker.dataSource = self;
    
    self.toolbarCancelDone = [[UIToolbar alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-200-64, SCREENWIDTH, 40)];
    
    _toolbarCancelDone.hidden = YES;
    _customPicker.hidden = YES;
    
    [self.view addSubview: self.customPicker];
    [self.view addSubview:self.toolbarCancelDone];
    
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
 
}
/**
 *  欢迎页,在线时间选择器
 */
-(void)creatOnLinePickView{
    
    self.customPickerOnLine = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-160-64, SCREENWIDTH, 160)] ;
    self.customPickerOnLine.backgroundColor = [UIColor lightGrayColor];
    self.customPickerOnLine.tag = 1002;
    self.customPickerOnLine.delegate = self;
    self.customPickerOnLine.dataSource = self;
    self.toolbarCancelDoneOnLine = [[UIToolbar alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-200-64, SCREENWIDTH, 40)];
    [self.view addSubview: self.customPickerOnLine];
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREENWIDTH-60, 0, 60, 40);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    //[okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [okBtn addTarget:self action:@selector(actionDone) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbarCancelDoneOnLine addSubview:okBtn];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 60, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbarCancelDoneOnLine addSubview:cancelBtn];
    
    [self.view addSubview:self.toolbarCancelDoneOnLine];
    
    _toolbarCancelDoneOnLine.hidden  = YES;
    _customPickerOnLine.hidden = YES;
}
/**
 *  初始化日期数据
 */
-(void)_inittable
{
    
    m=0;
       NSDate *date = [NSDate date];
    
    // Get Current Year
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    
    NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    year =[currentyearString intValue];
    
    
    [formatter setDateFormat:@"MM"];
    
    currentMonthString = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    month=[currentMonthString intValue];
    
    
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
    
    
    monthArray = @[@"0",@"1",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    [monthMutableArray addObjectsFromArray:monthArray];
    [monthMutableArray removeObjectAtIndex:0];
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


-(void)choiceAreaAction
{
    if (_ifArea == NO) {

        cityAreaTableView=[[UITableView alloc]initWithFrame:CGRectMake(75, 50, 80, 300) style:UITableViewStylePlain];
        cityAreaTableView.bounces=NO;
        cityAreaTableView.showsVerticalScrollIndicator=NO;
        cityAreaTableView.dataSource=self;
        cityAreaTableView.delegate=self;
        [self.view addSubview:cityAreaTableView];
        if (self.areaArray.count==0) {
            cityAreaTableView.frame = CGRectMake(75, 50, 80, 0);
        }
        _ifArea = YES;
    }
    else
    {
        _ifArea = NO;
        [cityAreaTableView removeFromSuperview];
    }
    
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
            pickerLabel.text =  [monthMutableArray objectAtIndex:row];  // Month
        }
        else if (component == 2)
        {
            pickerLabel.text =  [DaysArray objectAtIndex:row]; // Date
            
        }
        
        
        return pickerLabel;
    }
    else if (pickerView.tag == 1002) {
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
            pickerLabel.text =  [monthArray objectAtIndex:row]; // Year
        }
        else if (component == 1)
        {
            pickerLabel.text =  [self.onLineDay objectAtIndex:row];  // Month
        }
        else if (component == 2)
        {
            pickerLabel.text =  [self.onLineHour objectAtIndex:row]; // Date
            
        }
        
        
        return pickerLabel;
    }

    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
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
    if (pickerView.tag==1001) {
        if (component == 0)
        {
            return [yearArray count];
            
        }
        else if (component == 1)
        {
            NSInteger selectRow =  [pickerView selectedRowInComponent:0];
            int n;
            n= year-1970;
//            NSLog(@"=year==%d==%ld",n,selectRow);
            if (selectRow==n) {
                return [monthArray count];
            }else
            {
                return [monthMutableArray count];
                
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

    }else if (pickerView.tag==1002)
    {
        if (pickerView.tag==1002) {
            if (component == 0)
            {
                return [monthArray count];
                
            }
            else if (component == 1)
            {
                return self.onLineDay.count;
            }
            else
            {
                return self.onLineHour.count;
            }
        }

    }else if (pickerView.tag == 10001)
    {
        return self.placeArray.count;//广告位
    }

    return self.areaArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    if (pickerView.tag == 10001)
    {
        return self.placeArray[row];//广告位
    }

    return self.areaArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag==1001) {
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

    }else if (pickerView.tag==1002) {
        m=row;
        
        
        
        if (component == 0)
        {
            selectedMonthRowOnLine = row;
            [self.customPicker reloadAllComponents];
        }
        else if (component == 1)
        {
            selectedDayRowOnLine = row;
            [self.customPicker reloadAllComponents];
        }
        else if (component == 2)
        {
            selectedHourRowOnLine = row;
            
            [self.customPicker reloadAllComponents];
            
        }
        
    }else if(pickerView.tag ==10001)
    {
        _place_lab.text = self.placeArray[row];
//        self.placeLabel.text = self.placeArray[row];
//        [self.placePickerView removeFromSuperview];
//        _ifPlace =NO;
        
    }

    else
    {
    self.quyuLabel.text = self.areaArray[row];
    self.quyuString =self.areaArray[row];
    [self.pickerView removeFromSuperview];
    _ifArea = NO;
    [self.view reloadInputViews];
    }
    //    [self.alertView ];
    //    self.clerkLabel.text =@"";
    //    [self.myTable reloadData];
}


-(void)valueChange:(UISegmentedControl*)sender

{
    NSLog(@"===%ld",sender.selectedSegmentIndex);
    [self actionCancel];
    [self.myTableView reloadData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.myTableView) {
        if (self.segmentControl.selectedSegmentIndex ==1 ){
            return 3;
        }
        else if(self.segmentControl.selectedSegmentIndex ==0)
        {
            return 1;
        }
        else
            return 4;
    }else if (tableView==cityAreaTableView){
        return self.areaArray.count;
    }
    return 0;
    
}
//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.myTableView) {
        if (self.segmentControl.selectedSegmentIndex ==0)
        {
            
            return 300;
        }
        else return 40;
    }else if (tableView==cityAreaTableView){
        return 35;
    }
    return 0;
    
}

/**
 *  pickView上的取消按钮
 */
- (void)actionCancel
{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _customPicker.hidden = YES;
        _toolbarCancelDone.hidden = YES;
        
        self.customPickerOnLine.hidden = YES;
        self.toolbarCancelDoneOnLine.hidden = YES;
        

    }];

    
}
- (void)actionDone
{
    if(self.ifTextYear&&!self.ifoneView)
    {
        if ([self.startText.text isEqualToString:@""]) {
            self.startText.text = [NSString stringWithFormat:@"%@-%@-%@",[yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]],[monthMutableArray objectAtIndex:[self.customPicker selectedRowInComponent:1]],[DaysArray objectAtIndex:[self.customPicker selectedRowInComponent:2]]];
        }
    }
    else if(!self.ifTextYear&&!self.ifoneView){
        self.onLionText.text = [NSString stringWithFormat:@"%@个月%@天%@小时",[monthArray objectAtIndex:[self.customPickerOnLine selectedRowInComponent:0]],[_onLineDay objectAtIndex:[self.customPickerOnLine selectedRowInComponent:1]],[_onLineHour objectAtIndex:[self.customPickerOnLine selectedRowInComponent:2]]];
    }
    else if(self.ifTextYear&&self.ifoneView)
    {
        if ([self.startText1.text isEqualToString:@""]) {
            self.startText1.text = [NSString stringWithFormat:@"%@-%@-%@",[yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]],[monthMutableArray objectAtIndex:[self.customPicker selectedRowInComponent:1]],[DaysArray objectAtIndex:[self.customPicker selectedRowInComponent:2]]];
        }
    }
    else if(!self.ifTextYear&&self.ifoneView){
        self.onLionText1.text = [NSString stringWithFormat:@"%@个月%@天%@小时",[monthArray objectAtIndex:[self.customPickerOnLine selectedRowInComponent:0]],[_onLineDay objectAtIndex:[self.customPickerOnLine selectedRowInComponent:1]],[_onLineHour objectAtIndex:[self.customPickerOnLine selectedRowInComponent:2]]];
    }
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.customPicker.hidden = YES;
                         self.toolbarCancelDone.hidden = YES;
                         self.customPickerOnLine.hidden = YES;
                         self.toolbarCancelDoneOnLine.hidden = YES;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIPickerView class]]||[view isKindOfClass:[UIToolbar class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (UIView *view in self.demoView.subviews) {
        if ([view isKindOfClass:[UIPickerView class]]||[view isKindOfClass:[UIToolbar class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (textField.tag == 2001) {
        self.startText.text = @"";
        
        _customPickerOnLine.hidden = YES;
        _toolbarCancelDoneOnLine.hidden = YES;
        
        self.ifTextYear = YES;
        self.ifoneView = NO;
        

        
        [self creatPickView];
        
        self.customPicker.hidden = NO;
        self.toolbarCancelDone.hidden = NO;
    }else if (textField.tag == 101) {
        self.startText1.text = @"";
        _customPickerOnLine.hidden = YES;
        _toolbarCancelDoneOnLine.hidden = YES;

        self.ifTextYear = YES;
        self.ifoneView = YES;
        
        self.customPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.demoView.height-80, self.demoView.width, 90)] ;
        self.customPicker.backgroundColor = [UIColor lightGrayColor];
        self.customPicker.tag = 1001;
        self.customPicker.delegate = self;
        self.customPicker.dataSource = self;
        self.toolbarCancelDone = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.demoView.height-120, self.demoView.width, 40)];
        [self.demoView addSubview: self.customPicker];
        
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        okBtn.frame = CGRectMake(self.demoView.width-60, 0, 60, 40);
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
        
        [self.demoView addSubview:self.toolbarCancelDone];
        self.customPicker.hidden = NO;
        self.toolbarCancelDone.hidden = NO;
    }
    else if(textField.tag == 102)
    {
        self.onLionText1.text = @"";
        
        [self.customPicker setHidden: YES];
        [self.toolbarCancelDone setHidden: YES];
        self.ifTextYear = NO;
        self.ifoneView = YES;
        self.customPickerOnLine = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.demoView.height-80, self.demoView.width, 90)] ;
        self.customPickerOnLine.backgroundColor = [UIColor lightGrayColor];
        self.customPickerOnLine.tag = 1002;
        self.customPickerOnLine.delegate = self;
        self.customPickerOnLine.dataSource = self;
        self.toolbarCancelDoneOnLine = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.demoView.height-120, self.demoView.width, 40)];
        [self.demoView addSubview: self.customPickerOnLine];
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        okBtn.frame = CGRectMake(self.demoView.width-60, 0, 60, 40);
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        //[okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [okBtn addTarget:self action:@selector(actionDone) forControlEvents:UIControlEventTouchUpInside];
        [self.toolbarCancelDoneOnLine addSubview:okBtn];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, 60, 40);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelBtn addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
        [self.toolbarCancelDoneOnLine addSubview:cancelBtn];
        
        [self.demoView addSubview:self.toolbarCancelDoneOnLine];
        self.customPickerOnLine.hidden = NO;
        self.toolbarCancelDoneOnLine.hidden = NO;
    }else if (textField.tag == 2002) {

        self.onLionText.text = @"";
        self.customPicker.hidden = YES;
        self.toolbarCancelDone.hidden = YES;
        
        self.ifoneView = NO;
        self.ifTextYear = NO;
        
        [self creatOnLinePickView];
        
        self.customPickerOnLine.hidden = NO;
        self.toolbarCancelDoneOnLine.hidden = NO;

    }
    if ([textField isEqual:self.startText]||[textField isEqual:self.onLionText]||[textField isEqual:self.startText1]||[textField isEqual:self.onLionText1]||[textField isEqual:self.startText2]||[textField isEqual:self.onLionText2]) {
        return NO;
    }else
        return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return  YES;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.myTableView) {
        static NSString *cellIndentifier = @"cellIndentifier";
        // 定义唯一标识
        // 通过indexPath创建cell实例 每一个cell都是单独的
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.segmentControl.selectedSegmentIndex ==0) {
            UILabel *shangjiaLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 60, 30)];
            shangjiaLabel.text = @"上线日期";
            shangjiaLabel.font = [UIFont systemFontOfSize:13];
            [cell addSubview:shangjiaLabel];
            UITextField *shangjiaText = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, 120, 30)];
            shangjiaText.text = @"";
            shangjiaText.layer.borderWidth = 0.3;
            shangjiaText.delegate = self;
            shangjiaText.tag = 2001;
            self.startText = shangjiaText;
            
            shangjiaText.font = [UIFont systemFontOfSize:13];
            [cell addSubview:shangjiaText];
            
            UIView *lineLevel = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
            lineLevel.backgroundColor = [UIColor grayColor];
            lineLevel.alpha = 0.3;
            [cell addSubview:lineLevel];
            //在线时间
            UILabel *zaixianLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 60, 30)];
            zaixianLabel.text = @"在线时间";
            zaixianLabel.font = [UIFont systemFontOfSize:13];
            [cell addSubview:zaixianLabel];
            UITextField *zaixianText = [[UITextField alloc]initWithFrame:CGRectMake(90, 60, 120, 30)];
            zaixianText.text = @"";
            zaixianText.layer.borderWidth = 0.3;
            zaixianText.delegate = self;
            zaixianText.tag = 2002;
            self.onLionText = zaixianText;
            zaixianText.font = [UIFont systemFontOfSize:13];
            
            
            [cell addSubview:zaixianText];
            UIView *lineLevel11 = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 0.3)];
            lineLevel11.backgroundColor = [UIColor grayColor];
            lineLevel11.alpha = 0.3;
            [cell addSubview:lineLevel11];
            UILabel *imageLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 110, 60, 30)];
            imageLabel.text = @"上传图片:";
            imageLabel.font = [UIFont systemFontOfSize:13];
            [cell addSubview:imageLabel];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(90, 110, 100, 100)];
            imageView.image = [UIImage imageNamed:@"点击-04"];
            //imageView.backgroundColor = [UIColor grayColor];
            self.imageView = imageView;
            [cell addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choicePicture)];
            [imageView addGestureRecognizer:tapGesture];
            UIView *lineLevel1 = [[UIView alloc]initWithFrame:CGRectMake(0, 220, SCREENWIDTH, 0.3)];
            lineLevel1.backgroundColor = [UIColor grayColor];
            lineLevel1.alpha = 0.3;
            [cell addSubview:lineLevel1];
            //确定按钮
            UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            okBtn.frame = CGRectMake(SCREENWIDTH/3, 250, SCREENWIDTH/3, 35);
            okBtn.backgroundColor = ButtonGreenColor;
            okBtn.layer.cornerRadius = 10;
            [okBtn setTitle:@"提交申请" forState:UIControlStateNormal];
            [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [okBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [okBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:okBtn];
            
        }
        else if(self.segmentControl.selectedSegmentIndex ==1)
        {
            NSArray *advArr = @[@"一级广告(3)",@"二级广告(8)",@"三级广告(10)"];
            UILabel *advLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 100, 30)];
            advLabel.text = [advArr objectAtIndex:indexPath.row];;
            advLabel.font = [UIFont systemFontOfSize:13];
            [cell addSubview:advLabel];
            UIView *lineAdv = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 0.3)];
            lineAdv.backgroundColor = [UIColor grayColor];
            lineAdv.alpha = 0.3;
            [cell addSubview:lineAdv];
        }
        else
        {
            NSArray *advArr = @[@"默认推送(10)",@"优惠推送(10)",@"区域搜索推送(10)",@"商圈推送(10)"];
            UILabel *advLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 120, 30)];
            advLabel.text = [advArr objectAtIndex:indexPath.row];;
            advLabel.font = [UIFont systemFontOfSize:13];
            [cell addSubview:advLabel];
            UIView *lineAdv = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 0.3)];
            lineAdv.backgroundColor = [UIColor grayColor];
            lineAdv.alpha = 0.3;
            [cell addSubview:lineAdv];
        }
        return cell;
        
    }else if (tableView==cityAreaTableView){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.textLabel.font=[UIFont systemFontOfSize:13.0f];
        if (self.areaArray.count>0) {
            cell.textLabel.text=self.areaArray[indexPath.row];
        }
        return cell;
    }
    return nil;
}
/**
 *  提交申请
 */
-(void)submitAction
{
    [self postRequestSubmit];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.myTableView) {
        if(self.segmentControl.selectedSegmentIndex ==1)
        {
            switch (indexPath.row) {
                case 0:
                    _indexPathRow =1;
                    [self NewAddVipAction];
                    break;
                case 1:
                    _indexPathRow =2;
                    [self NewAddVipAction];
                    break;
                case 2:
                    _indexPathRow =3;
                    [self NewAddVipAction];
                    break;
                    
                default:
                    break;
            }
        }
        else if(self.segmentControl.selectedSegmentIndex ==2)
        {
            switch (indexPath.row) {
                case 0:
                    _indexPathRow =4;
                    [self NewAddVipAction];
                    break;
                case 1:
                    _indexPathRow =5;
                    [self NewAddVipAction];
                    break;
                case 2:
                    _indexPathRow =6;
                    [self NewAddVipAction];
                    break;
                case 3:
                    _indexPathRow =7;
                    [self NewAddVipAction];
                    break;
                    
                default:
                    break;
            }
            
        }
        
    }else if (tableView==cityAreaTableView){
        self.quyuLabel.text=self.areaArray[indexPath.row];
        _ifArea = NO;
        [cityAreaTableView removeFromSuperview];
        
    }
}
-(void)choicePicture
{
    UIActionSheet *sheet;
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
        self.alertView.hidden = YES;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}
//点击选取按钮触发事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.alertView.hidden = NO;
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
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *photoName =[NSString stringWithFormat:@"%@_%@.png",appdelegate.shopInfoDic[@"name"],appdelegate.shopInfoDic[@"phone"]];

    [self saveImage:image withName:photoName];

    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:photoName];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    _isFullScreen = NO;
    [self.imageView setImage:savedImage];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/upload/upload",BASEURL];
  
    
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    [parmer setValue:photoName forKey:@"name"];

    
    if (_indexPathRow==1) {
        [parmer setValue:@"advert1" forKey:@"type"];

    }
    else{
        [parmer setValue:@"wellcome" forKey:@"type"];

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
        }
        NSLog(@"result===%@", result);
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"error-----%@",error.description);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"图片太大,上传失败", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:4.f];
        
    }];

    
}
//- (void)requestFailed:(ASIHTTPRequest *)request {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.frame = CGRectMake(0, 64, 375, 667);
//    // Set the annular determinate mode to show task progress.
//    hud.mode = MBProgressHUDModeText;
//    hud.label.text = NSLocalizedString(@"图片太大,上传失败", @"HUD message title");
//    hud.label.font = [UIFont systemFontOfSize:13];
//    // Move to bottm center.
//    //    hud.offset = CGPointMake(0.f, );
//    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
//    [hud hideAnimated:YES afterDelay:4.f];
//    NSLog(@"请求失败");
//}
//
//- (void)requestFinished:(ASIHTTPRequest *)request {
//
//        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
//        
//        NSLog(@"%@", dic);
//
//}
-(void)postImage
{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *photoName =[NSString stringWithFormat:@"%@_%@.png",appdelegate.shopInfoDic[@"name"],appdelegate.shopInfoDic[@""]];
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/upload/upload",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //[params setObject:data forKey:@"file1"];
    [params setObject:photoName forKey:@"name"];
    [params setObject:@"advert1" forKey:@"type"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         
         NSLog(@"%@", result);
         
         
         if ([result[@"result_code"] isEqualToString:@"access"]) {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.frame = CGRectMake(0, 64, 375, 667);
             // Set the annular determinate mode to show task progress.
             hud.mode = MBProgressHUDModeText;
             
             hud.label.text = NSLocalizedString(@"添加成功", @"HUD message title");
             hud.label.font = [UIFont systemFontOfSize:13];
             // Move to bottm center.
             //    hud.offset = CGPointMake(0.f, );
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             [hud hideAnimated:YES afterDelay:4.f];
             //            [self.TabSc reloadData];
         }
         else
         {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.frame = CGRectMake(0, 64, 375, 667);
             // Set the annular determinate mode to show task progress.
             hud.mode = MBProgressHUDModeText;
             
             hud.label.text = NSLocalizedString(@"添加出错,请重新添加", @"HUD message title");
             hud.label.font = [UIFont systemFontOfSize:13];
             // Move to bottm center.
             //    hud.offset = CGPointMake(0.f, );
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             [hud hideAnimated:YES afterDelay:4.f];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@", error);
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         hud.frame = CGRectMake(0, 64, 375, 667);
         // Set the annular determinate mode to show task progress.
         hud.mode = MBProgressHUDModeText;
         
         hud.label.text = NSLocalizedString(@"添加出错,请重新添加", @"HUD message title");
         hud.label.font = [UIFont systemFontOfSize:13];
         // Move to bottm center.
         //    hud.offset = CGPointMake(0.f, );
         hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
         [hud hideAnimated:YES afterDelay:4.f];
         
     }];

}
-(void)postImage:(NSString *)pathFile andName:(NSString *)name
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/upload/upload",BASEURL];
    //NSData *data =[pathFile dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:pathFile forKey:@"file1"];
    [params setObject:name forKey:@"name"];
    [params setObject:@"advert1" forKey:@"type"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
    {
        
        NSLog(@"%@", result);
        
        
        if ([result[@"result_code"] isEqualToString:@"access"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"添加成功", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:4.f];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"添加出错,请重新添加", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            // Move to bottm center.
            //    hud.offset = CGPointMake(0.f, );
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:4.f];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"添加出错,请重新添加", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:4.f];
        
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
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [imageData writeToFile:fullPath atomically:NO];

//    NSData *imageData1 = [self replaceNoUtf8:imageData];
//    NSString *imageStr  =[[ NSString alloc] initWithData:imageData1 encoding:NSUTF8StringEncoding];
    
    
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



//一级广告弹出
-(void)NewAddVipAction
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    self.alertView = alertView;
    [alertView setContainerView:[self createDemoView]];
    
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确定", @"取消", nil]];
    [alertView setDelegate:self];
    
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    [alertView show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (alertView.tag==0&&buttonIndex==0) {
        if (_indexPathRow==1) {
            [self textCantBeNull1];

        }
        else if (_indexPathRow == 2)
        {
            [self textCantBeNull2];
        }else if (_indexPathRow == 3)
        {
            [self textCantBeNull2];
        }else if (_indexPathRow == 4||_indexPathRow == 5||_indexPathRow == 6)
        {
            [self textCantBeNull2];
        }
        
    }
}
-(void)textCantBeNull2
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:4.f];
    if ([self.quyuLabel.text isEqualToString:@""]) {
        hud.label.text = NSLocalizedString(@"请选择区域", @"HUD message title");
    }
    else if ([self.placeLabel.text isEqualToString:@""])
    {
        hud.label.text = NSLocalizedString(@"请选择广告位", @"HUD message title");
    }
    else if ([self.startText1.text isEqualToString:@""])
    {
        hud.label.text = NSLocalizedString(@"请选择上线日期", @"HUD message title");
    }else if ([self.onLionText1.text isEqualToString:@""])
    {
        hud.label.text = NSLocalizedString(@"请选择在线时间", @"HUD message title");
    }else if ([self.contentText2.text isEqualToString:@""]||self.contentText2.text.length<30)
    {
        hud.label.text = NSLocalizedString(@"请填写不少于30字的内容", @"HUD message title");
    }
    else
    {
        if(_indexPathRow==2)
        {
            [self postRequestSubmitLevel2];
        }else if(_indexPathRow==3)
        {
            [self postRequestSubmitLevel2];
        }else if(_indexPathRow==4||_indexPathRow==5)
        {
            [self postRequestSubmitLevel3];
        }else if(_indexPathRow==6)
        {
            [self postRequestSubmitLevel2];
        }
        [self.alertView close];
    }
    
}
-(void)textCantBeNull1
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(0, 64, 375, 667);
    hud.mode = MBProgressHUDModeText;
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:4.f];
    
    if ([self.quyuLabel.text isEqualToString:@""]) {
        hud.label.text = NSLocalizedString(@"请选择区域", @"HUD message title");
    }
    else if ([self.startText1.text isEqualToString:@""])
    {
        hud.label.text = NSLocalizedString(@"请选择上线日期", @"HUD message title");
    }else if ([self.onLionText1.text isEqualToString:@""])
    {
        hud.label.text = NSLocalizedString(@"请选择在线时间", @"HUD message title");
    }else
        [self postRequestSubmitLevel1];

    
    
}

-(void)postRequestSubmit
{
    NSString *url =[[NSString alloc]initWithFormat:@"http://%@/VipCard/advert_wellcome_add.php",SOCKETHOST ];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    NSString *photoName =[NSString stringWithFormat:@"%@_%@.png",appdelegate.shopInfoDic[@"name"],appdelegate.shopInfoDic[@"phone"]];
    
    
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    
    [params setObject:photoName forKey:@"advert_url"];
    [params setObject:self.startText.text forKey:@"online_date"];
    [params setObject:self.onLionText.text forKey:@"stay_time"];
    [params setObject:self.quyuLabel.text forKey:@"advert_eare"];
    
        NSLog(@"==url =%@=paramer =%@",url,params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        NSArray *resuArr = result;
        
        
        if ([[resuArr objectAtIndex:0] intValue]==1) {
            [self tishikuang:@"添加成功"];
            
        }
        else if([[resuArr objectAtIndex:0] intValue]==1062 )
        {
            [self tishikuang:@"数据重复"];
            
        }else{
            [self tishikuang:@"添加出错,请重新添加"];

        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        [self tishikuang:@"添加出错,请重新添加"];
        
        
    }];
    
}

-(void)postRequestSubmitLevel3
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/AdvertSbo/add",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];

    [params setObject:self.contentText2.text forKey:@"content"];
    [params setObject:self.startText1.text forKey:@"online_date"];
    [params setObject:self.onLionText1.text forKey:@"stay_time"];
    
    [params setObject:self.quyuLabel.text forKey:@"advert_eare"];

    NSString *advertPlace = [[NSString alloc]init];
    
    NSInteger index = [_placeArray indexOfObject:_placeLabel.text]+1;
    
    advertPlace = [NSString stringWithFormat:@"%ld",index];
    [params setObject:advertPlace forKey:@"advert_position"];
    if (_indexPathRow==4) {
        [params setObject:@"false" forKey:@"favor"];
    }else if (_indexPathRow==5) {
        [params setObject:@"true" forKey:@"favor"];
    }
    
    NSLog(@"postRequestSubmitLevel3==url=%@===param==%@",url,params);


    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        NSDictionary *resu_dic = (NSDictionary*)result;
        
        if ([resu_dic[@"result_code"] intValue]==1) {
            [self tishikuang:@"添加成功"];
            
        }
        else if([resu_dic[@"result_code"] intValue]==1062 )
        {
            [self tishikuang:@"数据重复"];
            
        }else{
            [self tishikuang:@"添加出错,请重新添加"];
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error.description);
        [self tishikuang:@"添加出错,请重新添加"];

        
    }];

}
-(void)postRequestSubmitLevel1
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/AdvertLay1/add",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    NSString *photoName =[NSString stringWithFormat:@"%@_%@.png",appdelegate.shopInfoDic[@"name"],appdelegate.shopInfoDic[@"phone"]];
    [params setObject:photoName forKey:@"advert_url"];
    [params setObject:self.startText1.text forKey:@"online_date"];
    [params setObject:self.onLionText1.text forKey:@"stay_time"];
    
    
    [params setObject:self.quyuLabel.text forKey:@"advert_eare"];
    NSString *advertPlace = [[NSString alloc]init];
    
    NSInteger index = [_placeArray indexOfObject:_placeLabel.text]+1;
    
    advertPlace = [NSString stringWithFormat:@"%ld",index];

    [params setObject:advertPlace forKey:@"advert_position"];

    NSLog(@"postRequestSubmitLevel1==url=%@===param==%@",url,params);

    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);
        NSDictionary *resut_dic = (NSDictionary*)result;
        
        
        if ([resut_dic[@"result_code"] intValue]==1) {
            [self tishikuang:@"添加成功"];

                  }
        else if([resut_dic[@"result_code"] intValue]==1062)
        {
            [self tishikuang:@"请不要重复添加"];

           
        }else{
            [self tishikuang:@"添加出错,请重新添加"];
 
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
        [self tishikuang:@"添加出错,请重新添加"];
      
        
    }];
    
}
-(void)postRequestSubmitLevel2
{
    
    NSString *url = [[NSString alloc]init];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];

    [params setObject:self.contentText2.text forKey:@"content"];
    [params setObject:self.startText1.text forKey:@"online_date"];
    [params setObject:self.onLionText1.text forKey:@"stay_time"];
    [params setObject:self.quyuLabel.text forKey:@"advert_eare"];
    
    NSString *advertPlace = [[NSString alloc]init];
    NSInteger index = [_placeArray indexOfObject:_placeLabel.text]+1;
    
    advertPlace = [NSString stringWithFormat:@"%ld",index];

    
       [params setObject:advertPlace forKey:@"advert_position"];
    
    
    if (_indexPathRow==2) {
        url =[[NSString alloc]initWithFormat:@"%@MerchantType/AdvertLay2/add",BASEURL];
    }else if (_indexPathRow==3) {
        url =[[NSString alloc]initWithFormat:@"%@MerchantType/AdvertLay3/add",BASEURL];
    }else if (_indexPathRow==6) {
        url =[[NSString alloc]initWithFormat:@"%@MerchantType/AdvertLaySbo/add",BASEURL];
        
    }
    
    NSLog(@"postRequestSubmitLevel2==url=%@===param==%@",url,params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);
        NSDictionary *resu_dic = (NSDictionary*)result;
        
        
        if ([resu_dic[@"result_code"] intValue]==1) {
            [self tishikuang:@"添加成功"];
           
        }
        else
        {
            [self tishikuang:@"添加出错,请重新添加"];
          
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
        [self tishikuang:@"添加出错,请重新添加"];
        
    }];
    
}

- (UIView *)createDemoView
{
    if (_indexPathRow==1) {
        UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 270)];
        self.demoView = demoView;
        //广告位/第一位
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 30)];
        typeLabel.text = @"广告位";
        typeLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:typeLabel];
        UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 80, 30)];
        self.placeLabel=placeLabel;
        placeLabel.layer.borderWidth = 0.3;
        placeLabel.textAlignment = NSTextAlignmentCenter;
        if ([placeLabel.text isEqualToString:@""]) {
            placeLabel.text = @"第一位";
        }
        NSLog(@"%@",placeLabel.text);
        placeLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:placeLabel];
        
        UIButton *choiceimage = [[UIButton alloc]initWithFrame:CGRectMake(170, 10, 40, 30)];
        [choiceimage setImage:[UIImage imageNamed:@"arraw_right"] forState:UIControlStateNormal];
        [demoView addSubview:choiceimage];
        
        UIButton *choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        choiceBtn.frame = CGRectMake(90, 0, 40+80, 50);
 
        [choiceBtn addTarget:self action:@selector(choicePlaceTypeAction) forControlEvents:UIControlEventTouchUpInside];
        //    self.boyBtn = boyBtn;
        [demoView addSubview:choiceBtn];
        
        
        UILabel *shangjiaLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 70, 30)];
        shangjiaLabel.text = @"上线日期";
        shangjiaLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:shangjiaLabel];
        UITextField *shangjiaText = [[UITextField alloc]initWithFrame:CGRectMake(90, 60, 120, 30)];
        shangjiaText.text = @"";
        shangjiaText.layer.borderWidth = 0.3;
        shangjiaText.delegate = self;
        shangjiaText.tag = 101;
        self.startText1 = shangjiaText;
        
        shangjiaText.font = [UIFont systemFontOfSize:13];
        
        [demoView addSubview:shangjiaText];
        
        UIView *lineLevel = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
        lineLevel.backgroundColor = [UIColor grayColor];
        lineLevel.alpha = 0.3;
        [demoView addSubview:lineLevel];
        //在线时间
        UILabel *zaixianLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, 70, 30)];
        zaixianLabel.text = @"在线时间";
        zaixianLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:zaixianLabel];
        UITextField *zaixianText = [[UITextField alloc]initWithFrame:CGRectMake(90, 110, 120, 30)];
        zaixianText.text = @"";
        zaixianText.layer.borderWidth = 0.3;
        zaixianText.delegate = self;
        zaixianText.tag = 102;
        self.onLionText1 = zaixianText;
        zaixianText.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:zaixianText];
        
        UIView *lineLevel11 = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 0.3)];
        lineLevel11.backgroundColor = [UIColor grayColor];
        lineLevel11.alpha = 0.3;
        [demoView addSubview:lineLevel11];
        UILabel *imageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, 70, 30)];
        imageLabel.text = @"上传图片:";
        imageLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:imageLabel];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(90, 160, 100, 100)];
        imageView.image = [UIImage imageNamed:@"点击-04"];
        //imageView.backgroundColor = [UIColor grayColor];
        self.imageView = imageView;
        [demoView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choicePicture)];
        [imageView addGestureRecognizer:tapGesture];
        //
        UILabel *noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(220, 160, SCREENWIDTH-220-20, 80)];
        noticeLabel.text=@"注：图片像素比例为：4*1，像素尺寸小于1000*250";
        noticeLabel.font=[UIFont systemFontOfSize:13.0];
        noticeLabel.numberOfLines=0;
        [demoView addSubview:noticeLabel];
        UIView *lineLevel1 = [[UIView alloc]initWithFrame:CGRectMake(0, 150, SCREENWIDTH, 0.3)];
        lineLevel1.backgroundColor = [UIColor grayColor];
        lineLevel1.alpha = 0.3;
        [demoView addSubview:lineLevel1];
        return demoView;
    }else if (_indexPathRow>1&&_indexPathRow <8)
    {
        UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 270)];
        self.demoView = demoView;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 250-60, 30)];
        if (_indexPathRow==2) {
            titleLabel.text = @"二级广告";
        }else if (_indexPathRow==3)
        {
            titleLabel.text = @"三级广告";
        }
        else if (_indexPathRow==4) {
            titleLabel.text = @"默认推送";
        }else if (_indexPathRow==5)
        {
            titleLabel.text = @"优惠推送";
        }else if (_indexPathRow==6) {
            titleLabel.text = @"区域搜索推送";
        }else if (_indexPathRow==7)
        {
            titleLabel.text = @"商圈推送";
        }
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:titleLabel];
        //广告位/第一位
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 65, 50)];
        typeLabel.text = @"广告位";
        typeLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:typeLabel];
        UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 60, 80, 30)];
        self.placeLabel=placeLabel;
        placeLabel.layer.borderWidth = 0.3;
        placeLabel.textAlignment = NSTextAlignmentCenter;
        if ([placeLabel.text isEqualToString:@""]) {
            placeLabel.text = @"第一位";
        }
        //        else
        //        {
        //            placeLabel.text = @"";
        //            cardTypeLabel.text = self.cardTypeString;
        //        }
        NSLog(@"%@",placeLabel.text);
        placeLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:placeLabel];
        
        
        UIButton *choiceimage = [[UIButton alloc]initWithFrame:CGRectMake(160, 60, 40, 30)];
        [choiceimage setImage:[UIImage imageNamed:@"arraw_right"] forState:UIControlStateNormal];
        [demoView addSubview:choiceimage];
        
        UIButton *choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        choiceBtn.backgroundColor = [UIColor grayColor];
        choiceBtn.frame = CGRectMake(90, 50, 40+80, 50);
        //箭头
//        UIButton *choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
////        choiceBtn.backgroundColor = [UIColor grayColor];
//        choiceBtn.frame = CGRectMake(160, 60, 40, 30);
//        //    choseBtn.backgroundColor = [UIColor redColor];
//        [choiceBtn setImage:[UIImage imageNamed:@"arraw_right"] forState:UIControlStateNormal];
//        [choiceBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateSelected];
        [choiceBtn addTarget:self action:@selector(choicePlaceTypeAction) forControlEvents:UIControlEventTouchUpInside];
        //    self.boyBtn = boyBtn;
        [demoView addSubview:choiceBtn];
        //上线日期
        UILabel *shangjiaLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, 65, 30)];
        shangjiaLabel.text = @"上线日期";
        shangjiaLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:shangjiaLabel];
        UITextField *shangjiaText = [[UITextField alloc]initWithFrame:CGRectMake(80, 110, 120, 30)];
        shangjiaText.text = @"";
        shangjiaText.layer.borderWidth = 0.3;
        shangjiaText.delegate = self;
        shangjiaText.tag = 101;
        self.startText1 = shangjiaText;
        
        shangjiaText.font = [UIFont systemFontOfSize:13];
        
        [demoView addSubview:shangjiaText];
        UIView *lineLevel = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
        lineLevel.backgroundColor = [UIColor grayColor];
        lineLevel.alpha = 0.3;
        [demoView addSubview:lineLevel];
        UIView *lineLevel22 = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 0.3)];
        lineLevel22.backgroundColor = [UIColor grayColor];
        lineLevel22.alpha = 0.3;
        [demoView addSubview:lineLevel22];
        //在线时间
        UILabel *zaixianLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, 65, 30)];
        zaixianLabel.text = @"在线时间";
        zaixianLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:zaixianLabel];
        UITextField *zaixianText = [[UITextField alloc]initWithFrame:CGRectMake(80, 160, 120, 30)];
        zaixianText.text = @"";
        zaixianText.layer.borderWidth = 0.3;
        zaixianText.delegate = self;
        zaixianText.tag = 102;
        self.onLionText1 = zaixianText;
        zaixianText.font = [UIFont systemFontOfSize:13];
        
        [demoView addSubview:zaixianText];
        UIView *lineLevel33 = [[UIView alloc]initWithFrame:CGRectMake(0, 150, SCREENWIDTH, 0.3)];
        lineLevel33.backgroundColor = [UIColor grayColor];
        lineLevel33.alpha = 0.3;
        [demoView addSubview:lineLevel33];
        UIView *lineLevel11 = [[UIView alloc]initWithFrame:CGRectMake(0, 200, SCREENWIDTH, 0.3)];
        lineLevel11.backgroundColor = [UIColor grayColor];
        lineLevel11.alpha = 0.3;
        [demoView addSubview:lineLevel11];
        UILabel *imageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 210, 65, 30)];
        imageLabel.text = @"内容";
        imageLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:imageLabel];
        UITextField *contentText = [[UITextField alloc]initWithFrame:CGRectMake(80, 210, 180, 50)];
        contentText.text = @"";
        [contentText setInputAccessoryView:toolView];
        contentText.layer.borderWidth = 0.3;
        contentText.delegate = self;
        self.contentText2 = contentText;
        [demoView addSubview:self.contentText2];
        //        UIView *lineLevel1 = [[UIView alloc]initWithFrame:CGRectMake(0, 220, SCREENWIDTH, 0.3)];
        //        lineLevel1.backgroundColor = [UIColor grayColor];
        //        lineLevel1.alpha = 0.3;
        //        [demoView addSubview:lineLevel1];
        return demoView;
    }else
    {
        UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 320)];
        self.demoView = demoView;
        return demoView;
    }
    
}
-(void)choicePlaceTypeAction
{
    
    
    
    if(_indexPathRow==1)
    {
        self.placeArray = @[@"第一位",@"第二位",@"第三位"];
    }else if (_indexPathRow==2)
    {
        self.placeArray = @[@"第一位",@"第二位",@"第三位",@"第四位",@"第五位",@"第六位",@"第七位",@"第八位"];
    }else
        self.placeArray = @[@"第一位",@"第二位",@"第三位",@"第四位",@"第五位",@"第六位",@"第七位",@"第八位",@"第九位",@"第十位"];
    if (_ifPlace == NO) {
        
        for (UIView *view in self.demoView.subviews) {
            if ([view isKindOfClass:[UIPickerView class]]||[view isKindOfClass:[UIToolbar class]]) {
                [view removeFromSuperview];
            }
        }

        
        UIPickerView* pickerView = [ [ UIPickerView alloc] initWithFrame:CGRectMake(0, self.demoView.height-120, SCREENWIDTH, 120)];
        pickerView.backgroundColor = [UIColor lightGrayColor];
        pickerView.delegate = self;
        pickerView.dataSource =  self;
        pickerView.tag = 10001;
        self.placePickerView = pickerView;
        [self.demoView addSubview:pickerView];
        
        
       _toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.demoView.height-120, self.demoView.width, 40)];
        [self.demoView addSubview:_toolbar];
        //工具条上的文字显示
        _place_lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-100, 40)];
        _place_lab.textColor =[UIColor blackColor];
        _place_lab.font =[UIFont systemFontOfSize:15];
        _place_lab.text =  self.placeArray[0];
        [_toolbar addSubview:_place_lab];
        
       //工具条上的确定按钮
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        okBtn.frame = CGRectMake(self.demoView.width-60, 0, 60, 40);
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [okBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
        [_toolbar addSubview:okBtn];
   
        _ifPlace = YES;
    }else
    {
        _ifPlace = NO;
//        [_toolbar removeFromSuperview];
//        [self.placePickerView removeFromSuperview];
    }
    
}

-(void)tishikuang:(NSString*)sting_ts{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(sting_ts, @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:4.f];
    
}
/**
 *  确定操作,将文字显示到广告位上
 */
-(void)sureClick{
    
    self.placeLabel.text = _place_lab.text;
    [_toolbar removeFromSuperview];
    [self.placePickerView removeFromSuperview];
    _ifPlace =NO;

}
-(void)dismissKeyBoard{
    
    [self.contentText2 resignFirstResponder];
    
    
    
}

@end
