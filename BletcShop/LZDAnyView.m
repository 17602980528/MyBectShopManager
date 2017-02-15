//
//  LZDAnyView.m
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LZDAnyView.h"
#define LZDAnyViewSubviewHW (kWeChatScreenWidth - 5*kWeChatPadding)/4

@interface LZDAnyView ()
/** 图片按钮 */
@property (nonatomic, weak) LZDButton *imgBtn;


/** 语音按钮 */
@property (nonatomic, weak) LZDButton *talkBtn;

/** 视频按钮 */
@property (nonatomic, weak) LZDButton *vedioBtn;


@end

@implementation LZDAnyView


- (instancetype)initImageBlock:(void (^)(void))imageBlock talkBlock:(void (^)(void))talkBlock vedioBlock:(void (^)(void))vedioBlock
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor grayColor];
        
        // 初始化
        LZDButton *imageBtn = [LZDButton creatLZDButton];
//        [imageBtn setBackgroundColor:[UIColor redColor]];
        [imageBtn setImage:[UIImage imageNamed:@"聊天键盘-icon-选择照片"] forState:UIControlStateNormal];
        [imageBtn setImage:[UIImage imageNamed:@"聊天键盘-icon-选择照片-点击"] forState:UIControlStateHighlighted];
//        [imageBtn setTitle:@"图片" forState:UIControlStateNormal];
        [self addSubview:imageBtn];
        
        LZDButton *talkChatBtn = [LZDButton creatLZDButton];
//        [talkChatBtn setBackgroundColor:[UIColor blueColor]];
//        [talkChatBtn setTitle:@"相机" forState:UIControlStateNormal];
        
        [talkChatBtn setImage:[UIImage imageNamed:@"聊天键盘-icon-拍照"] forState:UIControlStateNormal];
        [talkChatBtn setImage:[UIImage imageNamed:@"聊天键盘-icon-拍照-点击"] forState:UIControlStateHighlighted];

        [self addSubview:talkChatBtn];
        
        LZDButton *vedioChatBtn = [LZDButton creatLZDButton];
//        [vedioChatBtn setBackgroundColor:[UIColor orangeColor]];
        [vedioChatBtn setTitle:@"视频" forState:UIControlStateNormal];
//        [self addSubview:vedioChatBtn];
        
        // 赋值
        self.imgBtn = imageBtn;
        self.talkBtn = talkChatBtn;
        self.vedioBtn = vedioChatBtn;
        
        // 事件处理
        imageBtn.block = ^(LZDButton *btn){
            if (imageBlock) {
                imageBlock();
            }
        };
        talkChatBtn.block = ^(LZDButton *btn){
            if (talkBlock) {
                talkBlock();
            }
        };
        vedioChatBtn.block = ^(LZDButton *btn){
            if (vedioBlock) {
                vedioBlock();
            }
        };
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imgBtn.frame = CGRectMake(kWeChatPadding, kWeChatPadding, LZDAnyViewSubviewHW, LZDAnyViewSubviewHW);
    self.talkBtn.frame = CGRectMake(self.imgBtn.right + kWeChatPadding, self.imgBtn.top, LZDAnyViewSubviewHW, LZDAnyViewSubviewHW);
    self.vedioBtn.frame = CGRectMake(self.talkBtn.right + kWeChatPadding, self.talkBtn.top, LZDAnyViewSubviewHW, LZDAnyViewSubviewHW);
}


@end
