//
//  ChooseProductVC.m
//  BletcShop
//
//  Created by apple on 2017/6/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ChooseProductVC.h"
#import "AddPakageServiceVC.h"
#import "PackageTableViewCell.h"
//#import "PackageOtherTableViewCell.h"
//#import "ChoiceCardPictureViewController.h"
#import "UIImageView+WebCache.h"
@interface ChooseProductVC ()<UITableViewDelegate,UITableViewDataSource/*,ChoiceCardDelegate*/>
{
    BOOL allORSingle;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;//数据源
@property (strong, nonatomic) IBOutlet UIImageView *allORNot;
@property (strong, nonatomic) IBOutlet UILabel *chooseORCancel;

@property (strong,nonatomic)NSMutableDictionary *recordChooseState;
@property (strong,nonatomic)NSMutableArray *weChoosedArray;
@property (weak, nonatomic) IBOutlet UILabel *selectCountLab;//顶部所选数目
@end

@implementation ChooseProductVC
//确认添加
- (IBAction)chooseProductBtnClick:(id)sender {
    [_weChoosedArray removeAllObjects];
    for (int i=0; i<_dataArray.count; i++) {
        NSDictionary *dic=_dataArray[i];
        if ([dic[@"state"] isEqualToString:@"yes"]) {
            NSDictionary *dic=@{[NSString stringWithFormat:@"%d",i]:_dataArray[i]};
            [_weChoosedArray addObject:dic];
        }
    }
    if ([_delegate respondsToSelector:@selector(weChoosedPruductDic:)]&&_weChoosedArray.count>0) {
        [_delegate weChoosedPruductDic:_weChoosedArray];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self showTishi:@"您还没有选择项目!" dele:nil cancel:nil operate:@"确认"];
    }
}
//全选
- (IBAction)chooseAllBtnClick:(UIButton *)sender {
    allORSingle=!allORSingle;
    if (allORSingle) {
        for (int i=0; i<_dataArray.count; i++) {
            NSDictionary *dic=_dataArray[i];
            NSMutableDictionary *mutDic=[NSMutableDictionary dictionaryWithDictionary:dic];
            [mutDic setObject:@"yes" forKey:@"state"];
            [_dataArray replaceObjectAtIndex:i withObject:mutDic];
            [_recordChooseState setObject:@"yes" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        _chooseORCancel.text=@"取消全选";
        [_allORNot setImage:[UIImage imageNamed:@"de_icon_checkbox_sl"]];
    }else{
        for (int i=0; i<_dataArray.count; i++) {
            NSDictionary *dic=_dataArray[i];
            NSMutableDictionary *mutDic=[NSMutableDictionary dictionaryWithDictionary:dic];
            [mutDic setObject:@"no" forKey:@"state"];
            [_dataArray replaceObjectAtIndex:i withObject:mutDic];
        }
        [_recordChooseState removeAllObjects];
         _chooseORCancel.text=@"全选";
        [_allORNot setImage:[UIImage imageNamed:@"de_icon_checkbox_n"]];
    }
    [_tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self postRequestGetOption];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"选择项目";
    allORSingle=NO;
    _recordChooseState=[NSMutableDictionary dictionaryWithCapacity:0];
    if (self.normalArray.count>0) {
        _weChoosedArray =[NSMutableArray arrayWithArray:self.normalArray];
    }else{
         _weChoosedArray=[[NSMutableArray alloc]initWithCapacity:0];
    }
    UIButton *menuBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [menuBt addTarget:self action:@selector(addtBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuBt setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateNormal];
    [menuBt setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateHighlighted];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:menuBt];
    self.navigationItem.rightBarButtonItem = item;
    
    self.tableView.rowHeight=50;
}
-(void)addtBtnAction:(UIButton *)sender{
    AddPakageServiceVC *vc=[[AddPakageServiceVC alloc]init];
    vc.title=@"创建项目";
    [self.navigationController pushViewController:vc animated:YES];
}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section==0) {
        return _dataArray.count;
//    }else{
//        return 1;
//    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section==0) {
        return 0;
//    }else{
//        return 5;
//    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==0) {
        static NSString   * CellIdentiferId =  @"packageCell";
        PackageTableViewCell  * cell = [tableView  dequeueReusableCellWithIdentifier :CellIdentiferId];
        if (!cell){
            NSArray  * nibs = [[ NSBundle mainBundle ] loadNibNamed :@"PackageTableViewCell" owner :self options :nil ];
            cell = [  nibs lastObject ];
        };
    cell.productName.text=[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"name"]];
    cell.productPrice.text=[NSString stringWithFormat:@"%@元/次",_dataArray[indexPath.row][@"price"]];
    NSURL * nurl1=[[NSURL alloc] initWithString:[[NSString stringWithFormat:@"%@%@",PRODUCT_IMAGE,_dataArray[indexPath.row][@"image"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [cell.productImage sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
    
    if ([_dataArray[indexPath.row][@"state"] isEqualToString:@"no"]) {
        cell.chooseTip.image=[UIImage imageNamed:@"de_icon_checkbox_n"];
    }else{
        cell.chooseTip.image=[UIImage imageNamed:@"de_icon_checkbox_sl"];
    }
     return cell;
//    }else{
//        static NSString   * CellIdentiferId =  @"packageOtherCell";
//        PackageOtherTableViewCell  * cell = [tableView  dequeueReusableCellWithIdentifier :CellIdentiferId];
//        if (!cell){
//            NSArray  * nibs = [[ NSBundle mainBundle ] loadNibNamed :@"PackageOtherTableViewCell" owner :self options :nil ];
//            cell = [  nibs lastObject ];
//        };
//        [cell.chooseCardBtn addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
//        NSURL * nurl1=[[NSURL alloc] initWithString:[[NSString stringWithFormat:@"%@%@",SOURCECARD,self.choiceCard[@"image"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//        [cell.cardImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
//        return cell;
//    }
}
//-(void)goNext{
//    ChoiceCardPictureViewController *pictureView = [[ChoiceCardPictureViewController alloc]init];
//    pictureView.delegate = self;
//    [self.navigationController pushViewController:pictureView animated:YES];
//}
#pragma mark --ChoiceCardDelegate
//- (void)sendCardValue:(NSDictionary *)value
//{
//    self.choiceCard = [[NSDictionary alloc]initWithDictionary:value];
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *state=_dataArray[indexPath.row][@"state"];
    if ([state isEqualToString:@"no"]) {
        NSDictionary *dic=_dataArray[indexPath.row];
        NSMutableDictionary *mutDic=[NSMutableDictionary dictionaryWithDictionary:dic];
        [mutDic setObject:@"yes" forKey:@"state"];
        [_dataArray replaceObjectAtIndex:indexPath.row withObject:mutDic];
        [_recordChooseState setObject:@"yes" forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }else{
        NSDictionary *dic=_dataArray[indexPath.row];
        NSMutableDictionary *mutDic=[NSMutableDictionary dictionaryWithDictionary:dic];
        [mutDic setObject:@"no" forKey:@"state"];
        [_dataArray replaceObjectAtIndex:indexPath.row withObject:mutDic];
        [_recordChooseState removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    
    self.selectCountLab.text = [NSString stringWithFormat:@"已选%ld项",_recordChooseState.count];
    
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)postRequestGetOption{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/MealCard/getOption",BASEURL];
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    [parmer setValue:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    NSLog(@"0-----%@",parmer);
    
    [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
    NSLog(@"result===%@", result);
        if(result){
            _dataArray=[[NSMutableArray alloc]initWithArray:result];
            for (int i=0; i<_dataArray.count; i++) {
                NSDictionary *dic=_dataArray[i];
                NSMutableDictionary *mutDic=[NSMutableDictionary dictionaryWithDictionary:dic];
                [mutDic setObject:@"no" forKey:@"state"];
                [_dataArray replaceObjectAtIndex:i withObject:mutDic];
            }
            NSArray *allKeys=[_recordChooseState allKeys];
            NSLog(@"allKeys====%@",allKeys);
            for (int i=0; i<allKeys.count; i++) {
                NSString *key=allKeys[i];
                NSInteger keyInt=[key integerValue];
            
                NSDictionary *dic=_dataArray[keyInt];
                NSMutableDictionary *mutDic=[NSMutableDictionary dictionaryWithDictionary:dic];
                [mutDic setObject:@"yes" forKey:@"state"];
                [_dataArray replaceObjectAtIndex:keyInt withObject:mutDic];
            }
            if (self.normalArray.count>0) {
                for (int i=0; i<self.normalArray.count; i++) {
                    NSDictionary *dic=self.normalArray[i];
                    NSDictionary *value=[dic allValues][0];
                    NSInteger index=[[dic allKeys][0] integerValue];
                    [_dataArray replaceObjectAtIndex:index withObject:value];
                }
            }
            NSLog(@"%@",_dataArray);
            [_tableView reloadData];
        }
       
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"error-----%@",error.description);
        
    }];
    
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
        [self postRequestDeleteProducts:indexPath];
       
    }];
    // 将设置好的按钮放到数组中返回
    if (self.recArray.count==0){
        return @[deleteRowAction];
    }
    return @[];
}
-(void)postRequestDeleteProducts:(NSIndexPath *)indexPath{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/MealCard/delOption",BASEURL];
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    [parmer setValue:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [parmer setValue:_dataArray[indexPath.row][@"id"] forKey:@"option_id"];
    NSLog(@"0-----%@",parmer);
    [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        if ([result[@"result_code"]integerValue]==1) {
            //
            [self showTishi:@"删除成功!" dele:nil cancel:nil operate:@"确认"];
            [_recordChooseState removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            [self postRequestGetOption];
        }else if( [result[@"result_code"] isEqualToString:@"working"]){
            
            [self showTishi:@"正在使用不能删除..." dele:nil cancel:nil operate:@"确认"];

        }else{
            [self showTishi:@"删除失败!" dele:nil cancel:nil operate:@"确认"];

        }
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"error-----%@",error.description);
        
    }];

   
}
//
-(void)showTishi:(NSString *)mess dele:(id) delegate cancel:(NSString *)cancel operate:(NSString *)operate{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:mess message:nil delegate:delegate cancelButtonTitle:cancel otherButtonTitles:operate, nil];
    [alert show];
}
@end
