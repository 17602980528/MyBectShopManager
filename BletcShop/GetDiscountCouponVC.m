//
//  GetDiscountCouponVC.m
//  BletcShop
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "GetDiscountCouponVC.h"
#import "CouponIntroduceVC.h"
@interface GetDiscountCouponVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@end

@implementation GetDiscountCouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"专属优惠";
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        UIImageView *shopHead=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 95, 95)];
        shopHead.image=[UIImage imageNamed:@"5-01"];
        shopHead.tag=100;
        [cell addSubview:shopHead];
        
        UILabel *couponNameLable=[[UILabel alloc]initWithFrame:CGRectMake(125, 10, SCREENWIDTH-125-15-78-10, 50)];
        couponNameLable.text=@"美式黑椒牛排立减15元代金券";
        couponNameLable.font=[UIFont systemFontOfSize:15.0f];
        couponNameLable.numberOfLines=0;
        [cell addSubview:couponNameLable];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(SCREENWIDTH-78-10, 15, 78, 35);
        button.backgroundColor=[UIColor colorWithRed:237/255.0f green:71/255.0f blue:59/255.0f alpha:1.0f];
        button.layer.cornerRadius=3.0f;
        button.titleLabel.font=[UIFont systemFontOfSize:13.0f];
        [button setTitle:@"立即领取" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell addSubview:button];
        button.tag=indexPath.row;
        [button addTarget:self action:@selector(getCoupon:) forControlEvents:UIControlEventTouchUpInside];
        UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:24.0f];
        NSString *money=@"30元";
        NSString * moneys=[NSString getTheNoNullStr:money andRepalceStr:@""];
        CGSize size=[moneys sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName,nil]];
        CGFloat nameH = size.height;
        // 名字的W三人行麻辣香锅 3.0km
        CGFloat nameW = size.width;
        
        UILabel *couponMoney=[[UILabel alloc]initWithFrame:CGRectMake(125, couponNameLable.bottom+5, nameW, 30)];
        couponMoney.text=moneys;
        couponMoney.textColor=NavBackGroundColor;
        [cell addSubview:couponMoney];
        
        UILabel *baseCouponMoney=[[UILabel alloc]initWithFrame:CGRectMake(couponMoney.right,couponNameLable.bottom+(nameH-15) , SCREENWIDTH-couponMoney.frame.origin.x-couponMoney.width-5, 15)];
        baseCouponMoney.text=@"满100元可用";
        baseCouponMoney.textColor=[UIColor lightGrayColor];
        baseCouponMoney.font=[UIFont systemFontOfSize:13.0f];
        [cell addSubview:baseCouponMoney];
        
        UILabel *shopNameAndDistant=[[UILabel alloc]initWithFrame:CGRectMake(125, couponMoney.bottom+5, SCREENWIDTH-125, 15)];
        shopNameAndDistant.text=@"三人行麻辣香锅 3.0km";
        shopNameAndDistant.font=[UIFont systemFontOfSize:13.0f];
        shopNameAndDistant.textColor=[UIColor lightGrayColor];
        [cell addSubview:shopNameAndDistant];
        
    }
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*120/375.0f)];
    view.backgroundColor=[UIColor grayColor];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*120/375.0f)];
    imageView.image=[UIImage imageNamed:@"5-01.png"];
    [view addSubview:imageView];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)getCoupon:(UIButton *)sender{
    UITableViewCell *cell=(UITableViewCell *)[sender superview];
    NSIndexPath *indexPath=[_tableView indexPathForCell:cell];
    NSLog(@"%@",indexPath);
    if ([sender.titleLabel.text isEqualToString:@"立即使用"]) {
        CouponIntroduceVC *couponVC=[[CouponIntroduceVC alloc]init];
        couponVC.index=1;
        [self.navigationController pushViewController:couponVC animated:YES];
    }
    [sender setTitle:@"立即使用" forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    sender.backgroundColor=[UIColor whiteColor];
    sender.layer.borderWidth=1.0f;
    sender.layer.borderColor=[[UIColor redColor]CGColor];
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
