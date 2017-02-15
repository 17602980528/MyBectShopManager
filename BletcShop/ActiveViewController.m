//
//  ActiveViewController.m
//  BletcShop
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ActiveViewController.h"
#import "UIImageView+WebCache.h"
#import "ActiveMoreRuleViewController.h"
@interface ActiveViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *modelArr;
    UITableView *_tableView;
    CGFloat totalHeight;
}
@end

@implementation ActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"乐挖";
    modelArr=[[NSMutableArray alloc]init];
    [self postRequest];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (modelArr.count>0) {
        return 1;
    }else
        return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        for (int i=0; i<modelArr.count; i++) {
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(10+i%2*((SCREENWIDTH-30)/2+10), 10+i/2*190, (SCREENWIDTH-30)/2, 180)];
            view.tag=i;
            view.backgroundColor=[UIColor whiteColor];
            
            UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            [view addGestureRecognizer:tapRecognizer];
            
            UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, (SCREENWIDTH-30)/2-40, 80)];
            [view addSubview:imageView1];
            //imageView1.backgroundColor=[UIColor yellowColor];
            
            NSURL * nurl1=[[NSURL alloc] initWithString:[[DUOBAOIMAGE stringByAppendingString:[modelArr  objectAtIndex:i][1]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [imageView1 sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
            
            UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(5, 100, SCREENWIDTH/2-10, 30)];
            //label1.backgroundColor=[UIColor blueColor];
            label1.font=[UIFont systemFontOfSize:12.0f];
            label1.numberOfLines=0;
            [view addSubview:label1];
            label1.text=[modelArr objectAtIndex:i][0];
            
            UILabel *label11=[[UILabel alloc]initWithFrame:CGRectMake(5, 135, SCREENWIDTH/2, 15)];
            //label11.backgroundColor=[UIColor cyanColor];
            label11.font=[UIFont systemFontOfSize:11.0f];
            label11.textColor=[UIColor grayColor];
            [view addSubview:label11];
            float totalPerson = [modelArr[i][4] floatValue];
            float lastPerson = [modelArr[i][5] floatValue];
            CGFloat scale =(totalPerson-lastPerson)/totalPerson*100;
            NSString *progressStr=[[NSString alloc]initWithFormat:@"%.2f%%",scale];
            label11.text=[[NSString alloc]initWithFormat:@"揭晓进度:%@",progressStr ];
            
            UIProgressView *progressView=[[UIProgressView alloc]initWithFrame:CGRectMake(5, 160, SCREENWIDTH/4, 20)];
            progressView.progress=scale/100;
            progressView.tintColor=[UIColor orangeColor];
            [view addSubview:progressView];
            [cell addSubview:view];

        }
        cell.backgroundColor=[[UIColor alloc]initWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    //UIView *viewModel=[cell viewWithTag:<#(NSInteger)#>];
    totalHeight=180*(modelArr.count+2-1)/2;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return totalHeight;
}
-(void)postRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"http://101.201.100.191/VipCard/award_activity_get.php"];
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray* result)
     {
         for (int i=0; i<result.count; i++) {
             [modelArr addObject:result[i]];
         }
         
         _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, SCREENHEIGHT-64) style:UITableViewStylePlain];
         _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
         _tableView.backgroundColor=[[UIColor alloc]initWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
         _tableView.dataSource=self;
         _tableView.delegate=self;
         [self.view addSubview:_tableView];
         //[_tableView reloadData];
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(void)tapClick:(UITapGestureRecognizer *)tapRecognizer{
    UIView *view=[tapRecognizer view];
    ActiveMoreRuleViewController *moreVC=[[ActiveMoreRuleViewController alloc]init];
    moreVC.index=view.tag;
    moreVC.array=modelArr;
    [self.navigationController pushViewController:moreVC animated:YES];
    
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
