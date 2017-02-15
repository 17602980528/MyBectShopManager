//
//  LZDContactViewController.m
//  BletcShop
//
//  Created by Bletc on 16/8/29.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LZDContactViewController.h"
#import "LZDChartViewController.h"
#import "ApplyAndNoticeVC.h"
#import "GroupViewController.h"
#import "AddFriendTableViewController.h"
#import "EMSearchDisplayController.h"
#import "Database.h"

#import "Person.h"
#import "LZDSearchBar.h"
#import "ContactCell.h"

#import "UIImageView+WebCache.h"
@interface LZDContactViewController ()<EMContactManagerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>{
    SDRefreshHeaderView     *_refesh;
    UILabel*rednumbel;
    

}
@property(nonatomic,strong)FMDatabase *db;
@property(nonatomic,copy)NSString *path;

@property (strong, nonatomic) EMSearchDisplayController *searchController;

@property (nonatomic, weak) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *arrFriends; //好友列表
@property (nonatomic , strong) LZDSearchBar *searchBar;// 搜索框

@property(nonatomic,strong) NSMutableArray*data_A;
@property (nonatomic, strong) NSArray *arrSystem;// 系统列表

@property(nonatomic,strong)NSMutableDictionary *file_dic;//获取的好友申请列表

@end

@implementation LZDContactViewController
-(NSMutableArray *)arrFriends{
    if (!_arrFriends) {
        _arrFriends = [NSMutableArray array];
    }
    return _arrFriends;
}
-(NSMutableArray*)data_A{
    if (!_data_A) {
        _data_A = [NSMutableArray array];
    }
    return _data_A;
}

-(NSMutableDictionary*)file_dic{
    if (!_file_dic) {
        _file_dic = [NSMutableDictionary dictionary];
    }
    return _file_dic;
}


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

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak __typeof(self)weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            NSString *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"chatListCellHead.png"];
            cell.textLabel.text = buddy;
            cell.username = buddy;
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSString *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            NSString *loginUsername = [[EMClient sharedClient] currentUsername];
            if (loginUsername && loginUsername.length > 0) {
                if ([loginUsername isEqualToString:buddy]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                    [alertView show];
                    
                    return;
                }
            }
            
            [weakSelf.searchController.searchBar endEditing:YES];
            

//            ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:buddy
//                                                                                 conversationType:EMConversationTypeChat];
//                                                   chatVC.title = [[UserProfileManager sharedInstance] getNickNameWithUsername:buddy];
//                                                   [weakSelf.navigationController pushViewController:chatVC animated:YES];
                                                   }];
        }
         
         return _searchController;
 }

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
//    [self.view addSubview:self.searchBar];


  ;

    
    [self getListForFriends];

    
    
    // 创建tableview
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0 , kWeChatScreenWidth, kWeChatScreenHeight-64-44) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor=[UIColor clearColor];
    [self.view addSubview:tableView];
    tableView.rowHeight=60;

    self.myTableView = tableView;
    
    
        _arrSystem = @[@"申请与通知",@"群组"];
    
//    _refesh = [SDRefreshHeaderView refreshView];
//    __block LZDContactViewController *blockSelf = self;
//    [_refesh addToScrollView:blockSelf.myTableView];
//    
//    _refesh.beginRefreshingOperation=^{
//        [blockSelf getListForFriends];
//        
//        
//    };
//    _refesh.isEffectedByNavigationController=NO;
//    

    
}


-(void)getListForFriends{
    
    //获取 好友申请列表

    NSDictionary *dic =[[NSUserDefaults standardUserDefaults]objectForKey:@"FriendRequest"];
    self.file_dic =[NSMutableDictionary dictionaryWithDictionary:dic];


    NSLog(@"好友请求===%@===%ld",self.file_dic, self.file_dic.count);



    // 从服务器获取好友列表
   
    [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
        if (!aError) {
            NSLog(@"获取成功 -- %@",aList);
            //                [_refesh endRefreshing];
            
            self.arrFriends = [NSMutableArray arrayWithArray:aList];
            [self.myTableView reloadData];
            
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                for (int i =0;  i < self.arrFriends.count; i ++) {
                    [self saveInfo:self.arrFriends[i]];
                }
                
            });
            
            
        }else{
            NSLog(@"获取失败%@",aError.errorDescription);

        }
        
    }];
    
       
}
//保存用户信息到本地
-(void)saveInfo:(NSString*)auserName{
    NSString *url = [NSString stringWithFormat:@"%@Extra/IM/get",BASEURL];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
    [paramer setObject:auserName forKey:@"account"];
    NSLog(@"-saveInfo--%@",paramer);
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSArray *arr = (NSArray *)result;
        if (arr.count!=0) {
            Person *p = [Person modalWith:arr[0][@"nickname"] imgStr:arr[0][@"headimage"]  idstring:arr[0][@"account"]];
            
            [Database savePerdon:p];
        }
        
      
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return _arrSystem.count;
    }else
        return _arrFriends.count;
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
        lable.text = @"我的好友";
        lable.textColor = [UIColor blackColor];
        [view addSubview:lable];
    }
    
    return view;
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
        {
            if (indexPath.row==0) {
                [rednumbel removeFromSuperview];

                
//                NSDictionary *dic =[[NSUserDefaults standardUserDefaults]objectForKey:@"FriendRequest"];
//                self.file_dic =[NSMutableDictionary dictionaryWithDictionary:dic];

                NSLog(@"cell===好友请求===%@===%ld",self.file_dic, self.file_dic.count);

                cell.headerImg.image = [UIImage imageNamed:@"newFriends"];
                
                rednumbel=[[UILabel alloc]initWithFrame:CGRectMake(kWeChatScreenWidth-15, 0, 15, 15)];
                rednumbel.backgroundColor=[UIColor redColor];
                rednumbel.text=[NSString stringWithFormat:@"%lu",(unsigned long)self.file_dic.count];
                rednumbel.textColor= [UIColor whiteColor];

                if ([rednumbel.text intValue]==0) {
                    rednumbel.hidden=YES;
                }
                rednumbel.font=[UIFont systemFontOfSize:13];
                rednumbel.layer.cornerRadius=7.5;
                rednumbel.clipsToBounds=YES;
                rednumbel.textAlignment=NSTextAlignmentCenter;
                [cell.contentView addSubview:rednumbel];
                
                CGFloat width_red = [rednumbel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:rednumbel.font} context:nil].size.width+7+2;
                rednumbel.frame = CGRectMake(kWeChatScreenWidth-width_red-10, 49/2, width_red, 15);
                
            }else if (indexPath.row==1){
                cell.headerImg.image = [UIImage imageNamed:@"group"];

            }
            NSString *key =[_arrSystem objectAtIndex:indexPath.row];
            cell.labLe_cell.text = key;

            
            
            break;
        }
            
        case 1:
        {

            Person *p= [[Database searchPersonFromID:[_arrFriends objectAtIndex:indexPath.row]] firstObject];
            
            cell.labLe_cell.text =p.name;
            
            NSString *header_S = [[p.idstring componentsSeparatedByString:@"_"] firstObject];
            
            NSLog(@"p.imgStr--%@",p.imgStr);
            
            if ([header_S isEqualToString:@"u"]) {
                [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,p.imgStr]] placeholderImage:[UIImage imageNamed:@"user"]];

            }else{
                [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,p.imgStr]] placeholderImage:[UIImage imageNamed:@"user"]];

            }
            if (!p) {
                cell.labLe_cell.text =[_arrFriends objectAtIndex:indexPath.row];
                
            }

            break;
        }
            
        default:
            break;
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section!=0 && editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *username = _arrFriends[indexPath.row];
        // 删除好友
        [[EMClient sharedClient].contactManager asyncDeleteContact:username success:^{
            NSLog(@"删除成功");
            [[TKAlertCenter defaultCenter]postAlertWithMessage:@"删除好友成功"];
            [self getListForFriends];
            
        } failure:^(EMError *aError) {
            NSLog(@"删除失败");
            
        }];
        
        
        
    }else{
        
    }
    
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        return NO;
    }
    return YES;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section !=0) {
        
        
//        NSString *url = [NSString stringWithFormat:@"%@Extra/IM/get",BASEURL];
//        
//        
//            NSMutableDictionary *dic =[NSMutableDictionary dictionary];
//            [dic setObject:[[EMClient sharedClient] currentUsername]  forKey:@"account"];
//        NSLog(@"dic--%@",dic);
//            [KKRequestDataService requestWithURL:url params:dic httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
//                NSLog(@"result--%@-",result);
//                
//                if ([result count]==0) {
//                    [self showHint:@"暂未获取到您的信息"];
//
//                }else{
                    LZDChartViewController *chatCtr = [[LZDChartViewController alloc]init];
                    [chatCtr setHidesBottomBarWhenPushed:YES];
                    chatCtr.username = self.arrFriends[indexPath.row];
                    
                    NSLog(@"chatCtr.username---%@",chatCtr.username);
                    Person *p = [[Database searchPersonFromID:chatCtr.username] firstObject];
                    if (!p) {
//                        chatCtr.title = @"聊天";
                        
                        chatCtr.title =   [_arrFriends objectAtIndex:indexPath.row];
                        
                    }else{
                        chatCtr.title = p.name;
                        
                    }
//                    chatCtr.userInfo = (NSArray *)result;
                    chatCtr.chatType = EMChatTypeChat;
                    
//                    if (chatCtr.userInfo.count!=0) {
                        [self.navigationController pushViewController:chatCtr animated:YES];
                        
//                    }
 
//                }
        
               
                
//            } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//                
//            }];
//            
    

        
        
    }else{
        if (indexPath.row ==0) {
            
            ApplyAndNoticeVC *VC = [[ApplyAndNoticeVC alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
            
        }else if (indexPath.row==1){
            
            GroupViewController *VC = [[GroupViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];

            
        }
    }
}


//刷新数据

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getListForFriends];

    
    
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    __weak typeof(self) weakSelf = self;
//    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.contactsSource searchText:(NSString *)searchText collationStringSelector:@selector(showName) resultBlock:^(NSArray *results) {
//        if (results) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.searchController.resultsSource removeAllObjects];
//                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
//                [weakSelf.searchController.searchResultsTableView reloadData];
//            });
//        }
//    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
//    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

@end
