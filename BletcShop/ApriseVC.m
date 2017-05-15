//
//  ApriseVC.m
//  BletcShop
//
//  Created by apple on 2017/5/12.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ApriseVC.h"
#import "TableViewCell.h"
#import "UIImageView+WebCache.h"
@interface ApriseVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *table_View;
    SDRefreshFooterView *_refreshFooter;
    SDRefreshHeaderView *_refreshheader;
}
@property(nonatomic,strong)NSMutableArray *dataAray;
@property(nonatomic)NSInteger page;
@end

@implementation ApriseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.muid);
    self.navigationItem.title=@"用户评价";
    _page=1;
    _dataAray = [[NSMutableArray alloc]initWithCapacity:0];
//    NSDictionary *dic1=@{@"head":@"头像-19",@"nick":@"阿娇鲍鱼",@"content":@"今天天气不错是风和日丽的，我们一起出去玩吧！",@"time":@"2017-5-12"};
//    NSDictionary *dic2=@{@"head":@"头像-20",@"nick":@"天线宝宝",@"content":@"西安堇年的房价均价提高了一倍，可怜的刚需们，买不起房了，希望国家能从根本上解决问题，别坑了一代又一代的年轻人",@"time":@"2017-5-11"};
//    NSDictionary *dic3=@{@"head":@"头像-21",@"nick":@"火炉兄弟",@"content":@"日本老龄化问题已经很突出了",@"time":@"2017-5-11"};
//    NSDictionary *dic4=@{@"head":@"头像-22",@"nick":@"美女杀手",@"content":@"希望你们可以有个美好的未来",@"time":@"2017-5-10"};
//    NSDictionary *dic5=@{@"head":@"头像-23",@"nick":@"马云",@"content":@"今天想睡个懒觉",@"time":@"2017-5-8"};
//    [_dataAray addObject:dic1];
//    [_dataAray addObject:dic2];
//    [_dataAray addObject:dic3];
//    [_dataAray addObject:dic4];
//    [_dataAray addObject:dic5];
    
    table_View = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    table_View.separatorStyle = UITableViewCellSeparatorStyleNone;
    table_View.estimatedRowHeight=600;
    table_View.rowHeight=UITableViewAutomaticDimension;
    table_View.delegate = self;
    table_View.dataSource = self;
    [self.view addSubview:table_View];
    [self postRequest];
    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:table_View];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block ApriseVC *tempSelf=self;
    _refreshheader.beginRefreshingOperation = ^{
        tempSelf.page=1;
        [tempSelf.dataAray removeAllObjects];
        //请求数据
         [tempSelf postRequest];
    };
    
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:table_View];
    _refreshFooter.beginRefreshingOperation =^{
        tempSelf.page++;
       //数据请求
        NSLog(@"====>>>>%ld",tempSelf.page);
         [tempSelf postRequest];
        
    };

    
    //请求数据,成功后刷新表,考虑到分页效果，此处用到上拉和下拉刷新
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataAray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"aprise"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
    }
    if (_dataAray.count>0) {
         [ cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,_dataAray[indexPath.row][@"headimage"]]] placeholderImage:[UIImage imageNamed:@"3.1-02"]];
        cell.headImageView.layer.cornerRadius=cell.headImageView.width/2;
        cell.headImageView.clipsToBounds=YES;
        cell.headImageView.contentMode=UIViewContentModeScaleAspectFill;
        cell.nickNameLable.text=_dataAray[indexPath.row][@"nickname"];
        cell.apriseLable.text=_dataAray[indexPath.row][@"content"];
        cell.timeLable.text=_dataAray[indexPath.row][@"datetime"];
    }
    return cell;
    
}
-(void)postRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/evaluate/get",BASEURL];
     NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *pages=[NSString stringWithFormat:@"%ld",_page];
    [ params setValue:pages forKey:@"index"];
    [ params setValue:self.muid forKey:@"muid"];
    NSLog(@"%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"%@",result);
         if (result&&[result count]>0) {
             for (int i=0; i<[result count]; i++) {
                 [_dataAray addObject:result[i]];
             }
         }
         [_refreshFooter endRefreshing];
         [_refreshheader endRefreshing];
         [table_View reloadData];
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [_refreshFooter endRefreshing];
         [_refreshheader endRefreshing];
     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
