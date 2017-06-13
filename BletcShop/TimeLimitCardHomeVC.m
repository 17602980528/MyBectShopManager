//
//  TimeLimitCardHomeVC.m
//  BletcShop
//
//  Created by apple on 2017/6/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "TimeLimitCardHomeVC.h"
#import "EricForTimeLimitCell.h"
@interface TimeLimitCardHomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *totalCardLable;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *wait;
@property (strong, nonatomic) IBOutlet UIButton *finish;
@property (strong, nonatomic) IBOutlet UIButton *offMarket;

@end

@implementation TimeLimitCardHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.rowHeight=50;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString   * CellIdentiferId =  @"ericCell";
    EricForTimeLimitCell  * cell = [tableView  dequeueReusableCellWithIdentifier :CellIdentiferId];
    if (!cell){
        NSArray  * nibs = [[ NSBundle mainBundle ] loadNibNamed :@"EricForTimeLimitCell" owner :nil options :nil ];
        cell = [  nibs lastObject ];
    };
  return cell;
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
