//
//  SystemPrivileges.h
//  SystemNsnotifotion
//
//  Created by 韩俊强 on 16/3/23.
//  Copyright © 2016年 韩俊强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
typedef enum{
    TakePicture,// 相机
    Picture,    // 相册
    Location,   // 位置
    Sound,      // 麦克风
    localMessage// 系统通知
    
}privilegesType;

@interface SystemPrivileges : NSObject

@property (nonatomic, strong) CLLocationManager *locationManager;

+ (SystemPrivileges *)shareSystemPrivileges;

/**
 *  根据类型获取相应系统权限检测结果
 *
 *  @param type 监测类型
 */
- (BOOL)getSystemPrivilegesByPrivilegesType:(privilegesType)type;

/**
 *  相机权限
 */
- (BOOL)getTakePicturePrivileges;

/**
 *  相册权限
 */
- (BOOL)getPicturePrivileges;

/**
 *  位置权限
 */
- (BOOL)getLocationPrivileges;

/**
 *  麦克风权限（录音等）
 *  @return YES ? 有权限:无权限
 */
- (BOOL)canRecord;

/**
 *  系统通知
 *
 *  @return YES已开启 ： NO未开启
 */
- (BOOL) isAccessibilityPushNotification;
@end
