//
//  ExperienceCardTabVC.m
//  BletcShop
//
//  Created by Bletc on 2017/6/24.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ExperienceCardTabVC.h"

@interface ExperienceCardTabVC ()
{
    CGFloat heights;

}
@property(nonatomic,strong)NSArray *title_A;
@property(nonatomic,strong)NSDictionary *deadLine_dic;
@end

@implementation ExperienceCardTabVC

-(NSArray *)title_A{
    if (!_title_A) {
        _title_A = @[@{@"title":@"会员卡编号",@"content":@"code"},
                     @{@"title":@"会员卡价格",@"content":@"price"},
                     @{@"title":@"有效期",@"content":@"indate"},
                     @{@"title":@"内容说明",@"content":@"des"}
                     ];
    }
    return _title_A;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"体验卡详情";
    self.tableView.backgroundColor=RGB(255, 255, 255);

}



#pragma mark - Table view data source
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [UIView new];
    v.backgroundColor =RGB(230, 229, 232);
    
    return v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==self.title_A.count-1) {
        return heights;
    }else{
        return 33;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.title_A.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 155*(SCREENWIDTH-132)/244+28)];
    view.backgroundColor=RGB(240, 240, 240);
    
    UIImageView *cardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(66, 14, view.width-132, view.height-28)];
    cardImageView.layer.cornerRadius = 10;
    cardImageView.layer.masksToBounds = YES;
    cardImageView.layer.borderWidth = 0.5;
    cardImageView.layer.borderColor = RGB(234, 234, 234).CGColor;
    
    cardImageView.backgroundColor = [UIColor colorWithHexString:self.card_dic[@"template"]];
    [view addSubview:cardImageView];
    
    UILabel *typeAndeLevel = [[UILabel alloc]initWithFrame:CGRectMake(12, 20, cardImageView.width-24, 23)];
    typeAndeLevel.textColor = RGB(255,255,255);
    typeAndeLevel.text = @"体验卡";
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
    yueLabel.text = [[NSString alloc]initWithFormat:@"价格:%@",self.card_dic[@"price"]];
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    UILabel *shopName=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, downView.width-12, downView.height)];
    shopName.text=delegate.shopInfoDic[@"store"];
    shopName.textColor= RGB(51, 51, 51);
    [downView addSubview:shopName];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 155*(SCREENWIDTH-132)/244.0+28;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.font=[UIFont systemFontOfSize:15.0f];
        cell.detailTextLabel.textColor=RGB(51, 51, 51);
        cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor=RGB(141, 141, 141);
        cell.detailTextLabel.numberOfLines=0;
    }
    
    NSDictionary *dic = self.title_A[indexPath.row];
    
    cell.textLabel.text = dic[@"title"];
    cell.detailTextLabel.text  = self.card_dic[dic[@"content"]];
    
    if (indexPath.row==2) {
        cell.detailTextLabel.text  = self.deadLine_dic[self.card_dic[dic[@"content"]]];

    }
    
    if (indexPath.row==3) {
        heights=[cell.detailTextLabel.text getTextHeightWithShowWidth:SCREENWIDTH-120 AndTextFont:[UIFont systemFontOfSize:15.0f] AndInsets:5];
        heights= MAX(33, heights);

    }
    
   
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(NSDictionary *)deadLine_dic{
    if (!_deadLine_dic) {
        _deadLine_dic = @{@"0.5":@"半年",@"1":@"一年",@"2":@"两年",@"3":@"三年",@"0":@"无限期"};
    }
    
    return _deadLine_dic;
}
@end
