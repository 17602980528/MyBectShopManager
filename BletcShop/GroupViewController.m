//
//  GroupViewController.m
//  BletcShop
//
//  Created by Bletc on 16/8/31.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "GroupViewController.h"
#import "LZDSearchBar.h"
#import "ContactCell.h"
#import "CreatGroupVC.h"
#import "LZDChartViewController.h"
#import "PublicGroupViewController.h"
@interface GroupViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,EMGroupManagerDelegate>
{
    SDRefreshHeaderView     *_refesh;

}
@property (nonatomic , strong) LZDSearchBar *searchBar;// 搜索框
@property (nonatomic, weak) UITableView *myTableView;

@property (strong, nonatomic) NSMutableArray *dataSource;


@end

@implementation GroupViewController
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
    self.title = @"群组";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
//    [self.view addSubview:self.searchBar];
    
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    
    [self reloadDataSource];

    // 创建tableview
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0 , kWeChatScreenWidth, kWeChatScreenHeight-64-44) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor=[UIColor clearColor];
    [self.view addSubview:tableView];
    tableView.rowHeight=60;
    
    self.myTableView = tableView;
    _refesh = [SDRefreshHeaderView refreshView];
    __block GroupViewController *blockSelf = self;
    [_refesh addToScrollView:blockSelf.myTableView];
    
    _refesh.beginRefreshingOperation=^{
        [blockSelf reloadDataSource];
        
        
    };
    _refesh.isEffectedByNavigationController=NO;

    

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 30;
    }
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = RGB(244, 244, 244);
    
    if (section==1) {
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH, 30)];
        lable.text = @"我的群";
        lable.textColor = [UIColor blackColor];
        [view addSubview:lable];
    }
    
    return view;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else
    return [self.dataSource count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifire = @"identifier";
    
    
    ContactCell *cell =[tableView dequeueReusableCellWithIdentifier:identifire];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ContactCell" owner:self options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row==0) {
                cell.headerImg.image= [UIImage imageNamed:@"group_creategroup@2x"];
                cell.labLe_cell.text = @"新建群聊";

            }
//            else if (indexPath.row ==1){
//                cell.headerImg.image= [UIImage imageNamed:@"group_joinpublicgroup"];
//                cell.labLe_cell.text = @"添加公开群";
//
//            }
//            
//            
                       break;
        case 1:
        {
            
            if (self.dataSource.count>0) {
                EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
                NSString *imageName = @"group";
                //        NSString *imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                cell.headerImg.image = [UIImage imageNamed:imageName];
                if (group.subject && group.subject.length > 0) {
                    cell.labLe_cell.text = group.subject;
                }
                else {
                    cell.labLe_cell.text = group.groupId;
                }

            }
        }
            
            break;

            
        default:
            break;
    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            CreatGroupVC *VC= [[CreatGroupVC alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
        }
//        else{
//            
//            
//            PublicGroupViewController *VC= [[PublicGroupViewController alloc]init];
//            [self.navigationController pushViewController:VC animated:YES];
//
//        }
       
    }else{
        
        EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];

        NSString *url = [NSString stringWithFormat:@"%@Extra/IM/get",BASEURL];
        
        
        NSMutableDictionary *dic =[NSMutableDictionary dictionary];
        [dic setObject:[[EMClient sharedClient] currentUsername]  forKey:@"account"];
        
        NSLog(@"dic----%@",dic);
        [KKRequestDataService requestWithURL:url params:dic httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            
            if ([result count]==0) {
                
                [self showHint:@"暂未获取到您的信息"];
            }else{
                LZDChartViewController *chatCtr = [[LZDChartViewController alloc]init];
                [chatCtr setHidesBottomBarWhenPushed:YES];
                //            chatCtr.username = self.arrFriends[indexPath.row];
                
                if (group.subject && group.subject.length > 0) {
                    chatCtr.title = group.subject;
                }
                else {
                    chatCtr.title = group.groupId;
                }
                chatCtr.username =group.groupId;
                chatCtr.userInfo = (NSArray *)result;
                chatCtr.chatType = EMChatTypeGroupChat;
                
                if (chatCtr.userInfo.count!=0) {
                    [self.navigationController pushViewController:chatCtr animated:YES];
                    
                }
 
            }
            
            
            
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        

    }
}


- (void)dealloc
{
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}

- (void)didUpdateGroupList:(NSArray *)groupList
{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:groupList];
    [self.myTableView reloadData];
}
#pragma mark - data

- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    
    NSArray *rooms = [[EMClient sharedClient].groupManager getJoinedGroups];
    [self.dataSource addObjectsFromArray:rooms];
    
    [_refesh endRefreshing];
    [self.myTableView reloadData];
}


@end
