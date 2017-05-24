//
//  CanPayCardViewController.m
//  BletcShop
//
//  Created by Bletc on 16/6/6.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "CanPayCardViewController.h"
#import "CardVipCell.h"
#import "UIImageView+WebCache.h"
#import "RechargeViewController.h"

#import "MoneyPAYViewController.h"
#import "CountPAYViewController.h"
@interface CanPayCardViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)UITableView *Cardtable;
@property(nonatomic,strong)NSArray *data;

@end

@implementation CanPayCardViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self getCardList];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    
    self.navigationItem.title = @"我的会员卡";

    
    
    [self _inittable];

}


-(NSArray *)data
{
    if (_data == nil) {
        _data = [NSArray array];
    }return _data;
}
//创建TableView
-(void)_inittable
{
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.rowHeight = 104;
    table.bounces = NO;
    self.Cardtable = table;
    [self.view addSubview:table];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.payCardArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 185;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
        //cell.backgroundColor = RGB(240, 240, 240);
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    
    
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    
    //    if (indexPath.section==0) {
    
    NSDictionary *dic =[_payCardArray objectAtIndex:indexPath.row];
    
    UIView *bigView=[[UIView alloc]initWithFrame:CGRectMake(39, 10, SCREENWIDTH-78, 165)];
    bigView.backgroundColor=[UIColor whiteColor];
    bigView.layer.cornerRadius=10;
    bigView.clipsToBounds=YES;
    bigView.userInteractionEnabled=YES;
    [cell addSubview:bigView];
    
    UIView*upView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-78, 165-49)];
    upView.backgroundColor=[UIColor colorWithHexString:dic[@"card_temp_color"]];
    upView.userInteractionEnabled=YES;
    [bigView addSubview:upView];
    
    UIView *downView=[[UIView alloc]initWithFrame:CGRectMake(0, 165-49, SCREENWIDTH-78, 49)];
    downView.userInteractionEnabled=YES;
    downView.backgroundColor=[UIColor whiteColor];
    [bigView addSubview:downView];
    
    
    UILabel *typeAndeLevel = [[UILabel alloc]initWithFrame:CGRectMake(12, 30, upView.width-12, 23)];
    typeAndeLevel.textColor = RGB(255,255,255);
    typeAndeLevel.text = [NSString stringWithFormat:@"%@(%@)",dic[@"card_type"],dic[@"card_level"]];
    typeAndeLevel.font = [UIFont systemFontOfSize:20];
    [upView addSubview:typeAndeLevel];
    
    UILabel *yueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, upView.width-12, 21)];
    yueLabel.textColor = RGB(255,255,255);
    yueLabel.textAlignment = NSTextAlignmentRight;
    yueLabel.font = [UIFont systemFontOfSize:25];
    [upView addSubview:yueLabel];
    
    //商家名称
    UILabel *shopName=[[UILabel alloc]initWithFrame:CGRectMake(12, 9, upView.width-91-12, 31)];
    shopName.text=dic[@"store"];
    [downView addSubview:shopName];
    //付款
    LZDButton *payBtn = [LZDButton creatLZDButton];
    
    payBtn.frame = CGRectMake(upView.width-81, 9, 61, 31);
    [payBtn setTitle:@"付款" forState:UIControlStateNormal];
    payBtn.layer.cornerRadius = 15;
    payBtn.layer.borderWidth = 1;
    payBtn.layer.borderColor = RGB(221,221,221).CGColor;
    
    payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    payBtn.backgroundColor = [UIColor colorWithHexString:dic[@"card_temp_color"]];
    [payBtn addTarget:self action:@selector(choiceCard:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.row =indexPath.row;
    payBtn.section = indexPath.section;
    [downView addSubview:payBtn];
    
    if ([[[_payCardArray objectAtIndex:indexPath.row] objectForKey:@"card_type"] isEqualToString:@"计次卡"]) {
        NSString *oneString = [[_payCardArray objectAtIndex:indexPath.row] objectForKey:@"price"];//单价
        //
        NSString *allString = [[_payCardArray objectAtIndex:indexPath.row] objectForKey:@"card_remain"];//余额
        
        
        double onePrice = [oneString doubleValue];
        double allPrice = [allString doubleValue];
        
        int cishu =[[[_payCardArray objectAtIndex:indexPath.row] objectForKey:@"rule"] intValue];
        

        int time = (int)(allPrice/(onePrice/cishu));
        //
        yueLabel.text = [[NSString alloc]initWithFormat:@"次数:%d",time];
        
        
    }else{
        yueLabel.text = [[NSString alloc]initWithFormat:@"余额:%@",dic[@"card_remain"]];
    }
    

    return cell;
    
}
-(void)choiceCard:(LZDButton *)btn
{
    
    NSLog(@"=======%ld",btn.row);
    if ([self.payCardArray[btn.row][@"card_type"] isEqualToString:@"计次卡"]) {
        CountPAYViewController *countVC=[[CountPAYViewController alloc]init];
        countVC.card_dic=self.payCardArray[btn.row];
        [self.navigationController pushViewController:countVC animated:YES];
    }else{
        MoneyPAYViewController *moneyVC=[[MoneyPAYViewController alloc]init];
        moneyVC.card_dic=self.payCardArray[btn.row];
        [self.navigationController pushViewController:moneyVC animated:YES];
    }

    
    
    
}

-(void)getCardList{
    NSString *url = [NSString stringWithFormat:@"%@UserType/card/filter",BASEURL];
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.muid forKey:@"muid"];
    [paramer setValue:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        printf("result====%s",[[NSString dictionaryToJson:result] UTF8String]);
        
     if([result[@"num"] intValue]>1){
                
                self.payCardArray =result[@"info"];
         
         [self.Cardtable reloadData];
         
            }
        
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    

    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
