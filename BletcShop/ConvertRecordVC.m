//
//  ConvertRecordVC.m
//  BletcShop
//
//  Created by apple on 17/2/23.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ConvertRecordVC.h"
#import "UIImageView+WebCache.h"
#import "CheckLogisticsVC.h"

#import "ConvertRecordCell.h"
@interface ConvertRecordVC ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *_tableView;
}



@property(nonatomic,strong)NSArray *data_array;
@end

@implementation ConvertRecordVC
-(NSArray *)data_array{
    if (!_data_array) {
        _data_array = [NSArray array];
    }
    return _data_array;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"已兑换商品";
    self.view.backgroundColor=[UIColor whiteColor];
    
     _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    _tableView.estimatedRowHeight =100;
    
    _tableView.rowHeight=UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
    
    [self getData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ConvertRecordCell  *cell=[tableView dequeueReusableCellWithIdentifier:@"ConvertRecordCellID"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"ConvertRecordCell" owner:self options:nil] firstObject];
        
    }
    
    if (self.data_array.count != 0) {
        NSDictionary *dic = self.data_array[indexPath.row];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",POINT_GOODS,dic[@"image_url"]]]];
        
        cell.titleLab.text=dic[@"name"];
        cell.timeLab.text=dic[@"datetime"];
        cell.state_lab.text=dic[@"tip"];
        
        if ([dic[@"track_state"] isEqualToString:@"wait"]) {
            cell.state_lab.backgroundColor = [UIColor colorWithHexString:@"#e26666"];
            cell.state_m.hidden = YES;
        }else{
            if ([dic[@"track_state"] isEqualToString:@"sending"]) {
                cell.state_lab.backgroundColor = [UIColor colorWithHexString:@"#45ae26"];

            }else if([dic[@"track_state"] isEqualToString:@"received"]){
                cell.state_lab.backgroundColor = [UIColor colorWithHexString:@"#808080"];

            }
            cell.state_m.hidden = NO;

        }

    }

       return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


/*
 wait 待出货
 sending 已发货
 received 已签收
 **/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.data_array[indexPath.row];
    if (![dic[@"track_state"] isEqualToString:@"wait"]) {
        PUSH(CheckLogisticsVC)
        vc.order_dic = self.data_array[indexPath.row];

    }

    
    
}

-(void)getData{
    
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@Extra/mall/getExchange",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [paramer setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        [hub hideAnimated:YES];
        
        NSLog(@"result----%@",result);
        if (result) {
            self.data_array = (NSArray*)result;
            
            [_tableView reloadData];
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getExchange,error----%@",error);

        [hub hideAnimated:YES];
    }];

}
@end
