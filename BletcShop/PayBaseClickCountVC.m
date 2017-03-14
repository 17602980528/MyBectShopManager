//
//  PayBaseClickCountVC.m
//  BletcShop
//
//  Created by apple on 17/3/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PayBaseClickCountVC.h"
#import "GoToPayForAdvertistTableVC.h"
#import "SingleModel.h"
@interface PayBaseClickCountVC ()

{
    NSArray *dataArray;
    NSArray *daysOrCountsArr;
    SingleModel *model;
}
@end

@implementation PayBaseClickCountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(240, 240, 240);
    model=[SingleModel sharedManager];
    NSLog(@"%@",model.baseOnCountsOrTime);
    self.navigationItem.title=@"发布广告";
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(goNextVC)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    UILabel *describeLable=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREENWIDTH-20, 30)];
    describeLable.font=[UIFont systemFontOfSize:12.0f];
    
    [self.view addSubview:describeLable];

    NSArray *describeArray=@[@"选择消费次数",@"选择上线时间"];
    
    _record=-1;
    _selectedTime=@"null";
    if ([model.baseOnCountsOrTime isEqualToString:@"click"]) {
        dataArray=@[@"10",@"30",@"50",@"80",@"100",@"200",@"300",@"400",@"500",@"800",@"1000",@"其他次数"];
        daysOrCountsArr=@[@"1500",@"2000",@"2500",@"3000",@"3500",@"4000",@"5000",@"6000",@"8000",@"10000"];
        describeLable.text=describeArray[0];
        
    }else{
        dataArray=@[@"10天",@"30天",@"50天",@"80天",@"100天",@"200天",@"300天",@"400天",@"500天",@"800天",@"1000天",@"其他天数"];
    daysOrCountsArr=@[@"1500天",@"2000天",@"2500天",@"3000天",@"3500天",@"4000天",@"5000天",@"6000天",@"8000天",@"10000天"];
        describeLable.text=describeArray[1];
    }
    
    _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 30, SCREENWIDTH, 130)];
    _bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_bgView];
    for (int i=0; i<12; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(16+i%4*(16+(SCREENWIDTH-80)/4), 10+i/4*(10+30), (SCREENWIDTH-80)/4, 30);
        [button setTitle:dataArray[i] forState:UIControlStateNormal];
        button.layer.cornerRadius=5.0f;
        button.clipsToBounds=YES;
        button.layer.borderWidth=0.8;
        button.layer.borderColor=[NavBackGroundColor CGColor];
        [button setTitleColor:NavBackGroundColor forState:UIControlStateNormal];
        button.tag=i+1;
        button.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        [_bgView addSubview:button];
        [button addTarget:self action:@selector(chooseCountOrDays:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    self.pickerView = [[ValuePickerView alloc]init];
    self.pickerView.dataSource=daysOrCountsArr;
}
-(void)goNextVC{
    //判断是否选了次数/天数，有次数，才跳下个页面
    if (![_selectedTime isEqualToString:@"null"]) {
        //将——selected除天
        if ([_selectedTime containsString:@"天"]) {
            _selectedTime =[_selectedTime componentsSeparatedByString:@"天"][0];
            model.counts=_selectedTime;
        }else{
            model.counts=_selectedTime;
        }
        GoToPayForAdvertistTableVC *VC=[[GoToPayForAdvertistTableVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if ([model.baseOnCountsOrTime isEqualToString:@"click"]) {
            hud.label.text = NSLocalizedString(@"请选消费次数", @"HUD message title");
        }else{
            hud.label.text = NSLocalizedString(@"请选消费天数", @"HUD message title");
        }

        hud.label.font = [UIFont systemFontOfSize:13];
        //    [hud setColor:[UIColor blackColor]];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        hud.userInteractionEnabled = YES;
        
        [hud hideAnimated:YES afterDelay:2.f];
    }
}
-(void)chooseCountOrDays:(UIButton *)sender{
    //
    if (sender.tag!=12) {
        _selectedTime=sender.titleLabel.text;
        UIButton *recordButton=(UIButton *)[_bgView viewWithTag:_record];
        recordButton.layer.borderColor=[NavBackGroundColor CGColor];
        [recordButton setTitleColor:NavBackGroundColor forState:UIControlStateNormal];
        recordButton.backgroundColor=[UIColor whiteColor];
        
        _record=sender.tag;
        
        sender.backgroundColor=NavBackGroundColor;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        //有地区，并且有活动类型
        __weak PayBaseClickCountVC *tempSelf=self;
        self.pickerView.valueDidSelect = ^(NSString *value){
            NSArray * arr =[value componentsSeparatedByString:@"/"];
            NSString * newValue=arr[0];
            tempSelf.selectedTime=newValue;
            
            UIButton *recordButton=(UIButton *)[tempSelf.bgView viewWithTag:tempSelf.record];
            recordButton.layer.borderColor=[NavBackGroundColor CGColor];
            [recordButton setTitleColor:NavBackGroundColor forState:UIControlStateNormal];
            recordButton.backgroundColor=[UIColor whiteColor];
            
            tempSelf.record=sender.tag;
            
            sender.backgroundColor=NavBackGroundColor;
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setTitle:tempSelf.selectedTime forState:UIControlStateNormal];
        };
        
        [self.pickerView show];
    }
    
    
   
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
