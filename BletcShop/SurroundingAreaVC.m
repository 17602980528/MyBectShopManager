//
//  SurroundingAreaVC.m
//  BletcShop
//
//  Created by apple on 17/2/21.
//  Copyright © 2017年 bletc. All rights reserved.
//
#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

#import "SurroundingAreaVC.h"
#import "ValuePickerView.h"
#import "SingleModel.h"
#import "PayBaseCountOrTimeVC.h"
@interface SurroundingAreaVC ()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView *picker;
    
    NSMutableArray *province;//省datasource
    NSMutableArray *city;//市datasource
    NSMutableArray * district;//区datasource
    NSMutableArray *street;//街道datasource
    
    NSMutableArray *provinceCode;//省编码
    NSMutableArray *cityCode;//市编码
    NSMutableArray * districtCode;//区编码
    NSMutableArray * streetCode;//街道编码；
    
    NSString *selectedDistricts;
    
    NSInteger selected_pro;//省index；
    NSInteger selected_city;//市index;
    NSInteger selected_district;//区index;
    NSInteger selected_street;//
    UILabel *areaLable;//活动地区
    NSMutableArray *activatyKindsArr;//活动类型数据源
    UILabel *advertPositionLable;
    __block SingleModel *model;
    NSArray *advertPositionArr;//广告位数据源
    
}
@property (nonatomic,strong)UIToolbar *toolbarCancelDone;
@property (nonatomic, strong) ValuePickerView *pickerView;
@property (nonatomic,strong) ValuePickerView *advertPositionPickerView;
@property (nonatomic,strong)UILabel *advertStyleLable;
@property (nonatomic,copy)NSString *stateStr;
@end

@implementation SurroundingAreaVC

- (void)viewDidLoad {
    [super viewDidLoad];
     _stateStr=@"false";
    self.view.backgroundColor=RGB(240, 240, 240);
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(goNextVC)];
    self.navigationItem.rightBarButtonItem=rightItem;
    province=[[NSMutableArray alloc]initWithCapacity:0];
    city=[[NSMutableArray alloc]initWithCapacity:0];
    district=[[NSMutableArray alloc]initWithCapacity:0];
    street=[[NSMutableArray alloc]initWithCapacity:0];
    
    provinceCode=[[NSMutableArray alloc]initWithCapacity:0];
    cityCode=[[NSMutableArray alloc]initWithCapacity:0];
    districtCode=[[NSMutableArray alloc]initWithCapacity:0];
    streetCode=[[NSMutableArray alloc]initWithCapacity:0];
    
    selected_pro=0;
    selected_city=0;
    selected_district=0;
    selected_street=0;
    selectedDistricts=@"";
    
    model=[SingleModel sharedManager];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    model.shopName=delegate.shopInfoDic[@"store"];
    
    [self initTopView];
    [self postRequestProvince];
}
-(void)initTopView{
    
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
    UILabel *advertStyle=[[UILabel alloc]initWithFrame:CGRectMake(19, 50, 80, 49)];
    advertStyle.text=@"街道";
    advertStyle.textColor=RGB(102, 102, 102);
    advertStyle.font=[UIFont systemFontOfSize:16.0f];
    [bgview addSubview:advertStyle];
    
    _advertStyleLable=[[UILabel alloc]initWithFrame:CGRectMake(99, 50, SCREENWIDTH-99-27, 49)];
    _advertStyleLable.font=[UIFont systemFontOfSize:16.0f];
    _advertStyleLable.text=@"";
    [bgview addSubview:_advertStyleLable];
    
    
    UIButton *chooseAcKindButton=[UIButton buttonWithType:UIButtonTypeCustom];
    chooseAcKindButton.frame=CGRectMake(0, 50, SCREENWIDTH, 49);
    [bgview addSubview:chooseAcKindButton];
    [chooseAcKindButton addTarget:self action:@selector(chooseAcKindBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *detailImage2=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-27,50+16.5, 8, 16)];
    detailImage2.image=[UIImage imageNamed:@"arraw_right"];
    [bgview addSubview:detailImage2];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(13, 49+50, SCREENWIDTH-26, 1)];
    lineView2.backgroundColor=RGB(234, 234, 234);
    [bgview addSubview:lineView2];
    //row3
    UILabel *advertPosition=[[UILabel alloc]initWithFrame:CGRectMake(19, 50+50, 80, 49)];
    advertPosition.text=@"广告位置";
    advertPosition.textColor=RGB(102, 102, 102);
    advertPosition.font=[UIFont systemFontOfSize:16.0f];
    [bgview addSubview:advertPosition];
    
    advertPositionLable=[[UILabel alloc]initWithFrame:CGRectMake(99, 50+50, SCREENWIDTH-99-27, 49)];
    advertPositionLable.font=[UIFont systemFontOfSize:16.0f];
    advertPositionLable.text=@"";
    [bgview addSubview:advertPositionLable];
    
    UIImageView *detailImage3=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-27,50+16.5+50, 8, 16)];
    detailImage3.image=[UIImage imageNamed:@"arraw_right"];
    [bgview addSubview:detailImage3];
    
    UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(13, 49+50+50, SCREENWIDTH-26, 1)];
    lineView3.backgroundColor=RGB(234, 234, 234);
    [bgview addSubview:lineView3];
    
    UIButton *chooseAcPositionButton=[UIButton buttonWithType:UIButtonTypeCustom];
    chooseAcPositionButton.frame=CGRectMake(0, 50+50, SCREENWIDTH, 49);
    [bgview addSubview:chooseAcPositionButton];
    [chooseAcPositionButton addTarget:self action:@selector(chooseAcPositionButton) forControlEvents:UIControlEventTouchUpInside];
    
    //-----初始化活动
    self.pickerView = [[ValuePickerView alloc]init];//街道
    self.advertPositionPickerView=[[ValuePickerView alloc]init];//广告位
}
//选地区
-(void)chooseAreaBtnClick{
    [self choiceCity];
}
-(void)choiceCity{
    
    if (picker==nil) {
        picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, SCREENHEIGHT-64-160, SCREENWIDTH, 160)];
    }
    picker.backgroundColor = [UIColor whiteColor];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
//    [picker selectRow: 0 inComponent: 0 animated: YES];
//    selected_pro=0;
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
    picker.hidden = NO;
    self.toolbarCancelDone.hidden = NO;
}
-(void)chooseAcKindBtnClick{
    __weak SurroundingAreaVC *tempSelf=self;
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
        if (street.count>0) {
            //有地区，并且有街道
            tempSelf.pickerView.valueDidSelect = ^(NSString *value){
                NSArray * arr =[value componentsSeparatedByString:@"/"];
                NSString * newValue=arr[0];
                tempSelf.advertStyleLable.text=newValue;
                //获取广告位
                NSString *detailAreaStr=[NSString stringWithFormat:@"%@%@",areaLable.text,tempSelf.advertStyleLable.text];
                [self accessAdvertPositionByDetailArea:detailAreaStr];
            };
            
            [tempSelf.pickerView show];
        }
    }
    
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
    if (province.count!=0&&city.count!=0&&district.count!=0) {
        areaLable.text = [NSString stringWithFormat:@"%@%@%@",[province objectAtIndex:[picker selectedRowInComponent:0]],[city objectAtIndex:[picker selectedRowInComponent:1]],[district objectAtIndex:[picker selectedRowInComponent:2]]];
        selectedDistricts=districtCode[selected_district];
        
        [self postRequestStreets];
        
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             picker.hidden = YES;
                             self.toolbarCancelDone.hidden = YES;
                         }
                         completion:^(BOOL finished){
                             
                             
                         }];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"超出活动范围", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        //    [hud setColor:[UIColor blackColor]];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        hud.userInteractionEnabled = YES;
        
        [hud hideAnimated:YES afterDelay:2.f];
    }
    
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
    else{
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
        selected_pro=row;
        //获取市
        [self postRequestCity];
    }
    else if (component == CITY_COMPONENT) {
        selected_city=row;
        //获取区
        [self postRequestDistricts];
    
    }else if(component==DISTRICT_COMPONENT){
        selected_district=row;
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

-(void)goNextVC{
    if ([areaLable.text isEqualToString:@""]||[_advertStyleLable.text isEqualToString:@""]||[advertPositionLable.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"信息不完善，请检查", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        //    [hud setColor:[UIColor blackColor]];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        hud.userInteractionEnabled = YES;
        
        [hud hideAnimated:YES afterDelay:2.f];
    }else{
        model.advertTitle=self.title;
        model.advertArea=[NSString stringWithFormat:@"%@%@",areaLable.text,self.advertStyleLable.text];
        model.advertKind=@"无";
        model.advertPosition=advertPositionLable.text;
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
//获取广告位
-(void)accessAdvertPositionByDetailArea:(NSString *)detailArea{
    __block SurroundingAreaVC *tempSelf=self;
    NSString *url=[[NSString alloc]initWithFormat:@"%@MerchantType/advertNear/getPosition",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:detailArea forKey:@"address"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"result===%@",result);
        if (result) {
            _stateStr=result[@"check"];
            advertPositionArr=result[@"current_position"];
            tempSelf.advertPositionPickerView.dataSource=advertPositionArr;
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

//选广告位
-(void)chooseAcPositionButton{
    __weak SurroundingAreaVC *tempSelf=self;
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
    }else if ([self.advertStyleLable.text isEqualToString:@""]){
        //没有选地区，点击没反应
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"您还未选街道", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        //    [hud setColor:[UIColor blackColor]];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        hud.userInteractionEnabled = YES;
        
        [hud hideAnimated:YES afterDelay:2.f];
    }else{
        if (advertPositionArr.count>0) {
            //有地区
            tempSelf.advertPositionPickerView.valueDidSelect = ^(NSString *value){
                NSArray * arr =[value componentsSeparatedByString:@"/"];
                NSString * newValue=arr[0];
                advertPositionLable.text=newValue;
                model.advertPosition=newValue;
            };
            
            [tempSelf.advertPositionPickerView show];
        }
        
    }
}

//省
-(void)postRequestProvince{
    NSString *url=[[NSString alloc]initWithFormat:@"%@Extra/address/getProvince",BASEURL];
    
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"result===%@",result);
        for (int i=0; i<[result count]; i++) {
            [province addObject:result[i][@"name"]];
            [provinceCode addObject:result[i][@"code"]];
        }
        [picker reloadComponent:PROVINCE_COMPONENT];
        [picker selectRow:0 inComponent:0 animated:YES];
        selected_city=0;
        [self postRequestCity];
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
}
//市
-(void)postRequestCity{
    NSString *url=[[NSString alloc]initWithFormat:@"%@Extra/address/getCity",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:provinceCode[selected_pro] forKey:@"pro_id"];
    if (city.count!=0) {
        [city removeAllObjects];
    }
    if (cityCode.count!=0) {
        [cityCode removeAllObjects];
    }
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"result===%@",result);
        for (int i=0; i<[result count]; i++) {
            [city addObject:result[i][@"name"]];
            [cityCode addObject:result[i][@"code"]];
        }
        [picker reloadComponent:CITY_COMPONENT];
        [picker selectRow:0 inComponent:1 animated:YES];
        selected_district=0;
        if (city.count>0) {
            [self postRequestDistricts];
        }else{
            if (district.count!=0) {
                [district removeAllObjects];
            }
            if (districtCode.count!=0) {
                [districtCode removeAllObjects];
            }
            [picker reloadComponent:DISTRICT_COMPONENT];
        }
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
}
//区
-(void)postRequestDistricts{
    NSString *url=[[NSString alloc]initWithFormat:@"%@Extra/address/getDistrict",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:cityCode[selected_city] forKey:@"city_id"];
    if (district.count!=0) {
        [district removeAllObjects];
    }
    if (districtCode.count!=0) {
        [districtCode removeAllObjects];
    }
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"result===%@",result);
        for (int i=0; i<[result count]; i++) {
            [district addObject:result[i][@"name"]];
            [districtCode addObject:result[i][@"code"]];
        }
        [picker reloadComponent:DISTRICT_COMPONENT];
        [picker selectRow:0 inComponent:2 animated:YES];
        selected_district=0;
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
}
//街道
-(void)postRequestStreets{
    NSString *url=[[NSString alloc]initWithFormat:@"%@Extra/address/getStreet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:selectedDistricts forKey:@"district_id"];
    if (street.count!=0) {
        [street removeAllObjects];
    }
    if (streetCode.count!=0) {
        [streetCode removeAllObjects];
    }
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"result===%@",result);
        for (int i=0; i<[result count]; i++) {
            [street addObject:result[i][@"name"]];
            [streetCode addObject:result[i][@"code"]];
        }
        self.pickerView.dataSource=street;
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];

}
@end
