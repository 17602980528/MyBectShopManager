//
//  ChooseProductVC.m
//  BletcShop
//
//  Created by apple on 2017/6/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ChooseProductVC.h"
#import "AddPakageServiceVC.h"
#import "PackageTableViewCell.h"
#import "PackageOtherTableViewCell.h"
#import "ChoiceCardPictureViewController.h"
#import "UIImageView+WebCache.h"
@interface ChooseProductVC ()<UITableViewDelegate,UITableViewDataSource,ChoiceCardDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChooseProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *menuBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [menuBt addTarget:self action:@selector(addtBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuBt setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateNormal];
    [menuBt setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateHighlighted];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:menuBt];
    self.navigationItem.rightBarButtonItem = item;
    
    self.tableView.rowHeight=40;
}
-(void)addtBtnAction:(UIButton *)sender{
    AddPakageServiceVC *vc=[[AddPakageServiceVC alloc]init];
    vc.title=@"创建项目";
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 5;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString   * CellIdentiferId =  @"packageCell";
        PackageTableViewCell  * cell = [tableView  dequeueReusableCellWithIdentifier :CellIdentiferId];
        if (!cell){
            NSArray  * nibs = [[ NSBundle mainBundle ] loadNibNamed :@"PackageTableViewCell" owner :self options :nil ];
            cell = [  nibs lastObject ];
        };
        return cell;
    }else{
        static NSString   * CellIdentiferId =  @"packageOtherCell";
        PackageOtherTableViewCell  * cell = [tableView  dequeueReusableCellWithIdentifier :CellIdentiferId];
        if (!cell){
            NSArray  * nibs = [[ NSBundle mainBundle ] loadNibNamed :@"PackageOtherTableViewCell" owner :self options :nil ];
            cell = [  nibs lastObject ];
        };
        [cell.chooseCardBtn addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
        NSURL * nurl1=[[NSURL alloc] initWithString:[[NSString stringWithFormat:@"%@%@",SOURCECARD,self.choiceCard[@"image"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [cell.cardImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        return cell;
    }
}
-(void)goNext{
    ChoiceCardPictureViewController *pictureView = [[ChoiceCardPictureViewController alloc]init];
    pictureView.delegate = self;
    [self.navigationController pushViewController:pictureView animated:YES];
}
#pragma mark --ChoiceCardDelegate
- (void)sendCardValue:(NSDictionary *)value
{
    self.choiceCard = [[NSDictionary alloc]initWithDictionary:value];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
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
