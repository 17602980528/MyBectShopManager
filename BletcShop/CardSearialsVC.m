//
//  CardSearialsVC.m
//  BletcShop
//
//  Created by apple on 2017/5/3.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CardSearialsVC.h"
#import "CardCodeTypeVC.h"
#import "AddVipCardViewController.h"
@interface CardSearialsVC ()<CardCodeTypeVCDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,copy)NSString *cardType;
@property (strong, nonatomic) IBOutlet UIButton *moneyButton;
@property (strong, nonatomic) IBOutlet UIButton *countButton;
@end

@implementation CardSearialsVC

- (IBAction)moneyBtnClick:(UIButton *)sender {
    sender.backgroundColor=RGB(183, 183, 183);
    _countButton.backgroundColor=RGB(237, 237, 237);
    _cardType=@"储值卡";
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [self postRequestGetCardsLists:appdelegate.shopInfoDic[@"muid"] type:_cardType];
}
- (IBAction)countBtnClick:(UIButton *)sender {
     sender.backgroundColor=RGB(183, 183, 183);
    _moneyButton.backgroundColor=RGB(237, 237, 237);
    _cardType=@"计次卡";
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [self postRequestGetCardsLists:appdelegate.shopInfoDic[@"muid"] type:_cardType];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _cardType=@"储值卡";
    _array=[[NSArray alloc]init];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.navigationItem.title=@"会员卡系列";
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(addCodeKinds)];
    self.navigationItem.rightBarButtonItem=item;
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [self postRequestGetCardsLists:appdelegate.shopInfoDic[@"muid"] type:_cardType];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
    }
    cell.textLabel.text=_array[indexPath.row][@"name"];
//    cell.detailTextLabel.text=_array[indexPath.row][@"type"];
    cell.textLabel.textColor=[UIColor blackColor];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddVipCardViewController *addVipCardView = [[AddVipCardViewController alloc]init];
    addVipCardView.codeDic=_array[indexPath.row];
    [self.navigationController pushViewController:addVipCardView animated:YES];
}
-(void)postRequestGetCardsLists:(NSString *)muid type:(NSString *)type{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/card/getSeries",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:muid forKey:@"muid"];
    [params setObject:type forKey:@"type"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        _array=result;
        [self.tableView reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
-(void)addCodeKinds{
    CardCodeTypeVC *vc=[[CardCodeTypeVC alloc]init];
    vc.cardTypes=_cardType;
    vc.title=_cardType;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)addCardCodeAndTypes:(NSString *)names type:(NSString *)types muid:(NSString *)muid{
    NSLog(@"%@======%@-----%@",names,types,muid);
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/card/addSeries",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:muid forKey:@"muid"];
    [params setObject:types forKey:@"type"];
    [params setObject:names forKey:@"name"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        if ([result[@"result_code"]integerValue]==1) {
            [self postRequestGetCardsLists:muid type:types];
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
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
