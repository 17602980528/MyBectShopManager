//
//  OrderInfomaViewController.m
//  BletcShop
//
//  Created by Bletc on 16/7/27.
//  Copyright © 2016年 bletc. All rights reserved.
//
/**
 *  订单详情
 */

#import "OrderInfomaViewController.h"
#import "BuyCardChoicePayViewController.h"
#import "ChoicePayTypeViewController.h"

#import "MoneyBagChoiceTypeViewController.h"
#import "MyCashCouponViewController.h"
@interface OrderInfomaViewController ()<ViewControllerBDelegate>

@end

@implementation OrderInfomaViewController
-(NSDictionary *)coup_dic{
    if (!_coup_dic) {
        _coup_dic = [NSDictionary dictionary];
    }
    return _coup_dic;
}
- (void)sendValue:(NSDictionary *)value
{
    self.coup_dic = value;
    
    
    NSLog(@"ddddddd%@",self.coup_dic);
    self.Type = Wares;
    [self.myTable reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"确认订单";
    self.view.backgroundColor = [UIColor whiteColor];
    self.allPoint = [[NSString alloc]init];
    self.Type = 888;
    self.canUsePoint = 0;

    [self _inittable];

    [self postRequestPoints];
    
}
-(void)postRequestPoints
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountGet",BASEURL];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:@"integral" forKey:@"type"];
    
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        
        self.allPoint = result[@"integral"];

        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

-(void)_inittable
{
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.rowHeight = 104;
    table.bounces = NO;
    self.myTable = table;
    [self.view addSubview:table];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 4;
    }else if(section==1)
    {
        if (self.orderInfoType==3) {
            return 0;
        }
        else
            return 2;
    }
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==3) {
        return 20;
    }
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIndentifier = @"cellIndentifier";
    // 定义唯一标识
    // 通过indexPath创建cell实例 每一个cell都是单独的
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if(indexPath.section==0)
    {
        if (self.orderInfoType==1) {
            if (indexPath.row==0) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
                
                label.font = [UIFont systemFontOfSize:15];
                [cell addSubview:label];
                label.text = [[NSString alloc]initWithFormat:@"订单信息:%@",@"买卡"];
                label.textAlignment = NSTextAlignmentLeft;
                UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
                linePhone.backgroundColor = [UIColor grayColor];
                linePhone.alpha = 0.3;
                [cell addSubview:linePhone];
            }else if (indexPath.row==1) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
                
                label.font = [UIFont systemFontOfSize:15];
                [cell addSubview:label];
                label.text = [[NSString alloc]initWithFormat:@"卡片类型:%@",self.card_dic[@"type"]];
                label.textAlignment = NSTextAlignmentLeft;
                UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
                linePhone.backgroundColor = [UIColor grayColor];
                linePhone.alpha = 0.3;
                [cell addSubview:linePhone];
            }else if (indexPath.row==2)
            {
                UILabel *phonelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
                phonelabel.textAlignment = NSTextAlignmentLeft;
                phonelabel.font = [UIFont systemFontOfSize:15];
                [cell addSubview:phonelabel];
                phonelabel.text = [[NSString alloc]initWithFormat:@"卡片级别:%@",self.card_dic[@"level"] ];
                UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
                linePhone.backgroundColor = [UIColor grayColor];
                linePhone.alpha = 0.3;
                [cell addSubview:linePhone];
                
            }else if (indexPath.row==3)
            {
                UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
                levelLabel.textAlignment = NSTextAlignmentLeft;
                levelLabel.font = [UIFont systemFontOfSize:15];
                [cell addSubview:levelLabel];
                levelLabel.text = [[NSString alloc]initWithFormat:@"应付金额:%@",self.moneyString ];
                UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
                linePhone.backgroundColor = [UIColor grayColor];
                linePhone.alpha = 0.3;
                [cell addSubview:linePhone];
                
            }
        }else if (self.orderInfoType==2){
            
            if (indexPath.row==0) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
                
                label.font = [UIFont systemFontOfSize:15];
                [cell addSubview:label];
                label.text = [[NSString alloc]initWithFormat:@"订单信息:%@",@"续卡"];
                label.textAlignment = NSTextAlignmentLeft;
                UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
                linePhone.backgroundColor = [UIColor grayColor];
                linePhone.alpha = 0.3;
                [cell addSubview:linePhone];
            }else if (indexPath.row==1) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
                
                label.font = [UIFont systemFontOfSize:15];
                [cell addSubview:label];
                
                label.text = [[NSString alloc]initWithFormat:@"卡号:%@",appdelegate.cardInfo_dic[@"card_code"]];
                label.textAlignment = NSTextAlignmentLeft;
                UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
                linePhone.backgroundColor = [UIColor grayColor];
                linePhone.alpha = 0.3;
                [cell addSubview:linePhone];
            }else if (indexPath.row==2)
            {
                UILabel *phonelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
                phonelabel.textAlignment = NSTextAlignmentLeft;
                phonelabel.font = [UIFont systemFontOfSize:15];
                [cell addSubview:phonelabel];
                phonelabel.text = [[NSString alloc]initWithFormat:@"卡片级别:%@",appdelegate.cardInfo_dic[@"card_level"] ];
                UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
                linePhone.backgroundColor = [UIColor grayColor];
                linePhone.alpha = 0.3;
                [cell addSubview:linePhone];
                
            }else if (indexPath.row==3)
            {
                UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
                levelLabel.textAlignment = NSTextAlignmentLeft;
                levelLabel.font = [UIFont systemFontOfSize:15];
                [cell addSubview:levelLabel];
                levelLabel.text = [[NSString alloc]initWithFormat:@"应付金额:%@",self.moneyString ];
                UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
                linePhone.backgroundColor = [UIColor grayColor];
                linePhone.alpha = 0.3;
                [cell addSubview:linePhone];
                
            }

            
        }else if (self.orderInfoType==3){
            if (indexPath.row==0) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
                
                label.font = [UIFont systemFontOfSize:15];
                [cell addSubview:label];
                label.text = [[NSString alloc]initWithFormat:@"订单信息:%@",@"金额充值"];
                label.textAlignment = NSTextAlignmentLeft;
                UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
                linePhone.backgroundColor = [UIColor grayColor];
                linePhone.alpha = 0.3;
                [cell addSubview:linePhone];
            }else if (indexPath.row==1) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
                
                label.font = [UIFont systemFontOfSize:15];
                [cell addSubview:label];
                label.text = [[NSString alloc]initWithFormat:@"账号:%@",appdelegate.userInfoDic[@"phone"]];
                label.textAlignment = NSTextAlignmentLeft;
                UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
                linePhone.backgroundColor = [UIColor grayColor];
                linePhone.alpha = 0.3;
                [cell addSubview:linePhone];
            }else if (indexPath.row==2)
            {
                UILabel *phonelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
                phonelabel.textAlignment = NSTextAlignmentLeft;
                phonelabel.font = [UIFont systemFontOfSize:15];
                [cell addSubview:phonelabel];
                phonelabel.text = [[NSString alloc]initWithFormat:@"昵称:%@",appdelegate.userInfoDic[@"nickname"] ];
                UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
                linePhone.backgroundColor = [UIColor grayColor];
                linePhone.alpha = 0.3;
                [cell addSubview:linePhone];
                
            }else if (indexPath.row==3)
            {
                UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
                levelLabel.textAlignment = NSTextAlignmentLeft;
                levelLabel.font = [UIFont systemFontOfSize:15];
                [cell addSubview:levelLabel];
                levelLabel.text = [[NSString alloc]initWithFormat:@"充值金额:%@",self.moneyString ];
                UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
                linePhone.backgroundColor = [UIColor grayColor];
                linePhone.alpha = 0.3;
                [cell addSubview:linePhone];
                
            }
            
        }else if (self.orderInfoType==4){
            if (indexPath.row==0) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
                
                label.font = [UIFont systemFontOfSize:15];
                [cell addSubview:label];
                label.text = [[NSString alloc]initWithFormat:@"订单信息:%@",@"升级"];
                label.textAlignment = NSTextAlignmentLeft;
                UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
                linePhone.backgroundColor = [UIColor grayColor];
                linePhone.alpha = 0.3;
                [cell addSubview:linePhone];
            }else if (indexPath.row==2) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
                
                label.font = [UIFont systemFontOfSize:15];
                [cell addSubview:label];
                label.text = [[NSString alloc]initWithFormat:@"升级级别:%@",appdelegate.payCardType ];
                label.textAlignment = NSTextAlignmentLeft;
                UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
                linePhone.backgroundColor = [UIColor grayColor];
                linePhone.alpha = 0.3;
                [cell addSubview:linePhone];
            }else if (indexPath.row==1)
            {
                UILabel *phonelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
                phonelabel.textAlignment = NSTextAlignmentLeft;
                phonelabel.font = [UIFont systemFontOfSize:15];
                [cell addSubview:phonelabel];
                
                phonelabel.text = [[NSString alloc]initWithFormat:@"原卡级别:%@",appdelegate.cardInfo_dic[@"card_level"] ];
                UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
                linePhone.backgroundColor = [UIColor grayColor];
                linePhone.alpha = 0.3;
                [cell addSubview:linePhone];
                
            }else if (indexPath.row==3)
            {
                UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
                levelLabel.textAlignment = NSTextAlignmentLeft;
                levelLabel.font = [UIFont systemFontOfSize:15];
                [cell addSubview:levelLabel];
                levelLabel.text = [[NSString alloc]initWithFormat:@"应付金额:%@",self.moneyString ];
                UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
                linePhone.backgroundColor = [UIColor grayColor];
                linePhone.alpha = 0.3;
                [cell addSubview:linePhone];
                
            }

        }
    }
    else if(indexPath.section==1)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 90, 50)];
        label.font = [UIFont systemFontOfSize:15];
        [cell addSubview:label];
        
        label.textAlignment = NSTextAlignmentLeft;
        UIView *linePhone = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
        linePhone.backgroundColor = [UIColor grayColor];
        linePhone.alpha = 0.3;
        [cell addSubview:linePhone];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
        
        [cell addSubview:imageView];
        UILabel *contentlabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, SCREENWIDTH-150, 50)];
        contentlabel.font = [UIFont systemFontOfSize:12];
        [cell addSubview:contentlabel];

        contentlabel.textAlignment = NSTextAlignmentRight;
        
        if (indexPath.row==0) {
            label.text = @"使用乐点";
            NSLog(@"self.allPoint%@",self.allPoint);
            if (self.Type == points) {
                imageView.image = [UIImage imageNamed:@"checkbox_yes"];
                if(!(([self.allPoint integerValue]/10)<([self.moneyString floatValue])))
                {
                    self.canUsePoint =(([self.moneyString floatValue])/2)*10;
                }else
                    self.canUsePoint =[self.allPoint floatValue];
                
                
                NSLog(@"self.allPoint%ld",(([self.moneyString integerValue])/2)*10);
                
                //self.canUsePoint =40;
                float diXian =self.canUsePoint/10;
                if(!((([self.moneyString floatValue])/2)<1))
                {
                    contentlabel.text = [[NSString alloc]initWithFormat:@"可用%.f乐点抵用%.2f元现金",self.canUsePoint,diXian ];
                }else
                    contentlabel.text =@"不可使用乐点";

            }
            if(((([self.moneyString floatValue])/2)<1))
            {
                contentlabel.text =@"不可使用乐点";
            }
        }else
        {
            label.text = @"使用代金券";
            if (self.coup_dic.count>0) {
                contentlabel.text = [[NSString alloc]initWithFormat:@"%@代金券",self.coup_dic[@"type"]];
                if (self.Type == Wares) {
                    imageView.image = [UIImage imageNamed:@"checkbox_yes"];
                }
            }if(([self.moneyString floatValue]<1))
            {
                contentlabel.text = @"不可用代金券";
            }
            
        }
    }
    else if(indexPath.section==2)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 90, 50)];
        label.text = @"支付金额";
        label.font = [UIFont systemFontOfSize:15];
        [cell addSubview:label];
        UILabel *contentlabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, SCREENWIDTH-180, 50)];
        self.contentLabel = contentlabel;
        contentlabel.font = [UIFont systemFontOfSize:12];
        [cell addSubview:contentlabel];
        NSLog(@"self.moneyString----%f",[self.moneyString floatValue]);
        contentlabel.textAlignment = NSTextAlignmentRight;
        if(self.Type==Wares)
        {
            NSRange pend = [self.coup_dic[@"type"] rangeOfString:@"元"];
            NSString* price =[self.coup_dic[@"type"] substringToIndex:pend.location];
            if (!(([self.moneyString floatValue]*10/100)<[price floatValue])) {
                contentlabel.text = [[NSString alloc]initWithFormat:@"%.2f",([self.moneyString floatValue]-[price floatValue])];
            }else
            {
                contentlabel.text = [[NSString alloc]initWithFormat:@"%.2f",([self.moneyString floatValue]*90/100)];
                
            }
            NSLog(@"self.couponArray%@",self.coup_dic[@"type"]);
            
        }else if(self.Type==points)
        {
            if(!((([self.moneyString floatValue])/2)<1))
            {
            contentlabel.text = [[NSString alloc]initWithFormat:@"%.2f",[self.moneyString floatValue]-self.canUsePoint/10];
            }else
                contentlabel.text = [[NSString alloc]initWithFormat:@"%.2f",[self.moneyString floatValue]];
            
        }else
        {
            contentlabel.text = [[NSString alloc]initWithFormat:@"%.2f",[self.moneyString floatValue]];
        }
//        contentlabel.text = @"0.01";
    }
    else
    {
        UIButton *LandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        LandBtn.frame = CGRectMake(80, 5, SCREENWIDTH-160, 40);
        [LandBtn setTitle:@"确认订单" forState:UIControlStateNormal];
        [LandBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [LandBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [LandBtn setBackgroundColor:NavBackGroundColor];
        LandBtn.layer.cornerRadius = 10;
        [LandBtn addTarget:self action:@selector(admitAction) forControlEvents:UIControlEventTouchUpInside];
        LandBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cell addSubview:LandBtn];
    }
    return cell;
}
-(void)admitAction
{



    
    
    NSLog(@"---%d",self.orderInfoType);
    //买卡
    if (self.orderInfoType==1)
    {
        BuyCardChoicePayViewController *choiceView = [[BuyCardChoicePayViewController alloc]init];
        
        choiceView.moneyString =self.moneyString;
        choiceView.orderInfoType = self.orderInfoType;
        
        
        if (self.Type==Wares)
        {
            choiceView.pay_Type = @"voucher";
            choiceView.coup_dic = self.coup_dic;
        }
        else if (self.Type == points)
        {
            choiceView.pay_Type = @"integral";
            choiceView.point = [[NSString alloc]initWithFormat:@"%.f",self.canUsePoint];
        }else
        {
            choiceView.pay_Type = @"null";
        }
        choiceView.actualMoney = self.contentLabel.text;
        
        [self.navigationController pushViewController:choiceView animated:YES];
        
        
    }else if (self.orderInfoType==2 || self.orderInfoType==4)
    {
        //续卡====升级
        ChoicePayTypeViewController *choiceView = [[ChoicePayTypeViewController alloc]init];
        choiceView.moneyString =self.moneyString;
        choiceView.orderInfoType = self.orderInfoType;


        if (self.Type==Wares)
        {
            choiceView.pay_Type = @"voucher";
            choiceView.coup_dic = self.coup_dic;
        }
        else if (self.Type == points)
        {
            choiceView.pay_Type = @"integral";
            choiceView.point = [[NSString alloc]initWithFormat:@"%.f",self.canUsePoint];
        }else
        {
            choiceView.pay_Type = @"null";
        }
        choiceView.actualMoney = self.contentLabel.text;
        
        [self.navigationController pushViewController:choiceView animated:YES];
    }else if (self.orderInfoType==3)
    {//充值
        MoneyBagChoiceTypeViewController *choiceView = [[MoneyBagChoiceTypeViewController alloc]init];

        choiceView.moneyString =self.moneyString;
        
        choiceView.pay_Type = @"null";
        
        choiceView.actualMoney = self.contentLabel.text;
        
        [self.navigationController pushViewController:choiceView animated:YES];
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        if(indexPath.row == 1)
        {
            if(!([self.moneyString floatValue]<1))
            {
            self.canUsePoint =0;
            MyCashCouponViewController *choiceView = [[MyCashCouponViewController alloc]init];

                choiceView.useCoupon = 100;
            choiceView.delegate = self;
            [self.navigationController pushViewController:choiceView animated:YES];
            }
            
        }
        else if(indexPath.row == 0)
        {
            if(!((([self.moneyString floatValue])/2)<1)){
            self.Type = points;
                
//            if (self.couponArray.count>0) {
//                [self.couponArray removeAllObjects];
//            }
            [self.myTable reloadData];
            }
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
