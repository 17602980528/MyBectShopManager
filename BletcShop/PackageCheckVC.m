//
//  PackageCheckVC.m
//  BletcShop
//
//  Created by apple on 2017/6/24.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PackageCheckVC.h"
#import "CardDetailShowProdictCell.h"
#import "UIImageView+WebCache.h"
@interface PackageCheckVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *array;
    NSArray *productArray;
    CGFloat heights;
    UITableView *_tableView;
}
@end

@implementation PackageCheckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"套餐卡详情";
    NSLog(@"%@",self.dic);
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    array=[[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:@[@"会员卡名称",@"项目总数",@"会员卡原价",@"会员卡优惠价",@"优惠内容"]];
    productArray=[[NSArray alloc]init];
    [self postRequestCardInfo];
}

-(void)postRequestCardInfo{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/MealCard/showOption",BASEURL];
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    [parmer setValue:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [parmer setValue:self.dic[@"code"] forKey:@"code"];
    NSLog(@"0-----%@",parmer);
    [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        if (result&&[result count]>0) {
            productArray=result;
            [array addObject:productArray];
        }
        [_tableView reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"error-----%@",error.description);
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 5;
    }else{
        if (productArray &&productArray.count>0) {
            return productArray.count;
        }else{
            return 0;
        }
        
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 155*(SCREENWIDTH-132)/244+28)];
        view.backgroundColor=RGB(240, 240, 240);
        
        UIImageView *cardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(66, 14, view.width-132, view.height-28)];
        cardImageView.layer.cornerRadius = 10;
        cardImageView.layer.masksToBounds = YES;
        cardImageView.layer.borderWidth = 0.5;
        cardImageView.layer.borderColor = RGB(234, 234, 234).CGColor;
        
        cardImageView.backgroundColor = [UIColor colorWithHexString:self.dic[@"template"]];
        [view addSubview:cardImageView];
        
        UILabel *typeAndeLevel = [[UILabel alloc]initWithFrame:CGRectMake(12, 20, cardImageView.width-24, 23)];
        typeAndeLevel.textColor = RGB(255,255,255);
        typeAndeLevel.text = [NSString stringWithFormat:@"%@",self.dic[@"name"]];
        typeAndeLevel.font = [UIFont systemFontOfSize:22];
        [cardImageView addSubview:typeAndeLevel];
        
        UIView *downView=[[UIView alloc]initWithFrame:CGRectMake(0, cardImageView.height*3/4, cardImageView.width, cardImageView.height*1/4)];
        downView.backgroundColor=[UIColor whiteColor];
        [cardImageView addSubview:downView];
        
        UILabel *yueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, cardImageView.height*2/4, cardImageView.width-12, 21)];
        yueLabel.textColor = RGB(255,255,255);
        yueLabel.textAlignment = NSTextAlignmentRight;
        yueLabel.font = [UIFont systemFontOfSize:25];
        [cardImageView addSubview:yueLabel];
        yueLabel.text = [[NSString alloc]initWithFormat:@"价格:%@",self.dic[@"price"]];
        
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        UILabel *shopName=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, downView.width-12, downView.height)];
        shopName.text=delegate.shopInfoDic[@"store"];
        shopName.textColor= RGB(51, 51, 51);
        [downView addSubview:shopName];
        
        return view;
        
    }else if(section==1){
    
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, view.height)];
        lab.text = @"项目内容";
        lab.textColor = RGB(51, 51, 51);
        lab.font = [UIFont systemFontOfSize:15];
        [view addSubview:lab];
        
        return view;
    }else
        return nil;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row!=4) {
            return 33;
        }else{
            return heights;
        }
    }else{
        return 50;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString   * CellIdentiferId =  @"cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentiferId];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.font=[UIFont systemFontOfSize:15.0f];
            cell.detailTextLabel.textColor=RGB(51, 51, 51);
            cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
            cell.textLabel.textColor=RGB(141, 141, 141);
        }
        cell.textLabel.text=array[0][indexPath.row];
        if (indexPath.row==0) {
            cell.detailTextLabel.text=self.dic[@"name"];
        }else if (indexPath.row==1){
            cell.detailTextLabel.text=self.dic[@"option_num"];
        }else if (indexPath.row==2){
            cell.detailTextLabel.text=self.dic[@"option_sum"];
        }else if (indexPath.row==3){
            cell.detailTextLabel.text=self.dic[@"price"];
        }else if (indexPath.row==4){
            heights=[self.dic[@"des"] getTextHeightWithShowWidth:SCREENWIDTH-120 AndTextFont:[UIFont systemFontOfSize:15.0f] AndInsets:5];
            heights= MAX(33, heights);
            cell.detailTextLabel.numberOfLines=0;
            cell.detailTextLabel.text=self.dic[@"des"];
        }
        
        return cell;
        
    }else{
        static NSString   * CellIdentiferId =  @"CardDetailShowCell";
        CardDetailShowProdictCell  * cell = [tableView  dequeueReusableCellWithIdentifier :CellIdentiferId];
        if (!cell){
            NSArray  * nibs = [[ NSBundle mainBundle ] loadNibNamed :@"CardDetailShowProdictCell" owner :self options :nil ];
            cell = [  nibs lastObject ];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        };
        cell.productName.text=[NSString stringWithFormat:@"%@",productArray[indexPath.row][@"name"]];
        cell.productPrice.text=[NSString stringWithFormat:@"%@元/次",productArray[indexPath.row][@"price"]];
        NSURL * nurl1=[[NSURL alloc] initWithString:[[NSString stringWithFormat:@"%@%@",PRODUCT_IMAGE,productArray[indexPath.row][@"image"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [cell.productImage sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        return cell;
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 155*(SCREENWIDTH-132)/244.0+28;
    }else if(section==1){
        return 40;
    }else
        return 0.01;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
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
