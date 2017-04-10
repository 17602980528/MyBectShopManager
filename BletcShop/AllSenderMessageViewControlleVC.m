//
//  AllSenderMessageViewControlleVC.m
//  BletcShop
//
//  Created by Bletc on 2017/4/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AllSenderMessageViewControlleVC.h"
#import "UIImageView+WebCache.h"
@interface AllSenderMessageViewControlleVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *dataArray;
@end

@implementation AllSenderMessageViewControlleVC

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"群发信息";
    [self postRequest];

}

//数据请求
-(void)postRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/vipGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    
    DebugLog(@"url,----%@-params---%@",url,params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"self.data = %@", result);
        self.dataArray = result;
        
        [self.tableView reloadData];
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error.description);
        
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"allSenderID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if (_dataArray.count!=0) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        
        NSString *imgStr =[dic objectForKey:@"headimage"];
        
        
        
        
        NSURL * nurl1=[[NSURL alloc] initWithString:[[HEADIMAGE stringByAppendingString:imgStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [cell.imageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"mhead_default.png"] options:SDWebImageRetryFailed];
        
        
        
        cell.textLabel.text = dic[@"user"];

    }
       return cell;
}

@end
