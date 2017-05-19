//
//  LandingController.h
//  BletcShop
//
//  Created by Yuan on 16/2/23.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import "AsyncSocket.h"

@protocol LandingDelegate <NSObject>

-(void)reloadAPI;


@end
@interface LandingController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) AsyncSocket *socket; // socket
@property (nonatomic, copy ) NSString *socketHost; // socket的Host
@property (nonatomic, assign) UInt16 socketPort; // socket的prot
//-(void)socketConnectHost;// socket连接
@property (nonatomic, retain) NSTimer *connectTimer;

@property(nonatomic,weak)UIButton *getCodeBtn;
@property(nonatomic,weak)UITextField *proText;
//@property BOOL ifCIASuccess;
@property BOOL ifRemeber;
@property(nonatomic,weak)UIButton *valBtn;

@property (nonatomic , assign) id<LandingDelegate> delegate;// 刷新

@end
