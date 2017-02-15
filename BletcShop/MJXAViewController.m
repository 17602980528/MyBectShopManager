//
//  MJXAViewController.m
//  BletcShop
//
//  Created by apple on 16/9/29.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MJXAViewController.h"
#import "RoyShopTableViewCell.h"
#import "UIImageView+WebCache.h"

#import "LZDAddVipCell.h"
#import "AddVIPModel.h"

@interface MJXAViewController ()<UITableViewDelegate,UITableViewDataSource,SelectShopDelegate,addVipDelegate,UIAlertViewDelegate>
{
    UILabel *totalMoneyLabel;
    UITableView *_tableView;
    NSMutableArray *shopArray;
    NSMutableArray *memberArray;
    UIView *btnView;
    BOOL isOpen;
    float totalPrice;
    
    UIView *back_View;
}
@end

@implementation MJXAViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString:@"#eaeaea"];
    self.navigationItem.title=@"明细结算";
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addBtnClick)];
    self.navigationItem.rightBarButtonItem=rightButton;

    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-64*2, SCREENWIDTH, 64)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    totalMoneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 12, SCREENWIDTH-100, 40)];
    totalMoneyLabel.text=@"合计：￥0.00";
    totalMoneyLabel.font=[UIFont systemFontOfSize:17.0f];
    [view addSubview:totalMoneyLabel];
    
    totalPrice=0;
    
    UIButton *jiesuanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    jiesuanBtn.frame=CGRectMake(SCREENWIDTH-100, 0, 100, 64);
    jiesuanBtn.backgroundColor=[UIColor colorWithRed:88/255.0 green:174/255.0 blue:245/255.0 alpha:1.0f];
    [jiesuanBtn setTitle:@"结算" forState:UIControlStateNormal];
    [jiesuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:jiesuanBtn];
    [jiesuanBtn addTarget:self action:@selector(jsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //
    shopArray =[[NSMutableArray alloc]init];
    memberArray=[[NSMutableArray alloc]init];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-128) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];

    
    isOpen=NO;
    btnView=[[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH-130, 0, 130, 80)];
    btnView.backgroundColor=RGB(234, 234, 234);
    btnView.hidden=YES;
    [self.view addSubview:btnView];
    
    UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    imageView1.image=[UIImage imageNamed:@"se_icon_pr"];
    [btnView addSubview:imageView1];
    UIImageView *imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(10, 50, 20, 20)];
    imageView2.image=[UIImage imageNamed:@"se_icon_coy"];
    [btnView addSubview:imageView2];
    
    UIButton *upBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    upBtn.frame=CGRectMake(30, 0, 90, 40);
    [upBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    upBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [upBtn setTitle:@"添加产品" forState:UIControlStateNormal];
    [upBtn addTarget:self action:@selector(addShopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:upBtn];
    
    UIButton *downBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    downBtn.frame=CGRectMake(30, 40, 90, 40);
    [downBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    downBtn.titleLabel.font = upBtn.titleLabel.font;
    [downBtn setTitle:@"添加会员" forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(addMemberBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:downBtn];
    [self creatbackView];
}
-(void)creatbackView{
    back_View = [[UIView alloc]init];
    back_View.bounds= CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH);
    back_View.center = CGPointMake(SCREENWIDTH/2, (SCREENHEIGHT-64)/2-32);
    back_View.hidden= NO;
    [self.view addSubview:back_View];
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/3, SCREENWIDTH/3-50, SCREENWIDTH/3, SCREENWIDTH/3)];
    imgV.image = [UIImage imageNamed:@"tanhao"];
    [back_View addSubview:imgV];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imgV.bottom, SCREENWIDTH, 30)];
    lab.text = @"您还没有添加会员和商品哦!";
    lab.textColor = [UIColor darkGrayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font= [UIFont systemFontOfSize:15];
    [back_View addSubview:lab];
    
    
}
//添加
-(void)addBtnClick{
    if (!isOpen) {
        btnView.hidden=NO;
    }else{
        btnView.hidden=YES;
    }
    isOpen=!isOpen;
}
//添加产品
-(void)addShopBtnClick{
    btnView.hidden=YES;
    isOpen=!isOpen;
    SelectShopViewController *shopVC=[[SelectShopViewController alloc]init];
    shopVC.delegate=self;
    [self.navigationController pushViewController:shopVC animated:YES];
}
//添加会员
-(void)addMemberBtnCLick{
    btnView.hidden=YES;
    isOpen=!isOpen;
    LZDAddVIPViewController *memberVC=[[LZDAddVIPViewController alloc]init];
    memberVC.delegate = self;
    [self.navigationController pushViewController:memberVC animated:YES];
}
//去结算
-(void)jsBtnClick{
    
    if (memberArray.count>0 && shopArray.count>0) {
        UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否发送订单信息?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [altView show];

        
    }else{
        [self tishikuang:@"请选择商品或会员!"];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSString *dataString = [[NSString alloc]init];
        NSString *newDataString = [[NSString alloc]init];
        NSString *dataString1 = [[NSString alloc]init];//第一个商品内容
        NSString *newDataString1 = [[NSString alloc]init];//第一个用户
        NSString *dataString2 = [[NSString alloc]init];//第二个及多个
        NSString *newDataString2 = [[NSString alloc]init];//第二个及后面
        NSString *su = PAY_UORC;
        NSString *cardType = [[NSString alloc]init];
        cardType = @"v";
        
        
        {
            if (memberArray.count>0&&shopArray.count>0) {
                newDataString1 = [[memberArray objectAtIndex:0] objectForKey:@"uuid"];
                //拼接所有的用户信息
                if (memberArray.count==1) {
                    newDataString = [[memberArray objectAtIndex:0] objectForKey:@"uuid"];
                }else if (memberArray.count>1) {
                    for (int i=1; i<memberArray.count; i++) {
                        
                        newDataString2 = [su stringByAppendingString:[[memberArray objectAtIndex:i] objectForKey:@"uuid"]];
                        newDataString = [newDataString1 stringByAppendingString:newDataString2];
                        newDataString1 = newDataString;
                    }
                }
                //拼接所有的商品信息
                NSString *productName = [[shopArray objectAtIndex:0] objectForKey:@"name"];
                NSString *productPrice = [[shopArray objectAtIndex:0] objectForKey:@"price"];
                dataString1 =[ NSString stringWithFormat:@"%@%@%@",productName,PAY_NP,productPrice ];
                if (shopArray.count==1) {
                    
                    dataString =[ NSString stringWithFormat:@"%@%@%@",productName,PAY_NP,productPrice ];
                }else if (shopArray.count>1) {
                    for (int i=1; i<shopArray.count; i++) {
                        dataString2 = [su stringByAppendingString:[ NSString stringWithFormat:@"%@%@%@",[[shopArray objectAtIndex:i] objectForKey:@"name"],PAY_NP,[[shopArray objectAtIndex:i] objectForKey:@"price"] ]];
                        dataString = [dataString1 stringByAppendingString:dataString2];
                        dataString1 = dataString;
                    }
                }
            }
            
            NSString *statementString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@\r\n",PAY_ROUND,cardType,PAY_TYPE,newDataString,PAY_USCS,dataString,PAY_ROUND];
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            NSData *writeData = [statementString dataUsingEncoding:NSUTF8StringEncoding];
            if(shopArray.count>0&&memberArray.count>0){
                [appdelegate.asyncSocketShop writeData:writeData withTimeout:-1 tag:0];
                
            }
            NSLog(@"DataString =%@",statementString);
        }

    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return shopArray.count;
    }else if(section==1){
        return memberArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lab = [UILabel new];
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont systemFontOfSize:17];
    if (section ==0) {
        lab.text = @"   商品";
    }else{
        lab.text = @"   会员";
    }
    return lab;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
    RoyShopTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[RoyShopTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.choseBtn.hidden=YES;
        
        
        
        cell.nameLabel.text = [[shopArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.bianHaoLable.text = [[shopArray objectAtIndex:indexPath.row] objectForKey:@"number"];
        cell.priceLabel.text = [[shopArray objectAtIndex:indexPath.row] objectForKey:@"price"];
        cell.cuCunLabel.text = [NSString stringWithFormat:@"库存 %@",[[shopArray objectAtIndex:indexPath.row] objectForKey:@"remain"]];
        
        [cell.headIamgeView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,[[shopArray objectAtIndex:indexPath.row] objectForKey:@"image_url"]]] placeholderImage:[UIImage imageNamed:@"icon3"]];

   

        return cell;
    }else{
        
        static NSString *identifier= @"cellID";
        LZDAddVipCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[LZDAddVipCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.choseBtn.hidden = YES;
        }
        
        if (memberArray>0) {
            
            AddVIPModel *model = [[AddVIPModel alloc]initModelWithDictionary:memberArray[indexPath.row]];
            cell.vipModel = model;
            
        }
        return cell;

        
    }

}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        if (indexPath.section==0) {
            [shopArray removeObjectAtIndex:indexPath.row];
        }else{
            [memberArray removeObjectAtIndex:indexPath.row];
        }
        
        totalPrice = 0.0;
        for (int i=0; i<shopArray.count; i++) {
            NSArray * array=[shopArray[i][@"price"] componentsSeparatedByString:@"元"];
            NSLog(@"%@",array);
            NSString *string=array[0];
            CGFloat price = [string floatValue];
            
            totalPrice =totalPrice + price;
            NSLog(@"%.2f",totalPrice);
        }
        
        if (memberArray.count==0&&shopArray.count==0) {
            back_View.hidden= NO;
            _tableView.hidden = YES;
        }else{
            _tableView.hidden = NO;
            back_View.hidden= YES;
            
        }
        
        totalMoneyLabel.text=[NSString stringWithFormat:@"合计：￥%.2f",totalPrice];

        
        [_tableView reloadData];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 100;
    }else if (indexPath.section==1){
        return 70;
    }
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)sendNsArr:(NSMutableArray *)arr{
    
    
    shopArray=arr;
    for (int i=0; i<shopArray.count; i++) {
        NSArray * array=[shopArray[i][@"price"] componentsSeparatedByString:@"元"];
        NSLog(@"%@",array);
        NSString *string=array[0];
        CGFloat price = [string floatValue];
        
        totalPrice =totalPrice + price;
        NSLog(@"%.2f",totalPrice);
    }
    
    if (memberArray.count==0&&shopArray.count==0) {
        back_View.hidden= NO;
        _tableView.hidden = YES;
    }else{
        _tableView.hidden = NO;
        back_View.hidden= YES;

    }

    totalMoneyLabel.text=[NSString stringWithFormat:@"合计：￥%.2f",totalPrice];
    
    [_tableView reloadData];

}

-(void)senderVip_array:(NSArray *)arr{
    
    memberArray = [NSMutableArray arrayWithArray:arr];
    
    if (memberArray.count==0&&shopArray.count==0) {
        back_View.hidden= NO;
        _tableView.hidden = YES;
    }else{
        _tableView.hidden = NO;
        back_View.hidden= YES;

    }

    [_tableView reloadData];
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
