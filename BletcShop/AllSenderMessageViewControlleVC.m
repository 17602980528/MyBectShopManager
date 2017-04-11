//
//  AllSenderMessageViewControlleVC.m
//  BletcShop
//
//  Created by Bletc on 2017/4/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AllSenderMessageViewControlleVC.h"
#import "UIImageView+WebCache.h"
#import "AllSenderMessageCell.h"
#import "SendMessageToAllVC.h"
@interface AllSenderMessageViewControlleVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(strong,nonatomic)NSMutableDictionary *selectedDic;
@end

@implementation AllSenderMessageViewControlleVC
- (IBAction)nextBtnClick:(id)sender {
    NSArray *array=[self.selectedDic allValues];
    if (array.count>0) {
        SendMessageToAllVC *vc=[[SendMessageToAllVC alloc]init];
        vc.dic=self.selectedDic;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"您还未选好友", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:4.f];
    }
}
-(NSMutableDictionary *)selectedDic{
    if (!_selectedDic) {
        _selectedDic = [NSMutableDictionary dictionary];
    }
    return _selectedDic;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"群发信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(allChoose:)];
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
        self.dataArray = [NSMutableArray arrayWithArray:result];
        
        [self.tableView reloadData];
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error.description);
        
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AllSenderMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myCellss"];
    if (!cell)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"AllSenderMessageCell" owner:self options:nil]lastObject];
    }
    
    if (_dataArray.count!=0) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        
        NSString *imgStr =[dic objectForKey:@"headimage"];
        
        NSURL * nurl1=[[NSURL alloc] initWithString:[[HEADIMAGE stringByAppendingString:imgStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [cell.headImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"mhead_default.png"] options:SDWebImageRetryFailed];
        
        cell.nameLable.text = dic[@"user"];
        
        id selectedState=dic[@"selectedState"];
        if (!selectedState||[selectedState isEqualToString:@"no"]) {
            [cell.stateImageView setImage:[UIImage imageNamed:@"登陆-05"]];
        }else{
            [cell.stateImageView setImage:[UIImage imageNamed:@"登陆-04"]];
        }

    }
       return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=self.dataArray[indexPath.row];
    NSMutableDictionary *mutableDic=[NSMutableDictionary dictionaryWithDictionary:dic];
    id selectedState=mutableDic[@"selectedState"];
    if (!selectedState||[selectedState isEqualToString:@"no"]) {
        [mutableDic setValue:@"yes" forKey:@"selectedState"];
        [self.selectedDic setValue:self.dataArray[indexPath.row] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }else{
        [mutableDic setValue:@"no" forKey:@"selectedState"];
        [self.selectedDic removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    [self.dataArray replaceObjectAtIndex:indexPath.row withObject:mutableDic];
    [tableView reloadData];
    NSLog(@"========>>>%@",self.selectedDic);
}
//
-(void)allChoose:(UIBarButtonItem *)item{
    if ([item.title isEqualToString:@"全选"]) {
        for (int i=0; i<self.dataArray.count; i++) {
            NSMutableDictionary *mutableDic=[NSMutableDictionary dictionaryWithDictionary:self.dataArray[i]];
            [mutableDic setValue:@"yes" forKey:@"selectedState"];
            [self.dataArray replaceObjectAtIndex:i withObject:mutableDic];
            [self.selectedDic setValue:self.dataArray[i] forKey:[NSString stringWithFormat:@"%d",i]];
        }
        [item setTitle:@"取消"];
    }else{
        for (int i=0; i<self.dataArray.count; i++) {
            NSMutableDictionary *mutableDic=[NSMutableDictionary dictionaryWithDictionary:self.dataArray[i]];
            [mutableDic setValue:@"no" forKey:@"selectedState"];
            [self.dataArray replaceObjectAtIndex:i withObject:mutableDic];
        }
        [self.selectedDic removeAllObjects];
         [item setTitle:@"全选"];
    }
   [self.tableView reloadData];
}
@end
