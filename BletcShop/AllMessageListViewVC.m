//
//  AllMessageListViewVC.m
//  BletcShop
//
//  Created by Bletc on 2017/4/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AllMessageListViewVC.h"
#import "AllSenderMessageViewControlleVC.h"
#import "SendMessageToAllVC.h"
#import "AllmessageListCell.h"
@interface AllMessageListViewVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property(nonatomic,strong)NSArray *data_A;
@end

@implementation AllMessageListViewVC
-(NSArray *)data_A{
    if (!_data_A) {
        _data_A = [NSArray array];
    }
    return _data_A;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *from = [[EMClient sharedClient] currentUsername];
    NSLog(@"====%@",from);
    
    EMConversation*conver=[[EMClient sharedClient].chatManager getConversation:from type:EMConversationTypeGroupChat createIfNotExist:YES];
    
    
    
    [conver loadMessagesStartFromId:nil count:20 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        
        self.data_A = [aMessages copy];
        [self.tableVIew reloadData];
        if (self.data_A.count>0) {
            [self.tableVIew scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.data_A.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        NSLog(@"-----%@",self.data_A);
        
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"群发助手";
    self.view.backgroundColor = RGB(240, 238, 244);

    
}
- (IBAction)creatNew:(id)sender {
    
    
    AllSenderMessageViewControlleVC *VC = [[AllSenderMessageViewControlleVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"AllmessageListCell";
    
    AllmessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AllmessageListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    
    
    cell.message = self.data_A[indexPath.row];
    
    NSLog(@"-----%lf",cell.rowHeight);
    return cell.rowHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.data_A.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"AllmessageListCell";

    AllmessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AllmessageListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = RGB(240, 238, 244);
    
    }
    
    if (self.data_A.count!=0) {
        
        
        
        EMMessage *msg =self.data_A[indexPath.row];
        
        cell.message = msg;
        
//        cell.againSend.block = ^(LZDButton *sender) {
//            
//            
//            SendMessageToAllVC *VC = [[SendMessageToAllVC alloc]init];
//            VC.whoPush = @"再来一发";
//            
//            NSMutableDictionary *mutaDic = [NSMutableDictionary dictionary];
//            NSArray *msg_a = msg.ext[@"persons"];
//            for (NSDictionary *dic in msg_a) {
//                
//                [mutaDic setObject:dic forKey:[NSString stringWithFormat:@"%lu",(unsigned long)[msg_a indexOfObject:dic]]];
//                
//            }
//            VC.dic = mutaDic;
//            
//            [self.navigationController pushViewController:VC animated:YES];
//
//            
//        };
    }

    return cell;
}

@end
