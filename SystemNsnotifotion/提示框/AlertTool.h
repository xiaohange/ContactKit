//
//  AlertTool.h
//  AlertViewTest
//
//  Created by 韩俊强 on 16/3/25.
//  Copyright © 2016年 韩俊强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertTool : NSObject

+ (AlertTool *)shareAlertView;

/**
 *  提示框简单封装
 *
 *  @param viewController    viewController description
 *  @param title             标题
 *  @param message           message description
 *  @param cancelButtonTitle cancelButtonTitle description
 *  @param otherButtonTitle  otherButtonTitle description
 *  @param confirm           回调1
 *  @param cancle            回调2
 */
- (void)showAlertView:(id)vc title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle delegate:(id)delegate confirm:(void (^)())confirm cancle:(void (^)())cancle;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;



@end
