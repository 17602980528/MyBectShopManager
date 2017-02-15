//
//  MerchantDetailViewController.m
//  BletcShop
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MerchantDetailViewController.h"
#import "UIImageView+WebCache.h"
@interface MerchantDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *data_dic;
    NSArray *headArr;
}
@end

@implementation MerchantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"店铺详情";
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-40, 10, 80, 80)];
    imageView.layer.cornerRadius=40;
    imageView.clipsToBounds=YES;
    data_dic=[[NSDictionary alloc]init];

    data_dic =[self.array objectAtIndex:self.index];

    
    NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[NSString getTheNoNullStr:[data_dic objectForKey:@"image_url"] andRepalceStr:@"asda"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [imageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
    
    [self.view addSubview:imageView];
    headArr=[[NSArray alloc]initWithObjects:@"帐户：",@"店铺名：",@"手机号：",@"地址：",@"密码：",@"店铺余额：",@"营业总额：",@"会员数量：",@" ", nil];
    UITableView *tabView=[[UITableView alloc]initWithFrame:CGRectMake(0, 90, SCREENWIDTH, SCREENHEIGHT-90-49) style:UITableViewStylePlain];
    tabView.dataSource=self;
    tabView.delegate=self;
    tabView.bounces=NO;
    tabView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:tabView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return data_dic.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

    }
    NSString *headStr = headArr[indexPath.row];
    NSString *lastStr;
    if (indexPath.row==0) {
        lastStr= data_dic[@"name"];
    }
    if (indexPath.row==1) {
        lastStr= data_dic[@"store"];
    }
    if (indexPath.row==2) {
        lastStr= data_dic[@"phone"];
    }
    if (indexPath.row==3) {
        lastStr= data_dic[@"address"];
    }
    if (indexPath.row==4) {
        lastStr= data_dic[@"passwd"];
    }
    if (indexPath.row==5) {
        lastStr= data_dic[@"remain"];
    }
    if (indexPath.row==6) {
        lastStr= data_dic[@"sum"];
    }
    if (indexPath.row==7) {
        lastStr= data_dic[@"vip_num"];
    }
    NSString *newStr=[NSString stringWithFormat:@"%@%@",headStr,lastStr];
    cell.textLabel.text=[NSString getTheNoNullStr:newStr andRepalceStr:@""];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
