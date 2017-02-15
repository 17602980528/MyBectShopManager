//
//  SearchTableViewController.h
//  BletcShop
//
//  Created by Bletc on 16/6/20.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
@protocol SearchShopDelegate <NSObject>


- (void)beginSearch:(UISearchBar*)searchBar;

- (void)endSearch:(UISearchBar*)searchBar;

@end
@interface SearchTableViewController : UITableViewController<UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property (strong,nonatomic) NSMutableArray  *dataList;
@property (nonatomic, weak) id<SearchShopDelegate> delegate;
@property (strong,nonatomic) NSMutableArray  *searchList;
@property (nonatomic, strong) UISearchController *searchController;

@property(nonatomic,retain)NSMutableDictionary *infoArray;
@end
