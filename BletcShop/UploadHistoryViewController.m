//
//  UploadHistoryViewController.m
//  iqiyi_ios_sdk_demo
//
//  Created by meiwen li on 4/1/13.
//  Copyright (c) 2013 meiwen li. All rights reserved.
//

#import "UploadHistoryViewController.h"
#import "VCOPClient.h"

@implementation UploadHistoryViewController


- (id) init
{
    self = [super init];
    if (self)
    {
        return self;
    }
    return nil;
}


//-(void)setUploadHistoryArray:(NSArray *) _historyArray
//{
//    
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"未完视频";
    self.navigationController.navigationBarHidden = NO;
    //初始化tableview
    _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];//指定位置大小
    [_contentTableView setDelegate:self];//指定委托
    [_contentTableView setDataSource:self];//指定数据委托
    [self.view addSubview:_contentTableView];//加载tableview
   // NSLog(@"self.uploadingHistoryArray=%@",self.uploadingHistoryArray);
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}





//每个section显示的标题

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"未完成";
  }



//指定有多少个分区(Section)，默认为1

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}



//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   // NSLog(@"[self.uploadingHistoryArray count]=%d",[self.uploadingHistoryArray count]);
    return [self.uploadingHistoryArray count];
}



//绘制Cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] ;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    NSDictionary* dict = (NSDictionary *)[self.uploadingHistoryArray objectAtIndex:indexPath.row];
    //NSLog(@"dict=%@",dict);
    cell.textLabel.text = [dict objectForKey:@"fileId"];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.numberOfLines = 2;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* selectedItem = [self.uploadingHistoryArray objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResumeOneHistory" object:nil userInfo:selectedItem];
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


@end