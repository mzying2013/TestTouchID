//
//  ViewController.m
//  TestTouchID
//
//  Created by Bill liu on 14/11/5.
//  Copyright (c) 2014年 heshidai. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *touchIDResult;
@property (nonatomic, strong) LAContext *context;
- (IBAction)touchIDAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





//TouchID是否验证成功
-(void)touchIDSuccess{
    __block NSString *msg;
    
    [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                 localizedReason:NSLocalizedString(@"解锁 合时代金融", nil)
                           reply:^(BOOL success, NSError *error) {
                               if (success) {
                                   msg = [NSString stringWithFormat:NSLocalizedString(@"EVALUATE_POLICY_SUCCESS", nil)];
                               }else{
                                   msg = [NSString stringWithFormat:NSLocalizedString(@"EVALUATE_POLICY_WITH_ERROR", nil), error.localizedDescription];
                               }
                               NSLog(@"msg:%@",msg);
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   self.touchIDResult.text = msg;
                               });
    }];
    
    
}




//TouchID是否有效
-(BOOL)isValidateTouchID{
    __block NSString *message;
    NSError *error;
    BOOL success;
    
    success = [self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                        error:&error];
    
    if (success) {
        message = [NSString stringWithFormat:NSLocalizedString(@"TOUCH_ID_IS_AVAILABLE", nil)];
    }else{
        message = [NSString stringWithFormat:NSLocalizedString(@"TOUCH_ID_IS_NOT_AVAILABLE", nil)];
    }
    
    NSLog(@"message:%@",message);
    return success;
}



- (IBAction)touchIDAction:(id)sender {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        self.context = [[LAContext alloc] init];
        self.touchIDResult.text = @"指纹识别";
        
        if ([self isValidateTouchID]) {
            [self touchIDSuccess];
        }
    }
}
@end
