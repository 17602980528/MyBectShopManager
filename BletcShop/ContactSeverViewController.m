//
//  ContactSeverViewController.m
//  BletcShop
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ContactSeverViewController.h"

@interface ContactSeverViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@end

@implementation ContactSeverViewController
{
    NSArray *_imageNameArr;
    NSArray *_nameArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"联系客服";
    _imageNameArr=@[@"more_icon_tel_n",@"more_icon_wechatl_n",@"more_icon_sina_n",@"more_icon_public_n"];
    _nameArr=@[@"拨打电话",@"微信",@"微博",@"公众号"];
    UITableView *_tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        imageView.tag=100;
        [cell addSubview:imageView];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, SCREENWIDTH-60, 40)];
        label.tag=200;
        [cell addSubview:label];
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(10, 59.5, SCREENWIDTH-20, 0.5)];
        lineView.backgroundColor=[UIColor lightGrayColor];
        [cell addSubview:lineView];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    UIImageView *imgView=[cell viewWithTag:100];
    UILabel *lab=[cell viewWithTag:200];
    imgView.image=[UIImage imageNamed:_imageNameArr[indexPath.row]];
    lab.text=_nameArr[indexPath.row];
    if (indexPath.row==0) {
        cell.detailTextLabel.text = @"400-876-5213";
    }

    if (indexPath.row==1) {
        cell.detailTextLabel.text = @"cnconsum-service";
    }
    
    if (indexPath.row ==2) {
        cell.detailTextLabel.text = @"ggxc@cnconsum.com";
    }

    if (indexPath.row ==3) {
         cell.detailTextLabel.text = @"商消乐消费安全平台";
    }

    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否拨打客服电话" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView  show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex==1) {
        NSMutableString* telStr = [[NSMutableString alloc]initWithString:@"tel://4008765213"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
    }
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
