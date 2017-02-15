//
//  ComplaintDetailVC.m
//  BletcShop
//
//  Created by Bletc on 2017/1/12.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ComplaintDetailVC.h"

@interface ComplaintDetailVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *plachHode;
@property (weak, nonatomic) IBOutlet UILabel *countSize;

@end

@implementation ComplaintDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"投诉";
    
    self.button.backgroundColor = NavBackGroundColor;
    
    
    

}
- (IBAction)buttonClick:(UIButton *)sender {
    NSLog(@"=====%@",_textView.text);
    
    if (self.textView.text.length==0) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请填写原因", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        
        [hud hideAnimated:YES afterDelay:2.f];
        
        
    }else{
        NSString *url = [NSString stringWithFormat:@"%@UserType/complaint/commit",BASEURL];
        NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        [paramer setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
        [paramer  setValue:self.card_info[@"merchant"] forKey:@"muid"];
        
        [paramer  setValue:self.textView.text forKey:@"reason"];
        
        
        [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            
            if ([result[@"result_code"] integerValue] ==1) {
                
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"提交成功!", @"HUD message title");
                hud.label.font = [UIFont systemFontOfSize:13];
                
                [hud hideAnimated:YES afterDelay:2.f];
                
            }
            
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        
    }
    
}


-(void)textViewDidChange:(UITextView *)textView{

    
    self.plachHode.hidden = (textView.text.length !=0) ;
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if (range.location>=200) {
        self.countSize.text = @"200/200字";
        
        return NO;
    }else{
        
        self.countSize.text = [NSString stringWithFormat:@"%lu/200字",range.location];
        return YES;
    }
    
}

@end
