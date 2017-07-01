//
//  MealAndExpCardManageVC.m
//  BletcShop
//
//  Created by Bletc on 2017/6/29.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "MealAndExpCardManageVC.h"
#import "OrderViewController.h"
#import "ComplaintVC.h"
@interface MealAndExpCardManageVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table_View;
@property (strong, nonatomic) IBOutlet UIView *tabe_headerView;
@property (weak, nonatomic) IBOutlet UIView *header_bg;
@property (weak, nonatomic) IBOutlet UILabel *card_type;
@property (weak, nonatomic) IBOutlet UILabel *card_content;
@property (weak, nonatomic) IBOutlet UIView *grayView;


@property(nonatomic,strong)  NSArray *titles_array;
@property(nonatomic,strong) NSArray *imageNameArray;
@end

@implementation MealAndExpCardManageVC


-(NSArray *)titles_array{
    if (!_titles_array) {
        _titles_array = @[@"我要预约",@"投诉理赔"];
    }
    return _titles_array;
}
-(NSArray *)imageNameArray{
    if (!_imageNameArray) {
        _imageNameArray = @[@"vip_order_n",@"VIP_icon_comp_n"];
    }
    return _imageNameArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"会员卡";

    
    
   CGRect frame = self.tabe_headerView.frame;
    frame.size.width = SCREENWIDTH;
    frame.size.height = self.grayView.bottom;
    self.tabe_headerView.frame = frame;
//
    NSLog(@"frame = %@",NSStringFromCGRect(self.tabe_headerView.frame));
    
    self.table_View.tableHeaderView = self.tabe_headerView;
    self.table_View.rowHeight = 50;
    
    
    self.header_bg.backgroundColor = [UIColor colorWithHexString:_card_dic[@"card_temp_color"]];
    
    self.card_type.text = _card_dic[@"card_type"];
    if ([_card_dic[@"card_type"] isEqualToString:@"套餐卡"]) {
        self.card_content.text = [NSString stringWithFormat:@"套餐总价:%@",_card_dic[@"option_sum"]];

    }
    
    if ([_card_dic[@"card_type"] isEqualToString:@"体验卡"]) {
        self.card_content.text = [NSString stringWithFormat:@"价值:%@",_card_dic[@"price"]];
        
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
//    return self.tabe_headerView.height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return self.tabe_headerView;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
    }
    cell.textLabel.text=self.titles_array[indexPath.row];
    cell.imageView.image=[UIImage imageNamed:self.imageNameArray[indexPath.row]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 50-1, SCREENWIDTH, 1)];
    line.backgroundColor = RGB(220,220,220);
    [cell.contentView addSubview:line];
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        
        [self  postRequestOrder];
    
    }
    
    
    
    if (indexPath.row==1) {
        
        
        ComplaintVC *VC = [[ComplaintVC alloc]init];
        VC.card_info = _card_dic;
        
        [self.navigationController pushViewController:VC animated:YES];
    }
}


/**
 预约
 */
-(void)postRequestOrder
{
    //获取商家的商品列表
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/commodity/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [params setObject:_card_dic[@"merchant"] forKey:@"muid"];
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result = %@", result);
        
        OrderViewController *orderView = [[OrderViewController alloc]init];
        orderView.allClassArray =[NSMutableArray arrayWithArray:result];
        orderView.card_dic = _card_dic;
        
        
        [self.navigationController pushViewController:orderView animated:YES];
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}



@end
