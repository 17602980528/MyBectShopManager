//
//  ArcForRandomAdvertVC.m
//  BletcShop
//
//  Created by apple on 17/3/21.
//  Copyright © 2017年 bletc. All rights reserved.
//
#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2
#import "ArcForRandomAdvertVC.h"
#import "ValuePickerView.h"
#import "PayBaseCountOrTimeVC.h"
@interface ArcForRandomAdvertVC ()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    UILabel *advertPositionLable;
    UILabel *areaLable;//活动地区
    UIPickerView *picker;
    UIButton *button;
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    NSString *selectedProvince;
    NSArray *activatyPositionsArr;//广告位数据源
}
@property (nonatomic,strong)UIToolbar *toolbarCancelDone;
@property (nonatomic, strong) ValuePickerView *pickerView;
@property (nonatomic,copy)NSString *stateStr;
@end

@implementation ArcForRandomAdvertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(240, 240, 240);
     _stateStr=@"false";
    activatyPositionsArr=[NSArray array];
    self.navigationItem.title=self.advertTitle;
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(goNextVC)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    UIView *bgview=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, SCREENHEIGHT-74)];
    bgview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgview];
    //row1
    UILabel *chooseArea=[[UILabel alloc]initWithFrame:CGRectMake(19, 0, 80, 49)];
    chooseArea.text=@"选择地区";
    chooseArea.textColor=RGB(102, 102, 102);
    chooseArea.font=[UIFont systemFontOfSize:16.0f];
    [bgview addSubview:chooseArea];
    
    areaLable=[[UILabel alloc]initWithFrame:CGRectMake(99, 0, SCREENWIDTH-99-27, 49)];
    areaLable.font=[UIFont systemFontOfSize:16.0f];
    areaLable.text=@"";
    [bgview addSubview:areaLable];
    
    UIButton *chooseAreaButton=[UIButton buttonWithType:UIButtonTypeCustom];
    chooseAreaButton.frame=CGRectMake(0, 0, SCREENWIDTH, 49);
    [bgview addSubview:chooseAreaButton];
    [chooseAreaButton addTarget:self action:@selector(chooseAreaBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *detailImage=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-27, 16.5, 8, 16)];
    detailImage.image=[UIImage imageNamed:@"arraw_right"];
    [bgview addSubview:detailImage];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(13, 49, SCREENWIDTH-26, 1)];
    lineView.backgroundColor=RGB(234, 234, 234);
    [bgview addSubview:lineView];
    //row2

    UILabel *advertPosition=[[UILabel alloc]initWithFrame:CGRectMake(19, 50, 80, 49)];
    advertPosition.text=@"广告位置";
    advertPosition.textColor=RGB(102, 102, 102);
    advertPosition.font=[UIFont systemFontOfSize:16.0f];
    [bgview addSubview:advertPosition];
    
    advertPositionLable=[[UILabel alloc]initWithFrame:CGRectMake(99, 50, SCREENWIDTH-99-27, 49)];
    advertPositionLable.font=[UIFont systemFontOfSize:16.0f];
    advertPositionLable.text=@"";
    [bgview addSubview:advertPositionLable];
    
    UIImageView *detailImage2=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-27,50+16.5, 8, 16)];
    detailImage2.image=[UIImage imageNamed:@"arraw_right"];
    [bgview addSubview:detailImage2];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(13, 49+50, SCREENWIDTH-26, 1)];
    lineView2.backgroundColor=RGB(234, 234, 234);
    [bgview addSubview:lineView2];
    
    UIButton *choosePosition=[UIButton buttonWithType:UIButtonTypeCustom];
    choosePosition.frame=CGRectMake(0, 50, SCREENWIDTH, 49);
    [bgview addSubview:choosePosition];
    [choosePosition addTarget:self action:@selector(chooseAcPositionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.pickerView = [[ValuePickerView alloc]init];
}
-(void)chooseAreaBtnClick{
    [self choiceCity];
}
-(void)chooseAcPositionBtnClick{
    __weak ArcForRandomAdvertVC *tempSelf=self;
    if ([areaLable.text isEqualToString:@""]) {
        //没有选地区，点击没反应
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"您还未选地区", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        //    [hud setColor:[UIColor blackColor]];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        hud.userInteractionEnabled = YES;
        
        [hud hideAnimated:YES afterDelay:2.f];
    }else{
        if (activatyPositionsArr.count>0) {
            //有地区
            tempSelf.pickerView.valueDidSelect = ^(NSString *value){
                NSArray * arr =[value componentsSeparatedByString:@"/"];
                NSString * newValue=arr[0];
                //获取广告位
                advertPositionLable.text=newValue;
        
            };
            
            [tempSelf.pickerView show];
        }
    }

}
-(void)goNextVC{
    
    if ([areaLable.text isEqualToString:@""]||[advertPositionLable.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"信息不完善，请检查", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        //    [hud setColor:[UIColor blackColor]];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        hud.userInteractionEnabled = YES;
        
        [hud hideAnimated:YES afterDelay:2.f];
    }else{
        
        if ([_stateStr isEqualToString:@"true"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"您暂不能申请该活动广告位", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            //    [hud setColor:[UIColor blackColor]];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            hud.userInteractionEnabled = YES;
            [hud hideAnimated:YES afterDelay:3.0f];
            
        }else{
            PayBaseCountOrTimeVC *nextVC=[[PayBaseCountOrTimeVC alloc]init];
            [self.navigationController pushViewController:nextVC animated:YES];
        }
        
    }

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
    
    picker.backgroundColor = [UIColor whiteColor];
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
    
    areaLable.text = [NSString stringWithFormat:@"%@%@%@",[province objectAtIndex:[picker selectedRowInComponent:0]],[city objectAtIndex:[picker selectedRowInComponent:1]],[district objectAtIndex:[picker selectedRowInComponent:2]]];
    [self accessActivatyAllKinds:areaLable.text];
    
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
#pragma mark -- dataGet---method
//获取某地区可参与广告位
-(void)accessActivatyAllKinds:(NSString *)dictricts{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/advertActivity/getPosition",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:dictricts forKey:@"address"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"result===%@",result);
        if (result) {
            activatyPositionsArr=result[@"current_position"];
            self.pickerView.dataSource=activatyPositionsArr;
            
            _stateStr=result[@"check"];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
