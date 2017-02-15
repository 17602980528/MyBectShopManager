//
//  NoEvaluateController.m
//  BletcShop
//
//  Created by Yuan on 16/1/26.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NoEvaluateController.h"
#import "UIImageView+WebCache.h"
#import "AppraiseViewController.h"
@interface NoEvaluateController ()

@property(nonatomic,weak)UITableView *noEvaluateTable;
@property (nonatomic,retain)NSMutableArray *noEvaluateShopArray;


@end

@implementation NoEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self _inittable];
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [self postRequestEvaluate];
}
-(void)postRequestEvaluate
{
    
   
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/evaluate/listGet",BASEURL];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    
    
    NSLog(@"%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result%@", result);

         NSMutableArray *evaluateArray = [result copy];
         self.noEvaluateShopArray = evaluateArray;;
         [self.noEvaluateTable reloadData];
//         if (evaluateArray.count>0) {
//             self.noEvaluateShopArray = evaluateArray;;
//         }else{
//             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//             
//             // Set the annular determinate mode to show task progress.
//             hud.mode = MBProgressHUDModeText;
//             hud.label.text = NSLocalizedString(@"无未评价订单", @"HUD message title");
//             hud.label.font = [UIFont systemFontOfSize:13];
//             // Move to bottm center.
//             //    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
//             hud.frame = CGRectMake(0, SCREENHEIGHT/2, SCREENWIDTH, 40);
//             [hud hideAnimated:YES afterDelay:1.f];
//         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}
-(void)_inittable
{
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.rowHeight = 104;
    table.bounces = NO;
    self.noEvaluateTable = table;
    
    [self.view addSubview:table];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%@", self.noEvaluateShopArray);
    return self.noEvaluateShopArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    topView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:topView];
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, SCREENWIDTH, 100)];
    centerView.backgroundColor = tableViewBackgroundColor;
    [cell addSubview:centerView];
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, SCREENWIDTH, 40)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:bottomView];
    UIImageView *cardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 5, SCREENWIDTH/3, 80)];
    
    cardImageView.layer.cornerRadius = 10;
    cardImageView.layer.masksToBounds = YES;
    
    [centerView addSubview:cardImageView];
    //店铺名称
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH/3, 30)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:13];
    [topView addSubview:nameLabel];
    //交易成功
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH*2/3, 0, SCREENWIDTH/3-10, 30)];
    stateLabel.text = @"交易成功";
    stateLabel.textColor = [UIColor orangeColor];
    stateLabel.backgroundColor = [UIColor clearColor];
    stateLabel.textAlignment = NSTextAlignmentRight;
    stateLabel.font = [UIFont systemFontOfSize:13];
    [topView addSubview:stateLabel];
    //级别
    UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+SCREENWIDTH/3, 10, 35, 30)];
    levelLabel.backgroundColor = [UIColor clearColor];
    levelLabel.text = @"级别:";
    levelLabel.textAlignment = NSTextAlignmentLeft;
    levelLabel.font = [UIFont systemFontOfSize:13];
    [centerView addSubview:levelLabel];
    UILabel *levelLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(45+SCREENWIDTH/3, 10, 60, 30)];
    levelLabel1.backgroundColor = [UIColor clearColor];
    levelLabel1.textAlignment = NSTextAlignmentLeft;
    levelLabel1.font = [UIFont systemFontOfSize:13];
    [centerView addSubview:levelLabel1];
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-110, 10, 35, 30)];
    typeLabel.text = @"类型:";
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.textAlignment = NSTextAlignmentLeft;
    typeLabel.font = [UIFont systemFontOfSize:13];
    [centerView addSubview:typeLabel];
    UILabel *typeLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-75, 10, 60, 30)];
    typeLabel1.backgroundColor = [UIColor clearColor];
    typeLabel1.textAlignment = NSTextAlignmentLeft;
    typeLabel1.font = [UIFont systemFontOfSize:13];
    [centerView addSubview:typeLabel1];
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/3+10, 50, 35, 30)];
    moneyLabel.text = @"金额:";
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.font = [UIFont systemFontOfSize:13];
    [centerView addSubview:moneyLabel];
    UILabel *moneyLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/3+45, 50, 100, 30)];
    moneyLabel1.textAlignment = NSTextAlignmentLeft;
    moneyLabel1.backgroundColor = [UIColor clearColor];
//    moneyLabel1.textAlignment = NSTextAlignmentRight;
    moneyLabel1.font = [UIFont systemFontOfSize:13];
    [centerView addSubview:moneyLabel1];

    //删除
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //deleteBtn.backgroundColor = [UIColor whiteColor];
    //deleteBtn.layer.cornerRadius = 10;
    deleteBtn.layer.borderWidth = 0.3;
    deleteBtn.frame = CGRectMake(SCREENWIDTH-140, 5, 60, 30);
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    deleteBtn.tag = indexPath.row;
     deleteBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:deleteBtn];
    //评价
    UIButton * evaluateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    evaluateBtn.tag = indexPath.row;
    evaluateBtn.backgroundColor = NavBackGroundColor;
    //evaluateBtn.layer.cornerRadius = 10;
    //evaluateBtn.tag = 101;
    evaluateBtn.frame = CGRectMake(SCREENWIDTH-70, 5, 60, 30);
    [evaluateBtn setTitle:@"评价" forState:UIControlStateNormal];
    evaluateBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    [evaluateBtn addTarget:self action:@selector(evaluateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:evaluateBtn];

    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.5)];
    [cell addSubview:line];
    
    
    NSDictionary *data_dic = self.noEvaluateShopArray[indexPath.row];

    
    nameLabel.text =data_dic[@"store"];
    levelLabel1.text =data_dic[@"card_level"];
    typeLabel1.text =data_dic[@"card_type"];
    moneyLabel1.text = data_dic[@"card_remain"];
//    NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCECARD stringByAppendingString:data_dic[@"card_image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//    [cardImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon2.png"] options:SDWebImageRetryFailed];

    cardImageView.backgroundColor = [UIColor colorWithHexString:data_dic[@"card_temp_color"]];
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 170, SCREENWIDTH, 1)];
    viewLine.backgroundColor = tableViewBackgroundColor;
    viewLine.alpha = 0.3;
    [cell addSubview:viewLine];
    
    
    UIView *bot_view = [[UIView alloc]initWithFrame:CGRectMake(0, 55, cardImageView.width, 25)];
    bot_view.backgroundColor = [UIColor whiteColor];
    [cardImageView addSubview:bot_view];
    
    UILabel *vipLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cardImageView.width, 55)];
    vipLab.text = [NSString stringWithFormat:@"VIP%@",[data_dic objectForKey:@"card_level"]];
    vipLab.textAlignment = NSTextAlignmentCenter;
    vipLab.textColor = [UIColor whiteColor];
    [cardImageView addSubview:vipLab];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:vipLab.text];
    
    [attr setAttributes:@{NSForegroundColorAttributeName:RGB(253,171,65),NSFontAttributeName:[UIFont boldSystemFontOfSize:20]} range:NSMakeRange(0, 3)];
    
    [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(3, vipLab.text.length-3)];
    
    vipLab.attributedText = attr;
    
    
    return cell;
}
//删除
-(void)deleteBtnAction:(UIButton *)btn
{
    
    UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该信息?" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSDictionary *dic = [self.noEvaluateShopArray objectAtIndex:btn.tag];
        
        NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/evaluate/delete",BASEURL];
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
        [params setObject:dic[@"merchant"] forKey:@"muid"];
        [params setObject:dic[@"card_code"] forKey:@"cardCode"];
        [params setObject:dic[@"card_level"] forKey:@"cardLevel"];
        
        NSLog(@"params==%@===url==%@",params,url);
        
        
        
        [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
         {
             
             NSLog(@"%@", result);
             
             if ([result[@"result_code"] intValue]==1) {
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 //            hud.frame = CGRectMake(0, 64, 375, 667);
                 // Set the annular determinate mode to show task progress.
                 hud.mode = MBProgressHUDModeText;
                 
                 hud.label.text = NSLocalizedString(@"删除成功", @"HUD message title");
                 hud.label.font = [UIFont systemFontOfSize:13];
                 // Move to bottm center.
                 //    hud.offset = CGPointMake(0.f, );
                 hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                 [hud hideAnimated:YES afterDelay:1.f];
                 [self postRequestEvaluate];
                 
             }else{
                 
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 //            hud.frame = CGRectMake(0, 64, 375, 667);
                 // Set the annular determinate mode to show task progress.
                 hud.mode = MBProgressHUDModeText;
                 
                 hud.label.text = NSLocalizedString(@"删除失败,请重试", @"HUD message title");
                 hud.label.font = [UIFont systemFontOfSize:13];
                 // Move to bottm center.
                 //    hud.offset = CGPointMake(0.f, );
                 hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                 [hud hideAnimated:YES afterDelay:3.f];                  }
         } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
             //         [self noIntenet];
             NSLog(@"%@", error);
         }];

        
    }];
    
    [alterVC addAction:cancle];
    [alterVC addAction:sureAction];
    
    [self presentViewController:alterVC animated:YES completion:nil];
    
   }
//评价
-(void)evaluateBtnAction:(UIButton *)btn
{
    AppraiseViewController *appraiseView = [[AppraiseViewController alloc]init];
    appraiseView.evaluate_dic = [self.noEvaluateShopArray objectAtIndex:btn.tag];
    

    [self.navigationController pushViewController:appraiseView animated:YES];
    
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
