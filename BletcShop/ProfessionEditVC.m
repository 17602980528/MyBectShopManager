//
//  ProfessionEditVC.m
//  BletcShop
//
//  Created by Bletc on 2017/3/15.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ProfessionEditVC.h"

@interface ProfessionEditVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSIndexPath *oldindexpath;
}
@property (weak, nonatomic) IBOutlet UITableView *tabVIew;
@property(nonatomic,strong)NSArray *headTitle_A;
@property(nonatomic,strong)NSArray *title_A;

@end

@implementation ProfessionEditVC

-(NSArray *)headTitle_A{
    if (!_headTitle_A) {
        _headTitle_A = @[@"通用职业",@"IT互联网",@"文化传媒",@"金融",@"教育培训",@"医疗生物",@"政府组织",@"工业制造",@"餐饮出行",@"服务业",@"其他"];
    }
    return _headTitle_A;
}

-(NSArray*)title_A{
    if (!_title_A) {
        _title_A = @[
                     @[@"销售",@"市场",@"人力资源",@"行政",@"公关",@"客服",@"采购",@"技工",@"公司职员",@"职业经理人",@"私营企业主",@"中层管理者",@"自由职业者"],
                     @[@"开发工程师",@"测试工程师",@"设计师",@"运营师",@"产品经理",@"风控安全",@"个体/网店"],
                     @[@"编辑策划",@"记者",@"艺人",@"经纪人",@"媒体工作者"],
                     @[@"咨询",@"投行",@"保险",@"金融分析师",@"财务",@"风险管理",@"风险投资人"],
                     @[@"学生",@"留学生",@"大学生",@"研究生",@"博士",@"科研人员",@"教师"],
                     @[@"医生",@"护士",@"宠物医生",@"医学研究"],
                     @[@"公务员",@"事业单位",@"军人",@"律师",@"警察",@"国企工作者",@"运动员"],
                     @[@"技术研发",@"技工",@"质检",@"建筑工人",@"装修工人",@"建筑设计师"],
                     @[@"厨师",@"服务员",@"收银",@"导购",@"保安",@"乘务人员",@"驾驶员",@"航空人员",@"空乘"],
                     @[@"导游",@"快递员(含外卖)",@"美容美发",@"家政服务",@"婚庆摄影",@"运动健身"],
                     @[@"其他"]
                     ];
    }
    return _title_A;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabVIew.rowHeight = 44;
    self.navigationItem.title = @"职业";
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.headTitle_A.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.title_A[section] count];
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *tilt = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    tilt.text = self.headTitle_A[section];
    tilt.textAlignment = NSTextAlignmentCenter;
    tilt.textColor = RGB(51, 51, 51);
    tilt.font = [UIFont systemFontOfSize:15];
    return tilt;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idientifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idientifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idientifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = RGB(51, 51, 51);
    }
    if (oldindexpath ==indexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    cell.textLabel.text = self.title_A[indexPath.section][indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (oldindexpath != indexPath) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldindexpath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        oldindexpath = indexPath;
    }
    
    
}


-(void)sureClick{
    NSString *profession = @"";
    if (oldindexpath) {
        profession = self.title_A[oldindexpath.section][oldindexpath.row];
    }
    NSLog(@"-profession----%@",profession);
}
@end
