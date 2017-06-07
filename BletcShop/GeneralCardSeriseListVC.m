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

#define sectionNum 15
@interface GeneralCardSeriseListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *old_btn;
}
@property (weak, nonatomic) IBOutlet UITableView *table_View;
@property(nonatomic,strong)NSArray *data_A;
@property(nonatomic,strong)NSMutableDictionary *fold_mutab_dic;
@property (weak, nonatomic) IBOutlet UIButton *waitBtn;
@end

@implementation GeneralCardSeriseListVC

-(NSMutableDictionary *)fold_mutab_dic{
    if (!_fold_mutab_dic) {
        _fold_mutab_dic =[NSMutableDictionary dictionary];
        
        for (NSInteger i = 0; i <sectionNum; i ++) {
            [_fold_mutab_dic setValue:@"0" forKey:[NSString stringWithFormat:@"%ld",i]];
        }
    }
    
    return _fold_mutab_dic;
}
-(NSArray *)data_A{
    if (!_data_A) {
        _data_A = [NSArray array];
    }
    return _data_A;
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    old_btn = self.waitBtn;
    
    self.navigationItem.title = self.titleDic[@"cardName"];
    
    self.table_View.estimatedRowHeight = 100;
    self.table_View.rowHeight = UITableViewAutomaticDimension;
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return sectionNum;
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
    
    return fold? 3: 0;
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
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:cell.cardPrice.text];
    [attr setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]} range:NSMakeRange(0, 1)];
    cell.cardPrice.attributedText = attr;
    
    
    
    return cell;
    
}


-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewRowAction *edit_Action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    
    edit_Action.backgroundColor = RGB(175,175,175);
    
    UITableViewRowAction *up_Down_Action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"上架" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    
    up_Down_Action.backgroundColor = RGB(246,153,44);
    
    UITableViewRowAction *delete_Action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    delete_Action.backgroundColor = RGB(235,31,31);
   return  @[delete_Action,up_Down_Action,edit_Action];
}

//未处理 已上架 已下架
- (IBAction)footBtnClick:(UIButton *)sender {
    
    
    if (sender !=old_btn) {
        sender.backgroundColor = RGB(226,102,102);
        [sender setTitleColor:[UIColor whiteColor] forState:0];
        
        old_btn.backgroundColor = [UIColor whiteColor];
        [old_btn setTitleColor:RGB(51,51,51) forState:0];

        old_btn = sender;
    }
}

//添加会员卡
-(void)addCardClick:(UIButton*)sender{
    NSLog(@"添加会员卡==%ld",sender.tag);
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


@end
