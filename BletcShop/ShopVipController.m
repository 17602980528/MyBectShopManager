//
//  ShopVipController.m
//  BletcShop
//
//  Created by Yuan on 16/1/28.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShopVipController.h"
#import "ShopVipCell.h"
#import "ShopLandController.h"
#import "AddVipTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MemberDetailViewController.h"

#import "AllMessageListViewVC.h"

@interface ShopVipController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)UIScrollView *listView;
@property(nonatomic,strong)NSArray *data;
@property(nonatomic,weak)UIView *listView1;
@property(nonatomic,weak)UIView *NewView;
@property(nonatomic,weak)UIView *TopView;



@end

@implementation ShopVipController
{
    CGFloat totolHeight;
}

-(NSMutableDictionary *)shopInfo_dic{
    if (!_shopInfo_dic) {
        _shopInfo_dic = [NSMutableDictionary dictionary];
    }
    return _shopInfo_dic;
}

-(void)allSender{
    
    
    AllMessageListViewVC *VC = [[AllMessageListViewVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.navigationItem.title = @"我的会员";
    self.view.backgroundColor=[UIColor whiteColor];
    self.editArray = [[NSMutableArray alloc]init];
    self.editTag = 0;
    self.typeArray= @[@"普卡",@"银卡",@"金卡",@"白金卡",@"钻卡",@"黑金卡"];;

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"群发" style:UIBarButtonItemStylePlain target:self action:@selector(allSender)];
    
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.shopInfo_dic = appdelegate.shopInfoDic;
    self.array = [[NSMutableArray alloc]initWithObjects:@"按姓名查询",@"按年龄查询",@"按分类查询",@"按XX查询", nil];//@[@"按姓名查询",@"按年龄查询",@"按分类查询",@"按XX查询"];
    NSLog(@"shopInfo_dic = %@",self.shopInfo_dic);
    self.chaXun = [[NSString alloc]init];
    self.chaXun = @"";

    
    [self postRequest];
    
}

-(NSArray *)data
{
    if (_data == nil) {
        _data = [NSArray array];
        
    }
    return _data;
}


//数据请求
-(void)postRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/vipGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.shopInfo_dic[@"muid"] forKey:@"muid"];
    
    DebugLog(@"url,----%@-params---%@",url,params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"self.data = %@", result);
        self.data = (NSArray*)result;
        [self initUI3];
        
//        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            for (int i =0;  i < self.data.count; i ++) {
//                NSArray *arr = self.data[i];
//                [self saveInfo:[NSString stringWithFormat:@"u_%@",arr[2]]];
//            }
//            
//        });
        

        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error.description);
        
    }];
    
}

//初始化下部表
-(void)initUI3{
    UITableView *newTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-49) style:UITableViewStyleGrouped];
    newTableView.delegate=self;
    newTableView.dataSource=self;
    newTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    newTableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:newTableView];
    self.tabView=newTableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        for (int i=0; i<self.data.count; i++) {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-240)/5+i%4*(60+(SCREENWIDTH-240)/5), (SCREENWIDTH-240)/5+i/4*(60+(SCREENWIDTH-240)/5+10), 60, 60)];
            imageView.tag=i+10;
            imageView.layer.cornerRadius=8.0f;
            imageView.clipsToBounds=YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            [cell addSubview:imageView];
            unsigned long hangshu = (cell.subviews.count+4-1)/4;
            totolHeight=(60+(SCREENWIDTH-240)/5)*hangshu+(SCREENWIDTH-240)/5;
            cell.backgroundColor=[UIColor clearColor];
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((SCREENWIDTH-240)/5+i%4*(60+(SCREENWIDTH-240)/5), (SCREENWIDTH-240)/5+i/4*(60+(SCREENWIDTH-240)/5+10)+60+8, 60, 12)];
            label.font=[UIFont systemFontOfSize:15.0f];
            label.textAlignment=1;
            label.tag=i+100000;
            [cell addSubview:label];
        }
    }
    for (int i=0; i<self.data.count; i++) {
        UIImageView *imgView=(UIImageView *)[cell viewWithTag:i+10];
        imgView.userInteractionEnabled=YES;
        
        NSString *imgStr =[[self.data objectAtIndex:i] objectForKey:@"headimage"];
        
       
        
        
        NSURL * nurl1=[[NSURL alloc] initWithString:[[HEADIMAGE stringByAppendingString:imgStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"mhead_default.png"] options:SDWebImageRetryFailed];
        UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [imgView addGestureRecognizer:tapRecognizer];
        UILabel *lab=(UILabel *)[cell viewWithTag:i+100000];
        lab.text=[[self.data objectAtIndex:i] objectForKey:@"user"];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //cell.subviews.count
    return totolHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

}
-(void)tapClick:(UITapGestureRecognizer *)gesture{
    UIImageView *imageView=(UIImageView *)[gesture view];

    
    MemberDetailViewController *detailVC=[[MemberDetailViewController alloc]init];
    detailVC.array=self.data;
    detailVC.index=imageView.tag-10;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
