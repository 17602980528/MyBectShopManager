//
//  CardVipController.m
//  BletcShop
//
//  Created by Yuan on 16/1/26.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "CardVipController.h"
#import "CardVipCell.h"
#import "UIImageView+WebCache.h"
#import "CardManagerViewController.h"
#import "MoneyPAYViewController.h"
#import "CountPAYViewController.h"
@interface CardVipController()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)UITableView *Cardtable;
@property (nonatomic,retain)NSMutableArray *vipCardArray;
@property(nonatomic,strong)NSMutableArray *shareCard_A;//分享卡列表
@property(nonatomic,strong)NSMutableArray *countCardArray;//计次卡
@property(nonatomic,strong)NSMutableArray *moneyCardArray;//chuka
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray  *wholeDataArray;
@end

@implementation CardVipController
{
    UIView *noticeLine;
    UIView *topBackView;
    __block NSInteger _index;
}
-(NSArray *)shareCard_A{
    if (!_shareCard_A) {
        _shareCard_A = [NSMutableArray array];
    }
    return _shareCard_A;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self postRequestVipCard];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    _index=0;
    self.title = @"我的会员卡";
    [self initCatergray];
    [self _inittable];
    _countCardArray=[[NSMutableArray alloc]initWithCapacity:0];
    _moneyCardArray=[[NSMutableArray alloc]initWithCapacity:0];
    _wholeDataArray=[[NSMutableArray alloc]initWithCapacity:0];
}
//卡分类
-(void)initCatergray{
    NSArray *kindArray=@[@"全部",@"储值卡",@"计次卡",@"分享卡"];
    topBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    topBackView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topBackView];
    
    for (int i=0; i<4; i++) {
        UIButton *Catergray=[UIButton buttonWithType:UIButtonTypeCustom];
        Catergray.frame=CGRectMake(1+i%4*((SCREENWIDTH-5)/4+1), 0, (SCREENWIDTH-5)/4, 40);
        Catergray.titleLabel.font=[UIFont systemFontOfSize:17.0f];
        [Catergray setTitle:kindArray[i] forState:UIControlStateNormal];
        [Catergray setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        Catergray.tag=666+i;
        [topBackView addSubview:Catergray];
        [Catergray addTarget:self action:@selector(changeTitleColorAndRefreshCard:) forControlEvents:UIControlEventTouchUpInside];
        if (i!=3) {
            if (i==0) {
                [Catergray setTitleColor:RGB(24, 190, 245) forState:UIControlStateNormal];
                noticeLine=[[UIView alloc]init];
                noticeLine.bounds=CGRectMake(0, 0, (SCREENWIDTH-105)/4, 1);
                noticeLine.center=CGPointMake(Catergray.center.x, Catergray.center.y+14+4);
                noticeLine.backgroundColor=RGB(24, 190, 245);
                [topBackView addSubview:noticeLine];
            }
            UIView *catergrayView=[[UIView alloc]initWithFrame:CGRectMake(Catergray.frame.origin.x+(SCREENWIDTH-5)/4,10,1,20)];
            catergrayView.backgroundColor=RGB(234, 234, 234);
            [topBackView addSubview:catergrayView];
        }
        
    }
    
}
-(void)changeTitleColorAndRefreshCard:(UIButton *)sender{
    switch (sender.tag) {
        case 666:
        {
            _dataArray=_wholeDataArray;
            [self.Cardtable reloadData];
        }
            break;
        case 667:
        {
            _dataArray=_moneyCardArray;
            [self.Cardtable reloadData];
        }
            break;
        case 668:
        {
            _dataArray=_countCardArray;
            [self.Cardtable reloadData];
        }
            break;
        case 669:
        {
            _dataArray=_shareCard_A;
            [self.Cardtable reloadData];
        }
            break;
        case 670:
        {
            _dataArray=_shareCard_A;
            [self.Cardtable reloadData];
        }
            break;
        default:
            break;
    }
    noticeLine.center=CGPointMake(sender.center.x, sender.center.y+14+4);
    for (int i=0; i<4; i++) {
        UIButton*button=(UIButton *)[topBackView viewWithTag:666+i];
        if (button.tag==sender.tag) {
            [button setTitleColor:RGB(24, 190, 245) forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}
-(void)postRequestVipCard
{
    
    NSString *url = [NSString stringWithFormat:@"%@UserType/card/get",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    CardVipController *tempSelf=self;
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        tempSelf.vipCardArray = result[@"self"];
        tempSelf.shareCard_A = result[@"share"];
        [tempSelf.countCardArray removeAllObjects];
        [tempSelf.moneyCardArray removeAllObjects];
        [tempSelf.wholeDataArray removeAllObjects];
        for (int i=0; i<tempSelf.vipCardArray.count; i++) {
            if ([[[tempSelf.vipCardArray objectAtIndex:i] objectForKey:@"card_type"] isEqualToString:@"计次卡"]) {
                [tempSelf.countCardArray addObject:[self.vipCardArray objectAtIndex:i]];
            }else{
                [tempSelf.moneyCardArray addObject:[self.vipCardArray objectAtIndex:i]];
            }
            [tempSelf.wholeDataArray addObject:tempSelf.vipCardArray[i]];
        }
        
        for (int i=0; i<tempSelf.shareCard_A.count; i++) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:tempSelf.shareCard_A[i]];
            [dic setObject:@"share" forKey:@"Myshare"];
            [tempSelf.wholeDataArray addObject:dic];
        }
        //        for (int i=0; i<tempSelf.shareCard_A.count; i++) {
        //            [tempSelf.wholeDataArray addObject:tempSelf.shareCard_A[i]];
        //        }
        _index++;
        if (_index==1) {
            tempSelf.dataArray=tempSelf.wholeDataArray;
        }
        [self.Cardtable reloadData];
        NSLog(@"result===%@", result);
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self noIntenet];
        NSLog(@"%@", error);
    }];
    
}
- (void)noIntenet
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"服务器出错了...", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //        hud.offset = CGPointMake(0.f,MBProgressMaxOffset);
    hud.frame = CGRectMake(0, 310, 375, 100);
    [hud hideAnimated:YES afterDelay:4.f];
    
}

//创建TableView
-(void)_inittable
{
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, SCREENHEIGHT-64-40) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.bounces = YES;
    self.Cardtable = table;
    [self.view addSubview:table];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
       return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 185;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
        cell.backgroundColor = RGB(240, 240, 240);
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    
    
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    
    //    if (indexPath.section==0) {
    
    NSDictionary *dic =[_dataArray objectAtIndex:indexPath.row];
    
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
    
    
    UILabel *discountLab = [[UILabel alloc]initWithFrame:CGRectMake(typeAndeLevel.left, yueLabel.top, 100, yueLabel.height)];
    discountLab.font= yueLabel.font;
    discountLab.textColor = yueLabel.textColor;
    [upView addSubview:discountLab];
    
    //商家名称
    UILabel *shopName=[[UILabel alloc]initWithFrame:CGRectMake(12, 9, upView.width-91-12, 31)];
    shopName.text=[NSString getTheNoNullStr:dic[@"store"] andRepalceStr:@""];
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
    [payBtn addTarget:self action:@selector(cardPayManager:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.row =indexPath.row;
    payBtn.section = indexPath.section;
    [downView addSubview:payBtn];
    
    if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"card_type"] isEqualToString:@"计次卡"]) {
        NSString *oneString = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"price"];//单价
        //
        NSString *allString = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"card_remain"];//余额
        
        
        double onePrice = [oneString doubleValue];
        double allPrice = [allString doubleValue];
        
        int cishu =[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"rule"] intValue];
        
        int time = (int)(allPrice/(onePrice/cishu));
        //
        yueLabel.text = [[NSString alloc]initWithFormat:@"次数:%d",time];
        
        
    }else{
        discountLab.text = [NSString stringWithFormat:@"%g折",[dic[@"rule"] floatValue]/10];
        
        yueLabel.text = [[NSString alloc]initWithFormat:@"余额:%@",dic[@"card_remain"]];
    }
    
    return cell;
    
}
-(void)cardManager:(UIButton *)btn
{
    
    NSDictionary *dic = [_dataArray objectAtIndex:btn.tag];
    
    
    CardManagerViewController *cardManagerView = [[CardManagerViewController alloc]init];
    
    cardManagerView.card_dic =dic;
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    appdelegate.payCardType =dic[@"card_level"];
    
    appdelegate.cardInfo_dic =dic;
    
    
    
    [self.navigationController pushViewController:cardManagerView animated:YES];
}
-(void)cardPayManager:(LZDButton *)sender{
    NSArray *arr ;
    
    arr=_dataArray;
    if ([arr[sender.row][@"state"] isEqualToString:@"transfer"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"会员卡转让中" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
    }else{
        if ([arr[sender.row][@"card_type"] isEqualToString:@"计次卡"]) {
            CountPAYViewController *countVC=[[CountPAYViewController alloc]init];
            countVC.card_dic=[arr objectAtIndex:sender.row];
            [self.navigationController pushViewController:countVC animated:YES];
        }else{
            MoneyPAYViewController *moneyVC=[[MoneyPAYViewController alloc]init];
            moneyVC.card_dic=[arr objectAtIndex:sender.row];
            [self.navigationController pushViewController:moneyVC animated:YES];
        }

    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray!=_shareCard_A) {
        if (![[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Myshare"] isEqualToString:@"share"]) {
            NSLog(@"%@",[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Myshare"]);
            NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
            
            
            CardManagerViewController *cardManagerView = [[CardManagerViewController alloc]init];
            
            cardManagerView.card_dic =dic;
            
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            
            appdelegate.payCardType =dic[@"card_level"];
            
            appdelegate.cardInfo_dic =dic;
            
            
            
            [self.navigationController pushViewController:cardManagerView animated:YES];
        }
        
    }
    
}
@end
