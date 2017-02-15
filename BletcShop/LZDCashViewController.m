//
//  LZDCashViewController.m
//  BletcShop
//
//  Created by Bletc on 16/9/29.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LZDCashViewController.h"
#import "LZDAddVipCell.h"
#import "LZDAddVIPViewController.h"
#import "AddVIPModel.h"

@interface LZDCashViewController ()<UITableViewDelegate,UITableViewDataSource,addVipDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField *_money_filed;
    UILabel *totle_label;
}
@property(nonatomic,strong)NSMutableArray *data_vips;

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation LZDCashViewController

-(NSMutableArray *)data_vips{
    if (!_data_vips) {
        _data_vips = [NSMutableArray array];
        
    }
    return _data_vips;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
    
    
    self.navigationItem.title=@"金额结算";
      LZDButton *rightBtn = [LZDButton creatLZDButton];
    rightBtn.frame = CGRectMake(kWeChatScreenWidth-50, 20, 50, 44);
    
    [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightButton;

    
    rightBtn.block = ^(LZDButton *btn){
        NSLog(@"添加");
        
        LZDAddVIPViewController *VC = [[LZDAddVIPViewController alloc]init];
        VC.delegate = self;
        [self.navigationController pushViewController:VC animated:YES];
    };
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREENWIDTH-30, 44)];
    lab.text = @"金额收费(元):";
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = [UIColor blackColor];
    [self.view addSubview:lab];
    
    _money_filed = [[UITextField alloc]initWithFrame:CGRectMake(110, lab.top+5, SCREENWIDTH-120, lab.height-10)];
    _money_filed.placeholder = @"请输入金额";
    _money_filed.borderStyle = UITextBorderStyleLine;
    _money_filed.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _money_filed.font = [UIFont systemFontOfSize:15];
    _money_filed.textColor = [UIColor blackColor];
    _money_filed.delegate = self;
    [self.view addSubview:_money_filed];
    
   


    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _money_filed.bottom+10, SCREENWIDTH, SCREENHEIGHT-_money_filed.bottom-10) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resigefirst)];
    
    [tableView addGestureRecognizer:tap];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-64-64, SCREENWIDTH, 64)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
     totle_label = [[UILabel alloc]initWithFrame:CGRectMake(60, 0,150, bottomView.height)];
    totle_label.textColor = [UIColor blackColor];
    totle_label.text = @"合计:¥ 0.00";
    totle_label.font = [UIFont systemFontOfSize:17];
    [bottomView addSubview:totle_label];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREENWIDTH-100, 0, 100, bottomView.height);
    button.backgroundColor = RGB(88, 174, 245);
    [button setTitle:@"结算" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button addTarget:self action:@selector(goJiesuan) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:button];
    
    
    
}

-(void)senderVip_array:(NSArray *)arr{
    self.data_vips = [NSMutableArray arrayWithArray:arr];
    
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_vips.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier= @"cellID";
    LZDAddVipCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LZDAddVipCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.choseBtn.hidden = YES;
    }
    
    if (self.data_vips.count>0) {

        AddVIPModel *model = [[AddVIPModel alloc]initModelWithDictionary:self.data_vips[indexPath.row]];
        cell.vipModel = model;
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
            [self.data_vips removeObjectAtIndex:indexPath.row];
        
        
        
        [_tableView reloadData];
    }
}


-(void)goJiesuan{
//    DebugLog(@"goJiesuan");
    
    if ([_money_filed.text isEqualToString:@""]) {
        [self tishikuang:@"请输入金额!"];
        return;
    }else if(![self isPureInt:_money_filed.text] && ![self isPureFloat:_money_filed.text]){
        
        [self tishikuang:@"请输入纯数字!"];
        return;
        
    }
    
    else if([_money_filed.text floatValue]<0.0){
        
        [self tishikuang:@"请输入金额!"];
        return;
        
    }
    else if(self.data_vips.count<=0){
        [self tishikuang:@"请添加会员!"];
        
        return;
        
    }else{

    UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否发送订单信息?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [altView show];
    
    }
    
 
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
            
            NSString *newDataString = [[NSString alloc]init];
            NSString *dataString1 = [[NSString alloc]init];//第一个商品内容
            NSString *newDataString1 = [[NSString alloc]init];//第一个用户
            NSString *newDataString2 = [[NSString alloc]init];//第二个及后面
            NSString *su = PAY_UORC;
            {
                NSString *cardType = [[NSString alloc]init];
                cardType = @"v";
                
                
                {
                    if (self.data_vips.count>0) {
                        newDataString1 = [[self.data_vips objectAtIndex:0] objectForKey:@"uuid"];
                        //拼接所有的用户信息
                        if (self.data_vips.count==1) {
                            newDataString = [[self.data_vips objectAtIndex:0] objectForKey:@"uuid"];
                        }else if (self.data_vips.count>1) {
                            for (int i=1; i<self.data_vips.count; i++) {
                                newDataString2 = [su stringByAppendingString:[[self.data_vips objectAtIndex:i] objectForKey:@"uuid"]];
                                newDataString = [newDataString1 stringByAppendingString:newDataString2];
                                newDataString1 = newDataString;
                            }
                        }
                        //拼接所有的商品信息
                        NSString *productName = @"结算金额";
                        NSString *productPrice = [[NSString alloc]initWithFormat:@"%.2f",[_money_filed.text floatValue] ];
                        dataString1 =[ NSString stringWithFormat:@"%@%@%@元",productName,PAY_NP,productPrice ];
                        
                        NSString *statementString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@\r\n",PAY_ROUND,cardType,PAY_TYPE,newDataString,PAY_USCS,dataString1,PAY_ROUND];
                        

                        
                        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                        NSData *writeData = [statementString dataUsingEncoding:NSUTF8StringEncoding];
                        if([_money_filed.text intValue]>0&&self.data_vips.count>0){
                            [appdelegate.asyncSocketShop writeData:writeData withTimeout:-1 tag:0];
                        }
                        NSLog(@"DataString =%@",statementString);
                    }
                }
                
            }
            
        }

    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    totle_label.text = [NSString stringWithFormat:@"合计:¥ %@",textField.text];
    if ([textField.text floatValue]<=0.0) {
        totle_label.text = [NSString stringWithFormat:@"合计:¥ 0.00"];

    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)resigefirst{
    [self.view endEditing:YES];
    [_money_filed resignFirstResponder];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_money_filed resignFirstResponder];

    [self.view endEditing:YES];
}


-(void)tishikuang:(NSString*)sting_ts{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(sting_ts, @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:4.f];
    
}

//判断是整数
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string]; //定义一个NSScanner，扫描string
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
//是否是小数
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
