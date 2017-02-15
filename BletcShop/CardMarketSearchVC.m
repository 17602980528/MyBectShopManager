//
//  CardMarketSearchVC.m
//  BletcShop
//
//  Created by Bletc on 2017/1/17.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CardMarketSearchVC.h"
#import "CardMarketCell.h"
#import "CardMarketModel.h"
#import "CardmarketDetailVC.h"

@interface CardMarketSearchVC ()<UISearchControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating>
@property(nonatomic,strong)NSMutableArray *searchList;
@property (strong,nonatomic) NSMutableArray  *dataList;

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation CardMarketSearchVC

-(NSMutableArray *)searchList{
    if (!_searchList) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
    
}
-(NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
    
}

-(UISearchController *)searchController{
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.searchBar.delegate =self;
        _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);

    }
    return _searchController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.searchController.searchBar;

    
    
}



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.searchController.active) {
        return [self.searchList count];
    }else{
        return [self.dataList count];

    }


}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellH = 200;
    
    if (self.searchList.count!=0) {
        CardMarketModel *m = self.searchList[indexPath.row];
        cellH = m.cellHight;
    }
    return cellH;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CardMarketCell *cell = [CardMarketCell creatCellWithTableView:tableView];
    if (self.searchList.count !=0) {
        cell.model = self.searchList[indexPath.row];
    }
    NSLog(@"self.searchList.count---_%ld",self.searchList.count);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CardmarketDetailVC *VC = [[CardmarketDetailVC alloc]init];
    
    VC.model = self.searchList[indexPath.row];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    

}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    [self postRequestSearch];


    return YES;
}


-(void)postRequestSearch{
    
    NSString *url = [NSString stringWithFormat:@"%@UserType/CardMarket/get",BASEURL];

    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    NSString *searchString = [self.searchController.searchBar text];

    [paramer setObject:searchString forKey:@"store"];
    
    NSLog(@"CardMarket===%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"CardMarket===%@",result);
        
        NSArray *arr = (NSArray *)result;
        
        
    
        [self.searchList removeAllObjects];

        for (int i = 0; i <arr.count; i ++) {
            
            CardMarketModel *M = [[CardMarketModel alloc]intiWithDictionary:arr[i]];
            [self.searchList addObject:M];
        }
        
        
        [self.tableView reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
//    NSString *searchString = [self.searchController.searchBar text];
//    
//    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
//    
////        if (self.searchList!= nil&&self.searchList.count>0) {
////            [self.searchList removeAllObjects];
////        }
//    //过滤数据
//    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
////    刷新表格
//    NSLog(@"updateSearchResultsForSearchController%@",self.searchList);
//    [self.tableView reloadData];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}

@end
