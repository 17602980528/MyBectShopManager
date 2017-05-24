//
//  AddCouponDetailsVC.m
//  BletcShop
//
//  Created by apple on 17/3/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AddCouponDetailsVC.h"

@interface AddCouponDetailsVC ()
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UILabel *shopNameLable;
@property (strong, nonatomic) IBOutlet UILabel *couponMoneyLable;
@property (strong, nonatomic) IBOutlet UIView *seperateLineView;
@property (strong, nonatomic) IBOutlet UILabel *pulishCountLable;
@property (strong, nonatomic) IBOutlet UILabel *couponRemainLable;
@property (strong, nonatomic) IBOutlet UILabel *couponUseLimitLable;
@property (strong, nonatomic) IBOutlet UILabel *canUseTimeLable;
@property (strong, nonatomic) IBOutlet UILabel *useNoticeLable;

@end

@implementation AddCouponDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationItem.title=@"优惠券";
    
    
    NSLog(@"%@",self.infoDic);
    _backgroundView.layer.cornerRadius=5.0f;
    _backgroundView.clipsToBounds=YES;
    _shopNameLable.text=self.infoDic[@"store"];
    _couponMoneyLable.text=[NSString stringWithFormat:@"%@元代金券",self.infoDic[@"sum"]];
    _pulishCountLable.text=[NSString stringWithFormat:@"发行数量：%@",self.infoDic[@"remain"]];
    _couponRemainLable.text=[NSString stringWithFormat:@"剩余数量：%@",self.infoDic[@"remain"]];
    if ([self.infoDic[@"coupon_type"] isEqualToString:@"OFFLINE"]) {
        _couponUseLimitLable.text=[NSString stringWithFormat:@"使用条件：进店使用,满%@可用",self.infoDic[@"pri_condition"]];

    }else if ([self.infoDic[@"coupon_type"] isEqualToString:@"ONLINE"]){
        _couponUseLimitLable.text=[NSString stringWithFormat:@"使用条件：限办卡使用,满%@可用",self.infoDic[@"pri_condition"]];

    }else{
        _couponUseLimitLable.text=[NSString stringWithFormat:@"使用条件：满%@可用",self.infoDic[@"pri_condition"]];

    }
    
    _canUseTimeLable.text=[NSString stringWithFormat:@"有效期：%@～%@",self.infoDic[@"date_start"],self.infoDic[@"date_end"]];
    _useNoticeLable.text=[NSString getTheNoNullStr:self.infoDic[@"content"] andRepalceStr:@"无相关介绍"];
  
    
    
}
/*
 sum = 20,
	remain = 1000,
	content = 给你的广告起个响亮的名字吧 0/20字,
	state = true,
	store = 商消乐,
	image_url = face_02.jpg,
	pri_condition = 100,
	coupon_id = cp_ed10f0fc87,
	date_end = 2017-04-08,
	date_start = 2017-03-08,
	muid = m_d7c116a9cc
 */
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
