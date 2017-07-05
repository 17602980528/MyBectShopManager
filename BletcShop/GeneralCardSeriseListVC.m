//
//  GeneralCardSeriseListVC.m
//  BletcShop
//
//  Created by Bletc on 2017/6/6.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "GeneralCardSeriseListVC.h"
#import "GeneralCell.h"
#import "GeneralSectionHeader.h"
#import "AddMoneyOrCountCardVC.h"
#import "LZDAddSeriseListVC.h"
#import "UIImageView+WebCache.h"
#import "NoVipCardCustomView.h"

#import "CardShowViewController.h"

//#define sectionNum 15
@interface GeneralCardSeriseListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *old_btn;
    
    NoVipCardCustomView *noticeView;//没有会员卡提示View
}
@property (weak, nonatomic) IBOutlet UITableView *table_View;
@property (weak, nonatomic) IBOutlet UIView *footbtnView;//底部按钮背景
@property(nonatomic,strong)NSArray *data_A;
@property(nonatomic,strong)NSMutableDictionary *fold_mutab_dic;
@property (weak, nonatomic) IBOutlet UIButton *waitBtn;
@property(nonatomic,strong)NSArray*state_A;
@property (nonatomic , strong) NSDictionary *deadLine_dic;// 有效期

@end

@implementation GeneralCardSeriseListVC


-(void)addtBtnAction{
    
    PUSH(LZDAddSeriseListVC)
    vc.cardTypeName = self.navigationItem.title;
    vc.block = ^{
        NSLog(@"刷新数据");
        [self getDataRequestWithState:self.state_A[old_btn.tag]];

        
    };
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    old_btn = self.waitBtn;
    
    self.navigationItem.title = self.titleDic[@"cardName"];
    
    UIButton *menuBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [menuBt addTarget:self action:@selector(addtBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [menuBt setImage:[UIImage imageNamed:@"lzdAddSeriseImg"] forState:UIControlStateNormal];
    [menuBt setImage:[UIImage imageNamed:@"lzdAddSeriseImg"] forState:UIControlStateHighlighted];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:menuBt];
    self.navigationItem.rightBarButtonItem = item;
    
    self.table_View.estimatedRowHeight = 100;
    self.table_View.rowHeight = UITableViewAutomaticDimension;
    
    
    noticeView=[[NoVipCardCustomView alloc]initWithFrame:CGRectMake(0.2*SCREENWIDTH,0.283*(SCREENHEIGHT-64), 0.6*SCREENWIDTH,0.616*0.6*SCREENWIDTH)];
    [self.view addSubview:noticeView];
    noticeView.hidden=YES;
    [self getDataRequestWithState:self.state_A[old_btn.tag]];
    
    
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.data_A.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = [NSString stringWithFormat:@"%d", (int)section];

    BOOL fold = [self.fold_mutab_dic[key] boolValue];
    
    NSArray *arr = _data_A[section][@"card_list"];
    
    return fold? arr.count: 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    
   GeneralSectionHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerID"];
    
    if (!headerView) {
        headerView = [[GeneralSectionHeader alloc]initWithReuseIdentifier:@"headerID"];
        headerView.contentView.backgroundColor = [UIColor whiteColor];
    }
    headerView.tag = section;
    headerView.addBtn.tag = section;
    
    [headerView.addBtn addTarget:self action:@selector(addCardClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerClick:)];
    [headerView addGestureRecognizer:tap];
    
    NSDictionary *dic = _data_A[section];
    headerView.titleLab.text = [NSString getTheNoNullStr:dic[@"series_name"] andRepalceStr:@"缺失"];
    
    
    NSString *key = [NSString stringWithFormat:@"%d", (int)section];
    
    BOOL fold = [_fold_mutab_dic[key] boolValue];
    
    headerView.fold = fold;
    return headerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    GeneralCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generalCardCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GeneralCell" owner:self options:nil] firstObject];
        
    }
    
    NSDictionary *dic = _data_A[indexPath.section][@"card_list"][indexPath.row];
    
    cell.cardImg.image = [UIImage imageNamed:@""];
    cell.cardImg.backgroundColor = [UIColor colorWithHexString:dic[@"card_temp_color"]];
    cell.cardLevel.text = dic[@"level"];
    
    
   NSArray *cardTemp_A = [[NSUserDefaults standardUserDefaults]objectForKey:@"CARDIMGTEMP"];
    
    
    for (NSDictionary *tim_dic in cardTemp_A) {
        if ([tim_dic[@"color"] isEqualToString:[dic[@"card_temp_color"] noWhiteSpaceString]]) {
            
            NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCECARD stringByAppendingString:tim_dic[@"image"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            NSLog(@"-nurl1----%@",nurl1);
            
            [cell.cardImg sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
            cell.cardImg.backgroundColor = [UIColor whiteColor];

            break ;
        }
    }

    if ([self.navigationItem.title isEqualToString:@"计次卡"]) {
        cell.cardDiscount.text = [NSString stringWithFormat:@"%@次",dic[@"rule"]];
  
    }else{
        cell.cardDiscount.text = [NSString stringWithFormat:@"%g折",[dic[@"rule"] floatValue]/10];
  
    }
    
    cell.cardEndtime.text = [NSString stringWithFormat:@"有限期：%@（%@）",self.deadLine_dic[dic[@"indate"]],dic[@"type"]];
    
    cell.cardPrice.text = [NSString stringWithFormat:@"¥%@",dic[@"price"]];

    
    
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:cell.cardPrice.text];
    [attr setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]} range:NSMakeRange(0, 1)];
    cell.cardPrice.attributedText = attr;
    
    
    
    return cell;
    
}


-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *dic = _data_A[indexPath.section][@"card_list"][indexPath.row];

    
    UITableViewRowAction *edit_Action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        PUSH(AddMoneyOrCountCardVC)
        vc.card_dic = dic;
        
        vc.cardTypeName = self.navigationItem.title;
        vc.series_dic = _data_A[indexPath.section];
        vc.whoPush = @"编辑";
        vc.block = ^{
            [self getDataRequestWithState:_state_A[old_btn.tag]];
            
        };

        
    }];
    
    edit_Action.backgroundColor = RGB(175,175,175);
    
    NSString *ti = old_btn.tag==1 ? @"下架":@"上架" ;
    
    
    
    UITableViewRowAction *up_Down_Action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:ti handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"确定%@该会员卡?",ti] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction*sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (old_btn.tag==1) {
                [self UpOrDownCard:dic andState:@"off"];
                
            }else{
                [self UpOrDownCard:dic andState:@"on"];
                
            }
            
        }];
        
        [alertController addAction:cancel];
        [alertController addAction:sure];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];

        
    }];
    
    up_Down_Action.backgroundColor = RGB(246,153,44);
    
    UITableViewRowAction *delete_Action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该会员卡?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction*sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self postDeleteCards:dic];
        }];
        
        [alertController addAction:cancel];
        [alertController addAction:sure];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];

        
    }];
    delete_Action.backgroundColor = RGB(235,31,31);
    
    if (old_btn.tag==0) {
        
        return @[delete_Action,up_Down_Action,edit_Action];
        
    }else {
       
        return @[up_Down_Action];

   
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PUSH(CardShowViewController)
    vc.dic =_data_A[indexPath.section][@"card_list"][indexPath.row];
}

//未处理 已上架 已下架
- (IBAction)footBtnClick:(UIButton *)sender {
    
    if (sender !=old_btn) {
        sender.backgroundColor = RGB(226,102,102);
        [sender setTitleColor:[UIColor whiteColor] forState:0];
        
        old_btn.backgroundColor = [UIColor whiteColor];
        [old_btn setTitleColor:RGB(51,51,51) forState:0];

        old_btn = sender;
        
        [self getDataRequestWithState:_state_A[old_btn.tag]];
    }
}

//添加会员卡
-(void)addCardClick:(UIButton*)sender{
    NSLog(@"添加会员卡==%ld",sender.tag);
    PUSH(AddMoneyOrCountCardVC)
    vc.cardTypeName = self.navigationItem.title;
    vc.series_dic = _data_A[sender.tag];
    vc.whoPush = @"添加";
    vc.block = ^{
        [self getDataRequestWithState:_state_A[old_btn.tag]];

    };
    
}
//收缩cell
-(void)headerClick:(UITapGestureRecognizer*)tap{
    
    
    NSString *key = [NSString stringWithFormat:@"%d", (int)tap.view.tag];
    
    
    BOOL fold = [_fold_mutab_dic[key] boolValue];

    NSString *folded = fold ? @"0":@"1";
    
    [_fold_mutab_dic setValue:folded forKey:key];
    
    
    
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndex:tap.view.tag];
    
    [self.table_View reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    NSLog(@"收缩cell==%ld",tap.view.tag);
 
}
//删除会员卡
-(void)postDeleteCards:(NSDictionary *)dic{
    
    NSString *url ;
    
    if ([self.navigationItem.title isEqualToString:@"储值卡"]) {
        url = [[NSString alloc]initWithFormat:@"%@MerchantType/ValueCard/del",BASEURL];
        
    }else{
        url = [NSString stringWithFormat:@"%@MerchantType/CountCard/del",BASEURL];
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:dic[@"merchant"] forKey:@"muid"];
    [params setObject:dic[@"code"] forKey:@"code"];
    [params setObject:dic[@"level"] forKey:@"level"];

    NSLog(@"%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        if ([result[@"result_code"]integerValue]==1) {
            [self showHint:@"删除成功"];
            [self getDataRequestWithState:_state_A[old_btn.tag]];
        }else{
            [self showHint:@"删除失败"];

        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
}

//会员卡的上下架
-(void)UpOrDownCard:(NSDictionary*)card_dic andState:(NSString*)state{
    
    NSString *url ;
    
    if ([self.navigationItem.title isEqualToString:@"储值卡"]) {
        url = [[NSString alloc]initWithFormat:@"%@MerchantType/ValueCard/turn",BASEURL];
        
    }else{
        url = [NSString stringWithFormat:@"%@MerchantType/CountCard/turn",BASEURL];
    }

    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:card_dic[@"merchant"] forKey:@"muid"];
    [params setObject:card_dic[@"code"] forKey:@"code"];
    [params setObject:state forKey:@"display_state"];
    [params setObject:card_dic[@"level"] forKey:@"level"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        if ([result[@"result_code"]integerValue]==1) {
            if ([state isEqualToString:@"off"]) {
                [self showHint:@"下架成功"];

            }
            
            if ([state isEqualToString:@"on"]) {
                [self showHint:@"上架成功"];
                
            }

            [self getDataRequestWithState:_state_A[old_btn.tag]];
        }else{
            [self showHint:@"提交失败"];

        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

-(void)getDataRequestWithState:(NSString *)state{
    
    NSString *url;
    
    if ([self.navigationItem.title isEqualToString:@"储值卡"]) {
        url = [NSString stringWithFormat:@"%@MerchantType/ValueCard/get",BASEURL];

    }else{
        url = [NSString stringWithFormat:@"%@MerchantType/CountCard/get",BASEURL];
    }
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:app.shopInfoDic[@"muid"] forKey:@"muid"];
    [paramer setValue:state forKey:@"display_state"];

    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"getDataRequestWithState--url-%@-paramer-%@ result-%@",url,paramer,result);
        
        self.data_A = result;
        
        for (NSInteger i = 0; i <self.data_A.count; i ++) {
            [self.fold_mutab_dic setValue:@"1" forKey:[NSString stringWithFormat:@"%ld",i]];
        }

        noticeView.hidden = _data_A.count ;
        self.footbtnView.hidden = !_data_A.count;
        
        [self.table_View reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error.description-----%@",error.description);
    }];


}

#pragma mark 懒加载
-(NSArray *)state_A{
    if (!_state_A) {
        _state_A =  @[@"null",@"on",@"off"];
        
    }
    return _state_A;
}
-(NSMutableDictionary *)fold_mutab_dic{
    if (!_fold_mutab_dic) {
        _fold_mutab_dic =[NSMutableDictionary dictionary];
        
     }
    
    return _fold_mutab_dic;
}
-(NSArray *)data_A{
    if (!_data_A) {
        _data_A = [NSArray array];
    }
    return _data_A;
}

-(NSDictionary *)deadLine_dic{
    if (!_deadLine_dic) {
        _deadLine_dic = @{@"0.5":@"半年",@"1":@"一年",@"2":@"两年",@"3":@"三年",@"0":@"无限期"};
    }
    
    return _deadLine_dic;
}
@end
