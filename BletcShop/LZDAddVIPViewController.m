//
//  LZDAddVIPViewController.m
//  BletcShop
//
//  Created by Bletc on 16/9/29.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LZDAddVIPViewController.h"
#import "LZDAddVipCell.h"
#import "AddVIPModel.h"

@interface LZDAddVIPViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *back_View;

}

@property(nonatomic,strong) NSArray *data_A;
@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *muta_A;
@end

@implementation LZDAddVIPViewController
-(NSMutableArray *)muta_A{
    if (!_muta_A) {
        _muta_A = [NSMutableArray array];
        
    }
    return _muta_A;
}
-(NSArray *)data_A{
    if (!_data_A) {
        _data_A = [NSArray array];
        
    }
    return _data_A;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
    self.navigationItem.title=@"添加会员";
//    LZDButton *rightBtn = [LZDButton creatLZDButton];
//    rightBtn.frame = CGRectMake(kWeChatScreenWidth-50, 20, 50, 44);
//    
//    [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem=rightButton;
//    
//    
//    rightBtn.block = ^(LZDButton *btn){
//        [self.navigationController popViewControllerAnimated:YES];
//       
//    };
//    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = YES;
    tableView.rowHeight = 70;
    tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
    [self.view addSubview:tableView];

    self.tableView = tableView;
    
    [self creatbackView];
    [self postRequest];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_A.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier= @"cellID";
    LZDAddVipCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LZDAddVipCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (self.data_A.count>0) {
        AddVIPModel *model = [[AddVIPModel alloc] initModelWithDictionary:self.data_A[indexPath.row]];
;
        cell.vipModel = model;
        cell.choseBtn.tag = indexPath.row;
        
//        [cell.choseBtn addTarget:self action:@selector(choseClick:) forControlEvents:UIControlEventTouchUpInside];
        

    }
    return cell;
}

-(void)choseClick:(UIButton *)btn{
    
        btn.selected =! btn.selected;
    
        if (btn.selected == YES) {
            
            [self.muta_A addObject:self.data_A[btn.tag]];
            
        }
        else if(btn.selected == NO)
        {
            [self.muta_A removeObject:self.data_A[btn.tag]];
        }
    [self.delegate senderVip_array:self.muta_A];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LZDAddVipCell *cell = (LZDAddVipCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [self choseClick:cell.choseBtn];
    
//    [self.muta_A addObject:self.data_A[indexPath.row]];
//    [self.delegate senderVip_array:self.muta_A];
//
//    [self.navigationController popViewControllerAnimated:YES];
}

//数据请求
-(void)postRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/vipGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    

    [params setObject:appdelegate.shopInfoDic[@"muid"]  forKey:@"muid"];
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"===%@",result);
        
        self.data_A = (NSArray*)result;
        [self.tableView reloadData];
        

        if (self.data_A.count==0) {
            back_View.hidden =NO;

            
        }else{
            back_View.hidden =YES;
        }
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}

-(void)creatbackView{
    back_View = [[UIView alloc]init];
    back_View.bounds= CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH);
    back_View.center = CGPointMake(SCREENWIDTH/2, (SCREENHEIGHT-64)/2-32);
    back_View.hidden= NO;
    [self.view addSubview:back_View];
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/3, SCREENWIDTH/3-50, SCREENWIDTH/3, SCREENWIDTH/3)];
    imgV.image = [UIImage imageNamed:@"tanhao"];
    [back_View addSubview:imgV];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imgV.bottom, SCREENWIDTH, 30)];
    lab.text = @"您还没有会员哦!";
    lab.textColor = [UIColor darkGrayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font= [UIFont systemFontOfSize:15];
    [back_View addSubview:lab];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
