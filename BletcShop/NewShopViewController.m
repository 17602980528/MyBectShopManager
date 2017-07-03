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
#import "NewShopComeInTableViewCell.h"
#import "SDCycleScrollView.h"
@interface NewShopViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
{
    
    UITableView *table_View;
    SDRefreshFooterView *_refreshFooter;
    SDRefreshHeaderView *_refreshheader;
    UIView *slipBackView;
    NSMutableArray* _adverImages;
}

@property(nonatomic,strong)NSMutableArray *data_A;//存放数据,传递给下级界面
@property(nonatomic)NSInteger page;

@end

@implementation NewShopViewController
-(NSMutableArray *)data_A{
    if (!_data_A) {
        _data_A = [NSMutableArray array];
    }
    return _data_A;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _page=1;
    
    table_View = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    table_View.dataSource = self;
    table_View.delegate = self;
    table_View.rowHeight=130;
    table_View.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.view addSubview: table_View];
    
    [self getTopImgList];
    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:table_View];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block typeof(self)tempSelf =self;
    _refreshheader.beginRefreshingOperation = ^{
        tempSelf.page=1;
        [tempSelf.data_A removeAllObjects];
        //请求数据
        [tempSelf getDate];
    };
    
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:table_View];
    _refreshFooter.beginRefreshingOperation =^{
        tempSelf.page++;
        //数据请求
        NSLog(@"====>>>>%ld",tempSelf.page);
        [tempSelf getDate];
        
    };
    
    
}
-(void)getDate{
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/advertActivity/getList",BASEURL];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.activityId forKey:@"advert_id"];
    
    [paramer setValue:[NSString stringWithFormat:@"%ld",_page] forKey:@"index"];
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"=====%@===%@",[result class],result);
         [_refreshFooter endRefreshing];
         [_refreshheader endRefreshing];
         [self hideHud];
         
         [self.data_A  addObjectsFromArray:result];
         
         [table_View reloadData];
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self hideHud];
         [_refreshFooter endRefreshing];
         [_refreshheader endRefreshing];
         NSLog(@"%@", error);
     }];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 140*SCREENWIDTH/375+50-2.5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[self.data_A firstObject] isKindOfClass:[NSDictionary class]]) {
        return self.data_A.count;
    }else{
        return 0;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewShopComeInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewShopComeInCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NewShopComeInTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_data_A.count !=0) {
        NSDictionary *dic = _data_A[indexPath.row];
        cell.headname.text = dic[@"title"];
        
        
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,dic[@"image_url"]]] placeholderImage:[UIImage imageNamed:@"icon3"]];
        cell.shopKind.text=[NSString stringWithFormat:@" %@   ",dic[@"trade"]];
        
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    
}

-(NewShopDetailVC *)startSellerView:(NSMutableDictionary*)dic{
    
    NewShopDetailVC *controller = [[NewShopDetailVC alloc]init];
    
    controller.infoDic = dic;
    
    controller.title = @"商铺信息";
    //    NSLog(@"navigationController%@",self.navigationController);
    
    return controller;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    slipBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 140*SCREENWIDTH/375+47.5)];
    slipBackView.backgroundColor=RGB(240, 240, 240);
    
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, 140*SCREENWIDTH/375) delegate:self placeholderImage:[UIImage imageNamed:@""]];
    cycleScrollView2.imageURLStringsGroup = _adverImages;
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    //    cycleScrollView2.titlesGroup = titles;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [slipBackView addSubview:cycleScrollView2];
    
    UILabel *titileLable=[[UILabel alloc]initWithFrame:CGRectMake(0, cycleScrollView2.bottom+5, SCREENWIDTH, 40)];
    titileLable.backgroundColor=[UIColor whiteColor];
    titileLable.text=@"诚意上新";
    titileLable.font=[UIFont systemFontOfSize:15.0f];
    titileLable.textAlignment=NSTextAlignmentCenter;
    titileLable.textColor=RGB(98, 98, 98);
    [slipBackView addSubview:titileLable];
    
    return slipBackView;
}


-(void)getTopImgList{
    
    [self showHudInView:self.view hint:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/advert/settleGet",BASEURL];
  
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        _adverImages = [NSMutableArray array];
        
        
        for (int i=0; i<[result count]; i++) {
            [_adverImages addObject:[NSString stringWithFormat:@"%@%@",NEW_SHOP_TOP_IMAGE,result[i][@"image_url"]]];
            
        }

        
        [self getDate];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self hideHud];
    }];

}

@end
