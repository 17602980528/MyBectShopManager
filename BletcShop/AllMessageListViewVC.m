//
//  AllMessageListViewVC.m
//  BletcShop
//
//  Created by Bletc on 2017/4/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AllMessageListViewVC.h"
#import "AllSenderMessageViewControlleVC.h"
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"群发助手";

    NSString *from = [[EMClient sharedClient] currentUsername];
    NSLog(@"====%@",from);
    
    EMConversation*conver=[[EMClient sharedClient].chatManager getConversation:@"m_d7c116a9cc" type:EMConversationTypeGroupChat createIfNotExist:YES];
    
   
    
    [conver loadMessagesStartFromId:nil count:20 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        
        self.data_A = [aMessages copy];
        [self.tableVIew reloadData];
        
        NSLog(@"-----%@",self.data_A);

        
        
    }];

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
    
    }
    
    if (self.data_A.count!=0) {
        
        
        
        EMMessage *msg =self.data_A[indexPath.row];
        
        cell.message = msg;
    }

    return cell;
}

@end
