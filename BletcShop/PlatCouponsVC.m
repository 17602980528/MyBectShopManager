//
//  PlatCouponsVC.m
//  BletcShop
//
//  Created by Bletc on 2017/5/26.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PlatCouponsVC.h"
#import "CouponCell.h"
#import "UIImageView+WebCache.h"
@interface PlatCouponsVC ()
{
    __block MBProgressHUD *hud;

}
@property (nonatomic,strong)NSMutableArray *couponArray;

@end

@implementation PlatCouponsVC
-(NSMutableArray *)couponArray{
    if (!_couponArray) {
        _couponArray = [NSMutableArray array];
    }
    return _couponArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商消乐优惠券";
    self.tableView.rowHeight = 150+11;
    [self postRequestCashCoupon];
    
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.couponArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CouponCell *cell = [CouponCell couponCellWithTableView:tableView];
    
    if (self.couponArray.count!=0) {

        /*
         
( 0.0784314 0.584314 0.854902 1 ),( 0.270588 0.172549 0.396078 1 )
( 0.631373 0.619608 0.329412 1 ),( 0.756863 0.717647 0.435294 1 )

         cell.gradientLayer.colors = @[(__bridge id)RGB( arc4random()%200,  arc4random()%200,  arc4random()%200).CGColor,(__bridge id)RGB( arc4random()%256,  arc4random()%256,  arc4random()%256).CGColor];

         
         */
   
        
        NSLog(@"colors===%@",cell.gradientLayer.colors);
        NSDictionary *dic = self.couponArray[indexPath.row];
        
//        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,dic[@"image_url"]]]];
        cell.headImg.hidden= YES;
        cell.shopNamelab.text=[NSString stringWithFormat:@"%@券",dic[@"coupon_type"]];
        CGRect frame = cell.shopNamelab.frame;
        frame.origin.x = 20;
        frame.size.width = (SCREENWIDTH-24)*2/3-20;
        cell.shopNamelab.frame = frame;
        cell.shopNamelab.font = [UIFont systemFontOfSize:27];
        cell.couponMoney.text=dic[@"sum"];
        cell.deadTime.text= [NSString stringWithFormat:@"有效期:%@~%@",dic[@"date_start"],dic[@"date_end"]];
        cell.limitLab.text=[NSString stringWithFormat:@"满%@元%@",dic[@"pri_condition"],dic[@"content"]];
//        if ([dic[@"validate"] isEqualToString:@"true"]) {
            cell.showImg.hidden = YES ;
//        }else{
//            cell.showImg.hidden = NO ;
//            
//        }
        cell.onlineState.hidden = YES;
        
//        if ([dic[@"coupon_type"] isEqualToString:@"ONLINE"]||[dic[@"coupon_type"] isEqualToString:@"null"]) {
//            cell.onlineState.image=[UIImage imageNamed:@"线上角标"];
//        }else{
//            cell.onlineState.image=[UIImage imageNamed:@"线下角标"];
//        }
        
    }
    
    return cell;
}

-(void)postRequestCashCoupon
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/getSxlCoupon",BASEURL];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    
    if (_useCoupon ==100) {
        
        [params setObject:self.muid forKey:@"muid"];
        
    }
    NSLog(@"params---%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        [hud hideAnimated:YES];
        [self.couponArray removeAllObjects];
        
        DebugLog(@"result---%@",result);
      
            NSArray *arr = (NSArray*)result;
            
            if (self.useCoupon ==100) {
                for (NSDictionary *dic in arr) {
                    
                    if ([dic[@"pri_condition"] floatValue] <= [self.moneyString floatValue]) {
                        [self.couponArray addObject:dic];
                        
                    }
                    
                }
                
                
            }else{
                for (NSDictionary *dic in arr) {
                    
                    [self.couponArray addObject:dic];
                }
                
            }
            
      
        
        if ([_couponArray count]==0) {
            
            [self initNoneActiveView];
            
        }
        
        [self.tableView reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hideAnimated:YES afterDelay:3.f];
        NSLog(@"%@", error);
    }];
    
}

//无活动显示无活动
-(void)initNoneActiveView{
    self.view.backgroundColor=RGB(240, 240, 240);
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-92, 63, 184, 117)];
    imageView.image=[UIImage imageNamed:@"CC588055F2B4764AA006CD2B6ACDD25C.jpg"];
    [self.view addSubview:imageView];
    
    UILabel *noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+46, SCREENWIDTH, 30)];
    noticeLabel.font=[UIFont systemFontOfSize:15.0f];
    noticeLabel.textColor=RGB(153, 153, 153);
    noticeLabel.textAlignment=NSTextAlignmentCenter;
    noticeLabel.text=@"没有可用的代金券哦";
    [self.view addSubview:noticeLabel];
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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(_useCoupon==100){
       
        self.block(_couponArray[indexPath.row]);
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    
    
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
