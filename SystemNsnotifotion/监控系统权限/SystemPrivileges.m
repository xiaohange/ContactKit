//
//  SystemPrivileges.m
//  SystemNsnotifotion
//
//  Created by 韩俊强 on 16/3/23.
//  Copyright © 2016年 韩俊强. All rights reserved.
//

#import "SystemPrivileges.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
BOOL once = NO;// 取一次
BOOL systemToBool = YES;
@interface SystemPrivileges ()<UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@end

@implementation SystemPrivileges

+ (SystemPrivileges *)shareSystemPrivileges
{
    static SystemPrivileges *privileges;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        privileges = [[SystemPrivileges alloc]init];

    });
    return privileges;
}

- (BOOL)getSystemPrivilegesByPrivilegesType:(privilegesType)type
{
    NSString *tips = [NSString stringWithFormat:@"请在iPhone的”设置-通知“选项中，允许%@发送通知",NSLocalizedString(@"AppName",@"GMChatDemo")];
    switch (type) {
        case TakePicture:
            
            [self getTakePicturePrivileges];
            systemToBool = [self getTakePicturePrivileges];
            break;
            
            case Picture:
            
            [self getPicturePrivileges];
            systemToBool = [self getPicturePrivileges];
            break;
            
            case Location:
            
            [self getLocationPrivileges];
            systemToBool = [self getLocationPrivileges];
            break;
            
            case Sound:
            
            [self canRecord];
            systemToBool = [self canRecord];
            
            break;
            
            case localMessage:
            
            [self isAccessibilityPushNotification];
            systemToBool = [self isAccessibilityPushNotification];
            if (!systemToBool) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:tips delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil] show];
            }
            break;
        default:
            break;
    }
    return systemToBool;
}

// 相机权限
- (BOOL)getTakePicturePrivileges
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusAuthorized){
        
        return YES;
    }else{
        // 未权限
        [self onceForPicture];
        return NO;
    }
}

// 相册权限
- (BOOL)getPicturePrivileges
{
//    NSString *tips = [NSString stringWithFormat:@"请在iPhone的”设置-隐私-照片“选项中，允许%@访问你的照片",NSLocalizedString(@"AppName",@"GMChatDemo")];
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusAuthorized) {
        
        return YES;
    }else{
        // 未授权
        [self onceForPicture];
        return NO;
    }
}

- (void)onceForPicture
{
    if (once) {
        
        return;
    }else{
        
        once = YES;
        // 只取一次
        NSString *tips = [NSString stringWithFormat:@"请在iPhone的”设置-隐私-相机&相册“选项中，允许%@访问你的手机相机",NSLocalizedString(@"AppName",@"GMChatDemo")];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")){
            [[[UIAlertView alloc]initWithTitle:@"提示" message:tips delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil] show];
        }else{
           [[[UIAlertView alloc]initWithTitle:@"提示" message:tips delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            once = NO;
        });
    }
}

// 定位权限
- (BOOL)getLocationPrivileges
{
//    iOS8 下防止用户设置后Crash，plist文件新加两条变量
//    NSLocationAlwaysUsageDescription=YES;
//    NSLocationWhenInUseUsageDescription=YES; // 弹框描述
    
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    return systemToBool;
}

#pragma mark --- CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSString *tips = [NSString stringWithFormat:@"请在iPhone的”设置-隐私-定位服务“选项中，允许%@定位",NSLocalizedString(@"AppName",@"GMChatDemo")];
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
            
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [_locationManager requestWhenInUseAuthorization];
                systemToBool = YES;
            }
            break;
            case kCLAuthorizationStatusDenied :
            systemToBool = NO;
            [[[UIAlertView alloc] initWithTitle:@"提示" message:tips delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil] show];
            break;
        default:
            break;
    }
}

// 麦克风权限（录音等）
- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    //无权限
    if (!bCanRecord) {
        [self onceForRecord];
    }
    return bCanRecord;
}

- (void)onceForRecord
{
    if (once) {
        return;
    }else{
        
        once = YES;
        // 只取一次
        NSString *tips = [NSString stringWithFormat:@"请在iPhone的”设置-隐私-麦克风“选项中，允许%@访问你的麦克风",NSLocalizedString(@"AppName",@"GMChatDemo")];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")){
            [[[UIAlertView alloc]initWithTitle:@"提示" message:tips delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil] show];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:tips delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            once = NO;
        });
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        if (buttonIndex == 1) {

        NSURL*url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:url];
     }
   }
}

// 系统通知
- (BOOL) isAccessibilityPushNotification
{
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        
        UIRemoteNotificationType  type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        
        if (type == UIRemoteNotificationTypeNone) {
            
            return NO;
        }else{
            return YES;
        }
    }else{
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]) {
            
            UIUserNotificationType types = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
            return (types & UIUserNotificationTypeAlert);
        }else{
            UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
            return (types & UIRemoteNotificationTypeAlert);
        }
    }
}
@end
