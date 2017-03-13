//
//  SelectAddressViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/3/9.
//  Copyright © 2017年 bletc. All rights reserved.
//
#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

#import "SelectAddressViewController.h"

@interface SelectAddressViewController ()<UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource>

{
        UIPickerView *picker;
        UIButton *button;
        NSDictionary *areaDic;
        NSArray *province;
        NSArray *city;
        NSArray *district;
        NSString *selectedProvince;
}

@property (weak, nonatomic) IBOutlet UITextField *eareTF;
@property (weak, nonatomic) IBOutlet UITextField *detailTF;
@property (weak, nonatomic) IBOutlet UITextField *receiveName;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (nonatomic,strong)UIToolbar *toolbarCancelDone;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation SelectAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加收货地址";
    self.sureBtn.backgroundColor = NavBackGroundColor;

}
- (IBAction)sureBtnClick:(UIButton *)sender {
    
    
    if (self.eareTF.text.length >0&&self.detailTF.text.length >0&&self.receiveName.text.length >0&&self.phoneTF.text.length >0) {
//        if (self.delegate &&[self.delegate respondsToSelector:@selector(senderReceiceInfo:)]) {
        
//            NSMutableDictionary *muta_d = [NSMutableDictionary dictionary];
//            [muta_d setObject:self.eareTF.text  forKey:@"eare"];
//            [muta_d setObject:self.detailTF.text  forKey:@"detailPlace"];
//            [muta_d setObject:self.receiveName.text  forKey:@"name"];
//            [muta_d setObject:self.phoneTF.text  forKey:@"phone"];
//
//            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:muta_d];
//            
//            [self.delegate senderReceiceInfo:dic];
//            
//            
//            [self.navigationController popViewControllerAnimated:YES];
        if ([ToolManager validateMobile:self.phoneTF.text]) {
            [self getdata];
        }else{
            [self showHint:@"请输入正确手机号"];
 
        }
        

            }else{
            
            [self showHint:@"请完善信息"];
        }

//    }
    
}

-(void)getdata{
    NSString *url = [NSString stringWithFormat:@"%@Extra/mall/addAdd",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *address_s = [NSString stringWithFormat:@"%@%@",self.eareTF.text,self.detailTF.text];
    
    [paramer setObject:app.userInfoDic[@"uuid"] forKey:@"uuid"];
    [paramer setObject:address_s  forKey:@"address"];
    [paramer setObject:self.receiveName.text  forKey:@"name"];
    [paramer setObject:self.phoneTF.text  forKey:@"phone"];
    NSLog(@"------%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"result----_%@",result);
        if ([result[@"result_code"] intValue]==1) {
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            [self showHint:@"添加出错"];
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"----error----%@",error);
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (self.eareTF ==textField) {
        
        [self.detailTF resignFirstResponder];
        [self.receiveName resignFirstResponder];
        [self.phoneTF resignFirstResponder];
        
        [self choiceCity];

        return NO;
    }else{
        [self actionCancel];
        
        return YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
    
}

-(void)choiceCity{
    
    
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

    
    if (picker==nil) {
        picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, SCREENHEIGHT-64-160, SCREENWIDTH, 160)];
    }
    
    picker.backgroundColor = tableViewBackgroundColor;
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    [picker selectRow: 0 inComponent: 0 animated: YES];
    [self.view addSubview: picker];
    
    if (self.toolbarCancelDone==nil) {
        self.toolbarCancelDone = [[UIToolbar alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-200-64, SCREENWIDTH, 40)];
    }
    
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
    
    
    
    [self.view addSubview:self.toolbarCancelDone];
    selectedProvince = [province objectAtIndex: 0];
    picker.hidden = NO;
    self.toolbarCancelDone.hidden = NO;
}


- (void)actionCancel
{
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         picker.hidden = YES;
                         self.toolbarCancelDone.hidden = YES;
                         
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
}

- (void)actionDone
{
    
    self.eareTF.text = [NSString stringWithFormat:@"%@%@%@",[province objectAtIndex:[picker selectedRowInComponent:0]],[city objectAtIndex:[picker selectedRowInComponent:1]],[district objectAtIndex:[picker selectedRowInComponent:2]]];
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         picker.hidden = YES;
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
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
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
        [picker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [picker reloadComponent: CITY_COMPONENT];
        [picker reloadComponent: DISTRICT_COMPONENT];
        
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
        [picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [picker reloadComponent: DISTRICT_COMPONENT];
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


@end
