//
//  CardShowViewController.m
//  BletcShop
//
//  Created by apple on 16/12/15.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "CardShowViewController.h"
#import "ContentDetailViewController.h"
@interface CardShowViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSDictionary *deadLine_dic;
@end

@implementation CardShowViewController
{
    NSArray *array;
    CGFloat heights;
}
-(NSDictionary *)deadLine_dic{
    if (!_deadLine_dic) {
        _deadLine_dic = @{@"0.5":@"半年",@"1":@"一年",@"2":@"两年",@"3":@"三年",@"0":@"无限期"};
    }
    
    return _deadLine_dic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"会员卡信息";
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    array=@[@"会员卡编号",@"会员卡类型",@"会员卡级别",@"会员卡价格",@"有效期",@"优惠内容"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text=array[indexPath.row];
    if (indexPath.row==0) {
        cell.detailTextLabel.text=self.dic[@"code"];
    }else if (indexPath.row==1){
        cell.detailTextLabel.text=self.dic[@"type"];
    }else if (indexPath.row==2){
        cell.detailTextLabel.text=self.dic[@"level"];
    }else if (indexPath.row==3){
        cell.detailTextLabel.text=self.dic[@"price"];
    }else if (indexPath.row==4){
        NSLog(@"%@",_deadLine_dic);
        cell.detailTextLabel.text=[self.deadLine_dic objectForKey:self.dic[@"indate"]];
    }else if (indexPath.row==5){
        heights=[self.dic[@"content"] getTextHeightWithShowWidth:SCREENWIDTH-120 AndTextFont:[UIFont systemFontOfSize:17.0f] AndInsets:5];
        cell.detailTextLabel.numberOfLines=0;
        
        cell.detailTextLabel.text=self.dic[@"content"];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 200*(SCREENWIDTH-40)/336.0+20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row!=5) {
        return 64;
    }else{
        return heights;
    }
    return 64;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200*(SCREENWIDTH-40)/336.0+20)];
    view.backgroundColor=RGB(240, 240, 240);
    
    UIImageView *cardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, SCREENWIDTH-40, 200*(SCREENWIDTH-40)/336.0)];
    cardImageView.layer.cornerRadius = 10;
    cardImageView.layer.masksToBounds = YES;
    cardImageView.layer.borderWidth = 0.5;
    cardImageView.layer.borderColor = RGB(234, 234, 234).CGColor;
    
    cardImageView.backgroundColor = [UIColor colorWithHexString:self.dic[@"card_temp_color"]];
    
    
    [view addSubview:cardImageView];
    
    UILabel *typeAndeLevel = [[UILabel alloc]initWithFrame:CGRectMake(12, 30, cardImageView.width-12, 23)];
    typeAndeLevel.textColor = RGB(255,255,255);
    typeAndeLevel.text = [NSString stringWithFormat:@"%@(%@)",self.dic[@"type"],self.dic[@"level"]];
    typeAndeLevel.font = [UIFont systemFontOfSize:22];
    [cardImageView addSubview:typeAndeLevel];
    
    UIView *downView=[[UIView alloc]initWithFrame:CGRectMake(0, cardImageView.height - 49, cardImageView.width, 49)];
    downView.backgroundColor=[UIColor whiteColor];
    [cardImageView addSubview:downView];
    
    UILabel *yueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, cardImageView.height-49-21-30, cardImageView.width-12, 21)];
    yueLabel.textColor = RGB(255,255,255);
    yueLabel.textAlignment = NSTextAlignmentRight;
    yueLabel.font = [UIFont systemFontOfSize:27];
    [cardImageView addSubview:yueLabel];
    yueLabel.text = [[NSString alloc]initWithFormat:@"价格:%@",self.dic[@"price"]];
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    UILabel *shopName=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, downView.width-91-12, downView.height)];
    shopName.text=delegate.shopInfoDic[@"store"];
    shopName.textColor= RGB(51, 51, 51);
    [downView addSubview:shopName];
    
    return view;
}

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger row = indexPath.row;
//    if (row == 4) {
//        ContentDetailViewController *detailVC=[[ContentDetailViewController alloc]init];
//        detailVC.content=self.dic[@"content"];
//        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
//            detailVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//        }else{
//            detailVC.modalPresentationStyle=UIModalPresentationCurrentContext;
//        }
//        [self presentViewController:detailVC animated:YES completion:nil];
//    }
//}



@end
