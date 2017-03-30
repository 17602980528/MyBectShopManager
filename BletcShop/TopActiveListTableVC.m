//
//  TopActiveListTableVC.m
//  BletcShop
//
//  Created by Bletc on 2017/3/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "TopActiveListTableVC.h"
#import "UIImageView+WebCache.h"
#import "TopActiveCell.h"

#import "SellerViewController.h"
@interface TopActiveListTableVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *data_A;

@end

@implementation TopActiveListTableVC

-(NSArray *)data_A{
    if (!_data_A) {
        _data_A = [NSArray array];
    }
    return _data_A;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB( 234, 234, 234);
//    self.navigationItem.title = @"顶部轮播广告";
    self.tableView.estimatedRowHeight = 130;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    [self getDate];
}

-(void)getDate{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/advertTop/getList",BASEURL];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.activityId forKey:@"advert_id"];
    
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"=====%@",result);
         
    
         self.data_A= (NSArray*)result;
         
         [self.tableView reloadData];
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@", error);
     }];
    
    
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.data_A.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TopActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topActiveId"];
    

    

    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TopActiveCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_data_A.count !=0) {
        NSDictionary *dic = _data_A[indexPath.row];
        cell.headname.text = dic[@"title"];
        cell.headContent.text = dic[@"info"];

        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LUNBO_IMAGE,dic[@"image_url"]]] placeholderImage:[UIImage imageNamed:@"5-01"]];
        
    }
    return cell;
}


#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 进入下层入口
    NSMutableDictionary *dic = [self.data_A objectAtIndex:indexPath.row];
    
    SellerViewController *vc= [self startSellerView:dic];
    vc.videoID=@"";
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/videoGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //获取商家手机号
    
    [params setObject:dic[@"muid"] forKey:@"merchant"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray* result)
     {
         NSLog(@"%@",result);
         if (result.count>0) {
             __block TopActiveListTableVC* tempSelf = self;
             vc.videoID=result[0][@"video"];
             [tempSelf.navigationController pushViewController:vc animated:YES];
         }else{
             __block TopActiveListTableVC* tempSelf = self;
             vc.videoID=@"";
             [tempSelf.navigationController pushViewController:vc animated:YES];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         __block TopActiveListTableVC* tempSelf = self;
         vc.videoID=@"";
         [tempSelf.navigationController pushViewController:vc animated:YES];
     }];
    
    [self postRemainClickCount:self.data_A[indexPath.row]];
    
}



-(SellerViewController *)startSellerView:(NSMutableDictionary*)dic{
    
    SellerViewController *controller = [[SellerViewController alloc]init];
    
    controller.infoDic = dic;
    
    controller.title = @"商铺信息";
    
    return controller;
    
}

//点击广告处理
-(void)postRemainClickCount:(NSDictionary *)dic{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/advert/click",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //获取商家手机号
    [params setObject:dic[@"muid"] forKey:@"muid"];
    [params setObject:@"top" forKey:@"advert_type"];
    [params setObject:[getUUID getUUID] forKey:@"local_id"];
    [params setObject:dic[@"id"] forKey:@"advert_id"];
    [params setObject:dic[@"position"] forKey:@"advert_position"];
    NSLog(@"%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result==%@",result);
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         
     }];
    
}

@end
