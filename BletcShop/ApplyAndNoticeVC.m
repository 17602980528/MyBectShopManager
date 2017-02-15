//
//  ApplyAndNoticeVC.m
//  BletcShop
//
//  Created by Bletc on 16/8/31.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ApplyAndNoticeVC.h"
#import "Message.h"
#import "MessageCell.h"
#import "Database.h"
#import "Person.h"
@interface ApplyAndNoticeVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableDictionary *file_dic;
@property(nonatomic,strong)NSMutableArray *arrModel;

@end

@implementation ApplyAndNoticeVC

-(NSMutableArray *)arrModel{
    if (!_arrModel) {
        _arrModel = [NSMutableArray array];
        
    }
    return _arrModel;
}

-(void)getdata{
    NSDictionary *dic =[[NSUserDefaults standardUserDefaults]objectForKey:@"FriendRequest"];
    self.file_dic =[NSMutableDictionary dictionaryWithDictionary:dic];
    

    [self.arrModel removeAllObjects];
    NSArray *key_all = [self.file_dic allKeys];
    for (int i =0; i <key_all.count; i ++) {
        NSDictionary *dic = self.file_dic[key_all[i]];
        Message *msgModel = [[Message alloc]initWithDic:dic];
        [self.arrModel addObject:msgModel];
        
    }
    [self.table_View reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请与通知";
    //获取 好友申请列表
    [self getdata];
    self.view.backgroundColor =[UIColor whiteColor];
  

    
    // 创建tableview
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0 , SCREENWIDTH, SCREENHEIGHT-64-44) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorColor = [UIColor clearColor];
    tableView.estimatedRowHeight = 240;
    [self.view addSubview:tableView];
    
    self.table_View = tableView;



}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrModel.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageCell *cell = [MessageCell messageCellWithTableView:tableView];
    cell.model = self.arrModel[indexPath.row];
    cell.acceptBtn.tag = cell.jujueBtn.tag = indexPath.row;
    [cell.acceptBtn addTarget:self action:@selector(acceptClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.acceptBtn.backgroundColor = NavBackGroundColor;
    [cell.acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cell.acceptBtn.layer.cornerRadius = 5;
    cell.acceptBtn.clipsToBounds = YES;
    

    
    [cell.jujueBtn addTarget:self action:@selector(jujueClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.jujueBtn.backgroundColor = NavBackGroundColor;
    [cell.jujueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cell.jujueBtn.layer.cornerRadius = 5;
    cell.jujueBtn.clipsToBounds = YES;

    return cell;
    
}
-(void)acceptClick:(UIButton*)sender{
    
    NSLog(@"同意");
    
    NSArray *allKey = [self.file_dic allKeys];
    
    EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:allKey[sender.tag]];
                if (!error) {
                    NSLog(@"发送同意成功");
                    [[TKAlertCenter defaultCenter]postAlertWithMessage:@"添加成功"];
                    [self saveInfo:(NSString*)allKey[sender.tag]];
                    [self resetPlist:allKey[sender.tag]];
    
                }

}

-(void)jujueClick:(UIButton*)sender{
    NSLog(@"拒绝");
    NSArray *allKey = [self.file_dic allKeys];

    
                EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:allKey[sender.tag]];
                if (!error) {
                    NSLog(@"发送拒绝成功");
    
                    [[TKAlertCenter defaultCenter]postAlertWithMessage:@"拒绝成功"];

                    [self resetPlist:allKey[sender.tag]];
                    
                }

}

-(void)resetPlist:(NSString*)key_str{
    
    [self.file_dic removeObjectForKey:key_str];
    [[NSUserDefaults standardUserDefaults]setObject:self.file_dic forKey:@"FriendRequest"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self getdata];
    
}

-(void)saveInfo:(NSString*)auserName{
    NSString *url = [NSString stringWithFormat:@"%@Extra/IM/get",BASEURL];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
    [paramer setObject:auserName forKey:@"account"];
    NSLog(@"-saveInfo--%@",paramer);
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSArray *arr = (NSArray *)result;
        
        if (arr.count>0) {
            Person *p = [Person modalWith:arr[0][@"nickname"] imgStr:arr[0][@"headimage"]  idstring:arr[0][@"account"]];
            
            [Database savePerdon:p];

        }
      } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}



@end
