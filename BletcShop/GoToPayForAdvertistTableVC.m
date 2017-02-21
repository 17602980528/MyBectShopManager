//
//  GoToPayForAdvertistTableVC.m
//  BletcShop
//
//  Created by Bletc on 2017/2/21.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "GoToPayForAdvertistTableVC.h"

@interface GoToPayForAdvertistTableVC ()

{
    NSArray *dataSourse_A;
    NSArray *data_A;

}

@property(nonatomic,strong)NSArray *section1_A;
@property(nonatomic,strong)NSArray *section2_A;


@end

@implementation GoToPayForAdvertistTableVC

-(NSArray *)section1_A{
    if (!_section1_A) {
        _section1_A = @[@"商家名称",@"广告类型",@"地区",@"活动类型",@"广告位置"];
    }
    return _section1_A;
}
-(NSArray *)section2_A{
    if (!_section2_A) {
        _section2_A = @[@"有效日期",@"提交日期",@"商品总额",@"商品金额 ",@"优惠金额",@"实付金额",@"结算状态"];
    }
    return _section2_A;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  self.navigationItem.title = @"发布广告";
    
    dataSourse_A = @[self.section1_A,self.section2_A];
    data_A = @[@[@"商消乐",@"顶部活动轮播页面",@"西安市高新区富鱼路",@"XXXXXX",@"1-12"],@[@"2016-12-01至2017-05-07",@"2016-12-08 17:00:05",@"￥299",@"￥299",@"￥0",@"￥299",@"未结算"]];
    
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = RGB(240, 240, 240);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 35 ;
    
    
    
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataSourse_A.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else{
        return SCREENHEIGHT -64- tableView.contentSize.height;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT -64- tableView.contentSize.height);
        view.backgroundColor = [UIColor whiteColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(25, 20, SCREENWIDTH-50, 44);
        button.backgroundColor = NavBackGroundColor;
        [button setTitle:@"去支付" forState:0];
        button.layer.cornerRadius = 4;
        [button addTarget:self action:@selector(gotopay) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        return view;
    }else return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = dataSourse_A[section];
    
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GotopayFor";
    UILabel *leftLab;
    UILabel *rightLab;

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        leftLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
        leftLab.font = [UIFont systemFontOfSize:15];
        leftLab.textColor = RGB(102,102,102);
        leftLab.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:leftLab];
       
        
        rightLab = [[UILabel alloc]initWithFrame:CGRectMake(leftLab.right+15, 0, SCREENWIDTH-leftLab.right-15, leftLab.height)];
        rightLab.font = [UIFont systemFontOfSize:15];
        rightLab.textColor = RGB(102,102,102);
        rightLab.textAlignment = NSTextAlignmentLeft;
        rightLab.text = @"西安市高新区富鱼路";

        [cell.contentView addSubview:rightLab];
        
        
    }
    
    leftLab.text = dataSourse_A[indexPath.section][indexPath.row];
    rightLab.text = data_A[indexPath.section][indexPath.row];
    
    if (indexPath.section==1 && indexPath.row ==5) {
        rightLab.textColor = RGB(215,32,32);
        
    }
    return cell;
}

-(void)gotopay{
    
    NSLog(@"去支付");
}


@end
