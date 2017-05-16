//
//  CardCodeTypeVC.m
//  BletcShop
//
//  Created by apple on 2017/5/2.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CardCodeTypeVC.h"

@interface CardCodeTypeVC ()
@property (strong, nonatomic) IBOutlet UITextField *cardNameTF;
@property (strong, nonatomic) IBOutlet UILabel *cardType;

@end

@implementation CardCodeTypeVC

- (IBAction)completeAction:(id)sender {
    
    if (![_cardNameTF.text isEqualToString:@""]) {
        if ([_delegate respondsToSelector:@selector(addCardCodeAndTypes: type: muid:)]) {
            AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            
            [_delegate addCardCodeAndTypes:_cardNameTF.text type:_cardType.text muid:delegate.shopInfoDic[@"muid"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(240, 240, 240);
    _cardType.text=self.cardTypes;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
