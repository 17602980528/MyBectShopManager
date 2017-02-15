//
//  PublicGroupViewController.m
//  BletcShop
//
//  Created by Bletc on 16/9/2.
//  Copyright © 2016年 bletc. All rights reserved.
//
#define FetchPublicGroupsPageSize   50


#import "PublicGroupViewController.h"
#import "LZDSearchBar.h"
#import "ContactCell.h"
#import "PublicGroupDetailViewController.h"


@interface PublicGroupViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,EMGroupManagerDelegate>
{
    SDRefreshHeaderView *_refesh;
}
@property (nonatomic , strong) LZDSearchBar *searchBar;// 搜索框
@property (nonatomic, weak) UITableView *myTableView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation PublicGroupViewController
- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[LZDSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公有群组";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
//    [self.view addSubview:self.searchBar];


    // 创建tableview
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0 , kWeChatScreenWidth, kWeChatScreenHeight-64-44) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    tableView.rowHeight=60;
    
    self.myTableView = tableView;
    
    _refesh = [SDRefreshHeaderView refreshView];
    __block PublicGroupViewController *blockSelf = self;
    [_refesh addToScrollView:blockSelf.myTableView];
    
    _refesh.beginRefreshingOperation=^{
        [blockSelf getDataSource];
        
        
    };
    _refesh.isEffectedByNavigationController=NO;
    


    [self getDataSource];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return [self.dataSource count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifire = @"identifier";
    
    
    ContactCell *cell =[tableView dequeueReusableCellWithIdentifier:identifire];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ContactCell" owner:self options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
  
    
        EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
        NSString *imageName = @"group";
    
        cell.headerImg.image = [UIImage imageNamed:imageName];
        if (group.subject && group.subject.length > 0) {
            cell.labLe_cell.text = group.subject;
        }
        else {
            cell.labLe_cell.text = group.groupId;
        }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
    PublicGroupDetailViewController *detailController = [[PublicGroupDetailViewController alloc] initWithGroupId:group.groupId];
    
    if (group.subject && group.subject.length > 0) {
        detailController.title = group.subject;
    }
    else {
        detailController.title = group.groupId;
    }
    [self.navigationController pushViewController:detailController animated:YES];
    
}


-(void)getDataSource{

    
    
    [[EMClient sharedClient].groupManager getPublicGroupsFromServerWithCursor:self.cursor pageSize:FetchPublicGroupsPageSize completion:^(EMCursorResult *aResult, EMError *aError) {
        
        [_refesh endRefreshing];
        if (!aError) {
            {
        NSMutableArray *oldGroups = [self.dataSource mutableCopy];
        [self.dataSource removeAllObjects];
         [oldGroups removeAllObjects];
         [self.dataSource addObjectsFromArray:aResult.list];
          [self.myTableView reloadData];
                
          self.cursor = aResult.cursor;
            if ([aResult.cursor length])
          {
//           self.footerView.state = eGettingMoreFooterViewStateIdle;
            }
           else
           {
//             self.footerView.state = eGettingMoreFooterViewStateComplete;
             }
             }
            
        }
        NSLog(@"---%@",aResult);
    }];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
