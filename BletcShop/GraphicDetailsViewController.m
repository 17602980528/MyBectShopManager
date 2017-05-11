//
//  GraphicDetailsViewController.m
//  BletcShop
//
//  Created by Bletc on 16/6/24.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "GraphicDetailsViewController.h"

@interface GraphicDetailsViewController ()

@end

@implementation GraphicDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图文详情";
    self.pictureArray = [[NSMutableArray alloc]init];
    self.contentArray = [[NSMutableArray alloc]init];
    self.modelStateArray=[[NSMutableArray alloc]init];
    for (int i=0; i<self.pictureAndContentArray.count; i++) {
        [self.pictureArray addObject:[[self.pictureAndContentArray objectAtIndex:i] objectForKey:@"image_url"]];
        [self.contentArray addObject:[[self.pictureAndContentArray objectAtIndex:i] objectForKey:@"content"]];
        [self.modelStateArray addObject:[[self.pictureAndContentArray objectAtIndex:i] objectForKey:@"type"]];
    }
    NSLog(@"===info_dic%@",self.infoDic);
    [self.pictureArray insertObject:[self.infoDic objectForKey:@"image_url"] atIndex:0];
    [self.contentArray insertObject:[self.infoDic objectForKey:@"store"] ?[self.infoDic objectForKey:@"store"]:[self.infoDic objectForKey:@"title"]  atIndex:0];
    [self.modelStateArray insertObject:@"1" atIndex:0];

    [self initTableView];
    // Do any additional setup after loading the view.
}
-(void)initTableView
{
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.showsVerticalScrollIndicator = NO;
    table.rowHeight = SCREENHEIGHT/2;
    table.bounces = NO;
    self.myTableView = table;
    [self.view addSubview:table];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.pictureArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str=self.modelStateArray[indexPath.row];
    if ([str isEqualToString:@"1"]) {
        return SCREENWIDTH*2/3;
    }else if([str isEqualToString:@"0"]||[str isEqualToString:@"2"]){
        return (SCREENWIDTH/2-10)*2/3+10;
    }
    return SCREENWIDTH*2/3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, SCREENWIDTH, SCREENWIDTH*2/3-10)];
        imageView.tag=100;
        [cell addSubview:imageView];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0,(SCREENWIDTH*2/3)-80 , SCREENWIDTH, 100)];
        label.tag=200;
        //label.textAlignment=1;
        label.alpha=0.5;
        label.font=[UIFont systemFontOfSize:13.0f];
        label.numberOfLines=0;
        label.backgroundColor=[UIColor blackColor];
        label.textColor=[UIColor whiteColor];
        [cell addSubview:label];
        UIImageView *imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, SCREENWIDTH/2, 140)];
        imageView2.tag=300;
        [cell addSubview:imageView2];
    }
    UIImageView *imgView=[cell viewWithTag:100];
    UILabel *label=[cell viewWithTag:200];
    UIImageView *imgView2=[cell viewWithTag:300];
    if (indexPath.row==0) {
        label.hidden=NO;
        imgView2.hidden=YES;
        imgView.hidden=NO;
        imgView.image=[UIImage imageNamed:@"icon3"];
        NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[self.infoDic objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        NSString *newStr=self.contentArray[indexPath.row];
        CGFloat lableHeight=[newStr getTextHeightWithShowWidth:SCREENWIDTH AndTextFont:[UIFont systemFontOfSize:13.0f] AndInsets:5];
        label.text=newStr;
        label.frame=CGRectMake(0, SCREENWIDTH*2/3-lableHeight-5, SCREENWIDTH, lableHeight);
    }else{
        NSString *newStr=self.contentArray[indexPath.row];
        CGFloat lableHeight=[newStr getTextHeightWithShowWidth:SCREENWIDTH AndTextFont:[UIFont systemFontOfSize:13.0f] AndInsets:5];
        CGFloat labelHeight2=[newStr getTextHeightWithShowWidth:SCREENWIDTH/2 AndTextFont:[UIFont systemFontOfSize:13.0f] AndInsets:5];
        label.text=newStr;
        label.frame=CGRectMake(0, SCREENWIDTH*2/3-lableHeight-5, SCREENWIDTH, lableHeight);
        if([[NSString stringWithFormat:@"%@",self.modelStateArray[indexPath.row]] isEqualToString:@"0"]){
            label.hidden=NO;
            imgView2.hidden=NO;
            imgView.hidden=YES;
            imgView2.frame=CGRectMake(5, 5, SCREENWIDTH/2-10, (SCREENWIDTH/2-10)*2/3);
            if (labelHeight2<(SCREENWIDTH/2-10)*2/3) {
                label.frame=CGRectMake(SCREENWIDTH/2, (SCREENWIDTH/2-10)*1/3-labelHeight2/2+5, SCREENWIDTH/2, labelHeight2);
            }else{
                label.frame=CGRectMake(SCREENWIDTH/2, 5, SCREENWIDTH/2, (SCREENWIDTH/2-10)*2/3);
            }
            label.backgroundColor=[UIColor whiteColor];
            label.textColor=[UIColor blackColor];
            NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[self.pictureArray  objectAtIndex:indexPath.row]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [imgView2 sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        }else if ([[NSString stringWithFormat:@"%@",self.modelStateArray[indexPath.row]] isEqualToString:@"1"]){
            NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[self.pictureArray  objectAtIndex:indexPath.row]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
            imgView2.hidden=YES;
            imgView.hidden=NO;
            label.hidden=NO;
        }else if ([[NSString stringWithFormat:@"%@",self.modelStateArray[indexPath.row]] isEqualToString:@"2"]){
            label.hidden=NO;
            imgView2.hidden=NO;
            imgView.hidden=YES;
            imgView2.frame=CGRectMake(SCREENWIDTH/2+5, 5, SCREENWIDTH/2-10,(SCREENWIDTH/2-10)*2/3);
            if (labelHeight2<(SCREENWIDTH/2-10)*2/3) {
                label.frame=CGRectMake(0, (SCREENWIDTH/2-10)*1/3-labelHeight2/2+5, SCREENWIDTH/2, labelHeight2);
            }else{
                label.frame=CGRectMake(0, 5, SCREENWIDTH/2, (SCREENWIDTH/2-10)*2/3);
            }
            label.backgroundColor=[UIColor whiteColor];
            label.textColor=[UIColor blackColor];
            NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[self.pictureArray  objectAtIndex:indexPath.row]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [imgView2 sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        }else if ([[NSString stringWithFormat:@"%@",self.modelStateArray[indexPath.row]] isEqualToString:@"3"]){
            
            NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[self.pictureArray  objectAtIndex:indexPath.row]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
            imgView2.hidden=YES;
            imgView.hidden=NO;
            label.hidden=YES;
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
