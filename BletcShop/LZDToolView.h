//
//  LZDToolView.h
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

typedef enum {
    
    LZDToolViewVoiceTypeStart,
    LZDToolViewVoiceTypeStop,
    LZDToolViewVoiceTypeCancel
    
}LZDToolViewVoiceType;


typedef enum {
    
    LZDToolViewEditTextViewSend,
    LZDToolViewEditTextViewBegin
    
    
}LZDToolViewEditTextViewType;

#import <UIKit/UIKit.h>

typedef void(^LZDToolViewSendTextBlock)(UITextView*textView,LZDToolViewEditTextViewType);

//block方式
typedef void(^LZDToolViewVoiceTextBlock)(LZDToolViewVoiceType,LZDButton*btn);
typedef void(^LZDToolViewMoreBtnBlock)();

typedef void(^LZDToolViewEmTionBtnBlock)(UITextView *textView);


//delegate 方式
@protocol LZDToolViewVoiceDelegate <NSObject>

@optional

- (void)toolViewWithType:(LZDToolViewVoiceType)type Button:(LZDButton *)btn;


@end


@interface LZDToolView : UIView

@property (nonatomic,copy)LZDToolViewSendTextBlock sendTextBlock;//  发送消息的回调
@property (nonatomic,copy)LZDToolViewMoreBtnBlock moreBtnBlock;// 

@property(nonatomic,copy)LZDToolViewEmTionBtnBlock emtionBlock;//***表情

@property (nonatomic , assign) id <LZDToolViewVoiceDelegate> delegate;


@end
