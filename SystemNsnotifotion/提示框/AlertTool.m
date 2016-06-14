//
//  UIAlertTool.m
//  AlertViewTest
//
//  Created by 韩俊强 on 16/3/25.
//  Copyright © 2016年 韩俊强. All rights reserved.
//

#import "AlertTool.h"

#define IAIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
typedef void (^confirm)();
typedef void (^cancle)();
@interface AlertTool(){
    confirm confirmParam;
    cancle  cancleParam;
}
@end

@implementation AlertTool

+ (AlertTool *)shareAlertView
{
    static AlertTool *alertView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertView = [[AlertTool alloc]init];
    });
    return alertView;
}

- (void)showAlertView:(id)vc title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle  delegate:(id)delegate confirm:(void (^)())confirm cancle:(void (^)())cancle
{
    confirmParam=confirm;
    cancleParam=cancle;
    
    if (vc) {
        if (![vc isKindOfClass:[UIViewController class]]) {
            assert(@"仅支持ViewController");
        }
    }
    if (IAIOS8) {
         __weak id weakVC = vc;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            cancle();
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            confirm();
        }];
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [weakVC presentViewController:alertController animated:YES completion:nil];
    }
    else{
        UIAlertView *TitleAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:otherButtonTitle otherButtonTitles:cancelButtonTitle,nil];
        if (delegate) TitleAlert.delegate = delegate;
        [TitleAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        confirmParam();
    }
    else{
        cancleParam();
    }
}
@end