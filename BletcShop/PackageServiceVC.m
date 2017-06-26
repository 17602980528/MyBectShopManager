//
//  PackageServiceVC.m
//  BletcShop
//
//  Created by apple on 2017/6/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PackageServiceVC.h"
#import "NoVipCardCustomView.h"
#import "ChooseProductVC.h"
//#import "EricForTimeLimitCell.h"
#import "CreatPackageCardVC.h"
#import "PackageHomePageTableViewCell.h"
#import "PackageCheckVC.h"
#import "UIImageView+WebCache.h"
@interface PackageServiceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *operationState;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *totalCardLable;
@property (strong, nonatomic) IBOutlet UIButton *wait;
@property (strong, nonatomic) IBOutlet UIButton *finish;
@property (strong, nonatomic) IBOutlet UIButton *offMarket;
@property (nonatomic)NSInteger seletedState;
@property (nonatomic,strong)NSArray *dataArray;
@property (strong, nonatomic) IBOutlet UILabel *cardTotalCount;

@end

@implementation PackageServiceVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    switch (_seletedState) {
        case 0:
        {
            [self postRequestGetCardList:@"null"];
        }
            break;
        case 1:
        {
            [self postRequestGetCardList:@"on"];
        }
            break;
        case 2:
        {
            [self postRequestGetCardList:@"off"];
        }
            break;
        default:
            break;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray=[[NSArray alloc]init];
    _seletedState=0;
    UIButton *menuBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [menuBt addTarget:self action:@selector(addtBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuBt setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateNormal];
    [menuBt setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateHighlighted];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:menuBt];
    self.navigationItem.rightBarButtonItem = item;
    
    NoVipCardCustomView *view=[[NoVipCardCustomView alloc]initWithFrame:CGRectMake(0.2*SCREENWIDTH,0.283*(SCREENHEIGHT-64), 0.6*SCREENWIDTH,0.616*0.6*SCREENWIDTH)];
    [self.view addSubview:view];
    view.hidden=YES;
    _tableView.rowHeight=50;
    
}
-(void)addtBtnAction:(UIButton *)sender{//ChooseProductVC
    CreatPackageCardVC *vc=[[CreatPackageCardVC alloc]init];
    vc.title=@"添加套餐卡";
    [self.navigationController pushViewController:vc animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString   * CellIdentiferId =  @"PackageHomePageCell";
    PackageHomePageTableViewCell  * cell = [tableView  dequeueReusableCellWithIdentifier :CellIdentiferId];
    if (!cell){
        NSArray  * nibs = [[ NSBundle mainBundle ] loadNibNamed :@"PackageHomePageTableViewCell" owner :self options :nil ];
        cell = [  nibs lastObject ];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    };
    cell.oldPrice.text=_dataArray[indexPath.row][@"option_sum"];
    cell.nowPrice.text=_dataArray[indexPath.row][@"price"];
    cell.cardName.text=_dataArray[indexPath.row][@"name"];
    cell.content.text=_dataArray[indexPath.row][@"des"];
//    cell.cardImageView.backgroundColor=[UIColor colorWithHexString:_dataArray[indexPath.row][@"template"]];
    NSArray *array=[[NSUserDefaults standardUserDefaults]objectForKey:@"CARDIMGTEMP_ERIC"];
    NSString *imageName=@"";
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic=array[i];
        NSString *color=[dic allKeys][0];
        if (color==_dataArray[indexPath.row][@"template"]) {
            imageName=[dic allValues][0];
        }
    }
    
    NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCECARD stringByAppendingString:imageName]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [cell.cardImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
    
    NSLog(@"%@",cell.oldPrice.text);
    NSUInteger length = [cell.oldPrice.text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:cell.oldPrice.text];
    [attri addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSBaselineOffsetAttributeName:@(0)} range:NSMakeRange(0, length)];
    [cell.oldPrice setAttributedText:attri];
    
    return cell;
}
-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"删除"
                                                                       handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                           NSLog(@"删除");
                                                                           [self postRequestDeleteCardList:_dataArray[indexPath.row][@"code"]];
                                                                       }];
    rowAction.backgroundColor=[UIColor redColor];
    
//    UITableViewRowAction *rowActionSec = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
//                                                                            title:@"编辑"
//                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//                                                                              NSLog(@"编辑");
//                                                                          }];
//    rowActionSec.backgroundColor = [UIColor grayColor];
    
    UITableViewRowAction *rowActionThird = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                              title:@"上架"
                                                                            handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                                NSLog(@"上架");
                                                                                [self postRequestOnCardList:_dataArray[indexPath.row][@"code"]];
                                                                            }];
    rowActionThird.backgroundColor = [UIColor orangeColor];
    UITableViewRowAction *rowActionFourth = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                              title:@"下架"
                                                                            handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                                NSLog(@"下架");
                                                                                [self postRequestOffCardList:_dataArray[indexPath.row][@"code"]];
                                                                            }];
    rowActionFourth.backgroundColor = [UIColor orangeColor];

    NSArray *arr = @[rowAction,rowActionThird/*,rowActionSec*/];
    NSArray *arr1=@[rowActionFourth];
    NSArray *arr2=@[rowActionThird];
    if (_seletedState==0) {
         return arr;
    }else if (_seletedState==1){
         return arr1;
    }else if (_seletedState==2){
         return arr2;
    }
    return arr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)waitBtnClick:(UIButton *)sender {
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_finish setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_offMarket setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sender.backgroundColor=RGB(234, 125, 121);
    _finish.backgroundColor=RGB(235, 235, 235);
    _offMarket.backgroundColor=RGB(235, 235, 235);
    _operationState.text=sender.titleLabel.text;
    _seletedState=0;
     [self postRequestGetCardList:@"null"];
    //[_tableView reloadData];
}
- (IBAction)onMarketBtnClick:(UIButton *)sender {
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_wait setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_offMarket setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sender.backgroundColor=RGB(234, 125, 121);
    _wait.backgroundColor=RGB(235, 235, 235);
    _offMarket.backgroundColor=RGB(235, 235, 235);
    _operationState.text=sender.titleLabel.text;
    _seletedState=1;
     [self postRequestGetCardList:@"on"];
    //[_tableView reloadData];
}
- (IBAction)offMarketBtnClick:(UIButton *)sender {
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_wait setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_finish setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sender.backgroundColor=RGB(234, 125, 121);
    _wait.backgroundColor=RGB(235, 235, 235);
    _finish.backgroundColor=RGB(235, 235, 235);
    _operationState.text=sender.titleLabel.text;
    _seletedState=2;
     [self postRequestGetCardList:@"off"];
     //[_tableView reloadData];
}
//获取套餐卡列表
-(void)postRequestGetCardList:(NSString *)type{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/MealCard/get",BASEURL];
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    [parmer setValue:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [parmer setValue:type forKey:@"display"];
    NSLog(@"0-----%@",parmer);
    [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        if (result&&[result isKindOfClass:[NSArray class]]) {
            _dataArray=result;
        }
        _cardTotalCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)_dataArray.count];
        [_tableView reloadData];
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"error-----%@",error.description);
        
    }];
}
//删除套餐卡
-(void)postRequestDeleteCardList:(NSString *)code{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/MealCard/del",BASEURL];
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    [parmer setValue:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [parmer setValue:code forKey:@"code"];
    NSLog(@"0-----%@",parmer);
    [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        if ([result[@"result_code"]integerValue]==1) {
            [self postRequestGetCardList:@"null"];
            [self showTishi:@"会员卡删除成功" dele:nil cancel:nil operate:@"确认"];
        }
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"error-----%@",error.description);
        
    }];

}
//上架套餐卡
-(void)postRequestOnCardList:(NSString *)code{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/MealCard/turn",BASEURL];
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    [parmer setValue:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [parmer setValue:code forKey:@"code"];
     [parmer setValue:@"on" forKey:@"display"];
    NSLog(@"0-----%@",parmer);
    [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        if ([result[@"result_code"]integerValue]==1) {
           //
            [self showTishi:@"恭喜您，会员卡上架成功!" dele:nil cancel:nil operate:@"确认"];
            switch (_seletedState) {
                case 0:
                {
                    [self postRequestGetCardList:@"null"];
                }
                    break;
                case 1:
                {
                    [self postRequestGetCardList:@"on"];
                }
                    break;
                case 2:
                {
                    [self postRequestGetCardList:@"off"];
                }
                    break;
                default:
                    break;
            }

        }else{
            [self showTishi:@"会员卡上架失败!" dele:nil cancel:nil operate:@"确认"];
        }
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"error-----%@",error.description);
        
    }];

}
//下架套餐卡
-(void)postRequestOffCardList:(NSString *)code{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/MealCard/turn",BASEURL];
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    [parmer setValue:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [parmer setValue:code forKey:@"code"];
    [parmer setValue:@"off" forKey:@"display"];
    NSLog(@"0-----%@",parmer);
    [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        if ([result[@"result_code"]integerValue]==1) {
           //
             [self showTishi:@"会员卡下架成功!" dele:nil cancel:nil operate:@"确认"];
            switch (_seletedState) {
                case 0:
                {
                    [self postRequestGetCardList:@"null"];
                }
                    break;
                case 1:
                {
                    [self postRequestGetCardList:@"on"];
                }
                    break;
                case 2:
                {
                    [self postRequestGetCardList:@"off"];
                }
                    break;
                default:
                    break;
            }

        }else{
             [self showTishi:@"会员卡下架失败!" dele:nil cancel:nil operate:@"确认"];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"error-----%@",error.description);
        
    }];

}
-(void)showTishi:(NSString *)mess dele:(id) delegate cancel:(NSString *)cancel operate:(NSString *)operate{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:mess message:nil delegate:delegate cancelButtonTitle:cancel otherButtonTitles:operate, nil];
    [alert show];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PackageCheckVC *packageCheckVC=[[PackageCheckVC alloc]init];
    packageCheckVC.dic=_dataArray[indexPath.row];
    [self.navigationController pushViewController:packageCheckVC animated:YES];
}
@end
