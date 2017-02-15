//
//  QYShowResultView.m
//  iqiyi_ios_sdk_demo
//
//  Created by 苏 瑞强 on 13-8-8.
//  Copyright (c) 2013年 meiwen li. All rights reserved.
//

#import "QYShowResultView.h"


@implementation QYShowResultView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIToolbar* topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 44)];
        topBar.barStyle = UIBarStyleBlackTranslucent;
        
        NSMutableArray *myToolBarItems = [NSMutableArray array];
        [myToolBarItems addObject:[[UIBarButtonItem alloc]
                                    initWithTitle:@"关闭"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(action:)] ];
        [topBar setItems:myToolBarItems animated:YES];
        [self addSubview:topBar];
        
        CGRect textViewFrame = CGRectMake(0,60, frame.size.width, frame.size.height);
        UITextView* showView = [[UITextView alloc] initWithFrame:textViewFrame];
        showView.editable = NO;
        self.showView = showView;
        [self addSubview:self.showView];

    }
    return self;
}

-(void)action:(id)sender
{
    [self removeFromSuperview];
}

-(void)setContent:(NSString *)content
{
    if (_content != content) {
    
        NSLog(@"%@",_content);
        _content=[content copy];
        self.showView.text = _content;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
