//
//  Singleton.m
//  socket_tutorial
//
//  Created by xiaoliangwang on 14-7-4.
//  Copyright (c) 2014年 芳仔小脚印. All rights reserved.
//

#import "Singleton.h"

#import <sys/socket.h>

#import <netinet/in.h>

#import <arpa/inet.h>

#import <unistd.h>
#import "AppDelegate.h"

@implementation Singleton

+(Singleton *) sharedInstance
{
    
    static Singleton *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstace = [[self alloc] init];
    });
    
    return sharedInstace;
}
// socket连接
-(void)socketConnectHost{
    [self.socket setDelegate:nil];
    
    [self.socket disconnect];
    
    self.socket=nil;
    if (self.socket == nil) {
        self.socket = [[AsyncSocket alloc] initWithDelegate:self];
    }
    
    
    NSError *error = nil;
    NSLog(@"%@",self.socketHost);
    [self.socket connectToHost:self.socketHost onPort:self.socketPort withTimeout:3 error:&error];

}
// 连接成功回调
#pragma mark  - 连接成功回调
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket连接成功");
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    [self.connectTimer fire];
    
    
}
// 心跳连接
-(void)longConnectToSocket{
    
    // 根据服务器要求发送固定格式的数据，假设为指令@"longConnect"，但是一般不会是这么简单的指令
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.dataStream  = [[[NSString alloc]initWithString: appdelegate.userInfoDic[@"uuid"]] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [[NSString alloc] initWithData:self.dataStream  encoding:NSUTF8StringEncoding];
    NSLog(@" 心跳连接==%@",result);
    
    [self.socket writeData:self.dataStream withTimeout:-1 tag:0];
    
}
// 切断socket
-(void)cutOffSocket{
    
    self.socket.userData = SocketDisconnectByUser;
    
    [self.connectTimer invalidate];
    
    [self.socket disconnect];
}
-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"sorry the connect is failure %ld",sock.userData);
    if (sock.userData == SocketDisconnectByServer) {
        // 服务器掉线，重连
        [self socketConnectHost];
    }
    else if (sock.userData == SocketDisconnectByUser) {
        // 如果由用户断开，不进行重连
        return;
    }
    
}


-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // 对得到的data值进行解析与转换即可
    
    [self.socket readDataWithTimeout:-1 tag:0];
}
@end
