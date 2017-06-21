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
@interface TimeLimitCardHomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *totalCardLable;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *wait;
@property (strong, nonatomic) IBOutlet UIButton *finish;
@property (strong, nonatomic) IBOutlet UIButton *offMarket;
@property (strong, nonatomic) IBOutlet UILabel *operationState;

@end

@implementation TimeLimitCardHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.rowHeight=50;
    
    UIButton *menuBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [menuBt addTarget:self action:@selector(addtBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuBt setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateNormal];
    [menuBt setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateHighlighted];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:menuBt];
    self.navigationItem.rightBarButtonItem = item;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString   * CellIdentiferId =  @"ericCell";
    EricForTimeLimitCell  * cell = [tableView  dequeueReusableCellWithIdentifier :CellIdentiferId];
    if (!cell){
        NSArray  * nibs = [[ NSBundle mainBundle ] loadNibNamed :@"EricForTimeLimitCell" owner :self options :nil ];
        cell = [  nibs lastObject ];
    };
    NSLog(@"%@",cell.oldPrice.text);
    NSUInteger length = [cell.oldPrice.text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:cell.oldPrice.text];
//    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(2, length-2)];
//    [attri addAttribute:NSStrikethroughColorAttributeName value :[UIColor redColor] range:NSMakeRange(2, length-2)];
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
                                                                       }];
    rowAction.backgroundColor=[UIColor redColor];
    
    UITableViewRowAction *rowActionSec = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                            title:@"编辑"
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              NSLog(@"编辑");
                                                                          }];
    rowActionSec.backgroundColor = [UIColor grayColor];
    
    UITableViewRowAction *rowActionThird = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                            title:@"上架"
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              NSLog(@"上架");
                                                                          }];
    rowActionThird.backgroundColor = [UIColor orangeColor];
    NSArray *arr = @[rowAction,rowActionThird,rowActionSec];
    return arr;
}
-(void)addtBtnAction:(UIButton *)sender{
    TimeLimitVipCardVC *vc=[[TimeLimitVipCardVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)waitBtnClick:(UIButton *)sender {
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_finish setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_offMarket setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sender.backgroundColor=RGB(234, 125, 121);
    _finish.backgroundColor=[UIColor whiteColor];
    _offMarket.backgroundColor=[UIColor whiteColor];
    _operationState.text=sender.titleLabel.text;
}
- (IBAction)onMarketBtnClick:(UIButton *)sender {
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_wait setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_offMarket setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     sender.backgroundColor=RGB(234, 125, 121);
    _wait.backgroundColor=[UIColor whiteColor];
    _offMarket.backgroundColor=[UIColor whiteColor];
    _operationState.text=sender.titleLabel.text;
}
- (IBAction)offMarketBtnClick:(UIButton *)sender {
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_wait setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_finish setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     sender.backgroundColor=RGB(234, 125, 121);
     _wait.backgroundColor=[UIColor whiteColor];
     _finish.backgroundColor=[UIColor whiteColor];
    _operationState.text=sender.titleLabel.text;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end