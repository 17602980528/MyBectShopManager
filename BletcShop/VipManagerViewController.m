//
//  VipManagerViewController.m
//  BletcShop
//
//  Created by Bletc on 16/4/22.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "VipManagerViewController.h"
#import "RoyTableViewCell.h"
#import "UIImageView+WebCache.h"
//#import "AddVipCardViewController.h"
#import "CardShowViewController.h"
#import "CardSearialsVC.h"
#import "ChangeVipCardInfoVC.h"
@interface VipManagerViewController ()<UITextFieldDelegate>

@property(nonatomic,weak)UIScrollView *listView;
@property(nonatomic,strong)NSArray *data;

@property (nonatomic,retain)UITextField *codeText;//会员卡编号
@property (nonatomic,retain)UITextField *priceText;
@property (nonatomic,retain)UITextField *contentText;

@property (nonatomic,retain)UIView *demoView;//弹出视图
@property (nonatomic,retain)UIImageView *imageView;
@property (nonatomic,retain)CustomIOSAlertView *alertView;
@property (nonatomic,retain)UILabel *cardTypeLabel;//店员类型label
@property (nonatomic,retain)UILabel *cardLevelLabel;//店员类型label
@property (nonatomic,retain)NSArray *typeArray;
@property (nonatomic,retain)NSArray *levelArray;
@property (nonatomic,strong)NSDictionary *edit_dic;

@end
@implementation VipManagerViewController
{
    UITableView *TabSc;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self postRequest];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(240, 240, 240);
    UIButton *menuBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [menuBt addTarget:self action:@selector(addtBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuBt setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateNormal];
    [menuBt setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateHighlighted];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:menuBt];
    self.navigationItem.rightBarButtonItem = item;
    
    
    self.edit_dic = [[NSDictionary alloc]init];
    self.title = @"会员卡管理";
    
    self.typeArray= @[@"储值卡",@"计次卡"];
    self.levelArray= @[@"普卡",@"银卡",@"金卡",@"白金卡",@"钻卡",@"黑金卡"];;
    
    
}

-(void)postRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/card/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        self.data = result;
        [self _initUI2];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

-(void)_initUI2
{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    TabSc = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    TabSc.backgroundColor=RGB(240, 240, 240);
    TabSc.delegate = self;
    TabSc.dataSource = self;
    TabSc.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:TabSc];
    
}
-(void)NewAddVipAction
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    self.alertView = alertView;
    
    [alertView setContainerView:[self createDemoView]];
    
    
    {
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确定", nil]];
    }
    [alertView setDelegate:self];
    
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    [alertView show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (alertView.tag ==0&&buttonIndex==0) {
    }
    else
        [alertView close];
}

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] init ];
    demoView.frame=CGRectMake(0, 0, SCREENWIDTH, 290);
    
    self.demoView = demoView;
    
    
    
    {
        demoView.frame=CGRectMake(0, 0, SCREENWIDTH, 280);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
        label.text = @"会员卡编号:";
        label.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:label];
        UITextField *nameText = [[UITextField alloc]initWithFrame:CGRectMake(110, 5, 160, 30)];
        self.codeText = nameText;
        nameText.delegate=self;
        
        nameText.layer.borderWidth = 0.3;
        nameText.backgroundColor = tableViewBackgroundColor;
        nameText.text = self.edit_dic[@"code"];
        nameText.font = [UIFont systemFontOfSize:13];
        nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:nameText];
        
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 0.3)];
        line2.backgroundColor = [UIColor grayColor];
        line2.alpha = 0.3;
        [demoView addSubview:line2];
        
        
        //会员卡类型
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 40)];
        typeLabel.text = @"会员卡类型:";
        typeLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:typeLabel];
        UILabel *cardTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 45, 100, 30)];
        self.cardTypeLabel=cardTypeLabel;
        cardTypeLabel.layer.borderWidth = 0.3;
        cardTypeLabel.textAlignment = NSTextAlignmentCenter;
        cardTypeLabel.text = self.edit_dic[@"type"];
        
        NSLog(@"%@",cardTypeLabel.text);
        cardTypeLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:cardTypeLabel];
        
        //箭头
        UIButton *choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        choiceBtn.frame = CGRectMake(210, 45, 30, 30);
        //    choseBtn.backgroundColor = [UIColor redColor];
        [choiceBtn setImage:[UIImage imageNamed:@"arraw_right"] forState:UIControlStateNormal];
        [choiceBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateSelected];
        
        [demoView addSubview:choiceBtn];
        UIView *linecard = [[UIView alloc]initWithFrame:CGRectMake(0, 80, SCREENWIDTH, 0.3)];
        linecard.backgroundColor = [UIColor grayColor];
        linecard.alpha = 0.3;
        [demoView addSubview:linecard];
        //会员卡级别
        UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 40)];
        levelLabel.text = @"会员卡级别:";
        levelLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:levelLabel];
        UILabel *cardLevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 85, 100, 30)];
        cardLevelLabel.layer.borderWidth = 0.3;
        cardLevelLabel.textAlignment = NSTextAlignmentCenter;
        self.cardLevelLabel=cardLevelLabel;
        cardLevelLabel.text = self.edit_dic[@"level"];
        NSLog(@"%@",cardLevelLabel.text);
        cardLevelLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:cardLevelLabel];
        
        //箭头
        UIButton *choiceBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        choiceBtn1.frame = CGRectMake(210, 85, 30, 30);
        //    choseBtn.backgroundColor = [UIColor redColor];
        [choiceBtn1 setImage:[UIImage imageNamed:@"arraw_right"] forState:UIControlStateNormal];
        [choiceBtn1 setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateSelected];
        
        [demoView addSubview:choiceBtn1];
        UIView *lineLevel = [[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREENWIDTH, 0.3)];
        lineLevel.backgroundColor = [UIColor grayColor];
        lineLevel.alpha = 0.3;
        [demoView addSubview:lineLevel];
        
        UIView *lineJibie = [[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREENWIDTH, 0.3)];
        lineJibie.backgroundColor = [UIColor grayColor];
        lineJibie.alpha = 0.3;
        [demoView addSubview:lineJibie];
        //金额
        UILabel *addresslabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, 100, 40)];
        addresslabel.text = @"金额:";
        addresslabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:addresslabel];
        UITextField *addressText = [[UITextField alloc]initWithFrame:CGRectMake(110, 125, 160, 30)];
        addressText.delegate=self;
        self.priceText = addressText;
        addressText.layer.borderWidth = 0.3;
        addressText.backgroundColor = tableViewBackgroundColor;
        addressText.text = self.edit_dic[@"price"];
        addressText.font = [UIFont systemFontOfSize:13];
        addressText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:addressText];
        UIView *lineAdd = [[UIView alloc]initWithFrame:CGRectMake(0, 160, SCREENWIDTH, 0.3)];
        lineAdd.backgroundColor = [UIColor grayColor];
        lineAdd.alpha = 0.3;
        [demoView addSubview:lineAdd];
        UIView *lineMoney = [[UIView alloc]initWithFrame:CGRectMake(0, 1160, SCREENWIDTH, 0.3)];
        lineMoney.backgroundColor = [UIColor grayColor];
        lineMoney.alpha = 0.3;
        [demoView addSubview:lineMoney];
        
        //优惠内容
        UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, 100, 40)];
        descriptionLabel.text = @"优惠内容";
        descriptionLabel.font = [UIFont systemFontOfSize:12];
        [demoView addSubview:descriptionLabel];
        UITextField *descriptionText = [[UITextField alloc]initWithFrame:CGRectMake(110, 165, 160, 30)];
        descriptionText.delegate=self;
        self.contentText = descriptionText;
        descriptionText.layer.borderWidth = 0.3;
        descriptionText.backgroundColor = tableViewBackgroundColor;
        descriptionText.text = self.edit_dic[@"content"];
        descriptionText.font = [UIFont systemFontOfSize:13];
        descriptionText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [demoView addSubview:descriptionText];
        UIView *lineDes = [[UIView alloc]initWithFrame:CGRectMake(0, 200, SCREENWIDTH, 0.3)];
        lineDes.backgroundColor = [UIColor grayColor];
        lineDes.alpha = 0.3;
        [demoView addSubview:lineDes];
        //上传卡片
        UILabel *uploadLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, 100, 70)];
        uploadLabel.text = @"上传卡片";
        uploadLabel.font = [UIFont systemFontOfSize:13];
        [demoView addSubview:uploadLabel];
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(110, 205, 70, 60)];
        imageView.backgroundColor = [UIColor colorWithHexString:self.edit_dic[@"card_temp_color"]];
        imageView.userInteractionEnabled = YES;
        
        //
        //           NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCECARD stringByAppendingString:self.edit_dic[@"card_temp_color"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        //
        //
        //        [imageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon2.png"] options:SDWebImageRetryFailed];
        
        
        
        self.imageView = imageView;
        [demoView addSubview:imageView];
        
        UILabel *vipLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 42)];
        vipLab.text = [NSString stringWithFormat:@"VIP%@",self.edit_dic[@"level"]];
        vipLab.textAlignment = NSTextAlignmentCenter;
        vipLab.textColor = [UIColor whiteColor];
        [imageView addSubview:vipLab];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:vipLab.text];
        
        [attr setAttributes:@{NSForegroundColorAttributeName:RGB(253,171,65),NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} range:NSMakeRange(0, 3)];
        
        [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(3, vipLab.text.length-3)];
        
        vipLab.attributedText = attr;
        
        
        UIView *whiteView =[[UIView alloc]initWithFrame:CGRectMake(0, imageView.height-18, imageView.width, 18)];
        whiteView.backgroundColor =[UIColor whiteColor];
        [imageView addSubview:whiteView];
        
        
    }
    return demoView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.data.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    RoyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[RoyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    if (self.data.count>0) {
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        cell.cardLevelLable.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"level"];
        cell.cardPriceLable.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"price"];
        cell.cardDescription.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"content"];
        cell.shopNameLable.text=delegate.shopInfoDic[@"store"];
        
        if ([self.data[indexPath.row][@"state"] isEqualToString:@"true"]) {
            if ([self.data[indexPath.row][@"display_state"] isEqualToString:@"on"]) {
                [cell.onOrOffButton setTitle:@"下架" forState:UIControlStateNormal];
                cell.editButton.hidden=YES;
                cell.deleteButton.hidden=YES;
                cell.onOrOffButton.hidden=NO;
            }else if([self.data[indexPath.row][@"display_state"] isEqualToString:@"null"]){
                cell.editButton.hidden=NO;
                cell.deleteButton.hidden=NO;
                cell.onOrOffButton.hidden=NO;
                [cell.onOrOffButton setTitle:@"上架" forState:UIControlStateNormal];
            }else if([self.data[indexPath.row][@"display_state"] isEqualToString:@"off"]){
                cell.editButton.hidden=YES;
                cell.deleteButton.hidden=YES;
                cell.onOrOffButton.hidden=NO;
                [cell.onOrOffButton setTitle:@"上架" forState:UIControlStateNormal];
            }
        }else if ([self.data[indexPath.row][@"state"] isEqualToString:@"false"]){
            cell.editButton.hidden=NO;
            cell.deleteButton.hidden=NO;
            cell.onOrOffButton.hidden=YES;
        }else{
            cell.editButton.hidden=YES;
            cell.deleteButton.hidden=YES;
            cell.onOrOffButton.hidden=YES;
        }
        [cell.editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.onOrOffButton addTarget:self action:@selector(onOrOffButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.edit_dic = [self.data objectAtIndex:indexPath.row];
    //    [self NewAddVipAction];
    CardShowViewController *showVC=[[CardShowViewController alloc]init];
    showVC.dic=self.edit_dic;
    [self.navigationController pushViewController:showVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
//添加会员卡
-(void)addtBtnAction:(UIButton *)Btn
{
    //    AddVipCardViewController *addVipCardView = [[AddVipCardViewController alloc]init];
    //    [self.navigationController pushViewController:addVipCardView animated:YES];
    CardSearialsVC *vc=[[CardSearialsVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//不可编辑
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}
//编辑
-(void)editButtonClick:(UIButton *)sender{
    UITableViewCell *cell=(UITableViewCell *)[[sender superview]superview];
    NSIndexPath *indexPath=[TabSc indexPathForCell:cell];
    ChangeVipCardInfoVC *vc=[[ChangeVipCardInfoVC alloc]init];
    vc.codeDic=self.data[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
//删除
-(void)deleteButtonClick:(UIButton *)sender{
    UITableViewCell *cell=(UITableViewCell *)[[sender superview]superview];
    NSIndexPath *indexPath=[TabSc indexPathForCell:cell];
    NSDictionary *dic=self.data[indexPath.row];
    [self postDeleteCards:dic];
}
//上下架
-(void)onOrOffButtonClick:(UIButton *)sender{
    UITableViewCell *cell=(UITableViewCell *)[[sender superview]superview];
    NSIndexPath *indexPath=[TabSc indexPathForCell:cell];
    NSDictionary *dic=self.data[indexPath.row];
    NSString *state=dic[@"display_state"];
    if ([state isEqualToString:@"on"]) {
        [self postRequestGetCardsLists:dic[@"merchant"] code:dic[@"code"] display_state:@"off"];
    }else{
        [self postRequestGetCardsLists:dic[@"merchant"] code:dic[@"code"] display_state:@"on"];
    }
}
-(void)postRequestGetCardsLists:(NSString *)muid code:(NSString *)code display_state:(NSString *)state{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/card/turn",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:muid forKey:@"muid"];
    [params setObject:code forKey:@"code"];
    [params setObject:state forKey:@"display_state"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        if ([result[@"result_code"]integerValue]==1) {
            [self postRequest];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
-(void)postDeleteCards:(NSDictionary *)dic{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/card/del",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:dic[@"merchant"] forKey:@"muid"];
    [params setObject:dic[@"code"] forKey:@"code"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        if ([result[@"result_code"]integerValue]==1) {
            [self postRequest];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
