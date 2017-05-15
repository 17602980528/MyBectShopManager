//
//  SearchTableViewController.m
//  BletcShop
//
//  Created by Bletc on 16/6/20.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "SearchTableViewController.h"
#import "UIImageView+WebCache.h"
#import "NewShopDetailVC.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "ShaperView.h"
#import "DLStarRatingControl.h"
@interface SearchTableViewController ()
@property(nonatomic)int indexss;

@end

@implementation SearchTableViewController
{
    __block int _indexss;
    SDRefreshFooterView *_refreshFooter;
    SDRefreshHeaderView *_refreshheader;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索商家";
    
    _indexss=1;
    self.searchList=[[NSMutableArray alloc]initWithCapacity:0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (_searchController==nil) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    }
    
    
    _searchController.searchResultsUpdater = self;
    _searchController.delegate = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.delegate =self;
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:self.tableView];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block SearchTableViewController *blockSelf = self;
    _refreshheader.beginRefreshingOperation = ^{
        _indexss=1;
        [blockSelf postRequestSearch];
    };
    
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.tableView];
    
    _refreshFooter.beginRefreshingOperation =^{
        blockSelf.indexss++;
        [blockSelf postRequestSearch];
        
    };
    
    
}




#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //    DebugLog(@"dataList=====%lu",(unsigned long)self.dataList.count);
    
    
    if (self.searchController.active) {
        return [self.searchList count];
    }else{
        return [self.dataList count];
        return 0;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"cellIndentifier";
    // 定义唯一标识
    // 通过indexPath创建cell实例 每一个cell都是单独的
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    UIImageView *shopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 64, 64)];
    shopImageView.layer.cornerRadius = 5;
    shopImageView.layer.masksToBounds = YES;
    [cell addSubview:shopImageView];
    //店名
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, SCREENWIDTH-90, 20)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    nameLabel.numberOfLines = 0;
    nameLabel.text = @"";
    [cell addSubview:nameLabel];
    
    //距离
    UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 63, 120, 12)];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.textAlignment = NSTextAlignmentLeft;
    distanceLabel.font = [UIFont systemFontOfSize:12];
    distanceLabel.text = @"1000米";
    [cell addSubview:distanceLabel];
    //销售额
    UILabel *sellerLabel=[[UILabel alloc]initWithFrame:CGRectMake(90+95+20, 40, SCREENWIDTH-90-95-20, 12)];
    sellerLabel.font=[UIFont systemFontOfSize:12.0f];
    sellerLabel.textAlignment=NSTextAlignmentLeft;
    [cell addSubview:sellerLabel];
    
    ShaperView *viewr=[[ShaperView alloc]initWithFrame:CGRectMake(90, 85, SCREENWIDTH-90, 1)];
    ShaperView *viewt= [viewr drawDashLine:viewr lineLength:3 lineSpacing:3 lineColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f]];
    [cell addSubview:viewt];
    
    UILabel *sheLab=[[UILabel alloc]initWithFrame:CGRectMake(90, 97, 12, 12)];
    sheLab.backgroundColor=[UIColor colorWithRed:238/255.0 green:94/255.0 blue:44/255.0f alpha:1.0];
    sheLab.text=@"折";
    sheLab.textAlignment=1;
    sheLab.textColor=[UIColor whiteColor];
    sheLab.font=[UIFont systemFontOfSize:12.0f];
    [cell addSubview:sheLab];
    
    UILabel *sheContent=[[UILabel alloc]initWithFrame:CGRectMake(114, 97, SCREENWIDTH-114, 12)];
    sheContent.textAlignment=NSTextAlignmentLeft;
    sheContent.font=[UIFont systemFontOfSize:12.0f];
    
    [cell addSubview:sheContent];
    
    UILabel *giveLab=[[UILabel alloc]initWithFrame:CGRectMake(90, 117, 12, 12)];
    giveLab.backgroundColor=[UIColor colorWithRed:86/255.0 green:171/255.0 blue:228/255.0f alpha:1.0];
    giveLab.text=@"赠";
    giveLab.textAlignment=1;
    giveLab.textColor=[UIColor whiteColor];
    giveLab.font=[UIFont systemFontOfSize:12.0f];
    [cell addSubview:giveLab];
    
    UILabel *giveContent=[[UILabel alloc]initWithFrame:CGRectMake(114, 117, SCREENWIDTH-114, 12)];
    giveContent.textAlignment=NSTextAlignmentLeft;
    giveContent.font=[UIFont systemFontOfSize:12.0f];
    
    [cell addSubview:giveContent];
    
    UILabel *brandLabel=[[UILabel alloc]initWithFrame:CGRectMake(52, 10, 24, 12)];
    brandLabel.textAlignment=1;
    brandLabel.text=@"品牌";
    brandLabel.font=[UIFont systemFontOfSize:11.0f];
    [cell addSubview:brandLabel];
    brandLabel.backgroundColor=[UIColor colorWithRed:255/255.0 green:210/255.0 blue:0 alpha:1];
    
    DLStarRatingControl* dlCtrl = [[DLStarRatingControl alloc]initWithFrame:CGRectMake(-40, 0, 160, 35) andStars:5 isFractional:YES star:[UIImage imageNamed:@"result_small_star_disable_iphone"] highlightStar:[UIImage imageNamed:@"redstar"]];
    dlCtrl.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    dlCtrl.userInteractionEnabled = NO;
    dlCtrl.rating =0.0;
    
    UILabel *starLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 38, 95, 15)];
    starLabel.backgroundColor = [UIColor clearColor];
    starLabel.textAlignment = NSTextAlignmentLeft;
    starLabel.font = [UIFont systemFontOfSize:15];
    
    [starLabel addSubview:dlCtrl];
    [cell addSubview:starLabel];
    
    if (self.searchController.active){
        if (self.searchList.count>0) {
            
            nameLabel.text = @"";
            distanceLabel.text = @"";
            //店铺名
            nameLabel.text=[[self.searchList objectAtIndex:indexPath.row] objectForKey:@"store"];
            //销量
            sellerLabel.text=[NSString stringWithFormat:@"已售%@笔",[[self.searchList objectAtIndex:indexPath.row] objectForKey:@"sold"]];
            //距离
            CLLocationCoordinate2D c1 = CLLocationCoordinate2DMake([[[self.searchList objectAtIndex:indexPath.row] objectForKey:@"latitude"] doubleValue], [[[self.searchList objectAtIndex:indexPath.row] objectForKey:@"longtitude"] doubleValue]);
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            
            
            BMKMapPoint a=BMKMapPointForCoordinate(c1);
            BMKMapPoint b=BMKMapPointForCoordinate(appdelegate.userLocation.location.coordinate);
            CLLocationDistance distance = BMKMetersBetweenMapPoints(a,b);
            
            int meter = (int)distance;
            if (meter>1000) {
                distanceLabel.text = [[NSString alloc]initWithFormat:@"%.1fkm",meter/1000.0];
            }else
                distanceLabel.text = [[NSString alloc]initWithFormat:@"%dm",meter];
            NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[[self.searchList objectAtIndex:indexPath.row] objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [shopImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
            
        }
        
        //评星
        
        NSString *starsss = [NSString getTheNoNullStr:[[self.searchList objectAtIndex:indexPath.row] objectForKey:@"stars"] andRepalceStr:@"0"];
        dlCtrl.rating=[starsss floatValue];
        
        //sheContent
        NSString *sheString=[NSString getTheNoNullStr:[[self.searchList objectAtIndex:indexPath.row] objectForKey:@"add"] andRepalceStr:@"商家暂无折扣"];
        sheContent.text=sheString;
        
        NSString *giveContentStr=[NSString getTheNoNullStr:[[self.searchList objectAtIndex:indexPath.row] objectForKey:@"discount"] andRepalceStr:@"商家暂无赠送活动"];
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 139, SCREENWIDTH, 1)];
        giveContent.text=giveContentStr;
        
        lineView.backgroundColor=[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f];
        [cell addSubview:lineView];
        
    }else{
        [cell.textLabel setText:self.dataList[indexPath.row]];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    if ([self.delegate respondsToSelector:@selector(beginSearch:)]) {
        [self.delegate beginSearch:searchBar];
    }
    NSLog(@"searchBarShouldBeginEditing%@",self.searchList);
    return YES;
}
- (void)beginSearch:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)endSearch:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    [self.delegate endSearch:searchBar];
//}
/**
 *  搜索结束回调用于更新UI
 *
 *  @param searchBar
 *
 *  @return
 */
-(void)postRequestSearch
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/search",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[self.searchController.searchBar text] forKey:@"store"];
    [params setObject:[NSString stringWithFormat:@"%d",_indexss] forKey:@"index"];
    
    DebugLog(@"url ===%@\n paramers ==%@",url,params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"%@",result);
         if (_indexss==1) {
             
             self.searchList=[NSMutableArray arrayWithArray:result];
             
         }else{
             for (int i=0; i<[result count]; i++) {
                 [self.searchList addObject:result[i]];
             }
         }
         [_refreshheader endRefreshing];
         [_refreshFooter endRefreshing];
         
         NSLog(@"postRequestSearch===%@",self.searchList);
         [self.tableView reloadData];
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSMutableDictionary *shopInfoDic = [self.searchList objectAtIndex:indexPath.row];
    
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
//         NSLog(@"%@",result);
//         if (result.count>0) {
//             __block SearchTableViewController* tempSelf = self;
//             if ([result[0][@"state"] isEqualToString:@"true"]) {
//                 vc.videoID=result[0][@"video"];
//                 
//             }else{
//                 vc.videoID=@"";
//                 
//             }
//             [tempSelf.navigationController pushViewController:vc animated:YES];
//         }else{
//             __block SearchTableViewController* tempSelf = self;
//             vc.videoID=@"";
//             [tempSelf.navigationController pushViewController:vc animated:YES];
//         }
//         
//
//     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"%@", error);
//         __block SearchTableViewController* tempSelf = self;
//         vc.videoID=@"";
//         [tempSelf.navigationController pushViewController:vc animated:YES];
//     }];

    
}


-(NewShopDetailVC *)startSellerView:(NSMutableDictionary*)dic{
    
    NewShopDetailVC *controller = [[NewShopDetailVC alloc]init];
    
    controller.infoDic = dic;
    
    controller.title = @"商铺信息";
    NSLog(@"navigationController%@",self.navigationController);
    
    return controller;
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarShouldEndEditing");
    _indexss=1;
    [self.delegate endSearch:searchBar];
    [self postRequestSearch];
    
    return YES;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    
    //    if (self.searchList!= nil&&self.searchList.count>0) {
    //        [self.searchList removeAllObjects];
    //    }
    //过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    //刷新表格
    NSLog(@"updateSearchResultsForSearchController%@",self.searchList);
    [self.tableView reloadData];
    
}
//在viewWillDisappear中要将UISearchController移除, 否则切换到下一个View中, 搜索框仍然会有短暂的存在
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}



@end
