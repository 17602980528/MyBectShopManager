//
//  NewShopViewController.m
//  BletcShop
//
//  Created by Bletc on 2016/11/7.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NewShopViewController.h"
#import "AdvertiseCell.h"
#import "ActivityModel.h"
#import "NewShopDetailVC.h"
#import "TopActiveCell.h"
@interface NewShopViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
        UITableView *table_View;
        
    
}

@property(nonatomic,strong)NSArray *data_A;//存放数据,传递给下级界面


@end

@implementation NewShopViewController
-(NSArray *)data_A{
    if (!_data_A) {
        _data_A = [NSArray array];
    }
    return _data_A;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    table_View = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    table_View.dataSource = self;
    table_View.delegate = self;
    table_View.estimatedRowHeight = 200;
    table_View.separatorStyle= UITableViewCellSeparatorStyleNone;
    table_View.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview: table_View];
    
    [self getDate];
    
}
-(void)getDate{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/advertActivity/getList",BASEURL];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.activityId forKey:@"advert_id"];

    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"=====%@===%@",[result class],result);
         
         
             self.data_A= (NSArray*)result;
             
             [table_View reloadData];



         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@", error);
     }];

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 0.01;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[self.data_A firstObject] isKindOfClass:[NSDictionary class]]) {
            return self.data_A.count;
            
       
    }else{
        return 0;
    }
    
    
    
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    AdvertiseCell *cell = [AdvertiseCell advertiseCellIntiWithTableView:tableView];
//    
//    if (self.data_A.count!=0 && [[self.data_A firstObject] isKindOfClass:[NSDictionary class]]) {
//        
//        ActivityModel *model = [[ActivityModel alloc]initWithDic:self.data_A[indexPath.row]];
//        cell.model = model;
//        cell.goLooK.tag = indexPath.row;
//        [cell.goLooK addTarget:self action:@selector(goLookClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//    }
//    return cell;

    
    
    
    TopActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topActiveId"];
    
    
    
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TopActiveCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_data_A.count !=0) {
        NSDictionary *dic = _data_A[indexPath.row];
        cell.headname.text = dic[@"title"];
        cell.headContent.text = dic[@"info"];
        
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",THIER_ADVERTIMAGE,dic[@"image_url"]]] placeholderImage:[UIImage imageNamed:@"icon3"]];
        
    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
//   AdvertiseCell*cell = (AdvertiseCell*)[tableView cellForRowAtIndexPath:indexPath];
//    
//    UIButton *button =cell.goLooK;
//    
//    [self goLookClick:button];
//    
//    
//    NSLog(@"----%ld",sender.tag);
    NSMutableDictionary *shopInfoDic = [self.data_A objectAtIndex:indexPath.row];
    
    NewShopDetailVC *vc= [self startSellerView:shopInfoDic];
    vc.videoID=@"";
    
    
    vc.videoID=[NSString getTheNoNullStr:shopInfoDic[@"video"] andRepalceStr:@""];
    [self.navigationController pushViewController:vc animated:YES];
    

    
}

-(void)goLookClick:(UIButton*)sender{
    
    NSLog(@"----%ld",sender.tag);
    NSMutableDictionary *shopInfoDic = [self.data_A objectAtIndex:sender.tag];

    NewShopDetailVC *vc= [self startSellerView:shopInfoDic];
    vc.videoID=@"";
    
    
    vc.videoID=[NSString getTheNoNullStr:shopInfoDic[@"video"] andRepalceStr:@""];
    [self.navigationController pushViewController:vc animated:YES];
    
    
//    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/videoGet",BASEURL];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    //获取商家手机号
//
//    [params setObject:shopInfoDic[@"muid"] forKey:@"muid"];
//    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray* result)
//     {
//         NSLog(@"result==%@",result);
//         if (result.count>0) {
//             __block NewShopViewController* tempSelf = self;
//             if ([result[0][@"state"] isEqualToString:@"true"]) {
//                 vc.videoID=result[0][@"video"];
//                 
//             }else{
//                 vc.videoID=@"";
//                 
//             }
//             [tempSelf.navigationController pushViewController:vc animated:YES];
//         }else{
//             __block NewShopViewController* tempSelf = self;
//             vc.videoID=@"";
//             [tempSelf.navigationController pushViewController:vc animated:YES];
//         }
//
//     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"%@", error);
//         __block NewShopViewController* tempSelf = self;
//         vc.videoID=@"";
//         [tempSelf.navigationController pushViewController:vc animated:YES];
//     }];
    
}

-(NewShopDetailVC *)startSellerView:(NSMutableDictionary*)dic{
    
    NewShopDetailVC *controller = [[NewShopDetailVC alloc]init];
    
    controller.infoDic = dic;
    
    controller.title = @"商铺信息";
//    NSLog(@"navigationController%@",self.navigationController);
    
    return controller;
    
}


@end
