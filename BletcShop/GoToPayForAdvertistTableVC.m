//
//  GoToPayForAdvertistTableVC.m
//  BletcShop
//
//  Created by Bletc on 2017/2/21.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "GoToPayForAdvertistTableVC.h"
#import "SingleModel.h"
#import "AdverListViewController.h"
@interface GoToPayForAdvertistTableVC ()<UITableViewDelegate,UITableViewDataSource>

{
    NSArray *dataSourse_A;
    NSArray *data_A;
    SingleModel *model;
}

@property(nonatomic,strong)NSArray *section1_A;
@property(nonatomic,strong)NSArray *section2_A;


@end

@implementation GoToPayForAdvertistTableVC

-(NSArray *)section1_A{
    if (!_section1_A) {
        _section1_A = @[@"商家名称",@"广告类型",@"广告地区",@"活动类型",@"广告位置"];
    }
    return _section1_A;
}
-(NSArray *)section2_A{
    if (!_section2_A) {
        _section2_A = @[@"商品总额",@"优惠金额",@"实付金额"];
    }
    return _section2_A;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.navigationItem.title = @"发布广告";
    model=[SingleModel sharedManager];
    
    dataSourse_A = @[self.section1_A,self.section2_A];
    NSLog(@"%@==%@==%@==%@==%@",model.shopName,model.advertTitle,model.advertArea,model.advertKind,model.advertPosition);
    data_A = @[@[model.shopName,model.advertTitle,model.advertArea,model.advertKind,model.advertPosition],@[@"￥0",@"￥0",@"￥0"]];
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = RGB(240, 240, 240);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 35 ;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self getAdvertPrice];
}
-(void)getAdvertPrice{
    
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/advert/getPrice",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
    if (model.advertIndex==2) {
         [paramer setObject:model.advertID forKey:@"advert_id"];
        [paramer setObject:@"activity" forKey:@"advert_type"];

    }else if (model.advertIndex==3){
         [paramer setObject:model.advertArea forKey:@"advert_id"];
        [paramer setObject:@"near" forKey:@"advert_type"];
        [paramer setObject:model.advertArea forKey:@"advert_id"];

    }
    else{
        [paramer setObject:model.advertID forKey:@"advert_id"];
        [paramer setObject:@"top" forKey:@"advert_type"];

    }

    
   
    [paramer setObject:model.advertPosition forKey:@"position"];//
    [paramer setObject:model.baseOnCountsOrTime forKey:@"pay_type"];//
    [paramer setObject:model.counts forKey:@"pay_content"];//

    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"=====%@",result);
        
        NSString *p1 = [NSString stringWithFormat:@"¥%@",result[@"price"]];
        

        data_A = @[@[model.shopName,model.advertTitle,model.advertArea,model.advertKind,model.advertPosition],@[p1,@"￥0",p1]];

//        [self.tableView reloadData];
        
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataSourse_A.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else{
        return 84;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, SCREENWIDTH, 84);
        view.backgroundColor = [UIColor clearColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(25, 20, SCREENWIDTH-50, 44);
        button.backgroundColor = NavBackGroundColor;
        [button setTitle:@"提交申请" forState:0];
        button.layer.cornerRadius = 4;
        [button addTarget:self action:@selector(gotopay) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        return view;
    }else return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = dataSourse_A[section];
    
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GotopayFor";
    UILabel *leftLab;
    UILabel *rightLab;

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        leftLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
        leftLab.font = [UIFont systemFontOfSize:15];
        leftLab.textColor = RGB(102,102,102);
        leftLab.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:leftLab];
       
        
        rightLab = [[UILabel alloc]initWithFrame:CGRectMake(leftLab.right+15, 0, SCREENWIDTH-leftLab.right-15, leftLab.height)];
        rightLab.font = [UIFont systemFontOfSize:15];
        rightLab.textColor = RGB(102,102,102);
        rightLab.textAlignment = NSTextAlignmentLeft;
        rightLab.text = @"西安市高新区富鱼路";

        [cell.contentView addSubview:rightLab];
        
        
    }
    
    leftLab.text = dataSourse_A[indexPath.section][indexPath.row];
    rightLab.text = data_A[indexPath.section][indexPath.row];
    
    NSLog(@"====%@",data_A[1]);
    
    if (indexPath.section==1 && indexPath.row ==5) {
        rightLab.textColor = RGB(215,32,32);
        
    }
    return cell;
}
//提交申请
-(void)gotopay{
    NSString *url=@"";
    if (model.advertIndex==2) {
        url =[[NSString alloc]initWithFormat:@"%@MerchantType/advertActivity/add",BASEURL];
    }else if (model.advertIndex==3){
        url=[[NSString alloc]initWithFormat:@"%@MerchantType/advertNear/add",BASEURL];
    }
    else{
        url =[[NSString alloc]initWithFormat:@"%@MerchantType/advertTop/add",BASEURL];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];//
    if (model.advertIndex!=3) {
        [params setObject:model.advertID forKey:@"advert_id"];
        [params setObject:model.advertSmallTitle forKey:@"title"];
        [params setObject:model.advertDescription forKey:@"info"];
        [params setObject:model.advertImageUlr forKey:@"image_url"];
    }else{
        [params setObject:model.advertArea forKey:@"address"];
    }
    [params setObject:model.advertPosition forKey:@"position"];//
    [params setObject:model.baseOnCountsOrTime forKey:@"pay_type"];//
    [params setObject:model.counts forKey:@"pay_content"];//
    NSLog(@"%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"postRequestAddAdmin==%@", result);
        NSDictionary *result_dic = (NSDictionary*)result;
        
        if ([result_dic[@"result_code"]intValue]==1)
        {
        //
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"申请成功", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            //    [hud setColor:[UIColor blackColor]];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            hud.userInteractionEnabled = YES;
            [hud hideAnimated:YES afterDelay:1.f];
            [self performSelector:@selector(gotoAdvertList) withObject:nil afterDelay:2.0f];
            
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"申请成功，请勿重复申请", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            //    [hud setColor:[UIColor blackColor]];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            hud.userInteractionEnabled = YES;
            [hud hideAnimated:YES afterDelay:1.f];
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];

}
-(void)gotoAdvertList{
    AdverListViewController *vc=[[AdverListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
/*
 post参数:
 advert_id => 广告id
 muid => 商户注册id
 position => 广告位置
 title => 商户广告标题
 info => 商户广告内容
 image_url => 商户广告图片
 pay_type => 付费类型(time|click)
 pay_content => 日期：天数，点击：次数
 
 返回参数:
 result_code =>  [ "1"  (提交成功) ]
 */

@end
