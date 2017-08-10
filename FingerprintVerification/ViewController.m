//
//  ViewController.m
//  FingerprintVerification
//
//  Created by Sunshine on 2017/8/10.
//  Copyright © 2017年 Sunshine. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <sys/utsname.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpUI];
}

- (void)setUpUI{
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Finger"]];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    imgView.center = CGPointMake(screenSize.width * 0.5, screenSize.height * 0.4);
    [self.view addSubview:imgView];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"点击进行指纹解锁";
    [tipLabel sizeToFit];
    tipLabel.center = CGPointMake(screenSize.width * 0.5, CGRectGetMaxY(imgView.frame) + 30);
    [self.view addSubview:tipLabel];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchID];
}

- (void)touchID {
    
    LAContext *content = [[LAContext alloc] init];
    NSError *error = nil;
    //第一步判断是否支持指纹认证  或者 本机是否已经录入指纹
    if ([content canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        [content evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
           
            if (error) {
                NSLog(@"验证失败"); //系统会自动给出错误提示
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"验证成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
                    
                });
            }
            
        }];
        
    }else {
        
        if (self.isSimulator) {
            
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请用真机测试~" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
            
        }else {
            
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"不支持指纹认证" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
            
        }
        
    }
}

- (BOOL)isSimulator {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceMachine = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceMachine isEqualToString:@"i386"] || [deviceMachine isEqualToString:@"x86_64"]) {
        return YES;
    }
    return NO;
}

@end
