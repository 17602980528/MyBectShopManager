//
//  HolidayActivertyVC.m
//  BletcShop
//
//  Created by apple on 17/2/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "HolidayActivertyVC.h"
#import "AdvertiseCell.h"
#import "ActivityModel.h"
#import "SellerViewController.h"
@interface HolidayActivertyVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *table_View;
    
}
@property(nonatomic,strong)UIView *headerView;//头view
@property(nonatomic,strong)NSArray *data_A;//存放数据,传递给下级界面
@end

@implementation HolidayActivertyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(240, 240, 240);
    [self creatHeaderView];
    table_View = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-self.tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
    table_View.dataSource = self;
    table_View.delegate = self;
    table_View.estimatedRowHeight = 200;
    table_View.separatorStyle= UITableViewCellSeparatorStyleNone;
    table_View.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview: table_View];
    [self getDate];
    
}
-(void)getDate{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/activity/advertGet",BASEURL];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.activityId forKey:@"activity"];
    
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"=====%@",result);
         
         
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
    
//    return 0.01;
        return self.headerView.height;
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
    
    AdvertiseCell *cell = [AdvertiseCell advertiseCellIntiWithTableView:tableView];
    
    if (self.data_A.count!=0 && [[self.data_A firstObject] isKindOfClass:[NSDictionary class]]) {
        ActivityModel *model = [[ActivityModel alloc]initWithDic:self.data_A[indexPath.row]];
        cell.model = model;
        cell.goLooK.tag = indexPath.row;
        [cell.goLooK addTarget:self action:@selector(goLookClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    AdvertiseCell*cell = (AdvertiseCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    UIButton *button =cell.goLooK;
    
    [self goLookClick:button];
    
    
}

-(void)goLookClick:(UIButton*)sender{
    
    NSLog(@"----%ld",sender.tag);
    NSMutableDictionary *shopInfoDic = [self.data_A objectAtIndex:sender.tag];
    
    SellerViewController *vc= [self startSellerView:shopInfoDic];
    vc.videoID=@"";
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/videoGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //获取商家手机号
    
    [params setObject:shopInfoDic[@"merchant"] forKey:@"merchant"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray* result)
     {
         NSLog(@"result==%@",result);
         if (result.count>0) {
             __block HolidayActivertyVC* tempSelf = self;
             vc.videoID=result[0][@"video"];
             [tempSelf.navigationController pushViewController:vc animated:YES];
         }else{
             __block HolidayActivertyVC* tempSelf = self;
             vc.videoID=@"";
             [tempSelf.navigationController pushViewController:vc animated:YES];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         __block HolidayActivertyVC* tempSelf = self;
         vc.videoID=@"";
         [tempSelf.navigationController pushViewController:vc animated:YES];
     }];
    
}

-(SellerViewController *)startSellerView:(NSMutableDictionary*)dic{
    
    SellerViewController *controller = [[SellerViewController alloc]init];
    
    controller.infoDic = dic;
    
    controller.title = @"商铺信息";
    //    NSLog(@"navigationController%@",self.navigationController);
    
    return controller;
    
}

//定位地图

-(void)GoMapView{
    
    NSLog(@"地图");
    
}

-(NSArray *)data_A{
    if (!_data_A) {
        _data_A = [NSArray array];
    }
    return _data_A;
}
-(UIView *)creatHeaderView{
    self.headerView = [[UIView alloc]init];
    UIImageView *imgaView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 242*SCREENWIDTH/800)];
    imgaView.image = [UIImage imageNamed:@"tempActiverty.jpg"];
    [_headerView addSubview:imgaView];

    UIView *back_view = [[UIView alloc]initWithFrame:CGRectMake(12, imgaView.bottom+10, SCREENWIDTH-24, 31)];
    back_view.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:back_view];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, back_view.width, back_view.height)];
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    lable.text = appdelegate.addressInfo;


    lable.textColor = RGB(102,102,102);
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:14];
    [back_view addSubview:lable];

    NSMutableAttributedString *attri =[[NSMutableAttributedString alloc] initWithString:lable.text];
    NSTextAttachment *attch = [[NSTextAttachment alloc]init];
    attch.image = [UIImage imageNamed:@"location"];
    attch.bounds = CGRectMake(0, 0, 12, 12);
    NSAttributedString *atbs = [NSAttributedString attributedStringWithAttachment:attch];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:atbs];

    [attributedString appendAttributedString:attri];

    lable.attributedText = attributedString;

    _headerView.frame = CGRectMake(0, 0, SCREENWIDTH, back_view.bottom+10);

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GoMapView)];
    [back_view addGestureRecognizer:tap];

    return _headerView;

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
