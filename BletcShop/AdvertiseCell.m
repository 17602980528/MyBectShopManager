//
//  AdvertiseCell.m
//  BletcShop
//
//  Created by Bletc on 2016/11/7.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "AdvertiseCell.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
@implementation AdvertiseCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

+(instancetype)advertiseCellIntiWithTableView:(UITableView*)tableView;
{
    AdvertiseCell *cell = [tableView dequeueReusableCellWithIdentifier:advertiseID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AdvertiseCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    cell.distance_lab.hidden = YES;
    cell.goLooK.layer.cornerRadius = 3;
    cell.goLooK.layer.masksToBounds = YES;
    return cell;
}


-(void)setModel:(ActivityModel *)model{
    _model = model;
    self.shopName_lab.text = model.store;
    self.sale_count.text = model.sold;
    self.des_lab.text = model.text;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.model.Image_url] placeholderImage:[UIImage imageNamed:@"icon3.png"]];

    CLLocationCoordinate2D c1 = (CLLocationCoordinate2D){[model.latitude doubleValue], [model.longtitude doubleValue]};
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    CLLocationCoordinate2D c2 = appdelegate.userLocation.location.coordinate;
    
    BMKMapPoint a=BMKMapPointForCoordinate(c1);
    BMKMapPoint b=BMKMapPointForCoordinate(c2);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(a,b);
    int meter = (int)distance;
    if (meter>1000) {
        self.distance_lab.text = [[NSString alloc]initWithFormat:@"%.1fkm",meter/1000.0];
    }else
        self.distance_lab.text = [[NSString alloc]initWithFormat:@"%dm",meter];

    
}

@end
