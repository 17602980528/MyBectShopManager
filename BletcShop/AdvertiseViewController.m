//
//  AdvertiseViewController.m
//  BletcShop
//
//  Created by Bletc on 2016/11/7.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "AdvertiseViewController.h"
#import "AdvertiseCell.h"
#import "ActivityModel.h"
#import "NewShopDetailVC.h"
#import "TopActiveCell.h"
@interface AdvertiseViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *table_View;

}
@property(nonatomic,strong)UIView *headerView;//头view
@property(nonatomic,strong)NSArray *data_A;//存放数据,传递给下级界面

@end

@implementation AdvertiseViewController


-(NSArray *)data_A{
    if (!_data_A) {
        _data_A = [NSArray array];
    }
    return _data_A;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    table_View = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-self.tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
    table_View.dataSource = self;
    table_View.delegate = self;
    table_View.estimatedRowHeight = 130;
    table_View.separatorStyle= UITableViewCellSeparatorStyleNone;
    table_View.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview: table_View];

//    [self creatHeaderView];
    
    [self getDate];
    
}
-(void)getDate{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/advertActivity/getList",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.activityId forKey:@"advert_id"];
    
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"=====%@",result);

         
         self.data_A= (NSArray*)result;
         
         [table_View reloadData];
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@", error);
     }];
    
    
}


//-(UIView *)creatHeaderView{
//   self.headerView = [[UIView alloc]init];
//    
//    UIImageView *imgaView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 226*SCREENWIDTH/375)];
//    imgaView.image = [UIImage imageNamed:@"5-01"];
//    [_headerView addSubview:imgaView];
//    
//    UIView *back_view = [[UIView alloc]initWithFrame:CGRectMake(12, imgaView.bottom+10, SCREENWIDTH-24, 31)];
//    back_view.backgroundColor = [UIColor whiteColor];
//    [_headerView addSubview:back_view];
//    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, back_view.width, back_view.height)];
//    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    
//    lable.text = appdelegate.addressInfo;
//    
//    
//    lable.textColor = RGB(102,102,102);
//    lable.textAlignment = NSTextAlignmentCenter;
//    lable.font = [UIFont systemFontOfSize:14];
//    [back_view addSubview:lable];
//    
//    NSMutableAttributedString *attri =[[NSMutableAttributedString alloc] initWithString:lable.text];
//    NSTextAttachment *attch = [[NSTextAttachment alloc]init];
//    attch.image = [UIImage imageNamed:@"location"];
//    attch.bounds = CGRectMake(0, 0, 12, 12);
//    NSAttributedString *atbs = [NSAttributedString attributedStringWithAttachment:attch];
//    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:atbs];
//    
//    [attributedString appendAttributedString:attri];
//    
//    lable.attributedText = attributedString;
//    
//    _headerView.frame = CGRectMake(0, 0, SCREENWIDTH, back_view.bottom+10);
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GoMapView)];
//    [back_view addGestureRecognizer:tap];
//    
//    return _headerView;
//
//}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
//    return self.headerView.height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[self.data_A firstObject] isKindOfClass:[NSDictionary class]]) {
        return self.data_A.count;
        
    }else{
        return 0;
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.headerView;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
//    AdvertiseCell *cell = [AdvertiseCell advertiseCellIntiWithTableView:tableView];
//    
//    if (self.data_A.count!=0 && [[self.data_A firstObject] isKindOfClass:[NSDictionary class]]) {
//        ActivityModel *model = [[ActivityModel alloc]initWithDic:self.data_A[indexPath.row]];
//        cell.model = model;
//        cell.goLooK.tag = indexPath.row;
//        [cell.goLooK addTarget:self action:@selector(goLookClick:) forControlEvents:UIControlEventTouchUpInside];
//
//        
//    }
    

    
    
        TopActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topActiveId"];
        
        
        
        
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"TopActiveCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (_data_A.count !=0) {
            NSDictionary *dic = _data_A[indexPath.row];
            cell.headname.text = dic[@"title"];
            cell.headContent.text = dic[@"info"];
            
            [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",THIER_ADVERTIMAGE,dic[@"image_url"]]] placeholderImage:[UIImage imageNamed:@"5-01"]];
            
        }
        return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    AdvertiseCell*cell = (AdvertiseCell*)[tableView cellForRowAtIndexPath:indexPath];
//    
//    UIButton *button =cell.goLooK;
//    
//    [self goLookClick:button];
//    
//    
//}
//
//-(void)goLookClick:(UIButton*)sender{
//    
//    NSLog(@"----%ld",sender.tag);
    NSMutableDictionary *shopInfoDic = [self.data_A objectAtIndex:indexPath.row];
    
    NewShopDetailVC *vc= [self startSellerView:shopInfoDic];
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
//             __block AdvertiseViewController* tempSelf = self;
//             vc.videoID=result[0][@"video"];
//             [tempSelf.navigationController pushViewController:vc animated:YES];
//         }else{
//             __block AdvertiseViewController* tempSelf = self;
//             vc.videoID=@"";
//             [tempSelf.navigationController pushViewController:vc animated:YES];
//         }
//         
//     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"%@", error);
//         __block AdvertiseViewController* tempSelf = self;
//         vc.videoID=@"";
//         [tempSelf.navigationController pushViewController:vc animated:YES];
//     }];
//    //
    if ([self.data_A[indexPath.row][@"pay_type"] isEqualToString:@"click"]) {
        [self postRemainClickCount:self.data_A[indexPath.row]];
    }
    
}

-(NewShopDetailVC *)startSellerView:(NSMutableDictionary*)dic{
    
    NewShopDetailVC *controller = [[NewShopDetailVC alloc]init];
    
    controller.infoDic = dic;
    
    controller.title = @"商铺信息";
    //    NSLog(@"navigationController%@",self.navigationController);
    
    return controller;
    
}

//定位地图

-(void)GoMapView{

    NSLog(@"地图");
    
}
//点击广告处理
-(void)postRemainClickCount:(NSDictionary *)dic{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/advert/click",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //获取商家手机号
    [params setObject:dic[@"muid"] forKey:@"muid"];
    [params setObject:@"activity" forKey:@"advert_type"];
    [params setObject:[getUUID getUUID] forKey:@"local_id"];
    [params setObject:dic[@"id"] forKey:@"advert_id"];
    [params setObject:dic[@"position"] forKey:@"advert_position"];
    NSLog(@"%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result==%@",result);
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         
     }];

}
@end
