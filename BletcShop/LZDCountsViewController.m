//
//  LZDCountsViewController.m
//  BletcShop
//
//  Created by Bletc on 16/9/29.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LZDCountsViewController.h"
#import "LZDAddVipCell.h"
#import "LZDAddVIPViewController.h"
#import "AddVIPModel.h"

@interface LZDCountsViewController ()<UITableViewDelegate,UITableViewDataSource,addVipDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField *_numText;
    UILabel *totle_label;
}
@property(nonatomic,strong)NSMutableArray *data_vips;

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation LZDCountsViewController

-(NSMutableArray *)data_vips{
    if (!_data_vips) {
        _data_vips = [NSMutableArray array];
        
    }
    return _data_vips;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
    
    
    self.navigationItem.title=@"按次结算";
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
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15,10, SCREENWIDTH-30, 44)];
    lab.text = @"消费次数:";
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = [UIColor blackColor];
    [self.view addSubview:lab];
    
    _numText = [[UITextField alloc]initWithFrame:CGRectMake(90, lab.top+5, 100, lab.height-10)];
    _numText.placeholder = @"请输入次数";
    _numText.borderStyle = UITextBorderStyleRoundedRect;
    _numText.keyboardType = UIKeyboardTypeNumberPad;
    _numText.font = [UIFont systemFontOfSize:15];
    _numText.textColor = [UIColor blackColor];
    _numText.textAlignment = NSTextAlignmentCenter;
    _numText.delegate = self;
    _numText.text = @"0";
    [self.view addSubview:_numText];
    
    UIButton *querenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    querenBtn.frame = CGRectMake(_numText.right+15, _numText.center.y-10, 20, 20);
    querenBtn.layer.cornerRadius = 10;
    querenBtn.tag = 100;
    [querenBtn setImage:[UIImage imageNamed:@"grey_add"] forState:UIControlStateNormal];
    [querenBtn setImage:[UIImage imageNamed:@"grey_add"] forState:UIControlStateHighlighted];
    [querenBtn addTarget:self action:@selector(AddorSub:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:querenBtn];
    
    UIButton *querenBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    querenBtn1.frame = CGRectMake(querenBtn.right+20, querenBtn.top, querenBtn.width, querenBtn.height);
    querenBtn1.layer.cornerRadius = 10;
    querenBtn1.tag = 101;
    [querenBtn1 setImage:[UIImage imageNamed:@"grey_red"] forState:UIControlStateNormal];
    [querenBtn1 setImage:[UIImage imageNamed:@"grey_red"] forState:UIControlStateHighlighted];
    [querenBtn1 addTarget:self action:@selector(AddorSub:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:querenBtn1];

    
    
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _numText.bottom+10, SCREENWIDTH, SCREENHEIGHT-_numText.bottom-10) style:UITableViewStylePlain];
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
    totle_label.text = @"合计:0次";
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
//    DebugLog("goJiesuan");
    
    if ([_numText.text intValue]<=0) {
        [self tishikuang:@"请输入次数!"];
        return;
    }else if(self.data_vips.count<=0){
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
            cardType = @"t";
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
                NSString *productName = @"结算次数";
                NSString *productPrice = [[NSString alloc]initWithFormat:@"%ld",[_numText.text integerValue] ];
                dataString1 =[ NSString stringWithFormat:@"%@%@%@",productName,PAY_NP,productPrice ];
                
                NSString *statementString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@\r\n",PAY_ROUND,cardType,PAY_TYPE,newDataString,PAY_USCS,dataString1,PAY_ROUND];
                
                
                
                AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                NSData *writeData = [statementString dataUsingEncoding:NSUTF8StringEncoding];
                if([_numText.text intValue]>0&&self.data_vips.count>0){
                    [appdelegate.asyncSocketShop writeData:writeData withTimeout:-1 tag:0];
                }
                NSLog(@"DataString =%@",statementString);
                //tyenulltt消费次数sm2
            }
        }
    }
}
-(void)AddorSub:(UIButton*)button{
    
    int num = [_numText.text intValue];
    if (button.tag ==100) {
        num +=1;
    }else{
        if (num>0) {
            num -=1;

        }
        
    }
    
   _numText.text =[[NSString alloc]initWithFormat:@"%d",num];
    
    totle_label.text = [NSString stringWithFormat:@"合计:%@次",_numText.text];


}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    totle_label.text = [NSString stringWithFormat:@"合计:%@次",textField.text];
    if ([textField.text floatValue]<=0.0) {
        totle_label.text = [NSString stringWithFormat:@"合计:0次"];
        
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)resigefirst{
    [self.view endEditing:YES];
    [_numText resignFirstResponder];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_numText resignFirstResponder];
    
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
@end
