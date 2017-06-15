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
#import "CardShowViewController.h"
#import "ChangeVipCardInfoVC.h"
#import "ChooseCardTypeVC.h"
@interface VipManagerViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@property(nonatomic,weak)UIScrollView *listView;
@property(nonatomic,strong)NSArray *data;

@property (nonatomic,retain)UITextField *codeText;//会员卡编号
@property (nonatomic,retain)UITextField *priceText;
@property (nonatomic,retain)UITextField *contentText;

@property (nonatomic,retain)UIView *demoView;//弹出视图
@property (nonatomic,retain)UIImageView *imageView;
@property (nonatomic,retain)UILabel *cardTypeLabel;//店员类型label
@property (nonatomic,retain)UILabel *cardLevelLabel;//店员类型label
@property (nonatomic,retain)NSArray *typeArray;
@property (nonatomic,retain)NSArray *levelArray;
@property (nonatomic,strong)NSDictionary *edit_dic;

@end
@implementation VipManagerViewController
{
    UITableView *TabSc;
    SDRefreshHeaderView *refreshHeader;
    
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
    
    
    [self _initUI2];

    
}

-(void)postRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/card/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [refreshHeader endRefreshing];
        NSLog(@"result===%@", result);
        self.data = result;
        
        [TabSc reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [refreshHeader endRefreshing];

        NSLog(@"%@", error);
        
    }];
    
}

-(void)_initUI2
{
   
    TabSc = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    TabSc.backgroundColor=RGB(240, 240, 240);
    TabSc.delegate = self;
    TabSc.dataSource = self;
    TabSc.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:TabSc];
    
    
    refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:TabSc];
    refreshHeader.isEffectedByNavigationController = NO;
    
    __block typeof(self) tempSelf = self;
    
    refreshHeader.beginRefreshingOperation = ^{
        //请求数据
        [tempSelf postRequest];
    };
    
    
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
    ChooseCardTypeVC *vc=[[ChooseCardTypeVC alloc]init];
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
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除次会员卡？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag=indexPath.row;
    [alert show];
}
//上下架
-(void)onOrOffButtonClick:(UIButton *)sender{
    
 
    
    UITableViewCell *cell=(UITableViewCell *)[[sender superview]superview];
    NSIndexPath *indexPath=[TabSc indexPathForCell:cell];
    NSDictionary *dic=self.data[indexPath.row];
    NSString *state=dic[@"display_state"];
    
    
    
    if ([state isEqualToString:@"on"]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定下架该会员卡?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction*sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self postRequestGetCardsLists:dic[@"merchant"] code:dic[@"code"] display_state:@"off" cardLevel:dic[@"level"]];

        }];
        
        [alertController addAction:cancel];
        [alertController addAction:sure];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
        

    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定上架该会员卡?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction*sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self postRequestGetCardsLists:dic[@"merchant"] code:dic[@"code"] display_state:@"on" cardLevel:dic[@"level"]];
            
        }];
        
        [alertController addAction:cancel];
        [alertController addAction:sure];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];

    }
}
-(void)postRequestGetCardsLists:(NSString *)muid code:(NSString *)code display_state:(NSString *)state cardLevel:(NSString *)level{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/card/turn",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:muid forKey:@"muid"];
    [params setObject:code forKey:@"code"];
    [params setObject:state forKey:@"display_state"];
    [params setObject:level forKey:@"level"];
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
    [params setObject:dic[@"level"] forKey:@"level"];

    NSLog(@"%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        if ([result[@"result_code"]integerValue]==1) {
            [self postRequest];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSDictionary *dic=self.data[alertView.tag];
        [self postDeleteCards:dic];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
