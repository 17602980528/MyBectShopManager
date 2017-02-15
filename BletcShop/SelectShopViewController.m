//
//  SelectShopViewController.m
//  BletcShop
//
//  Created by apple on 16/9/29.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "SelectShopViewController.h"
#import "RoyShopTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface SelectShopViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *data;
@property(nonatomic,strong)NSMutableArray *Newdata;
@end

@implementation SelectShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"所有产品";
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    [self postRequest];
}
//点击确认按钮，返回去结算页面
-(void)confirm{
    [self.delegate sendNsArr:self.Newdata];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)postRequest
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@/MerchantType/commodity/get",BASEURL];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    [params setObject:@"18629691107" forKey:@"phone"];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];

    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        self.data = result;
        [self initTabel];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
-(void)initTabel{
    UITableView *_tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(NSArray *)data
{
    if (_data == nil) {
        _data = [NSArray array];
    }return _data;
}
-(NSMutableArray *)Newdata
{
    if (_Newdata == nil) {
        _Newdata = [NSMutableArray array];
    }return _Newdata;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoyShopTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[RoyShopTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.choseBtn.tag = indexPath.row;
    [cell.choseBtn addTarget:self action:@selector(choseAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.nameLabel.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.bianHaoLable.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"number"];
    cell.priceLabel.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"price"];
   cell.cuCunLabel.text = [NSString stringWithFormat:@"库存 %@",[[self.data objectAtIndex:indexPath.row] objectForKey:@"remain"]];
    
    [cell.headIamgeView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,[[self.data objectAtIndex:indexPath.row] objectForKey:@"image_url"]]] placeholderImage:[UIImage imageNamed:@"icon3"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RoyShopTableViewCell *cell = (RoyShopTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [self choseAction:cell.choseBtn];
    
  
}


//各个Button的点击事件
-(void)choseAction:(UIButton *)btn
{
    btn.selected =! btn.selected;
    
    NSLog(@"%@",self.data[btn.tag]);
    
    if (btn.selected == YES) {
        
        [self.Newdata addObject:self.data[btn.tag]];
        
    }
    else if(btn.selected == NO)
    {
        [self.Newdata removeObject:self.data[btn.tag]];
    }
    
    NSLog(@"%ld",self.Newdata.count);
    
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
