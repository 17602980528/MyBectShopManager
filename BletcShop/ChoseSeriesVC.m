//
//  ChoseSeriesVC.m
//  BletcShop
//
//  Created by Bletc on 2017/5/16.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ChoseSeriesVC.h"
#import "ChoseSeriesCellT.h"
#import "AddSeriesViewController.h"
#import "AddVipCardViewController.h"
@interface ChoseSeriesVC ()<UITableViewDelegate,UITableViewDataSource,AddSeriesViewControllerDelegate>
{
    NSInteger selectedRow;
    UIImageView *imageView;
}
@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property(nonatomic,strong)NSArray *array;
@end

@implementation ChoseSeriesVC

-(void)addtBtnAction:(UIButton *)senser{
    AddSeriesViewController *VC = [[AddSeriesViewController alloc]init];
    VC.cardTypes=_cardType;
    VC.delegate=self;
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _array=[[NSArray alloc]init];
    self.navigationItem.title = @"选择系列";
    _tabView.rowHeight=61;
    selectedRow=0;
    UIButton *menuBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [menuBt addTarget:self action:@selector(addtBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuBt setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateNormal];
    [menuBt setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateHighlighted];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:menuBt];
    self.navigationItem.rightBarButtonItem = item;
    
     AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
     [self postRequestGetCardsLists:appdelegate.shopInfoDic[@"muid"] type:_cardType];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoseSeriesCellT *cell = [tableView dequeueReusableCellWithIdentifier:@"choseSeriesID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChoseSeriesCellT" owner:self options:nil] firstObject];
        cell.backView.layer.borderWidth=1.0f;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row==selectedRow) {
        cell.backView.layer.borderColor=[RGB(226, 102, 102)CGColor];
        cell.choseImg.image=[UIImage imageNamed:@"quan3"];
        cell.rightImg.image = [UIImage imageNamed:@"形状 2"];

        cell.titleLab.textColor=RGB(226, 102, 102);
    }else{
        cell.backView.layer.borderColor=[RGB(117, 91, 91)CGColor];
        cell.choseImg.image=[UIImage imageNamed:@"quan4"];
        cell.rightImg.image = [UIImage imageNamed:@"形状 1 拷贝"];

        cell.titleLab.textColor=RGB(117, 91, 91);
    }
   
    cell.titleLab.text=_array[indexPath.row][@"name"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedRow=indexPath.row;
    [_tabView reloadData];
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
        if (result) {
               _array=result;
        }
        if (_array.count>0) {
              [_tabView reloadData];
            _tabView.hidden=NO;
            if (imageView) {
                [imageView removeFromSuperview];
            }
        }else{
            _tabView.hidden=YES;
            imageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 25, SCREENWIDTH-24, (SCREENWIDTH-24)*215/702)];
            imageView.image=[UIImage imageNamed:@"xilietishi"];
            [self.view addSubview:imageView];
        }
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
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



@end
