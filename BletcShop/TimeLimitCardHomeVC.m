//
//  TimeLimitCardHomeVC.m
//  BletcShop
//
//  Created by apple on 2017/6/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "TimeLimitCardHomeVC.h"
#import "EricForTimeLimitCell.h"
#import "TimeLimitVipCardVC.h"
#import "UIImageView+WebCache.h"
#import "ExperienceCardTabVC.h"
@interface TimeLimitCardHomeVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *old_btn;
}
@property (strong, nonatomic) IBOutlet UILabel *totalCardLable;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *wait;
@property (strong, nonatomic) IBOutlet UILabel *operationState;
@property(nonatomic,strong)NSArray*state_A;
@property(nonatomic,strong)NSArray *data_A;
@property (nonatomic , strong) NSDictionary *deadLine_dic;// 有效期

@end

@implementation TimeLimitCardHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.rowHeight=50;
    
    old_btn= _wait;
    
    UIButton *menuBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [menuBt addTarget:self action:@selector(addtBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuBt setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateNormal];
    [menuBt setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateHighlighted];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:menuBt];
    self.navigationItem.rightBarButtonItem = item;
    
    
    
    [self getDataRequestWithState:self.state_A[old_btn.tag]];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_A.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString   * CellIdentiferId =  @"ericCell";
    EricForTimeLimitCell  * cell = [tableView  dequeueReusableCellWithIdentifier :CellIdentiferId];
    if (!cell){
        NSArray  * nibs = [[ NSBundle mainBundle ] loadNibNamed :@"EricForTimeLimitCell" owner :self options :nil ];
        cell = [  nibs lastObject ];
    };
    
    NSDictionary *dic = _data_A[indexPath.row];
    
    cell.nowPrice.text = dic[@"price"];
//    cell.cardName.text = dic[@"des"];
    cell.deadTime.text =  [NSString stringWithFormat:@"有限期：%@",self.deadLine_dic[dic[@"indate"]]];
    
    
    NSArray *cardTemp_A = [[NSUserDefaults standardUserDefaults]objectForKey:@"CARDIMGTEMP"];
    
    for (NSDictionary *tim_dic in cardTemp_A) {
        if ([tim_dic[@"color"] isEqualToString:dic[@"template"]]) {
            NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCECARD stringByAppendingString:tim_dic[@"image"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            
            [cell.cardImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
            cell.cardImageView.backgroundColor = [UIColor whiteColor];
            
            
            break ;
        }
    }

    cell.oldPrice.hidden =YES;
//    NSUInteger length = [cell.oldPrice.text length];
//    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:cell.oldPrice.text];
//    [attri addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSBaselineOffsetAttributeName:@(0)} range:NSMakeRange(0, length)];
//    [cell.oldPrice setAttributedText:attri];
    
    
    
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PUSH(ExperienceCardTabVC)
    vc.card_dic =_data_A[indexPath.row];
    
    
}
-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSDictionary *dic = _data_A[indexPath.row];
    
    
    UITableViewRowAction *edit_Action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        PUSH(TimeLimitVipCardVC)
        vc.card_dic = dic;
        
//        vc.cardTypeName = self.navigationItem.title;
//        vc.series_dic = _data_A[indexPath.section];
//        vc.whoPush = @"编辑";
        vc.navigationItem.title = @"编辑体验卡";
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


-(void)addtBtnAction:(UIButton *)sender{
    TimeLimitVipCardVC *vc=[[TimeLimitVipCardVC alloc]init];
    vc.navigationItem.title=@"发布体验卡";

    vc.block = ^{
        [self getDataRequestWithState:_state_A[old_btn.tag]];

    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)threeBtnClick:(UIButton *)sender {
    
    if (sender !=old_btn) {
       
        
        sender.backgroundColor = RGB(226,102,102);
        [sender setTitleColor:[UIColor whiteColor] forState:0];
        
        old_btn.backgroundColor = [UIColor whiteColor];
        [old_btn setTitleColor:RGB(51,51,51) forState:0];
        
        _operationState.text=sender.titleLabel.text;

        
        old_btn = sender;
        
        [self getDataRequestWithState:_state_A[old_btn.tag]];

    }
  
}

-(void)getDataRequestWithState:(NSString *)state{
    
    NSString *url;
    
//    if ([self.navigationItem.title isEqualToString:@"储值卡"]) {
//        url = [NSString stringWithFormat:@"%@MerchantType/ValueCard/get",BASEURL];
//        
//    }else{
        url = [NSString stringWithFormat:@"%@MerchantType/ExperienceCard/get",BASEURL];
//    }
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:app.shopInfoDic[@"muid"] forKey:@"muid"];
    [paramer setValue:state forKey:@"display"];
    
    NSLog(@"getDataRequestWithState--url-%@-paramer-%@ @",url,paramer);

    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"getDataRequestWithState result-%@",result);
        
        self.data_A = result;
        
        self.totalCardLable.text =  [NSString stringWithFormat:@"%lu",(unsigned long)self.data_A.count];
        
        [self.tableView reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error.description-----%@",error.description);
    }];
    
    
}

//会员卡的上下架
-(void)UpOrDownCard:(NSDictionary*)card_dic andState:(NSString*)state{
    
    NSString *url ;
    
//    if ([self.navigationItem.title isEqualToString:@"储值卡"]) {
//        url = [[NSString alloc]initWithFormat:@"%@MerchantType/ValueCard/turn",BASEURL];
//        
//    }else{
        url = [NSString stringWithFormat:@"%@MerchantType/ExperienceCard/turn",BASEURL];
//    }
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:card_dic[@"muid"] forKey:@"muid"];
    [params setObject:card_dic[@"code"] forKey:@"code"];
    [params setObject:state forKey:@"display"];
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

//删除会员卡
-(void)postDeleteCards:(NSDictionary *)dic{
    
    NSString *url ;
    
//    if ([self.navigationItem.title isEqualToString:@"储值卡"]) {
//        url = [[NSString alloc]initWithFormat:@"%@MerchantType/ValueCard/del",BASEURL];
//        
//    }else{
        url = [NSString stringWithFormat:@"%@MerchantType/ExperienceCard/del",BASEURL];
//    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:dic[@"muid"] forKey:@"muid"];
    [params setObject:dic[@"code"] forKey:@"code"];
    
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

#pragma mark 懒加载
-(NSArray *)state_A{
    if (!_state_A) {
        _state_A =  @[@"null",@"on",@"off"];
        
    }
    return _state_A;
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
