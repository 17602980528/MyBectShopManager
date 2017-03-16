//
//  UserInfoEditVC.m
//  BletcShop
//
//  Created by Bletc on 2017/3/15.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "UserInfoEditVC.h"

@interface UserInfoEditVC ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *datePickView;
    UIToolbar *toolbarCancelDone;
    
    
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
    
    NSInteger selectedHourRowOnLine;
    NSInteger selectedMonthRowOnLine;
    NSInteger selectedDayRowOnLine;
}
@property (weak, nonatomic) IBOutlet UILabel *title_lab;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;

@end

@implementation UserInfoEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self.contentTF.subviews firstObject] removeFromSuperview];
  
  
    
    self.navigationItem.title = [NSString stringWithFormat:@"修改%@",self.leibie];
    self.title_lab.text = self.leibie;
    self.contentTF.placeholder = [NSString stringWithFormat:@"请填写您的%@",self.leibie];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];

    
    if ([self.leibie isEqualToString:@"生日"]) {
        [self _inittableDate];
    }
}



-(void)sureClick{
    
    [self.contentTF resignFirstResponder];
    
    [self postRevise];
}

-(void)postRevise
{
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountSet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [params setObject:self.contentTF.text forKey:@"para"];

    if ([self.leibie isEqualToString:@"昵称"]) {
        [params setObject:@"nickname" forKey:@"type"];
    }else if ([self.leibie isEqualToString:@"地址"]) {
        [params setObject:@"address" forKey:@"type"];
    }else if ([self.leibie isEqualToString:@"邮箱"]) {
        [params setObject:@"mail" forKey:@"type"];
    }else if ([self.leibie isEqualToString:@"性别"]) {
        [params setObject:@"sex" forKey:@"type"];
        
    }else if ([self.leibie isEqualToString:@"生日"]) {
        [params setObject:@"age" forKey:@"type"];
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


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([self.leibie isEqualToString:@"性别"]) {
        [self creatSheetView];
        return NO;
    }else  if ([self.leibie isEqualToString:@"生日"]) {
        [self creatPickView];
        return NO;
    }else{
        return YES;
    }
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

-(void)creatPickView{
    
    
        datePickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-160-64, SCREENWIDTH, 160)] ;
        datePickView.backgroundColor = [UIColor whiteColor];
        datePickView.delegate = self;
        datePickView.dataSource = self;
        toolbarCancelDone = [[UIToolbar alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-200-64, SCREENWIDTH, 40)];
        [self.view addSubview: datePickView];
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        okBtn.frame = CGRectMake(SCREENWIDTH-60, 0, 60, 40);
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        //[okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [okBtn addTarget:self action:@selector(actionDone) forControlEvents:UIControlEventTouchUpInside];
        [toolbarCancelDone addSubview:okBtn];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, 60, 40);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelBtn addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
        [toolbarCancelDone addSubview:cancelBtn];
        
        [self.view addSubview:toolbarCancelDone];
    
    [datePickView selectRow:[yearArray indexOfObject:currentyearString] inComponent:0 animated:NO];
    
    [datePickView selectRow:[monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];

    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
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
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
        m=row;
        
        
        
        if (component == 0)
        {
            selectedYearRow = row;
            [datePickView reloadAllComponents];
        }
        else if (component == 1)
        {
            selectedMonthRow = row;
            [datePickView reloadAllComponents];
        }
        else if (component == 2)
        {
            selectedDayRow = row;
            
            [datePickView reloadAllComponents];
            
        }
        

}

- (void)actionCancel
{
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         datePickView.hidden = YES;
                         toolbarCancelDone.hidden = YES;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    
}
- (void)actionDone
{
    
    
    self.contentTF.text = [NSString stringWithFormat:@"%@-%@-%@",[yearArray objectAtIndex:[datePickView selectedRowInComponent:0]],[monthArray objectAtIndex:[datePickView selectedRowInComponent:1]],[DaysArray objectAtIndex:[datePickView selectedRowInComponent:2]]];
    
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         datePickView.hidden = YES;
                         toolbarCancelDone.hidden = YES;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    
    
}


-(void)creatSheetView{
    UIAlertController *alertVC = [[UIAlertController alloc]init];
    
    UIAlertAction *manAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.contentTF.text = @"男";
        
    }];
    
    UIAlertAction *wemon =[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.contentTF.text = @"女";

        
    }];
    [alertVC addAction:manAction];
    [alertVC addAction:wemon];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
